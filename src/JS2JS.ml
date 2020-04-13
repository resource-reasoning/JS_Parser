open JSParserSyntax
open List
open JSParserConstants

let promise_var_name = "__promise__internal_"
let catch_var_name = "e"


let strings_from_exps (exps: exp list) : string list =
  (* This is useful to check whether a list of expressions if formed of strings *)
  fold_left (fun ac exp -> 
              match exp.exp_stx with
              | String s -> ac @ [s]
              | Var s -> ac @ [s]
              | _ -> []) [] exps 

let string_from_propname (p : propname) : string =
  (* For now, we are supporting lambda exps with objects containing strings as property names *)
  match p with
  | PropnameId x | PropnameString x -> x
  | _ -> raise (Failure "Propname not supported") 

(*  C(await e) ::= Promise.await(e) *)
let await_expression_to_call (e : exp) : exp_syntax = 
  (* We assume that the expression e is a promise *)
  let mk_exp_s exp = mk_exp exp 0 [] in
  let await_call = CAccess(mk_exp_s (Var promise_constructor), mk_exp_s (String await_fun))  in  
    Call (mk_exp_s await_call, [ e ])

(*  C(e) ::= Promise.predicate(e) *)
let await_expression_argument (e : exp) : exp = 
  (* We assume that the expression e is a promise *)
  let mk_exp_s exp = mk_exp exp 0 [] in
  let predicate_fun : exp_syntax = CAccess(mk_exp_s (Var promise_constructor), mk_exp_s (String predicate_fun)) in  
  let pred_fun_call : exp_syntax = Call (mk_exp_s predicate_fun, [ e ]) in 
    mk_exp_s pred_fun_call


(* Iterates over Template elements and concat the result with the identifier, if applicable *)
let rec template_literal_to_concat e1s e2s =
  let mk_exp_s exp = mk_exp exp 0 [] in
  (match e1s, e2s with
  | [], [] -> String ""
  (* This case is not possible *)
  | [], (exp::exps) -> BinOp (exp, Arith Plus, mk_exp_s (template_literal_to_concat [] exps))
  | (te::tes), [] -> BinOp (te, Arith Plus, mk_exp_s (template_literal_to_concat tes []))
  | (te::tes), (exp::exps) -> BinOp (mk_exp_s (BinOp (te, Arith Plus, exp)), Arith Plus, (mk_exp_s (template_literal_to_concat tes exps)))) 

(* For now, we only support async functions of the form:
   async fun(...){ ... return exp } *)
let async_to_sync (e: exp) : exp =
  let mk_exp_s exp = mk_exp exp 0 [] in
  (* The expression e is actually the body of the async function *)

  (* The promise_wrapper function compiles a statement to either Promise.resolve(v) or Promise.reject(v) 
  (e: exp) The expression representing the statement to be compiled (it will be either of the form Return e or Throw e most of the times)  
  (exps: exp list) the remaining block 
  (resolve: bool) if true, the statement is compiled to Promise.resolve(v), otherwise Promise.reject(v)
  : exp = the compiled block that now returns a promise *)
  let promise_wrapper (e: exp) (exps: exp list) (resolve: bool) : exp =
    let promise_fun = if resolve then resolve_fun else reject_fun in
    let promise_access = Access (mk_exp_s (Var promise_constructor), promise_fun) in
    let promise_fulfill = Call (mk_exp_s promise_access, [e]) in
    let new_ret         = mk_exp_s (Return (Some (mk_exp_s promise_fulfill))) in
    mk_exp_s (Block (List.rev (new_ret :: exps))) in

  let undefined_exp = mk_exp_s (Var undefined_val) in
  (match e.exp_stx with
  (* If the body is not a block, we don't do anything *)
  | Block exps ->
    (* We need to change the last expression of the block, which should be of the form return exp *)
    (let rev_exps = List.rev exps in
    match rev_exps with
    | [] -> promise_wrapper undefined_exp [] true
    | (e_ret::es) -> 
      (match e_ret.exp_stx with
      (* return e ===> return Promise.resolve(e) *)
      | Return e_ret -> 
        (match e_ret with
        | Some e -> promise_wrapper e es true
        (* TODO: perhaps throw error in the cases below. Check the real behaviour!*) 
        | None -> promise_wrapper undefined_exp es true)
      (* throw e ===> return Promise.reject(e) *)
      | Throw e_err -> promise_wrapper e_err es false
      | _ -> promise_wrapper undefined_exp es true
      ))
  | _ -> e)


let fixed_aux_var = "_____aux_var_" 

let async_to_sync_try_catch (s : exp) : exp =
  let mk_exp_s exp = mk_exp exp 0 [] in
  
  let (var_decl : exp_syntax)     = VarDec [ (fixed_aux_var, None) ] in 

  let undefined_exp = mk_exp_s (Var undefined_val) in
  let catch_var_exp = mk_exp_s (Var catch_var_name) in 
  (**  *)
  let (resolve_call : exp_syntax) = Call (mk_exp_s (Var resolve_fun), [ undefined_exp ]) in 
  let (try_body : exp_syntax)     = Block [ s; mk_exp_s resolve_call ] in 
  let (catch_call : exp_syntax)   = Call (mk_exp_s (Var reject_fun), [ catch_var_exp ]) in 
  let (catch_body : exp_syntax)   = Block [ mk_exp_s catch_call ] in 
  let (try_catch : exp_syntax)    = Try (mk_exp_s try_body, Some (catch_var_name, mk_exp_s catch_body), None) in 
  mk_exp_s (Block [ (mk_exp_s var_decl); (mk_exp_s try_catch) ])

(* 
 * C(s) = 
      var p = new Promise (function (resolve, reject) {
         var _____aux_var_; 
         try { 
            s
            resolve(undefined)
         }
         catch (e) {
           reject(e)
         }
      }); 
      return p 
 *)
let async_to_sync_jose (s : exp) : exp =
  let mk_exp_s exp = mk_exp exp 0 [] in
  (** *)
  let (executor_exp : exp_syntax) =  FunctionExp (true, None, [ resolve_fun; reject_fun ], (async_to_sync_try_catch s), false) in  
  let (promise_exp : exp_syntax)  = New (mk_exp_s (Var promise_constructor), [ mk_exp_s executor_exp ]) in 
  let (var_decl : exp_syntax)     = VarDec [ (promise_var_name, Some (mk_exp_s promise_exp)) ] in 
  let (return_stmt : exp_syntax)  = Return (Some (mk_exp_s (Var promise_var_name))) in 
  let (block_stmt : exp_syntax)   = Block [ (mk_exp_s var_decl); mk_exp_s return_stmt ] in 
  mk_exp_s block_stmt 


let return_to_resolve (e : exp option) : exp = 
  let mk_exp_s exp  = mk_exp exp 0 [] in
  let undefined_exp = mk_exp_s (Var undefined_val) in
  (** *)
  let call_arg : exp = 
    match e with 
      | None   -> undefined_exp 
      | Some e -> e in
  let call_exp : exp = mk_exp_s (Call (mk_exp_s (Var resolve_fun), [ call_arg ])) in 
  call_exp  

let return_to_resolve_finally (e : exp option) : exp = 
  let mk_exp_s exp  = mk_exp exp 0 [] in
  let undefined_exp = mk_exp_s (Var undefined_val) in
  let asgn_arg : exp = 
    match e with 
      | None   -> undefined_exp 
      | Some e -> e in
  let asgn_exp : exp = mk_exp_s (Assign (mk_exp_s (Var fixed_aux_var), asgn_arg)) in 
  asgn_exp 

let make_finally_resolve () : exp = 
  let mk_exp_s exp  = mk_exp exp 0 [] in
  mk_exp_s (Call (mk_exp_s (Var resolve_fun), [ mk_exp_s (Var fixed_aux_var) ]))

(* Transforms forOf into while *)
let for_of_to_while e1 e2 e3 =
  let mk_exp_s exp = mk_exp exp 0 [] in
  (* 1. var iter = obj.getIterator() *)
  let iter_var_name = fresh_iter_var () in
  let iter_var = VarDec [(iter_var_name, None)] in
  let get_iterator_call = Call (mk_exp_s (Access (e2, get_iterator_fun_name)), []) in
  let iter_assignment = Assign(mk_exp_s iter_var, mk_exp_s get_iterator_call) in
  
  (* 2. while(iter.hasNext()) {e = iter.next(); e3 } *)
  let iter_has_next = Call (mk_exp_s (Access (mk_exp_s (Var iter_var_name), has_next_fun_name)), []) in
  let iter_next = Call (mk_exp_s (Access (mk_exp_s (Var iter_var_name), next_fun_name)), []) in
  let e_equal_iter_next = Assign (e1, mk_exp_s iter_next) in
  let while_body = Block [mk_exp_s e_equal_iter_next; e3] in
  let while_has_next = While (mk_exp_s iter_has_next, mk_exp_s while_body) in

  (* We simply return the first command followed by the second*)
  Block [mk_exp_s iter_assignment; mk_exp_s while_has_next] 

(* Transforms lambda into fun decl *)
(* If params are variables, translation is straightforward *)
(* (x1, …, xn)  => { s } becomes function (x1, …, xn) { s } *)
(* Otherwise, we create a function which takes an object as parameter and tries to access the lambda parameters in this obj *)
(* ( {x1, …, xn }) => { s } becomes 
  function (o) { 
    var x1 = o.x1;
    …
    var xn = o.xn; 
    s
} *)
let lambda_to_fdecl (b: bool) (id: string option) (params: exp list) (body: exp) (async: bool): exp_syntax = 
  let mk_exp_s exp = mk_exp exp 0 [] in
  match params with
  | [] -> FunctionExp (b, id, [], body, async)
  | ps when (strings_from_exps ps <> []) ->
    let string_params = strings_from_exps ps in 
    FunctionExp (b, id, string_params, body, async)
  | [single_param] -> 
    (match single_param.exp_stx with
    | Obj props -> 
      let obj_param = "o" in
      let access_list = map 
        (fun (p,_,_) -> 
          let p_str = string_from_propname p in
          (p_str, Some (mk_exp_s (Access (mk_exp_s (Var obj_param), p_str)))
        )) props in
      let fun_body = Block [mk_exp_s (VarDec access_list); body] in
      FunctionExp (b, id, [obj_param], mk_exp_s fun_body, async)
    | _ -> raise (Failure "Lambda expression not supported yet."))
  | _ -> raise (Failure "Lambda expression not supported yet.") 

let rec js2js (with_finally : bool) (async : bool) (exp: exp) : exp =
  let f = js2js with_finally async in

  let ff = js2js true async in 

  let fop e = match e with
    | None -> None
    | Some e -> Some (f e) in

  match exp.exp_stx with
    | Label (x, e) -> {exp with exp_stx = Label (x, f e)}
    | If (e1, e2, e3) -> {exp with exp_stx = If (f e1, f e2, fop e3)}
    | While (e1, e2) -> {exp with exp_stx = While (f e1, f e2)}
    | DoWhile (e1, e2) -> {exp with exp_stx = DoWhile (f e1, f e2)}
    | Delete e -> {exp with exp_stx = Delete (f e)}
    | Comma (e1, e2) -> {exp with exp_stx = Comma (f e1, f e2)}
    | Unary_op (op, e) -> {exp with exp_stx = Unary_op (op, f e)}
    | BinOp (e1, op, e2) -> {exp with exp_stx = BinOp (f e1, op, f e2)}
    | Access (e, x) -> {exp with exp_stx = Access (f e, x)}
    | Call (e1, e2s) -> {exp with exp_stx = Call (f e1, map f e2s)}
    | Assign (e1, e2) -> {exp with exp_stx = Assign (f e1, f e2)}
    | VarDec xs -> {exp with exp_stx = VarDec (List.map (fun (name, e1) -> (name, fop e1)) xs)}
    | AssignOp (e1, op, e2) -> {exp with exp_stx = AssignOp (f e1, op, f e2)}
    | FunctionExp (b, n, xs, e, async) -> 
      let body = if async then async_to_sync_jose (js2js false true e) else (js2js false false e) in
      {exp with exp_stx = FunctionExp (b, n, xs, body, false)}
    | Function (b, n, xs, e, async) -> 
      let body = if async then async_to_sync_jose (js2js false true e) else (js2js false false e) in
      {exp with exp_stx = Function (b, n, xs, body, false)}
    | ArrowExp (b, n, es, e, async) -> 
      let body = if async then async_to_sync_jose (js2js false true e) else (js2js false false e) in
      {exp with exp_stx = lambda_to_fdecl b n (map f es) body async}
    | New (e1, e2s) -> {exp with exp_stx = New (f e1, map f e2s)}
    | Array es -> {exp with exp_stx = Array (List.map fop es)}
    | CAccess (e1, e2) -> {exp with exp_stx = CAccess (f e1, f e2)}
    | With (e1, e2) -> {exp with exp_stx = With (f e1, f e2)}
    | Throw e -> {exp with exp_stx = Throw (f e)}
    | Return e ->
        if async 
          then (if with_finally 
                  then (
                    return_to_resolve_finally (fop e)
                  )
                  else (
                    return_to_resolve (fop e)
                  ))         
          else (
            {exp with exp_stx = Return (fop e) }
          )
    | Await e -> 
        let e' = await_expression_argument (f e) in
          { exp with exp_stx = Await e' }
    | TemplateLiteral (e1s, e2s) -> {exp with exp_stx = (template_literal_to_concat (map f e1s) (map f e2s))}
    | TemplateElement (s1, _, _) -> {exp with exp_stx = String s1}
    | ForIn (e1, e2, e3) -> {exp with exp_stx = ForIn (f e1, f e2, f e3)}
    | ForOf (e1, e2, e3) -> {exp with exp_stx = (for_of_to_while (f e1) (f e2) (f e3))}
    | For (e1, e2, e3, e4) -> {exp with exp_stx = For (fop e1, fop e2, fop e3, f e4)}
    | Try (e1, e2, Some e3) -> 
       let e3' = f e3 in 
       let e3 = { e3' with exp_stx = Block [ e3; make_finally_resolve() ] } in 
       { exp with exp_stx = Try (ff e1, (match e2 with None -> None | Some (x, e2) -> Some (x, f e2)), Some e3)  }
    | Try (e1, e2, e3) -> {exp with exp_stx = Try (f e1, (match e2 with None -> None | Some (x, e2) -> Some (x, f e2)), fop e3)}
    | Switch (e1, e2s) -> {exp with exp_stx = 
      Switch (f e1, List.map (
        fun (case, e) ->
          match case with
          | Case ce -> Case (f ce), f e
          | DefaultCase -> DefaultCase, f e
        ) e2s)}
    | ConditionalOp (e1, e2, e3) -> {exp with exp_stx = ConditionalOp (f e1, f e2, f e3)}
    | Block es -> {exp with exp_stx = Block (map f es)}
    | Script (b, es) -> {exp with exp_stx = Script (b, map f es)}       
    | _ -> exp