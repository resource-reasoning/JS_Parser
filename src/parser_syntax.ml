open List

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
  | VarDec of var * exp option (* var x *)
  | This                  (* this *)
  | Delete of exp         (* delete e *)
  | Comma of exp * exp    (* e, e *)
  | Unary_op of unary_op * exp       (* unary_op e *)
  | BinOp of exp * bin_op * exp  (* e op e*)
  | Access of exp * string (* e.x *)
  | Call of exp * exp list     (* e(e1,..,en) *)
  | Assign of exp * exp   (* e = e *)
  | AssignOp of exp * arith_op * exp   (* e op= e *)
  | AnnonymousFun of var list * exp (* function (x1,..,x2){e} *)
  | NamedFun of string * var list * exp (* function x(x1,..,x2){e} *)
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
  | Block of exp list (* { es }*)
and switch_case =
  | Case of exp
  | DefaultCase
  
let mk_exp_with_annot s o annots =
  { exp_offset = o; exp_stx = s; exp_annot = annots }

let mk_exp s o =
  mk_exp_with_annot s o []