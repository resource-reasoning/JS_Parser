open List

exception CannotHappen

(* syntax *)

type comparison_op =
  | Equal
  | NotEqual
  | TripleEqual
  | NotTripleEqual
  | Lt
  | Le
  | Gt
  | Ge
  | In
  | InstanceOf

type arith_op =
  | Plus
  | Minus
  | Times
  | Div
  | Mod
  | Ursh
  | Lsh
  | Rsh
  | Bitand
  | Bitor
  | Bitxor

type bool_op =
  | And
  | Or

type bin_op =
  | Comparison of comparison_op
  | Arith of arith_op
  | Boolean of bool_op

type unary_op =
  | Not
  | TypeOf
  | Positive
  | Negative
  | Pre_Decr
  | Post_Decr
  | Pre_Incr
  | Post_Incr
  | Bitnot
  | Void

type var = string

type annotation_type =
  | TopRequires   (* Precondition of global  *)
  | TopEnsures    (* Normal postcondition of global *)
  | TopEnsuresErr (* Error postcondition of global *)
  | Requires      (* Precondition of function *)
  | Ensures       (* Normal postcondition of function *)
  | EnsuresErr    (* Error postcondition of function *)
  | Id            (* Function identifier *)
	| Codename      (* Codename *)
  | Pred          (* Predicate *)
  | OnlySpec      (* Specification without function body *)
	| Invariant     (* Invariant *)
	| Lemma         (* Lemma *)
	| Tactic        (* General tactic: fold, unfold, recursive unfold, assert, flash, callspec, and many more to come... *)
  | BiAbduce      (* Bi-abduction indicator *)
  | Call          (* Function call with substitution *)
  | JSIL_only     (* Function called in JSIL only *)

type annotation =
  {
    annot_type : annotation_type;
    annot_formula : string
  }

type propname =
  | PropnameId of string
  | PropnameString of string
  | PropnameNum of float

type proptype =
  | PropbodyVal
  | PropbodyGet
  | PropbodySet

type exp = { exp_offset : int; exp_stx : exp_syntax; exp_annot : annotation list}
and exp_syntax =
  | Num of float            (* 17 *)
  | String of string      (* "abc" *)
  | Label of string * exp (* label: exp *)
  | Null                  (* null *)
  | Bool of bool          (* true, false *)
  | Var of var            (* x *)
  | If of exp * exp * exp option (* if (e){e}{e} *)
  | While of exp * exp   (* while (e){e} *)
  | DoWhile of exp * exp (* do {e} while e *)
  | VarDec of (var * exp option) list (* var x *)
  | This                  (* this *)
  | Delete of exp         (* delete e *)
  | Comma of exp * exp    (* e, e *)
  | Unary_op of unary_op * exp       (* unary_op e *)
  | BinOp of exp * bin_op * exp  (* e op e*)
  | Access of exp * string (* e.x *)
  | Call of exp * exp list     (* e(e1,..,en) *)
  | Assign of exp * exp   (* e = e *)
  | AssignOp of exp * arith_op * exp   (* e op= e *)
  | FunctionExp of bool * (string option) * var list * exp * bool (* function (x1,..,x2){e} *)
  | ArrowExp of bool * (string option) * exp list * exp * bool(* function (x1,..,x2){e} *)
  | Function of bool * (string option) * var list * exp * bool (* function x(x1,..,x2){e}  *)
  | New of exp * exp list      (* new e(e1,..,en) *)
  | Obj of (propname * proptype * exp) list (* {x_i : e_i} *)
  | Array of (exp option) list (* [e1,...,en] *)
  | CAccess of exp * exp  (* e[e] *)
  | With of exp * exp     (* with (e){e} *)
  | Skip
  | Throw of exp          (* throw e *)
  | Return of exp option        (* return e *)
  | TemplateLiteral of exp list * exp list (* `${e1}e2` *)
  | TemplateElement of string * string * bool
  | Await of exp            (* await e *)
  | RegExp of string * string (* / pattern / flags *)
  | For of (exp option) * (exp option) * (exp option) * exp (* for (e1; e2; e3) {e4} *)
  | ForIn of exp * exp * exp (* for (exp in exp) {exp}*)
  | ForOf of exp * exp * exp (* for (exp in exp) {exp}*)
  | Break of string option
  | Continue of string option
  | Try of exp * (string * exp) option * exp option (* try e catch e finally e *)
  | Switch of exp * (switch_case * exp) list
  | Debugger
  | ConditionalOp of exp * exp * exp (* (e ? e : e) *)
  | Block of exp list (* { es } *)
  | Script of bool * exp list (* top node *)
and switch_case =
  | Case of exp
  | DefaultCase

let mk_exp s o annots =
  { exp_offset = o; exp_stx = s; exp_annot = annots }

let is_directive exp =
  match exp.exp_stx with
    | String s -> true
    | _ -> false

let get_directives exp =
    match exp.exp_stx with
    | Script (_, stmts)
    | Block stmts ->
      let (_, directives) = List.fold_left (fun (is_in_directive, directives) e ->
        if (not is_in_directive) then
          (false, directives)
        else if (is_directive e) then
          (true, (match e.exp_stx with
            | String s -> s
            | _ -> raise CannotHappen) :: directives)
        else (false, directives)
      ) (true, []) stmts in directives
    | _ -> []

let is_in_strict_mode exp =
  List.mem "use strict" (get_directives exp)

let rec add_strictness parent_strict exp =
  let f = add_strictness parent_strict in
  let fop e = match e with
    | None -> None
    | Some e -> Some (f e) in
  match exp.exp_stx with
    | Num n -> exp
    | String x -> exp
    | Label (x, e1) -> {exp with exp_stx = Label (x, f e1)}
    | Null -> exp
    | Bool b -> exp
    | Var x -> exp
    | If (e1, e2, e3) -> {exp with exp_stx = If (f e1, f e2, fop e3)}
    | While (e1, e2) -> {exp with exp_stx = While (f e1, f e2)}
    | DoWhile (e1, e2) -> {exp with exp_stx = DoWhile (f e1, f e2)}
    | VarDec xs -> {exp with exp_stx = VarDec (List.map (fun (name, e1) -> (name, fop e1)) xs)}
    | This -> exp
    | Delete e -> {exp with exp_stx = Delete (f e)}
    | Comma (e1, e2) -> {exp with exp_stx = Comma (f e1, f e2)}
    | Unary_op (op, e) -> {exp with exp_stx = Unary_op (op, f e)}
    | BinOp (e1, op, e2) -> {exp with exp_stx = BinOp (f e1, op, f e2)}
    | Access (e, x) -> {exp with exp_stx = Access (f e, x)}
    | Call (e1, e2s) -> {exp with exp_stx = Call (f e1, List.map f e2s)}
    | Assign (e1, e2) -> {exp with exp_stx = Assign (f e1, f e2)}
    | AssignOp (e1, op, e2) -> {exp with exp_stx = AssignOp (f e1, op, f e2)}
    | FunctionExp (_, n, xs, e, b) ->
      let strict = parent_strict || is_in_strict_mode e in
      {exp with exp_stx = FunctionExp (strict, n, xs, add_strictness strict e, b)}
    | ArrowExp (_, n, xs, e, b) ->
      let strict = parent_strict || is_in_strict_mode e in
      {exp with exp_stx = ArrowExp (strict, n, xs, add_strictness strict e, b)}  
    | Function (_, n, xs, e, b) ->
      let strict = parent_strict || is_in_strict_mode e in
      {exp with exp_stx = Function (strict, n, xs, add_strictness strict e, b)}
    | New (e1, e2s) -> {exp with exp_stx = New (f e1, List.map f e2s)}
    | Obj l -> {exp with exp_stx = Obj (List.map (fun (x, p, e) -> (x, p, f e)) l)}
    | Array es -> {exp with exp_stx = Array (List.map fop es)}
    | CAccess (e1, e2) -> {exp with exp_stx = CAccess (f e1, f e2)}
    | With (e1, e2) -> {exp with exp_stx = With (f e1, f e2)}
    | Skip -> exp
    | Throw e -> {exp with exp_stx = Throw (f e)}
    | Return e -> {exp with exp_stx = Return (fop e)}
    | Await e -> {exp with exp_stx = Await (f e)}
    | TemplateLiteral (e1s, e2s) -> {exp with exp_stx = TemplateLiteral (List.map f e1s, List.map f e2s)}
    | TemplateElement _ -> exp
    | RegExp (s1, s2) -> exp
    | ForIn (e1, e2, e3) -> {exp with exp_stx = ForIn (f e1, f e2, f e3)}
    | ForOf (e1, e2, e3) -> {exp with exp_stx = ForOf (f e1, f e2, f e3)}
    | For (e1, e2, e3, e4) -> {exp with exp_stx = For (fop e1, fop e2, fop e3, f e4)}
    | Break _ -> exp
    | Continue _ -> exp
    | Try (e1, e2, e3) -> {exp with exp_stx = Try (f e1, (match e2 with None -> None | Some (x, e2) -> Some (x, f e2)), fop e3)}
    | Switch (e1, e2s) ->
      {exp with exp_stx = Switch (f e1, List.map (
        fun (case, e) ->
          match case with
            | Case ce -> Case (f ce), f e
            | DefaultCase -> DefaultCase, f e
        ) e2s)}
    | Debugger -> exp
    | ConditionalOp (e1, e2, e3) -> {exp with exp_stx = ConditionalOp (f e1, f e2, f e3)}
    | Block es -> {exp with exp_stx = Block (List.map f es)}
    | Script (_, es) ->
      let strict = is_in_strict_mode exp in
      {exp with exp_stx = Script (strict, List.map (add_strictness strict) es)}

let fresh_sth (name : string) : (unit -> string) =
  let counter = ref 0 in
  let rec f () =
    let v = name ^ (string_of_int !counter) in
    counter := !counter + 1;
    v
  in f

let fresh_var : (unit -> string) = fresh_sth "x_"

let fresh_iter_var : (unit -> string) = fresh_sth "x_iter_"