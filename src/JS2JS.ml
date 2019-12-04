open JSParserSyntax
open List
 
let rec js2js (exp: exp) : exp =
  let f = js2js in

  let rec template_literal_to_concat e1s e2s =
    (* Iterate over Template elements and concat the result with the identifier, if applicable *)
    (match e1s, e2s with
    | [], [] -> String ""
    (* This case is not possible *)
    | [], (exp::exps) -> BinOp (js2js exp, Arith Plus, mk_exp (template_literal_to_concat [] exps) 0 [])
    | (te::tes), [] -> BinOp (js2js te, Arith Plus, mk_exp (template_literal_to_concat tes []) 0 [])
    | (te::tes), (exp::exps) -> BinOp (mk_exp (BinOp (js2js te, Arith Plus, js2js exp)) 0 [], Arith Plus, (mk_exp (template_literal_to_concat tes exps) 0 []))) in

  let for_of_to_while e1 e2 e3 =
    let mk_exp_s exp = mk_exp exp 0 [] in

    (* Transforms forOf into while *)
    (* 1. var iter = obj.getIterator() *)
    let iter_var_name = fresh_iter_var () in
    let iter_var = VarDec [(iter_var_name, None)] in
    let get_iterator_call = Call (mk_exp_s (Access (e2, "getIterator")), []) in
    let iter_assignment = Assign(mk_exp_s iter_var, mk_exp_s get_iterator_call) in
    
    (* 2. while(iter.hasNext()) {e = iter.next(); e3 } *)
    let iter_has_next = Call (mk_exp_s (Access (mk_exp_s (Var iter_var_name), "hasNext")), []) in
    let iter_next = Call (mk_exp_s (Access (mk_exp_s (Var iter_var_name), "next")), []) in
    let e_equal_iter_next = Assign (e1, mk_exp_s iter_next) in
    let while_body = Block [mk_exp_s e_equal_iter_next; e3] in
    let while_has_next = While (mk_exp_s iter_has_next, mk_exp_s while_body) in

    (* We simply return the first command followed by the second*)
    Block [mk_exp_s iter_assignment; mk_exp_s while_has_next] in

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
    | AssignOp (e1, op, e2) -> {exp with exp_stx = AssignOp (f e1, op, f e2)}
    | FunctionExp (b, n, xs, e, async) -> {exp with exp_stx = FunctionExp (b, n, xs, f e, async)}
    | Function (b, n, xs, e, async) -> {exp with exp_stx = Function (b, n, xs, f e, async)}
    | ArrowExp (b, n, es, e) -> {exp with exp_stx = exp.exp_stx}
    | New (e1, e2s) -> {exp with exp_stx = New (f e1, map f e2s)}
    | Array es -> {exp with exp_stx = Array (List.map fop es)}
    | CAccess (e1, e2) -> {exp with exp_stx = CAccess (f e1, f e2)}
    | With (e1, e2) -> {exp with exp_stx = With (f e1, f e2)}
    | Throw e -> {exp with exp_stx = Throw (f e)}
    | Return e -> {exp with exp_stx = Return (fop e)}
    | Await e -> {exp with exp_stx = Await (f e)}
    | TemplateLiteral (e1s, e2s) -> {exp with exp_stx = (template_literal_to_concat e1s e2s)}
    | TemplateElement (s1, _, _) -> {exp with exp_stx = String s1}
    | ForIn (e1, e2, e3) -> {exp with exp_stx = ForIn (f e1, f e2, f e3)}
    | ForOf (e1, e2, e3) -> {exp with exp_stx = (for_of_to_while e1 e2 e3)}
    | For (e1, e2, e3, e4) -> {exp with exp_stx = For (fop e1, fop e2, fop e3, f e4)}
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