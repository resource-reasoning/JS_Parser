open Flow_parser.Ast
open Syntax
module Loc = Flow_parser.Loc
type loc = Loc.t
type pos = Loc.position

exception CannotHappen of string
exception Unknown_Annotation of string
exception Overlapping_Syntax
exception Unhandled_Statement of loc Statement.t * int
exception Unhandled_Expression of loc Expression.t * int
exception NotEcmaScript5 of string * int
exception UnusedAnnotations of annotation list * int

(* IF YOU ARE GOING TO DIVE INTO THIS CODE, PLEASE READ THIS :
f
   To understand better the way this code works, the reader is invited to read the ESTree spec : https://github.com/estree/estree
   This spec describes the AST that is given by the `esprima` parser. This code uses `flow-parser`, which outputs a very similar AST, but in OCaml.
   We only care about the parts of that AST that were available in ES5, all the rest will raise a `NotEcmaScript5` exception.

   Moreover, we part of the parsing of JS Logic annotations here. In particular, the `flow-parser` separates the comments from the code, althoug it gives information
   about where said annotations are.
   Each transforming function takes the possible annotations that will be attached to the produced content. Then it detaches its own annotations from the annotations
   of its child(ren) by selecting only the annotations that are happening before the children.
*)


(*******  This part deals with extracting annotations *******)

let deal_with_whitespace (s : string) = 
  let renl = Str.regexp "\n"    in let s : string = Str.global_replace renl " " s in
  let retb = Str.regexp "[\t]+" in let s : string = Str.global_replace retb " " s in
  let resp = Str.regexp "[ ]+"  in let s : string = Str.global_replace resp " " s in
    s

let remove_first = function
  | _::(b::r) -> (b::r)
  | _         -> raise (CannotHappen "Removing the first of a list that has less than 2 elements")


let make_annotation (atype, adesc) =
  let atype =
    match atype with
		| "requires" -> Requires
		| "ensures" -> Ensures
		| "ensureserr" -> EnsuresErr
		| "toprequires" -> TopRequires
		| "topensures" -> TopEnsures
		| "topensureserr" -> TopEnsuresErr
		| "pre" -> Requires
		| "post" -> Ensures
		| "posterr" -> EnsuresErr
		| "id" -> Id
		| "pred" -> Pred
		| "onlyspec" -> OnlySpec
		| "invariant" -> Invariant
		| "lemma" -> Lemma
		| "tactic" -> Tactic
		| "codename" -> Codename
    | "biabduce" -> BiAbduce
    | "call" -> Call
    | "JSIL" -> JSIL_only
		| annot -> raise (Unknown_Annotation annot)
  in
	{ annot_type = atype; annot_formula = adesc }


let get_annotations (comments: loc Comment.t list) : (loc * Syntax.annotation list) list =
  (* Extracts strig from comment *)
  let mapkeep f l = List.map (fun (a, b) -> (a, f b)) l in
  let filterkeep f l = List.filter (fun (_, b) -> f b) l in
  let only_string = function
    | Comment.Block s | Comment.Line s -> s
  in
  let simp_comments = mapkeep only_string comments in
  (* Cleans comment strings *)
  let clean cs = deal_with_whitespace (String.trim cs) in
  let clean_comments = mapkeep clean simp_comments in
  let split cs = List.map clean (String.split_on_char '@' cs) in
  let splited_comments = mapkeep split clean_comments in
  (* splited_comments is a list of (loc * string list),
     if the string_list inside the tuple is of size < 2,
     it means that there was no '@' in the comment, therefore it is not
     an annotation, we remove that comment from our considerations *)
  let only_annot_comments = filterkeep (fun s -> List.length s >= 2) splited_comments in
  (* Since we splitted on the '@' char, and are only interested in what's after,
     we can always remove the first element of the list *)
  let only_annots = mapkeep remove_first only_annot_comments in
  let spaces = List.map (fun (_, z) -> (List.map (fun x -> try Some (String.index x ' ') with _ ->  None)) z) only_annots in
  let annot_pairs = List.map2 (fun (loc, cms) il ->
    (loc,
     List.map2 (fun c i -> match i with
                          | None -> None
                          | Some i -> Some (String.trim (String.sub c 0 i), String.trim (String.sub c i (String.length c - i))))
                cms il
    ))
    only_annots spaces
  in
  let rec filter_and_get = function | a::r -> (match a with None -> filter_and_get r | Some x -> x::(filter_and_get r)) | [] -> [] in
  let annot_pairs_clean = mapkeep filter_and_get annot_pairs in
  mapkeep (List.map make_annotation) annot_pairs_clean


(******* Now we deal with AST transformation *********)

let lower_pos posa posb =
  let open Loc in
  posa.offset < posb.offset

let lower_eq_pos posa posb =
  let open Loc in
  posa.offset <= posb.offset


type loc_compare =
  | Before 
  | After
  | Child
  | Parent

let compare_loc loca locb =
  let open Loc in
  if lower_pos loca._end locb.start then Before
  else (
    if lower_pos locb._end loca.start then After
    else (
      if lower_eq_pos loca.start locb.start && lower_eq_pos locb._end loca._end then Parent
      else (
        if lower_eq_pos locb.start loca.start && lower_eq_pos loca._end locb._end then Child
        else raise Overlapping_Syntax
      )
    )
  )

(* Loc utils *)
let before loca locb = match compare_loc loca locb with Before -> true | _ -> false
let child loca locb = match compare_loc loca locb with Child -> true | _ -> false
let after loca locb = match compare_loc loca locb with After -> true | _ -> false

let get_first = function
  | [] -> raise (CannotHappen "Getting the first element of an empty list")
  | a::_ -> a

let rec get_last = function
  | [] -> raise (CannotHappen "Getting the last element of an empty list")
  | [a] -> a
  | _::r -> get_last r

let rem_locs (annots: (loc * annotation list) list) : annotation list =
  List.flatten (List.map (fun (_,b) -> b) annots)

let offset loc = loc.Loc.start.offset

let leading (annots: (loc * annotation list) list) (loc: loc) = List.filter (fun (l, _) -> before l loc) annots

let leading_list (annots: (loc * annotation list) list) (l_with_loc: (loc * 'a) list) : (loc * annotation list) list =
  match l_with_loc with
  | [] -> annots
  | lll ->
    let (fl, _) = get_first lll in
    leading annots fl

let partition_inner (loc: loc) (annots: (loc * annotation list) list) = List.partition (fun (l, _) -> child l loc) annots

let char_plus loc num =
  let open Loc in
  let _end =
    let { line; column; offset } = loc._end in
    let column, offset = column + num, offset + num in
    { line; column; offset }
  in
  let start = _end in
  { loc with start; _end }


let char_after loc =
  char_plus loc 1

let rec with_start_loc start_loc ll =
  match ll with
  | [] -> []
  | (loc, a)::r -> let nl = char_after loc in (start_loc, (loc, a))::(with_start_loc nl r)

(* Takes a list of annotations (with locs), check if its empty. If it is not it raises the appropriate UnusedAnnotations error *)
let check_unused_annots off annotation_l =
    let flattened = rem_locs annotation_l in
    let () = if List.length flattened > 0 then raise (UnusedAnnotations (flattened, off)) in
    ()

(* Add annotations to a JSParser expression. *)
let add_annot annots exp =
  { exp with exp_annot = exp.exp_annot @ annots }

(* Option utils *)
let option_map f o = match o with None -> None | Some i -> Some (f i)

(* Flow AST utils *)
let get_str_id ((_, b): loc Identifier.t) = b

let get_str_pattern pat off =
  let open Pattern in
  match pat with
  | Identifier.(Identifier { name=(_, str) ; _ }) -> str
  | Expression _ -> raise (NotEcmaScript5 ("ES5 only allows simple identifiers as patterns, given expr !", off))
  | _ -> raise (NotEcmaScript5 ("ES5 only allows simple identifiers as patterns", off))


let function_param_filter params =
  (* We are in ES5, so the only pattern available when declaring a function is an identifier.
      also there is no `rest` *)
  let (_, Function.Params.{ params; rest }) = params in
  let () = match rest with Some (lr, _) -> raise (NotEcmaScript5 ("Using rest params", (offset lr))) | None -> () in
  (* Now we are going to filter patterns that are not Identifier, if we find something else, we raise an error *)
  let rec f = function
    | [] -> []
    | (l, pattern)::r -> (get_str_pattern pattern (offset l))::(f r)
  in
  f params

(* Actual transformations *)

let absolutely_do_not_ever_actually_use = mk_exp (This) 0 [] [@@ocaml.deprecated]


let transform_unary_op off =
  let open Expression in
  function
  | Unary.Minus -> Negative
  | Unary.Plus -> Positive
  | Unary.Not -> Not
  | Unary.BitNot -> Bitnot
  | Unary.Typeof -> TypeOf
  | Unary.Void -> Void
  | Unary.Delete -> raise (CannotHappen "Delete is a special case of operator that should have been caught earlier")
  | Unary.Await -> raise (NotEcmaScript5 ("The await keyword is not part of ES5", off))

let transform_binary_op off =
  let open Expression in
  function
  | Binary.Equal -> Comparison Equal
  | Binary.NotEqual -> Comparison NotEqual
  | Binary.StrictEqual -> Comparison TripleEqual
  | Binary.StrictNotEqual -> Comparison NotTripleEqual
  | Binary.LessThan -> Comparison Lt
  | Binary.LessThanEqual -> Comparison Le
  | Binary.GreaterThan -> Comparison Gt
  | Binary.GreaterThanEqual -> Comparison Ge
  | Binary.LShift -> Arith Lsh
  | Binary.RShift -> Arith Rsh
  | Binary.RShift3 -> Arith Ursh
  | Binary.Plus -> Arith Plus
  | Binary.Minus -> Arith Minus
  | Binary.Mult -> Arith Times
  | Binary.Exp -> raise (NotEcmaScript5 ("Exponentiation operator (**) is not part of ES5", off))
  | Binary.Div -> Arith Div
  | Binary.Mod -> Arith Mod
  | Binary.BitOr -> Arith Bitor
  | Binary.Xor -> Arith Bitxor
  | Binary.BitAnd -> Arith Bitand
  | Binary.In -> Comparison In
  | Binary.Instanceof -> Comparison InstanceOf

let transform_assignment_op off =
  let open Expression.Assignment in
  function
  | Assign -> raise (CannotHappen "The Assign operator case should have been handled separetly")
  | PlusAssign -> Plus
  | MinusAssign -> Minus
  | MultAssign -> Times
  | ExpAssign -> raise (NotEcmaScript5 ("The exponentiation operator is not part of ES5", off))
  | DivAssign -> Div
  | ModAssign -> Mod
  | LShiftAssign -> Lsh
  | RShiftAssign -> Rsh
  | RShift3Assign -> Ursh
  | BitOrAssign -> Bitor
  | BitXorAssign -> Bitxor
  | BitAndAssign -> Bitand

let transform_logical_op off =
  let open Expression in
  function
  | Logical.Or -> Boolean Or
  | Logical.And -> Boolean And
  | Logical.NullishCoalesce -> raise (NotEcmaScript5 ("The Nullish Coalescing operator is not part of ES5", off))

let transform_update_op prefix op =
  let open Expression.Update in
  match prefix, op with
  | true, Increment -> Pre_Incr
  | true, Decrement -> Pre_Decr
  | false, Increment -> Post_Incr
  | false, Decrement -> Post_Decr



let rec transform_properties start_pos annotations properties =
  let open Expression.Object.Property in
  match properties with
  | [] -> let () = check_unused_annots (offset start_pos) annotations in []
  | (loc, Init { key; value; shorthand })::r ->
    let () = if shorthand then raise (NotEcmaScript5 ("Shorthand properties are not part of ES5", offset loc)) in
    let inner_annots, rest_annots = partition_inner (Loc.btwn start_pos loc) annotations in
    let trans_key = transform_prop_key key in
    let trans_val = transform_expression inner_annots value in
    (trans_key, PropbodyVal, trans_val)::(transform_properties (char_after loc) rest_annots r)
  | (loc, Get { key; value })::r
  | (loc, Set { key; value })::r ->
    let inner_annots, rest_annots = partition_inner (Loc.btwn start_pos loc) annotations in
    let trans_key = transform_prop_key key in
    let (lf, func) = value in
    let fun_annots, leading_annots = partition_inner lf inner_annots in
    let trans_fun = transform_function ~expression:true start_pos (rem_locs leading_annots) fun_annots func in
    let typ = match properties with (_, Get _)::_ -> PropbodyGet | (_, Set _)::_ -> PropbodySet | _ -> raise (CannotHappen "pattern matching gone wrong") in
    (trans_key, typ, trans_fun)::(transform_properties (char_after loc) rest_annots r)
  | (loc, Method _)::_ -> raise (NotEcmaScript5 ("Methods are not allowed in ES5 for objects", offset loc))

and transform_prop_key key =
  let open Expression.Object.Property in
  match key with
  | Literal (_, Literal.{ value=String s; _ }) -> PropnameString s
  | Literal (_, Literal.{ value=Number f; _ }) -> PropnameNum f
  | Identifier i -> PropnameId (get_str_id i)
  | Literal (l, _)
  | PrivateName (l, _)
  | Computed (l, _) -> raise (NotEcmaScript5 ("Only strings or string and int literals are authorised as property key in ES5", offset l))

and transform_expression_sequence start_pos leading_annots inner_annots expr_list =
  let rec aux stpos annots acc expl =
    match expl with
    | [] -> let () = check_unused_annots (offset start_pos) annots in acc
    | exp::r ->
      let (le, _) = exp in
      let e_annots, rest_annots = partition_inner (Loc.btwn stpos (char_after le)) annots in
      let trans_exp = transform_expression e_annots exp in
      let trans_acc = mk_exp (Comma (acc, trans_exp)) (offset start_pos) [] in
      aux (char_after le) rest_annots trans_acc r
  in
  match expr_list with
  | fst :: snd :: rest ->
    let lfst, _ = fst in
    let fst_annots, rest_annots = partition_inner (Loc.btwn start_pos (char_after lfst)) inner_annots in
    let trans_fst = transform_expression fst_annots fst in
    let lsnd, _ = snd in
    let snd_annots, rest_annots = List.partition (fun (l, _) ->  child l (Loc.btwn (char_after lfst) lsnd)) rest_annots in
    let trans_snd = transform_expression snd_annots snd in
    let acc = mk_exp (Comma (trans_fst, trans_snd)) (offset start_pos) [] in
    add_annot leading_annots (aux (char_after lsnd) rest_annots acc rest)
  | _ -> raise (CannotHappen "Expression sequence with less than 2 elements")

and transform_expression (annotations: (loc * annotation list) list) (expression: loc Expression.t) : exp =
  let loc, expr = expression in
  (* We supposedly passed with the expression :
     - the annotations of its children
     - its own leading annotations.
     Therefore, we can simply split them here. *)
  let leading_annots, inner_annots = List.partition (fun (l, _) -> before l loc) annotations in
  let leading_annots = rem_locs leading_annots in
  let off = offset loc in
  let first_pos = Loc.first_char loc in
  match expr with
  | Expression.(Unary Unary.{ operator; prefix=_; argument }) ->
    let trans_arg = transform_expression inner_annots argument in
    begin
      match operator with
      | Expression.Unary.Delete -> mk_exp (Delete trans_arg) off leading_annots
      | o ->
        let trans_op = transform_unary_op off o in
        mk_exp (Unary_op (trans_op, trans_arg)) off leading_annots
    end
  | Expression.(Binary Binary.{ left; right; operator }) ->
    let (leftloc, _) = left in
    let left_annots, right_annots = partition_inner (Loc.btwn first_pos (char_after leftloc)) inner_annots in
    let trans_left = transform_expression left_annots left in
    let trans_right = transform_expression right_annots right in
    let trans_op = transform_binary_op off operator in
    mk_exp (BinOp (trans_left, trans_op, trans_right)) off leading_annots
  | Expression.(Assignment Assignment.{ left; right; operator }) ->
    let (leftloc, _) = left in
    let left_annots, right_annots = partition_inner (Loc.btwn first_pos (char_after leftloc)) inner_annots in
    let trans_left =
      let (locpat, pat) = left in
      match pat with
      | Pattern.(Identifier Identifier.{ name=(_, i); _ }) ->
        mk_exp (Var i) (offset locpat) (rem_locs left_annots)
      | Pattern.Expression ex -> transform_expression left_annots ex
      | _ -> raise (NotEcmaScript5 ("Pattern matching in assignment is not authorized in ES5", offset locpat))
    in
    let trans_right = transform_expression right_annots right in
    begin
      match operator with
      | Assign -> mk_exp (Assign (trans_left, trans_right)) off leading_annots
      | o -> 
        let trans_op = transform_assignment_op off o in
        mk_exp (AssignOp (trans_left, trans_op, trans_right)) off leading_annots
    end
  | Expression.(Logical Logical.{ left; right; operator }) ->
    let (leftloc, _) = left in
    let left_annots, right_annots = partition_inner (Loc.btwn first_pos leftloc) inner_annots in
    let trans_left = transform_expression left_annots left in
    let trans_right = transform_expression right_annots right in
    let trans_op = transform_logical_op off operator in
    mk_exp (BinOp (trans_left, trans_op, trans_right)) off leading_annots
  | Expression.(Update Update.{ operator; argument; prefix }) ->
    let trans_arg = transform_expression inner_annots argument in
    let trans_op = transform_update_op prefix operator in
    mk_exp (Unary_op (trans_op, trans_arg)) off leading_annots
  | Expression.(Member Member.{ _object; property; computed }) ->
    let (lobject, _) = _object in
    let object_annots, mem_annots = partition_inner (Loc.btwn first_pos lobject) inner_annots in
    let trans_obj = transform_expression object_annots _object in
    begin
      let open Expression.Member in
      match property with
      | PropertyIdentifier i ->
        let () = if computed then raise (CannotHappen "Computed member given an identifier instead of expr") in
        let strname = get_str_id i in
        mk_exp (Access (trans_obj, strname)) off leading_annots
      | PropertyExpression e ->
        let () = if not computed then raise (CannotHappen "Not computed property member given an expression") in
        let trans_prop = transform_expression mem_annots e in
        mk_exp (CAccess (trans_obj, trans_prop)) off leading_annots
      | PropertyPrivateName (l, _) -> raise (NotEcmaScript5 ("Private properties are not part of ES5", offset l))
    end
  | Expression.This ->
    let () = check_unused_annots off inner_annots in
    mk_exp This off leading_annots
  | Expression.(Object Object.{ properties }) ->
    let open Expression.Object in
    (* First we filter object properties *)
    let props = List.map (
      function
      | Property p -> p
      | SpreadProperty (l, _) -> raise (NotEcmaScript5 ("Use of spread property illegal in ES5", offset l))
      ) properties in
    let trans_props = transform_properties first_pos inner_annots props in
    mk_exp (Obj trans_props) off leading_annots
  | Expression.(Sequence Sequence.{ expressions }) ->
    transform_expression_sequence first_pos leading_annots inner_annots expressions
  | Expression.(New New.{ callee; arguments; _ }) ->
    let (calleeloc, _) = callee in
    let callee_annots, arg_annots = partition_inner (Loc.btwn first_pos calleeloc) inner_annots in
    let trans_callee = transform_expression callee_annots callee in
    let exprs_args = List.map 
      Expression.(
        function
        | Expression e -> e
        | Spread _ -> raise (NotEcmaScript5 ("Use of spread illegal in ES5", offset loc))
      )
      arguments
    in
    let trans_args = transform_expr_list (char_after calleeloc) arg_annots exprs_args in
    mk_exp (New (trans_callee, trans_args)) off leading_annots
  | Expression.(Conditional Conditional.{ test; consequent; alternate }) ->
    let trans_cond = transform_expr_list first_pos inner_annots [test; consequent; alternate] in
    let trans_test, trans_cons, trans_alt =
      match trans_cond with
      | [ t; c; a ] -> t, c, a
      | _ -> raise (CannotHappen "Inconsistent size of array after mapping")
    in
    mk_exp (ConditionalOp (trans_test, trans_cons, trans_alt)) off leading_annots
  | Expression.(Array Array.{ elements }) ->
    let expr_opt_els = List.map
      Expression.(
        function
        | Some (Expression e) -> Some e
        | Some (Spread _) -> raise (NotEcmaScript5 ("Use of spread illegal in ES5", offset loc))
        | None -> None
      )
      elements
    in
    let rec trans_els_opt start_pos annots expr_opt_l =
      match expr_opt_l with
      | [] -> let () = check_unused_annots (offset start_pos) annots in []
      | exp_opt::r ->
        match exp_opt with
        | Some exp -> 
          let le, _ = exp in
          let this_annots, rest_annots = partition_inner (Loc.btwn start_pos le) annots in
          (Some (transform_expression this_annots exp))::(trans_els_opt (char_after le) rest_annots r)
        | None -> None::(trans_els_opt (start_pos) annots r)
    in
    let trans_els = trans_els_opt first_pos inner_annots expr_opt_els in
    mk_exp (Array (trans_els)) off leading_annots
  | Expression.(Identifier (_, i)) ->
    mk_exp (Var i) off (rem_locs annotations)
  | Expression.(Literal Literal.{ value; raw }) ->
    let trans_val =
      match value with
      | Literal.Boolean b -> Bool b
      | Literal.Number f -> Num f
      | Literal.Null when (String.equal raw "null") -> Null
      | Literal.Null -> Num(infinity)
      | Literal.String s -> String s
      | Literal.(RegExp RegExp.{ pattern; flags }) -> RegExp (pattern, flags)
    in
    mk_exp trans_val off leading_annots
  | Expression.(Call Call.{ callee; arguments; _ }) ->
    let (calleeloc, _) = callee in
    let callee_annots, arg_annots = partition_inner (Loc.btwn first_pos calleeloc) inner_annots in
    let trans_callee = transform_expression callee_annots callee in
    let exprs_args = List.map 
      Expression.(
        function
        | Expression e -> e
        | Spread _ -> raise (NotEcmaScript5 ("Use of spread illegal in ES5", offset loc))
      )
      arguments
    in
    let trans_args = transform_expr_list (char_after calleeloc) arg_annots exprs_args in
    mk_exp (Call (trans_callee, trans_args)) off leading_annots
  | Expression.Function fn ->
    transform_function ~expression:true first_pos leading_annots inner_annots fn
  | _ -> raise (Unhandled_Expression (expression, off))

and transform_expr_list start_pos annots exprl =
  match exprl with
  | [] -> let () = check_unused_annots (offset start_pos) annots in []
  | exp::r ->
    let le, _ = exp in
    let this_annots, rest_annots = partition_inner (Loc.btwn start_pos le) annots in
    (transform_expression this_annots exp)::(transform_expr_list (char_after le) rest_annots r)

and transform_variable_decl declaration total_loc leading_annots inner_annots =
  (* We are in ES5, the only patterns available when declaring variable is an identifier.
     Also, the kind has to be var, since let and cons were introduced in ES2015. *)
  let open Statement.VariableDeclaration in
  let start = Loc.first_char total_loc in
  let { kind; declarations } = declaration in
  let () =
    match kind with
    | Var -> ()
    | _   -> raise (NotEcmaScript5 ("Using Let or Const is not authorized in ES5 !", offset start))
  in
  let rec f stloc remaining_annots = function
  | [] -> let () = check_unused_annots (offset total_loc) remaining_annots in []
  | (_, Declarator.{ id = (lpat, pattern); init})::r ->
    let var = get_str_pattern pattern (offset lpat) in
    let exp, rest_annot, last_char = 
      match init with
      | None -> None, remaining_annots, char_after lpat
      | Some (le, e) ->
        let this_annot, rest_annot = partition_inner (Loc.btwn stloc le) remaining_annots in
        Some (transform_expression this_annot (le, e)), rest_annot, char_after le
    in

    (var, exp)::(f last_char rest_annot r)
  in
  match declarations with
  | [] -> raise (CannotHappen "Empty list of declarators in variable declaration !")
  | children -> mk_exp (VarDec (f start inner_annots children)) (offset total_loc) leading_annots

and transform_function
      ~(expression:bool) (* If true, gives a FunctionExp, other a Function (statement) *)
      (start_pos:Loc.t)
      (leading_annots:annotation list)
      (inner_annots: (loc * annotation list) list)
      (fn:loc Function.t) : exp =
  let Function.{ id; params; body; _ } = fn in
  let id = match id with None -> None | Some (_, i) -> Some i in
  let param_strs = function_param_filter params in
  let body_transf = 
    match body with
    | Function.BodyBlock (_, fbody) ->
      let Statement.Block.{ body } = fbody in
      let children = trans_stmt_list start_pos body inner_annots in
      mk_exp (Block children) (offset start_pos) [] (* Annotations are attached to the children *)
    | Function.BodyExpression expr ->
      transform_expression inner_annots expr
  in
  if expression then
    mk_exp (FunctionExp (false, id, param_strs, body_transf)) (offset start_pos) leading_annots
  else
    mk_exp (Function (false, id, param_strs, body_transf)) (offset start_pos) leading_annots

and transform_statement (annotations: (loc * annotation list) list) (statement: loc Statement.t) : exp =
  let loc, stmt = statement in
  (* We supposedly passed with the statements :
     - the annotations of its children
     - its own leading annotations.
     Therefore, we can simply split them here. *)
  let leading_annots, inner_annots = List.partition (fun (l, _) -> before l loc) annotations in
  let leading_annots = rem_locs leading_annots in
  let off = offset loc in
  let first_pos = Loc.first_char loc in
  match stmt with
  | Statement.Block { body } ->
    let children = trans_stmt_list first_pos body inner_annots in
    mk_exp (Block children) off leading_annots
  | Statement.FunctionDeclaration fn ->
    transform_function ~expression:false first_pos leading_annots inner_annots fn
  | Statement.VariableDeclaration vd ->
    transform_variable_decl vd loc leading_annots inner_annots
  | Statement.Expression e ->
    let Statement.Expression.{ expression; _ } = e in
    transform_expression annotations expression (* all the annotations are given to the child directly *)
  | Statement.(If { test=(ltest, testexp); consequent=(lcons, consstmt); alternate }) ->
    let test_annots, other_annots = partition_inner (Loc.btwn loc ltest) inner_annots in (* annots between the `if` and the end of the test` *)
    let cons_annots, other_annots = partition_inner (Loc.btwn (char_after ltest) lcons) other_annots in (* annots between the test and the end of the consequent *)
    let trans_test = transform_expression test_annots (ltest, testexp) in
    let trans_cons = transform_statement cons_annots (lcons, consstmt) in
    let (trans_alt, rest_annots) =
      match alternate with
      | None -> None, other_annots
      | Some (lalt, altstmt) ->
        let alt_annots, rest_annots = partition_inner (Loc.btwn (char_after lcons) lalt) other_annots in
        let trans_alt = Some (transform_statement alt_annots (lalt, altstmt)) in
        trans_alt, rest_annots
    in
    let () = check_unused_annots off rest_annots in
    mk_exp (If (trans_test, trans_cons, trans_alt)) off leading_annots
  | Statement.(Labeled Labeled.{ label; body }) ->
    let (locbody, _) = body in
    let (loclab, lab) = label in
    let child_annot, rest_annot = partition_inner (Loc.btwn (char_after loclab) locbody) inner_annots in
    let () = check_unused_annots off rest_annot in
    let trans_child = transform_statement child_annot body in
    mk_exp (Label (lab, trans_child)) off leading_annots
  | Statement.(Break Break.{ label }) ->
    let () = check_unused_annots off inner_annots in (* We do not consider annotations between the 'break' and the label if there is one *)
    let lab = option_map get_str_id label in
    mk_exp (Break lab) off leading_annots
  | Statement.(Continue Continue.{ label }) ->
    let () = check_unused_annots off inner_annots in (* We do not consider annotations between the 'break' and the label if there is one *)
    let lab = option_map get_str_id label in
    mk_exp (Continue lab) off leading_annots
  | Statement.(With With.{ _object; body }) ->
    let (lobj, _) = _object in
    let obj_annot, body_annot = partition_inner (Loc.btwn loc lobj) inner_annots in
    let trans_obj = transform_expression obj_annot _object in
    let trans_body = transform_statement body_annot body in (* Every remaining annotation goes to the body *)
    mk_exp (With (trans_obj, trans_body)) off leading_annots
  | Statement.(Switch { discriminant; cases }) ->
    let (ldisc, _) = discriminant in
    let expr_annots, other_annots = partition_inner ldisc inner_annots in
    let trans_discr = transform_expression expr_annots discriminant in
    let trans_cases = List.map (transform_case other_annots) cases in (* This might lose some annotations between the end of a case and the beginning of the next one *)
    mk_exp (Switch (trans_discr, trans_cases)) off leading_annots
  | Statement.(Throw Throw.{ argument }) ->
    let trans_arg = transform_expression inner_annots argument in
    mk_exp (Throw trans_arg) off leading_annots
  | Statement.(Try Try.{ block; handler; finalizer }) ->
    let (lblock, Statement.Block.{ body }) = block in
    let block_annots, other_annots = partition_inner lblock inner_annots in
    let block_start = Loc.first_char lblock in
    let trans_inside_block = trans_stmt_list block_start body block_annots in
    let trans_block = mk_exp (Block trans_inside_block) (offset lblock) [] in
    let trans_handler, other_annots =
      match handler with
      | None -> None, other_annots
      | Some (Statement.Try.CatchClause.(lhandler, { param; body=(lbody, bblock) })) ->
        let str_param =
          match param with
          | None -> raise (NotEcmaScript5 ("In ES5, catch must have a parameter!", offset lhandler))
          | Some (lpat, pat) -> get_str_pattern pat(offset lpat)
        in
        let body_start = Loc.first_char lbody in
        let body_annots, other_annots = partition_inner (lbody) other_annots in
        let Statement.Block.{ body } = bblock in
        let trans_inside_body = trans_stmt_list body_start body body_annots in
        let trans_body = mk_exp (Block trans_inside_body) (offset lbody) [] in
        let h = Some (str_param, trans_body) in
        h, other_annots
    in
    let trans_final, other_annots =
      match finalizer with
      | Some (lfin, Statement.Block.{ body }) ->
        let fin_annots, other_annots = partition_inner lfin other_annots in
        let block_start = Loc.first_char lfin in
        let trans_inside_final = trans_stmt_list block_start body fin_annots in
        let trans_final = mk_exp (Block trans_inside_final) (offset lfin) [] in
        let h = Some trans_final in
        h, other_annots
      | None -> None, other_annots
    in
    let () = check_unused_annots off other_annots in
    mk_exp (Try (trans_block, trans_handler, trans_final)) off leading_annots
  | Statement.(While While.{ test; body }) ->
    let ltest, _ = test in
    let expr_annots, body_annots = partition_inner (Loc.btwn first_pos ltest) inner_annots in
    let trans_exp = transform_expression expr_annots test in
    let trans_body = transform_statement body_annots body in
    mk_exp (While (trans_exp, trans_body)) off leading_annots
  | Statement.(DoWhile DoWhile.{ test; body }) ->
    let ltest, _ = test in
    let expr_annots, body_annots = partition_inner (Loc.btwn first_pos ltest) inner_annots in
    let trans_test = transform_expression expr_annots test in
    let trans_body = transform_statement body_annots body in
    mk_exp (DoWhile (trans_body, trans_test)) off leading_annots
  | Statement.(ForIn ForIn.{ left; right; body; each=_ }) ->
    let open Statement.ForIn in
    let trans_left, other_annots, endleft =
      match left with
      | LeftPattern (locleft, leftpat) ->
        let left_annots, other_annots = partition_inner (Loc.btwn first_pos locleft) inner_annots in
        let strpat = get_str_pattern leftpat (offset locleft) in
        let exp = mk_exp (Var strpat) (offset locleft) (rem_locs left_annots) in
        exp, other_annots, char_after locleft
      | LeftDeclaration (locleft, vdecl) ->
        let left_annots, other_annots = partition_inner (Loc.btwn first_pos locleft) inner_annots in
        let t = transform_variable_decl vdecl locleft [] left_annots in
        t, other_annots, char_after locleft
    in
    let trans_right, other_annots, endright =
      let (locright, _) = right in
      let right_annots, other_annots = partition_inner (Loc.btwn endleft locright) other_annots in
      let exp = transform_expression right_annots right in
      exp, other_annots, char_after locright
    in
    let trans_body, rest_annots =
      let (locbody, _) = body in
      let body_annots, rest_annots = partition_inner (Loc.btwn endright locbody) other_annots in
      let exp = transform_statement body_annots body in
      exp, rest_annots
    in
    let () = check_unused_annots off rest_annots in
    mk_exp (ForIn (trans_left, trans_right, trans_body)) off leading_annots
  | Statement.(For For.{ init; test; update; body }) ->
    let open Statement.For in
    let trans_init, other_annots, endinit =
      match init with
      | None -> None, inner_annots, first_pos
      | Some (InitDeclaration (ldec, vd)) ->
        let init_annots, other_annots = partition_inner (Loc.btwn first_pos ldec) inner_annots in
        let t = transform_variable_decl vd ldec [] init_annots in
        Some t, other_annots, char_after ldec
      | Some (InitExpression (le, e)) ->
        let init_annots, other_annots = partition_inner (Loc.btwn first_pos le) inner_annots in
        let t = transform_expression init_annots (le, e) in
        Some t, other_annots, char_after le
    in
    let trans_test, other_annots, endtest =
      match test with
      | None -> None, other_annots, endinit
      | Some (le, e) ->
        let test_annots, other_annots = partition_inner (Loc.btwn endinit le) other_annots in
        let t = transform_expression test_annots (le, e) in
        Some t, other_annots, char_after le
    in
    let trans_update, other_annots, endupdate =
      match update with
      | None -> None, other_annots, endtest
      | Some (le, e) ->
        let update_annots, other_annots = partition_inner (Loc.btwn endinit le) other_annots in
        let t = transform_expression update_annots (le, e) in
        Some t, other_annots, char_after le
    in
    let trans_body, rest_annots =
      let lbody, _ = body in
      let body_annots, other_annots = partition_inner (Loc.btwn endupdate lbody) other_annots in
      let t = transform_statement body_annots body in
      t, other_annots
    in
    let () = check_unused_annots off rest_annots in
    mk_exp (For (trans_init, trans_test, trans_update, trans_body)) off leading_annots
  | Statement.(Return Return.{ argument }) ->
    let trans_arg = option_map (transform_expression inner_annots) argument in
    mk_exp (Return trans_arg) off leading_annots
  | Statement.Empty ->
    let () = check_unused_annots off inner_annots in
    mk_exp Skip off leading_annots
  | Statement.Debugger ->
    let () = check_unused_annots off inner_annots in
    mk_exp Debugger off leading_annots
  | _ -> raise (Unhandled_Statement (statement, off))

and transform_case annots case =
  (* I don't know how correct the following is. *)
  let open Statement.Switch.Case in
  let (lcase, { test; consequent }) = case in
  let inner_annots = List.filter (fun (l, _) -> child l lcase) annots in
  let (test_end, trans_test) = match test with
    | None -> (* `default` is of length  7*)
      let test_end = char_plus lcase 7 in
      let trans_test = DefaultCase in
      (test_end, trans_test)
    | Some (le, e) ->
      let test_end = char_after le in 
      let trans_test = Case (transform_expression [] (le, e)) in
      (test_end, trans_test)
  in
  let trans_cons = trans_stmt_list test_end consequent inner_annots in
  (trans_test, mk_exp (Block trans_cons) (offset test_end) []) 

and trans_stmt_list start_loc raw_stmts annots =
  let stmts_with_start_loc = with_start_loc start_loc raw_stmts in
  let trans_stmt (st_l, (lloc, s)) = 
    let children_annotations = List.filter (fun (l, _) -> child l (Loc.btwn st_l lloc)) annots in
    transform_statement children_annotations (lloc, s)
  in
  List.map trans_stmt stmts_with_start_loc


let transform_program (prog:loc program) =
  let start_loc = Loc.none in (* At @esy-ocaml/flow-parser v 0.76, this is position (0, 0) *)
  let loc, raw_stmts, cmts = prog in
  let annots = get_annotations cmts in
  let stmts = trans_stmt_list start_loc raw_stmts annots in
  mk_exp (Script (false, stmts)) (offset loc) [] (* The script never has annotations *)