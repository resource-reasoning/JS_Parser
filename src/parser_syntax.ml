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
  | TopRequires
  | TopEnsures
  | Requires
  | Ensures
  | Invariant
  | Codename
  | PredDefn

type annotation = 
  { 
    annot_type : annotation_type;
    annot_formula : string
  }
  
let is_top_spec annot : bool =
  annot.annot_type = TopRequires || annot.annot_type = TopEnsures || annot.annot_type = PredDefn
  
let is_function_spec annot : bool =
  annot.annot_type = Requires || annot.annot_type = Ensures || annot.annot_type = Codename || annot.annot_type = PredDefn
  
let is_invariant annot : bool =
  annot.annot_type = Invariant 

type exp = { exp_offset : int; exp_stx : exp_syntax; exp_annot : annotation list}
and exp_syntax =
  | Num of float            (* 17 *)
  | String of string      (* "abc" *)
  | Label of string * exp (* label: exp *)
  | Null                  (* null *)
  | Bool of bool          (* true, false *)
  | Seq of exp * exp      (* e; e *)
  | Var of var            (* x *)
  | If of exp * exp * exp option (* if (e){e}{e} *)
  | While of exp * exp   (* while (e){e} *)
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
  | AnnonymousFun of bool * var list * exp (* function (x1,..,x2){e} *)
  | NamedFun of bool * string * var list * exp (* function x(x1,..,x2){e} *)
  | New of exp * exp list      (* new e(e1,..,en) *)
  | Obj of (string * exp) list (* {x_i : e_i} *)
  | Array of (exp option) list (* [e1,...,en] *)
  | CAccess of exp * exp  (* e[e] *)
  | With of exp * exp     (* with (e){e} *)
  | Skip
  | Throw of exp          (* throw e *)
  | Return of exp option        (* return e *)
  | RegExp of string * string (* / pattern / flags *)
  | ForIn of exp * exp * exp (* for (exp in exp) {exp}*)
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
  
let mk_exp_with_annot s o annots =
  { exp_offset = o; exp_stx = s; exp_annot = annots }

let mk_exp s o =
  mk_exp_with_annot s o []
  
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
    | Seq (e1, e2) -> {exp with exp_stx = Seq (f e1, f e2)}
    | Var x -> exp
    | If (e1, e2, e3) -> {exp with exp_stx = If (f e1, f e2, fop e3)}
    | While (e1, e2) -> {exp with exp_stx = While (f e1, f e2)}
    | VarDec xs -> exp
    | This -> exp
    | Delete e -> {exp with exp_stx = Delete (f e)}
    | Comma (e1, e2) -> {exp with exp_stx = Comma (f e1, f e2)}
    | Unary_op (op, e) -> {exp with exp_stx = Unary_op (op, f e)}
    | BinOp (e1, op, e2) -> {exp with exp_stx = BinOp (f e1, op, f e2)}
    | Access (e, x) -> {exp with exp_stx = Access (f e, x)}
    | Call (e1, e2s) -> {exp with exp_stx = Call (f e1, List.map f e2s)}
    | Assign (e1, e2) -> {exp with exp_stx = Assign (f e1, f e2)}
    | AssignOp (e1, op, e2) -> {exp with exp_stx = AssignOp (f e1, op, f e2)}
    | AnnonymousFun (_, xs, e) -> 
      let strict = parent_strict || is_in_strict_mode e in
      {exp with exp_stx = AnnonymousFun (strict, xs, add_strictness strict e)}
    | NamedFun (_, n, xs, e) -> 
      let strict = parent_strict || is_in_strict_mode e in
      {exp with exp_stx = NamedFun (strict, n, xs, add_strictness strict e)}
    | New (e1, e2s) -> {exp with exp_stx = New (f e1, List.map f e2s)}
    | Obj l -> {exp with exp_stx = Obj (List.map (fun (x, e) -> (x, f e)) l)}
    | Array es -> {exp with exp_stx = Array (List.map fop es)}
    | CAccess (e1, e2) -> {exp with exp_stx = CAccess (f e1, f e2)}
    | With (e1, e2) -> {exp with exp_stx = With (f e1, f e2)}
    | Skip -> exp
    | Throw e -> {exp with exp_stx = Throw (f e)}
    | Return e -> {exp with exp_stx = Return (fop e)}
    | RegExp (s1, s2) -> exp
    | ForIn (e1, e2, e3) -> {exp with exp_stx = ForIn (f e1, f e2, f e3)}
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