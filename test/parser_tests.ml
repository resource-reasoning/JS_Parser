open OUnit2
open Parser_syntax
open Parser_main

let mk_exp s o = Parser_syntax.mk_exp s o []

let mk_exp_with_annot = Parser_syntax.mk_exp

(* Equality testing function for expressions, ignoring the character offsets *)
let rec exp_stx_eq e1 e2 =
  match (e1.exp_stx, e2.exp_stx) with
  | (Label (s, e), Label (s', e'))
  | (Access (e, s), Access (e', s'))
     -> s = s' && exp_stx_eq e e'
  | (Unary_op (op, e), Unary_op (op', e'))
     -> op = op' && exp_stx_eq e e'

  | (Delete e, Delete e')
  | (Throw e, Throw e')
     -> exp_stx_eq e e'

  | (While   (e1, e2), While   (e1', e2'))
  | (Comma   (e1, e2), Comma   (e1', e2'))
  | (Assign  (e1, e2), Assign  (e1', e2'))
  | (DoWhile (e1, e2), DoWhile (e1', e2'))
  | (CAccess (e1, e2), CAccess (e1', e2'))
  | (With    (e1, e2), With    (e1', e2'))
     -> exp_stx_eq e1 e1' && exp_stx_eq e2 e2'

  | (BinOp (e1, op, e2), BinOp (e1', op', e2'))
     -> op = op' && exp_stx_eq e1 e1' && exp_stx_eq e2 e2'
  | (AssignOp (e1, op, e2), AssignOp (e1', op', e2'))
     -> op = op' && exp_stx_eq e1 e1' && exp_stx_eq e2 e2'

  | (ForIn (e1, e2, e3), ForIn (e1', e2', e3'))
  | (ConditionalOp (e1, e2, e3), ConditionalOp (e1', e2', e3'))
     -> exp_stx_eq e1 e1' && exp_stx_eq e3 e3' && exp_stx_eq e3 e3'

  | (If (e1, e2, o), If (e1', e2', o'))
      -> exp_stx_eq e1 e1' && exp_stx_eq e2 e2' && opt_exp_eq o o'

  | (VarDec l, VarDec l')
      -> List.for_all2 (fun (s, o) (s', o') -> s = s' && opt_exp_eq o o') l l'

  | (Call (e, l), Call (e', l'))
  | (New (e, l), New (e', l'))
      -> exp_stx_eq e e' && List.for_all2 exp_stx_eq l l'

  | (FunctionExp (b, o, l, e), FunctionExp (b', o', l', e'))
  | (Function    (b, o, l, e), Function    (b', o', l', e'))
      -> b = b' && o = o' && l = l' && exp_stx_eq e e'

  | (Obj l, Obj l')
      -> List.for_all2 (fun (pn, pt, e) (pn', pt', e') -> pn = pn' && pt = pt' && exp_stx_eq e e') l l'

  | (Block l, Block l')
      -> list_exp_eq l l'

  | (Array l, Array l')
      -> List.for_all2 opt_exp_eq l l'

  | (Return o, Return o')
      -> opt_exp_eq o o'

  | (Script (b, l), Script (b', l'))
      -> b = b' && list_exp_eq l l'

  | (For (o1, o2, o3, e), For (o1', o2', o3', e'))
      -> opt_exp_eq o1 o1' && opt_exp_eq o2 o2' && opt_exp_eq o3 o3' && exp_stx_eq e e'

  | (Try (e, o, oe), Try (e', o', oe'))
      -> exp_stx_eq e e' &&
         BatOption.eq ~eq:(fun (s, e) (s', e') -> s = s' && exp_stx_eq e e') o o' &&
         opt_exp_eq oe oe'

  | (Switch (e, l), Switch (e', l'))
      -> exp_stx_eq e e' &&
         List.for_all2 (fun (c, e) (c', e') -> switch_case_eq c c' && exp_stx_eq e e') l l'

  | (s1, s2) -> s1 = s2

and switch_case_eq c c' =
  match c, c' with
  | Case e, Case e' -> exp_stx_eq e e'
  | c, c' -> c = c'

and opt_exp_eq o o' =
  BatOption.eq ~eq:exp_stx_eq o o'
and list_exp_eq l l' =
  List.for_all2 exp_stx_eq l l'

let assert_equal' = assert_equal ~printer:BatPervasives.dump

let assert_exp_eq = assert_equal' ~cmp:exp_stx_eq

let skip_testing_annots () = ()
  (* skip_if !use_json "JSON parser doesn't support annotations." *)

let add_script e =
  mk_exp (Script(false, [e])) 0

let rm_node e =
  match e.exp_stx with
  | Script (_, [e]) | Label (_, e) -> e
  | _ -> assert_failure "Could not find a matching Script or Label tag."

(** * Tests begin here * **)

let test_unescape_html test_ctx =
  assert_equal' "<>&\"'" (Parser.unescape_html "&lt;&gt;&amp;&quot;&apos;")

let test_unescape_html_number test_ctx =
  assert_equal' "a\009a" (Parser.unescape_html "a&#9;a")

let test_unescape_html_hex test_ctx =
  assert_equal' "abb\009abb\010" (Parser.unescape_html "abb&#x9;abb&#xA;")

let test_unescape_html_1 test_ctx =
  let exp = exp_from_string "var o = \"3 < 2\"" in
  let s = mk_exp (String "3 < 2") 8 in
  assert_exp_eq (add_script(mk_exp(VarDec ["o", Some s]) 0)) exp

let test_var test_ctx =
  let exp = exp_from_string "var x" in
  assert_exp_eq (add_script (mk_exp (VarDec ["x", None]) 0)) exp

let test_var_value test_ctx =
  let exp = exp_from_string "var x = 5" in
  let num_5 = mk_exp (Num 5.0) 8 in
  assert_exp_eq (add_script(mk_exp (VarDec ["x", Some num_5]) 0)) exp

let test_var_list test_ctx =
  let exp = exp_from_string "var x = 5, y = null" in
  let num_5 = mk_exp (Num 5.0) 8 in
  let nul = mk_exp Null 15 in
  let vardec = mk_exp (VarDec [("x", Some num_5);("y", Some nul)]) 0 in
  assert_exp_eq (add_script vardec) exp

let test_regexp test_ctx =
  let exp = exp_from_string "/^\\s+/" in
  assert_exp_eq (add_script (mk_exp (RegExp ("^\\s+", "")) 0)) exp

let test_regexp_with_flags test_ctx =
  let exp = exp_from_string "/^\\s+/g" in
  assert_exp_eq (add_script (mk_exp (RegExp ("^\\s+", "g")) 0)) exp

let test_not test_ctx =
  let exp = exp_from_string "!selector" in
  let selector = mk_exp (Var "selector") 1 in
  assert_exp_eq (add_script (mk_exp (Unary_op (Not, selector)) 0)) exp

let test_caccess test_ctx =
  let exp = exp_from_string "this[0]" in
  let this = mk_exp This 0 in
  let zero = mk_exp (Num 0.0) 5 in
  assert_exp_eq (add_script (mk_exp (CAccess (this, zero)) 0)) exp

let test_and test_ctx =
  let exp = exp_from_string "a && b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Boolean And, b)) 0)) exp

let test_array_literal test_ctx =
  let exp = exp_from_string "[,x,,y]" in
  let x = mk_exp (Var "x") 2 in
  let y = mk_exp (Var "y") 5 in
  assert_exp_eq (add_script (mk_exp (Array [None; Some x; None; Some y]) 0)) exp

let test_ge test_ctx =
  let exp = exp_from_string "1 >= 2" in
  let one = mk_exp (Num 1.0) 0 in
  let two = mk_exp (Num 2.0) 5 in
  assert_exp_eq (add_script (mk_exp (BinOp (one, Comparison Ge, two)) 0)) exp

let test_or test_ctx =
  let exp = exp_from_string "a || b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Boolean Or, b)) 0)) exp

let test_not_triple_eq test_ctx =
  let exp = exp_from_string "a !== b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 6 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Comparison NotTripleEqual, b)) 0)) exp

let test_hook test_ctx =
  let exp = exp_from_string "a >= b ? a : b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  let ab = mk_exp (BinOp (a, Comparison Ge, b)) 0 in
  let a9 = mk_exp (Var "a") 9 in
  let b13 = mk_exp (Var "b") 13 in
  assert_exp_eq (add_script (mk_exp (ConditionalOp (ab, a9, b13)) 0)) exp

let test_instanceof test_ctx =
  let exp = exp_from_string "a instanceof b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 13 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Comparison InstanceOf, b)) 0)) exp

let test_typeof test_ctx =
  let exp = exp_from_string "typeof selector" in
  let selector = mk_exp (Var "selector") 7 in
  assert_exp_eq (add_script (mk_exp (Unary_op (TypeOf, selector)) 0)) exp

let test_pos test_ctx =
  let exp = exp_from_string "+(a + 1)" in
  let a = mk_exp (Var "a") 2 in
  let one = mk_exp (Num 1.0) 6 in
  let a1 = mk_exp (BinOp (a, Arith Plus, one)) 2 in
  assert_exp_eq (add_script (mk_exp (Unary_op (Positive, a1)) 0)) exp

let test_dec_pre test_ctx =
  let exp = exp_from_string "--a" in
  let a = mk_exp (Var "a") 2 in
  assert_exp_eq (add_script (mk_exp (Unary_op (Pre_Decr, a)) 0)) exp

let test_dec_post test_ctx =
  let exp = exp_from_string "a--" in
  let a = mk_exp (Var "a") 0 in
  assert_exp_eq (add_script (mk_exp (Unary_op (Post_Decr, a)) 0)) exp

let test_inc_pre test_ctx =
  let exp = exp_from_string "++a" in
  let a = mk_exp (Var "a") 2 in
  assert_exp_eq (add_script (mk_exp (Unary_op (Pre_Incr, a)) 0)) exp

let test_inc_post test_ctx =
  let exp = exp_from_string "a++" in
  let a = mk_exp (Var "a") 0 in
  assert_exp_eq (add_script (mk_exp (Unary_op (Post_Incr, a)) 0)) exp

let test_for test_ctx =
  let exp = exp_from_string "for (; a < 5; a++ ) { x = 1 }" in
  let empty = None in
  let a = mk_exp (Var "a") 0 in
  let five = mk_exp (Num 5.0) 0 in
  let condition = Some (mk_exp (BinOp (a, Comparison Lt, five)) 0) in
  let a = mk_exp (Var "a") 0 in
  let inc = Some (mk_exp (Unary_op (Post_Incr, a)) 0) in
  let one = mk_exp (Num 1.0) 0 in
  let x = mk_exp (Var "x") 0 in
  let assignment = mk_exp (Assign (x, one)) 0 in
  let block = mk_exp (Block [assignment]) 0 in
  let loop = mk_exp (For (empty, condition, inc, block)) 0 in
  assert_exp_eq (add_script loop) exp

let test_for_annot test_ctx =
  skip_testing_annots ();
  let exp = exp_from_string "for (; a < 5; a++ ) { /** @invariant #cScope = [#lg] */ x = 1 }" in
  assert_equal' (rm_node exp).exp_annot [{annot_type = Invariant; annot_formula = "#cScope = [#lg]"}]

let test_forin test_ctx =
  let exp = exp_from_string "for (var prop in oldObj) { obj[prop] = oldObj[prop] }" in
  let varprop = mk_exp (VarDec ["prop", None]) 5 in
  let oldObj1= mk_exp (Var "oldObj") 17 in
  let obj = mk_exp (Var "obj") 27 in
  let prop1 = mk_exp (Var "prop") 31 in
  let ca1 = mk_exp (CAccess (obj, prop1)) 27 in
  let oldObj2 = mk_exp (Var "oldObj") 39 in
  let prop2 = mk_exp (Var "prop") 46 in
  let ca2 = mk_exp (CAccess (oldObj2, prop2)) 39 in
  let assignment = mk_exp (Assign (ca1, ca2)) 27 in
  let block = mk_exp (Block [assignment]) 25 in
  assert_exp_eq (add_script (mk_exp (ForIn (varprop, oldObj1, block)) 0)) exp

let test_assign_add test_ctx =
  let exp = exp_from_string "a += b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Plus, b)) 0)) exp

let test_assign_sub test_ctx =
  let exp = exp_from_string "a -= b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Minus, b)) 0)) exp

let test_assign_mul test_ctx =
  let exp = exp_from_string "a *= b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Times, b)) 0)) exp

let test_assign_div test_ctx =
  let exp = exp_from_string "a /= b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Div, b)) 0)) exp

let test_assign_mod test_ctx =
  let exp = exp_from_string "a %= b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Mod, b)) 0)) exp

let test_assign_ursh test_ctx =
  let exp = exp_from_string "a >>>= b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 7 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Ursh, b)) 0)) exp

let test_assign_lsh test_ctx =
  let exp = exp_from_string "a <<= b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 6 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Lsh, b)) 0)) exp

let test_assign_rsh test_ctx =
  let exp = exp_from_string "a >>= b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 6 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Rsh, b)) 0)) exp

let test_assign_bitand test_ctx =
  let exp = exp_from_string "a &= b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Bitand, b)) 0)) exp

let test_assign_bitor test_ctx =
  let exp = exp_from_string "a |= b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Bitor, b)) 0)) exp

let test_assign_bitxor test_ctx =
  let exp = exp_from_string "a ^= b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (AssignOp (a, Bitxor, b)) 0)) exp

let test_notequal test_ctx =
  let exp = exp_from_string "a != b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Comparison NotEqual, b)) 0)) exp

let test_gt test_ctx =
  let exp = exp_from_string "a > b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 4 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Comparison Gt, b)) 0)) exp

let test_in test_ctx =
  let exp = exp_from_string "a in b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Comparison In, b)) 0)) exp

let test_comma1 test_ctx =
  let exp = exp_from_string "a , b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 4 in
  assert_exp_eq (add_script (mk_exp (Comma (a, b)) 0)) exp

let test_comma2 test_ctx =
  let exp = exp_from_string "a, b, c" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 3 in
  let c = mk_exp (Var "c") 6 in
  let ab = mk_exp (Comma (a, b)) 0 in
  assert_exp_eq (add_script (mk_exp (Comma (ab, c)) 0)) exp

let test_negative test_ctx =
  let exp = exp_from_string "-a" in
  let a = mk_exp (Var "a") 1 in
  assert_exp_eq (add_script (mk_exp (Unary_op (Negative, a)) 0)) exp

let test_bitnot test_ctx =
  let exp = exp_from_string "~a" in
  let a = mk_exp (Var "a") 1 in
  assert_exp_eq (add_script (mk_exp (Unary_op (Bitnot, a)) 0)) exp

let test_void test_ctx =
  let exp = exp_from_string "void a" in
  let a = mk_exp (Var "a") 5 in
  assert_exp_eq (add_script (mk_exp (Unary_op (Void, a)) 0)) exp

let test_mod test_ctx =
  let exp = exp_from_string "a % b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 4 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Arith Mod, b)) 0)) exp

let test_ursh test_ctx =
  let exp = exp_from_string "a >>> b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 6 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Arith Ursh, b)) 0)) exp

let test_lsh test_ctx =
  let exp = exp_from_string "a << b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Arith Lsh, b)) 0)) exp

let test_rsh test_ctx =
  let exp = exp_from_string "a >> b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 5 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Arith Rsh, b)) 0)) exp

let test_bitand test_ctx =
  let exp = exp_from_string "a & b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 4 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Arith Bitand, b)) 0)) exp

let test_bitor test_ctx =
  let exp = exp_from_string "a | b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 4 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Arith Bitor, b)) 0)) exp

let test_bitxor test_ctx =
  let exp = exp_from_string "a ^ b" in
  let a = mk_exp (Var "a") 0 in
  let b = mk_exp (Var "b") 4 in
  assert_exp_eq (add_script (mk_exp (BinOp (a, Arith Bitxor, b)) 0)) exp

let test_return test_ctx =
  let exp = exp_from_string "function f() {return}" in
  let r = mk_exp (Return None) 14 in
  let block = mk_exp (Block [r]) 13 in
  assert_exp_eq (add_script (mk_exp (Function (false, Some "f", [], block)) 0)) exp

let test_return_exp test_ctx =
  let exp = exp_from_string "function f() {return g()}" in
  let g = mk_exp (Var "g") 21 in
  let gcall = mk_exp (Call (g, [])) 21 in
  let r = mk_exp (Return (Some gcall)) 14 in
  let block = mk_exp (Block [r]) 13 in
  assert_exp_eq (add_script (mk_exp (Function (false, Some "f", [], block)) 0)) exp

let test_do_while test_ctx =
  let exp = exp_from_string "do { a = 1 } while (a < 5)" in
  let a = mk_exp (Var "a") 0 in
  let five = mk_exp (Num 5.0) 0 in
  let condition = mk_exp (BinOp (a, Comparison Lt, five)) 0 in
  let a = mk_exp (Var "a") 0 in
  let one = mk_exp (Num 1.0) 0 in
  let assignment = mk_exp (Assign (a, one)) 0 in
  let body = mk_exp (Block [assignment]) 0 in
  let loop = mk_exp (DoWhile (body, condition)) 0 in
  assert_exp_eq (add_script loop) exp

let test_do_while_annot test_ctx =
  skip_testing_annots ();
  let exp = exp_from_string "do { /** @invariant #cScope = [#lg] */ a = 1 } while (a < 5)" in
  assert_equal' (rm_node exp).exp_annot [{annot_type = Invariant; annot_formula = "#cScope = [#lg]"}]

let test_delete test_ctx =
  let exp = exp_from_string "delete a" in
  let a = mk_exp (Var "a") 7 in
  assert_exp_eq (add_script (mk_exp (Delete a) 0)) exp

let test_continue test_ctx =
  let exp = exp_from_string "while (a > 5) {a++; continue}" in
  let a = mk_exp (Var "a") 0 in
  let five = mk_exp (Num 5.0) 0 in
  let condition = mk_exp (BinOp (a, Comparison Gt, five)) 0 in
  let a = mk_exp (Var "a") 0 in
  let app = mk_exp (Unary_op (Post_Incr, a)) 0 in
  let cont = mk_exp (Continue None) 0 in
  let body = mk_exp (Block [app; cont]) 0 in
  assert_exp_eq (add_script (mk_exp (While (condition, body)) 0)) exp

let test_continue_annot test_ctx =
  skip_testing_annots ();
  let exp = exp_from_string "while (a > 5) {/** @invariant #cScope = [#lg] */ a++; continue}" in
  assert_equal' (rm_node exp).exp_annot [{annot_type = Invariant; annot_formula = "#cScope = [#lg]"}]

let test_continue_label test_ctx =
  let exp = exp_from_string "test: while (a > 5) {a++; continue test}" in
  let a = mk_exp (Var "a") 0 in
  let five = mk_exp (Num 5.0) 0 in
  let condition = mk_exp (BinOp (a, Comparison Gt, five)) 0 in
  let a = mk_exp (Var "a") 0 in
  let app = mk_exp (Unary_op (Post_Incr, a)) 0 in
  let cont = mk_exp (Continue (Some "test")) 0 in
  let body = mk_exp (Block [app; cont]) 0 in
  let loop = mk_exp (While (condition, body)) 0 in
  assert_exp_eq (add_script (mk_exp (Label ("test", loop)) 0)) exp

let test_continue_label_annot test_ctx =
  skip_testing_annots ();
  let exp = exp_from_string "test: while (a > 5) {/** @invariant #cScope = [#lg] */ a++; continue test}" in
  assert_equal' (rm_node (rm_node exp)).exp_annot [{annot_type = Invariant; annot_formula = "#cScope = [#lg]"}]

let test_break test_ctx =
  let exp = exp_from_string "while (a > 5) {a++; break}" in
  let a = mk_exp (Var "a") 0 in
  let five = mk_exp (Num 5.0) 0 in
  let condition = mk_exp (BinOp (a, Comparison Gt, five)) 0 in
  let a = mk_exp (Var "a") 0 in
  let app = mk_exp (Unary_op (Post_Incr, a)) 0 in
  let cont = mk_exp (Break None) 0 in
  let body = mk_exp (Block [app; cont]) 0 in
  assert_exp_eq (add_script (mk_exp (While (condition, body)) 0)) exp

let test_break_annot test_ctx =
  skip_testing_annots ();
  let exp = exp_from_string "while (a > 5) {/** @invariant #cScope = [#lg] */ a++; break}" in
  assert_equal' (rm_node exp).exp_annot [{annot_type = Invariant; annot_formula = "#cScope = [#lg]"}]

let test_break_label test_ctx =
  let exp = exp_from_string "test: while (a > 5) {a++; break test}" in
  let a = mk_exp (Var "a") 0 in
  let five = mk_exp (Num 5.0) 0 in
  let condition = mk_exp (BinOp (a, Comparison Gt, five)) 0 in
  let a = mk_exp (Var "a") 0 in
  let app = mk_exp (Unary_op (Post_Incr, a)) 0 in
  let cont = mk_exp (Break (Some "test")) 0 in
  let body = mk_exp (Block [app; cont]) 0 in
  let loop = mk_exp (While (condition, body)) 0 in
  assert_exp_eq (add_script (mk_exp (Label ("test", loop)) 0)) exp

let test_break_label_annot test_ctx =
  skip_testing_annots ();
  let exp = exp_from_string "test: while (a > 5) {/** @invariant #cScope = [#lg] */ a++; break test}" in
  assert_equal' (rm_node (rm_node exp)).exp_annot [{annot_type = Invariant; annot_formula = "#cScope = [#lg]"}]

let test_get_invariant test_ctx =
  let xml = " <WHILE pos=\"0\">
						    <GT pos=\"7\">
						      <NAME pos=\"7\" value=\"a\"/>
						      <NUMBER pos=\"11\" value=\"5.0\"/>
						    </GT>
						    <BLOCK pos=\"14\">
						      <EXPR_RESULT pos=\"49\">
						        <INC decpos=\"post\" pos=\"49\">
						          <ANNOTATION formula=\"#cScope = [#lg]\" pos=\"49\" type=\"invariant\"/>
						          <NAME pos=\"49\" value=\"a\"/>
						        </INC>
						      </EXPR_RESULT>
						      <CONTINUE pos=\"54\"/>
						    </BLOCK>
						  </WHILE>" in
  let xml = Xml.parse_string xml in
  assert_equal' [{annot_type = Invariant; annot_formula = "#cScope = [#lg]"}] (Parser.get_invariant xml)

let test_try_catch test_ctx =
  let exp = exp_from_string "try {a} catch (b) {c}" in
  let a = mk_exp (Var "a") 5 in
  let ablock = mk_exp (Block [a]) 4 in
  let c = mk_exp (Var "c") 19 in
  let cblock = mk_exp (Block [c]) 18 in
  assert_exp_eq (add_script (mk_exp (Try (ablock, Some ("b", cblock), None)) 0)) exp

let test_try_catch_finally test_ctx =
  let exp = exp_from_string "try {a} catch (b) {c} finally {d}" in
  let a = mk_exp (Var "a") 5 in
  let ablock = mk_exp (Block [a]) 4 in
  let c = mk_exp (Var "c") 19 in
  let cblock = mk_exp (Block [c]) 18 in
  let d = mk_exp (Var "d") 31 in
  let dblock = mk_exp (Block [d]) 30 in
  assert_exp_eq (add_script (mk_exp (Try (ablock, Some ("b", cblock), Some dblock)) 0)) exp

let test_try_finally test_ctx =
  let exp = exp_from_string "try {a} finally {d}" in
  let a = mk_exp (Var "a") 5 in
  let ablock = mk_exp (Block [a]) 4 in
  let d = mk_exp (Var "d") 17 in
  let dblock = mk_exp (Block [d]) 16 in
  assert_exp_eq (add_script (mk_exp (Try (ablock, None, Some dblock)) 0)) exp

let test_switch test_ctx =
  let exp = exp_from_string "switch (a) { case 1 : b; break; default : d; case 2 : c }" in
  let a = mk_exp (Var "a") 8 in
  let one = mk_exp (Num 1.0) 18 in
  let b = mk_exp (Var "b") 22 in
  let break = mk_exp (Break None) 25 in
  let block1 = mk_exp (Block [b; break]) 13 in
  let d = mk_exp (Var "d") 42 in
  let block2 = mk_exp (Block [d]) 32 in
  let two = mk_exp (Num 2.0) 50 in
  let c = mk_exp (Var "c") 54 in
  let block3 = mk_exp (Block [c]) 45 in
  assert_exp_eq (add_script (mk_exp (Switch (a, [(Case one, block1); (DefaultCase, block2); (Case two, block3)])) 0)) exp

let test_debugger test_ctx =
  let exp = exp_from_string "debugger" in
  assert_exp_eq (add_script (mk_exp Debugger 0)) exp

let test_top_annotations test_ctx =
  skip_testing_annots ();
  let exp = exp_from_string "/** @topensures #cScope = [#lg] */ debugger" in
  assert_equal' (mk_exp_with_annot (Script (false, [mk_exp Debugger 35])) 0 [{annot_type = TopEnsures; annot_formula = "#cScope = [#lg]"}]) exp

let test_script_strict test_ctx =
  let exp = exp_from_string "'use strict'; function f() {return}" in
  let string_exp = mk_exp (String "use strict") 0 in
  let r = mk_exp (Return None) 28 in
  let block = mk_exp (Block [r]) 27 in
  let script = mk_exp (Script (true, [string_exp; mk_exp (Function (true, Some "f", [], block)) 14])) 0 in
  assert_exp_eq script exp

let test_script_not_strict test_ctx =
  let exp = exp_from_string "{'use strict'}; function f() {return}" in
  let string_exp = mk_exp (String "use strict") 1 in
  let block_strict = mk_exp (Block [string_exp]) 0 in
  let r = mk_exp (Return None) 30 in
  let block = mk_exp (Block [r]) 29 in
  let empty = mk_exp Skip 14 in
  let script = mk_exp (Script (false, [block_strict; empty; mk_exp (Function (false, Some "f", [], block)) 16])) 0 in
  assert_exp_eq script exp

let test_fun_strict test_ctx =
  let exp = exp_from_string "function f() {'use strict'; return}" in
  let string_exp = mk_exp (String "use strict") 14 in
  let r = mk_exp (Return None) 28 in
  let block = mk_exp (Block [string_exp; r]) 13 in
  let script = mk_exp (Script (false, [mk_exp (Function (true, Some "f", [], block)) 0])) 0 in
  assert_exp_eq script exp

let test_getter test_ctx =
  let exp = exp_from_string "a = {get y() { return 0;}};" in
  let zero = mk_exp (Num 0.0) 22 in
  let r = mk_exp (Return (Some zero)) 15 in
  let block = mk_exp (Block [r]) 13 in
  let getter = mk_exp (FunctionExp(false, None, [], block)) 9 in
  let obj = mk_exp (Obj [PropnameId "y", PropbodyGet, getter]) 4 in
  let a = mk_exp (Var "a") 0 in
  let assign = mk_exp (Assign (a, obj)) 0 in
  let script = mk_exp (Script (false, [assign])) 0 in
  assert_exp_eq script exp

let test_setter test_ctx =
  let exp = exp_from_string "a = {set y(val) {}};" in
  let block = mk_exp (Block []) 16 in
  let setter = mk_exp (FunctionExp(false, None, ["val"], block)) 9 in
  let obj = mk_exp (Obj [PropnameId "y", PropbodySet, setter]) 4 in
  let a = mk_exp (Var "a") 0 in
  let assign = mk_exp (Assign (a, obj)) 0 in
  let script = mk_exp (Script (false, [assign])) 0 in
  assert_exp_eq script exp

let test_obj_init test_ctx =
  let exp = exp_from_string "a = {1 : b, \"abc\" : c, name : d};" in
  let b = mk_exp (Var "b") 9 in
  let c = mk_exp (Var "c") 20 in
  let d = mk_exp (Var "d") 30 in
  let obj = mk_exp (Obj [PropnameNum 1.0, PropbodyVal, b; PropnameString "abc", PropbodyVal, c; PropnameId "name", PropbodyVal, d]) 4 in
  let a = mk_exp (Var "a") 0 in
  let assign = mk_exp (Assign (a, obj)) 0 in
  let script = mk_exp (Script (false, [assign])) 0 in
  assert_exp_eq script exp

let test_fun_annot test_ctx =
  skip_testing_annots ();
  let exp = exp_from_string " /** @pre something \n @post something */ var x = 5;" in
  let string_exp = mk_exp (String "use strict") 52 in
  let r = mk_exp (Return None) 66 in
  let block = mk_exp (Block [string_exp; r]) 51 in
  let f = mk_exp_with_annot (Function (true, Some "f", [], block)) 38
    [{annot_type = EnsuresErr; annot_formula = "B"}] in
  let script = mk_exp_with_annot (Script (false, [f])) 0
    [{annot_type = TopEnsuresErr; annot_formula = "A"}] in
  assert_equal' script exp

(* TODO: tests for object initializer, unnamed function expression *)

let suite = "Testing_Parser" >:::
  [
(**
   "test_unescape_html" >:: test_unescape_html;
   "test_unescape_html_number" >:: test_unescape_html_number;
   "test_unescape_html_hex" >:: test_unescape_html_hex;
   "test_unescape_html_1" >:: test_unescape_html_1;
   "test var" >:: test_var;
   "test var with assignment" >:: test_var_value;
   "test var list" >:: test_var_list;
   "test regexp" >:: test_regexp;
   "test regexp with flags" >:: test_regexp_with_flags;
   "test not" >:: test_not;
   "test_caccess" >:: test_caccess;
   "test_and" >:: test_and;
   "test_array_literal" >:: test_array_literal;
   "test_ge" >:: test_ge;
   "test_or" >:: test_or;
   "test_not_triple_eq" >:: test_not_triple_eq;
   "test_hook" >:: test_hook;
   "test_instanceof" >:: test_instanceof;
   "test_typeof" >:: test_typeof;
   "test_pos" >:: test_pos;
   "test_dec_pre" >:: test_dec_pre;
   "test_dec_post" >:: test_dec_post;
   "test_inc_pre" >:: test_inc_pre;
   "test_inc_post" >:: test_inc_post;
   "test_for" >:: test_for;
   "test_for_annot" >:: test_for_annot;
   "test_forin" >:: test_forin;
   "test_mod" >:: test_mod;
   "test_ursh" >:: test_ursh;
   "test_lsh" >:: test_lsh;
   "test_rsh" >:: test_rsh;
   "test_bitand" >:: test_bitand;
   "test_bitor" >:: test_bitor;
   "test_bitxor" >:: test_bitxor;
   "test_notequal" >:: test_notequal;
   "test_gt" >:: test_gt;
   "test_in" >:: test_in;
   "test_comma1" >:: test_comma1;
   "test_comma2" >:: test_comma2;
   "test_negative" >:: test_negative;
   "test_bitnot" >:: test_bitnot;
   "test_void" >:: test_void;
   "test_assign_add" >:: test_assign_add;
   "test_assign_sub" >:: test_assign_sub;
   "test_assign_mul" >:: test_assign_mul;
   "test_assign_div" >:: test_assign_div;
   "test_assign_mod" >:: test_assign_mod;
   "test_assign_ursh" >:: test_assign_ursh;
   "test_assign_lsh" >:: test_assign_lsh;
   "test_assign_rsh" >:: test_assign_rsh;
   "test_assign_bitand" >:: test_assign_bitand;
   "test_assign_bitor" >:: test_assign_bitor;
   "test_assign_bitxor" >:: test_assign_bitxor;
   "test_return" >:: test_return;
   "test_return_exp" >:: test_return_exp;
   "test_do_while" >:: test_do_while;
   "test_do_while_annot" >:: test_do_while_annot;
   "test_delete" >:: test_delete;
   "test_continue" >:: test_continue;
   "test_continue_annot" >:: test_continue_annot;
   "test_continue_label" >:: test_continue_label;
   "test_continue_label_annot" >:: test_continue_label_annot;
   "test_break" >:: test_break;
   "test_break_annot" >:: test_break_annot;
   "test_break_label" >:: test_break_label;
   "test_break_label_annot" >:: test_break_label_annot;
   "test_get_invariant" >:: test_get_invariant;
   "test_try_catch" >:: test_try_catch;
   "test_try_catch_finally" >:: test_try_catch_finally;
   "test_try_finally" >:: test_try_finally;
   "test_switch" >:: test_switch;
   "test_debugger" >:: test_debugger;
   "test_top_annotations" >:: test_top_annotations;
   "test_script_strict" >:: test_script_strict;
   "test_script_not_strict" >:: test_script_not_strict;
   "test_fun_strict" >:: test_fun_strict;
   "test_getter" >:: test_getter;
   "test_setter" >:: test_setter;
   "test_obj_init" >:: test_obj_init; *)
   "test_fun_annot" >:: test_fun_annot;
  ]

let json = Conf.make_bool "json" false "test json parser"

let decorator test test_ctx =
  use_json := json test_ctx;
  test test_ctx

let _ =
  init ~path:"lib" ();
  run_test_tt_main (OUnitTest.test_decorate decorator suite)
