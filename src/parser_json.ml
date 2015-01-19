open Parser
open Parser_syntax
open List
open Yojson
open Yojson.Safe

let nodebin = ref "nodejs"

let get_json_field field_name json =
  match json with
    | `Assoc contents ->  
        snd (List.find (fun (str, _) -> (str = field_name)) contents)
    | _ -> print_string field_name; raise Empty_list

let get_json_type json = 
  match get_json_field "type" json with
    | `String s -> s
    | _ -> raise CannotHappen

let get_json_offset json =
  try (
     match get_json_field "range" json with
       | `List((`Int(start)) :: _) -> start
       | _ -> raise CannotHappen
  )  with
  | Not_found -> 0


let get_json_list field json = 
  match get_json_field field json with
    | `List(children) -> children
    | _ -> raise CannotHappen

let get_json_string field json =
  match get_json_field field json with
    | `String(name) -> name
    | _ -> raise CannotHappen

let get_json_bool field json =
  match get_json_field field json with
    | `Bool(v) -> v
    | _ -> raise CannotHappen

let get_json_ident_name ident =
  get_json_string "name" ident

let rec json_to_exp json : exp = 
  let json_type = get_json_type json in
  match json_type with
    | "Program" ->
      let children = get_json_list "body" json in
      let stmts = map json_to_exp children in
      mk_exp (Script (false, stmts)) (get_json_offset json)
    | "BlockStatement" ->
      let children = get_json_list "body" json in
      json_mk_block_exp children (get_json_offset json)
    | "FunctionExpression"
    | "FunctionDeclaration" ->
      let fn_name = get_json_field "id" json in
      let fn_params = map get_json_ident_name (get_json_list "params" json) in
      let fn_body = json_to_exp (get_json_field "body" json) in
      begin match fn_name with
        | `Null -> mk_exp (AnnonymousFun (false,fn_params,fn_body)) (get_json_offset json)
        | ident -> mk_exp (NamedFun (false,(get_json_ident_name fn_name),fn_params,fn_body)) (get_json_offset json)
      end
    | "VariableDeclaration" -> 
      let offset = (get_json_offset json) in
      begin match (get_json_list "declarations" json) with
        | [] -> raise Empty_list
        | children ->
            let vars = map (json_var_declaration offset) children in
            mk_exp (VarDec vars) offset
      end
    | "ExpressionStatement" -> 
      json_to_exp (get_json_field "expression" json)
    | "IfStatement" ->
      let offset = get_json_offset json in
      let test = json_to_exp (get_json_field "test" json) in
      let cons = json_to_exp (get_json_field "consequent" json) in
      let alt = 
      begin match (get_json_field "alternate" json) with
        | `Null -> None
        | stat  -> Some (json_to_exp stat)
      end in
      mk_exp (If (test, cons, alt)) offset
    | "LabeledStatement" ->
      let lname = get_json_ident_name (get_json_field "label" json) in
      let body = json_to_exp (get_json_field "body" json) in
      mk_exp (Label (lname, body)) (get_json_offset json)
    | "BreakStatement" ->
      let label = 
      begin match (get_json_field "label" json) with
        | `Null -> None
        | ident -> Some (get_json_ident_name ident)
      end in
      mk_exp (Break label) (get_json_offset json)
    | "ContinueStatement" ->
      let label = 
      begin match (get_json_field "label" json) with
        | `Null -> None
        | ident -> Some (get_json_ident_name ident)
      end in
      mk_exp (Continue label) (get_json_offset json)
    | "WithStatement" ->
      let obj = json_to_exp (get_json_field "object" json) in
      let body = json_to_exp (get_json_field "body" json) in 
      mk_exp (With (obj, body)) (get_json_offset json)
    | "SwitchStatement" ->
      let offset = get_json_offset json in
      let disc = json_to_exp (get_json_field "discriminant" json) in
      let cases = get_json_list "cases" json in
      let cases = map(fun c -> json_parse_case c offset) cases in
      mk_exp (Switch (disc, cases)) offset
    | "ThrowStatement" ->
      let e = get_json_field "argument" json in
      mk_exp (Throw (json_to_exp e)) (get_json_offset json)
    | "TryStatement" ->
      let offset = get_json_offset json in
      let block_obj = get_json_field "block" json in
      let block = json_mk_block_exp (get_json_list "body" block_obj) (get_json_offset block_obj) in
      let handler = get_json_list "handlers" json in
      let guardedHandlers = get_json_list "guardedHandlers" json in
      let finaliser = get_json_field "finalizer" json in
      let catch, finally = json_get_catch_finally handler guardedHandlers finaliser offset in 
      mk_exp (Try (block, catch, finally)) offset
    | "WhileStatement" ->
      let condition = json_to_exp (get_json_field "test" json) in
      let block = json_to_exp (get_json_field "body" json) in
      mk_exp (While (condition, block)) (get_json_offset json)
    | "DoWhileStatement" ->
      let condition = json_to_exp (get_json_field "test" json) in
      let block = json_to_exp (get_json_field "body" json) in
      mk_exp (DoWhile (block, condition)) (get_json_offset json)
    | "ForStatement" ->
      let offset = get_json_offset json in
      let init = json_parse_for_exp (get_json_field "init" json) offset in
      let condition = json_parse_for_exp (get_json_field "test" json) offset in
      let incr = json_parse_for_exp (get_json_field "update" json) offset in
      let block = json_to_exp (get_json_field "body" json) in
      mk_exp (For (init, condition, incr, block)) offset
    | "ForInStatement" ->
      let offset = get_json_offset json in
      let var = json_to_exp (get_json_field "left" json) in
      let obj = json_to_exp (get_json_field "right" json) in
      let block = json_to_exp (get_json_field "body" json) in
      mk_exp (ForIn (var, obj, block)) offset
    | "DebuggerStatement" ->
      mk_exp Debugger (get_json_offset json)
    | "UnaryExpression" ->
      let child = json_to_exp (get_json_field "argument" json) in
      let op = get_json_string "operator" json in
      json_mk_un_op child op (get_json_offset json)
    | "BinaryExpression" ->
      json_mk_left_right_op json json_mk_bin_op
    | "AssignmentExpression" ->
      json_mk_left_right_op json json_mk_assign_op
    | "LogicalExpression" ->
      json_mk_left_right_op json json_mk_logical_op
    | "UpdateExpression" ->
      let child = json_to_exp (get_json_field "argument" json) in
      let op = get_json_string "operator" json in
      let is_prefix = get_json_bool "prefix" json in
      json_mk_update_op child op is_prefix (get_json_offset json)
    | "MemberExpression" -> 
      let obj = json_to_exp (get_json_field "object" json) in
      let prop = get_json_field "property" json in
      begin if (get_json_bool "computed" json) then
        mk_exp (CAccess (obj, json_to_exp prop)) (get_json_offset json)
      else
        mk_exp (Access (obj, get_json_ident_name prop)) (get_json_offset json)
      end
    | "ThisExpression" -> 
      mk_exp This (get_json_offset json)
    | "ArrayExpression" -> 
      let members = get_json_list "elements" json in
      json_parse_array_literal members (get_json_offset json)
    | "ObjectExpression" ->
      let l = map (fun obj -> 
        let key = json_propname_element (get_json_field "key" obj) in
        let value = json_to_exp (get_json_field "value" obj) in
        match (get_json_string "kind" obj) with
          | "init" -> (key, PropbodyVal, value) 
          | "get"  -> (key, PropbodyGet, value)
          | "set"  -> (key, PropbodySet, value)
          | _ -> raise Parser_ObjectLit
      ) (get_json_list "properties" json)
    in (mk_exp (Obj l) (get_json_offset json))
    | "SequenceExpression" ->
      json_nest_sequence (get_json_list "expressions" json) (get_json_offset json)
    | "ConditionalExpression" ->
      let test = json_to_exp (get_json_field "test" json) in
      let cons = json_to_exp (get_json_field "consequent" json) in
      let alt = json_to_exp (get_json_field "alternate" json) in
      mk_exp (ConditionalOp (test, cons, alt)) (get_json_offset json) 
    | "NewExpression" ->
      let callee = json_to_exp (get_json_field "callee" json) in
      let arguments = (get_json_list "arguments" json) in
      mk_exp (New (callee, (map json_to_exp arguments))) (get_json_offset json)
    | "ReturnStatement" ->
      let offset = (get_json_offset json) in
      begin match (get_json_field "argument" json) with
        | `Null -> mk_exp (Return None) offset 
        | expr  -> mk_exp (Return (Some (json_to_exp expr))) offset
      end
    | "CallExpression" ->
      let callee = json_to_exp (get_json_field "callee" json) in
      let arguments = (get_json_list "arguments" json) in
      mk_exp (Call (callee, (map json_to_exp arguments))) (get_json_offset json)
    | "Identifier" -> 
      mk_exp (Var (get_json_ident_name json)) (get_json_offset json)
    | "Literal" ->
      mk_exp (json_parse_literal json) (get_json_offset json)
    | "EmptyStatement" -> 
      mk_exp Skip (get_json_offset json)
    | _ -> raise (Parser_Unknown_Tag (json_type, (get_json_offset json)))
and
json_propname_element key =
  match (get_json_string "type" key) with
    | "Identifier" -> PropnameId (get_json_ident_name key)
    | "Literal" -> begin match (json_parse_literal key) with
                     | Num(f)    -> PropnameNum (f)
                     | String(s) -> PropnameString (s)
                     | _ -> raise InvalidArgument
                   end
    | _ -> raise (Parser_Name_Element "")
and
json_var_declaration offset vd =
  let name = get_json_ident_name (get_json_field "id" vd) in
  let init = begin match get_json_field "init" vd with
   | `Null -> None
   | expr  -> Some (json_to_exp expr)
  end in
  name, init
and
json_parse_catch handler offset =
  let name = get_json_ident_name (get_json_field "param" handler) in
  let body = json_to_exp (get_json_field "body" handler) in
  (name, body)
and
json_get_catch_finally handler guardedHandlers f_block offset =
  begin if (guardedHandlers <> []) then raise (Parser_Unknown_Tag ("json_get_catch_finally", offset)) end;
  let finaliser = begin match f_block with
    | `Null -> None
    | expr  -> Some (json_to_exp expr)
  end in
  match handler with
    | []      -> None, finaliser
    | h :: [] -> Some (json_parse_catch h offset), finaliser
    | _ -> raise (Parser_Unknown_Tag ("json_get_catch_finally", offset)) 
and
json_mk_left_right_op json json_mk_op =
  let child1 = json_to_exp (get_json_field "left" json) in
  let child2 = json_to_exp (get_json_field "right" json) in
  let op = get_json_string "operator" json in
  json_mk_op child1 child2 op (get_json_offset json)
and
json_mk_block_exp children off = 
  let stmts = map json_to_exp children in
  mk_exp (Block stmts) off
and
json_parse_literal lit =
  let value = get_json_field "value" lit in
  let raw = get_json_string "raw" lit in
  match value with
    | `Bool(b)     -> Bool(b)
    | `Float(f)    -> Num(f)
    | `Int(i)      -> Num(float_of_int(i))
    | `Intlit(s)   -> Num(float_of_string(s))
    | `Null        -> if(raw = "null") then Null else Num(infinity) (*This is a very bad workaround*)
    | `String(str) -> String(str)
    | `Assoc([]) -> json_parse_regexp(raw) (*This is a regexp*)
    | _ -> raise InvalidArgument
and
json_parse_regexp raw =
  let trimmed_lit = Str.string_after raw 1 in
  let lit, flag = begin match Str.last_chars raw 1 with
    | "/" -> (Str.string_before trimmed_lit ((String.length trimmed_lit) - 1)), ""
    | c -> (Str.string_before trimmed_lit ((String.length trimmed_lit) - ((String.length c) + 1))), c
  end in 
  RegExp(lit, flag)
  
and
json_mk_assign_op e1 e2 op off =
  match op with
    | "=" -> mk_exp (Assign (e1, e2)) off
    | _ -> let op_enum = begin match op with
             | "+="   -> Plus
             | "-="   -> Minus
             | "*="   -> Times
             | "/="   -> Div
             | "%="   -> Mod
             | "<<="  -> Lsh
             | ">>="  -> Rsh
             | ">>>=" -> Ursh
             | "|="   -> Bitor
             | "^="   -> Bitxor
             | "&="   -> Bitand
             | _ -> raise InvalidArgument
           end in
           mk_exp (AssignOp (e1, op_enum, e2)) off
and
json_mk_un_op e op off =
  match op with
    | "delete" -> mk_exp (Delete e) off
    | _ -> let op_enum = begin match op with
             | "-" -> Negative
             | "+" -> Positive
             | "!" -> Not
             | "~" -> Bitnot
             | "typeof" -> TypeOf
             | "void"   -> Void
             | _ -> raise InvalidArgument
           end in
           mk_exp (Unary_op (op_enum, e)) off
and
json_mk_bin_op e1 e2 op off = 
  let op_enum = begin match op with
    | "=="  -> Comparison Equal
    | "!="  -> Comparison NotEqual
    | "===" -> Comparison TripleEqual
    | "!==" -> Comparison NotTripleEqual
    | "<"   -> Comparison Lt
    | "<="  -> Comparison Le
    | ">"   -> Comparison Gt
    | ">="  -> Comparison Ge
    | "in"  -> Comparison In
    | "instanceof" -> Comparison InstanceOf
    | "<<"  -> Arith Lsh
    | ">>"  -> Arith Rsh
    | ">>>" -> Arith Ursh
    | "+"   -> Arith Plus
    | "-"   -> Arith Minus
    | "*"   -> Arith Times
    | "/"   -> Arith Div
    | "%"   -> Arith Mod
    | "|"   -> Arith Bitor
    | "^"   -> Arith Bitxor
    | "&"   -> Arith Bitand
    | _ -> raise InvalidArgument
  end in
  mk_exp (BinOp (e1, op_enum, e2)) off
and
json_mk_logical_op e1 e2 op off =
  match op with
    | "||" -> mk_exp (BinOp (e1, (Boolean Or), e2)) off
    | "&&" -> mk_exp (BinOp (e1, (Boolean And), e2)) off
    | _ -> raise InvalidArgument
and
json_mk_update_op e op pre off = 
  let op_enum = begin match op with
    | "++" -> if (pre) then Pre_Incr else Post_Incr
    | "--" -> if (pre) then Pre_Decr else Post_Decr 
    | _ -> raise InvalidArgument
  end in
  mk_exp (Unary_op (op_enum, e)) off
and
json_parse_case child offset =
  let stat_list = get_json_list "consequent" child in
  let test_obj = get_json_field "test" child in
  let test =
  begin match test_obj with
    | `Null -> DefaultCase
    | expr  -> Case (json_to_exp expr)
  end in
  let block = json_mk_block_exp stat_list (get_json_offset child) in
  test, block
and
json_parse_for_exp exp off = 
  match exp with
    | `Null -> None
    | expr  -> Some (json_to_exp exp)
and
json_parse_array_literal members offset =
  let l = mapi (fun index child -> 
    match child with
      | `Null -> None
      | expr  -> Some (json_to_exp child)
  ) members in
  mk_exp (Array l) offset
and
json_nest_sequence expressions off =
  match expressions with
    | fst :: snd :: rest ->
      let init = mk_exp (Comma (json_to_exp fst, json_to_exp snd)) off in
      List.fold_left (fun acc e -> mk_exp (Comma (acc, json_to_exp e)) off) init rest
    | _ -> raise CannotHappen


let build_argstr force_strict init filename =
  let f = (if force_strict then " -force_strict" else "") in
  let i = (if init then " -builtin_init" else "") in
  String.concat " " [!nodebin; "simple_print.js"; (Filename.quote filename); f; i]

let js_file_to_json ?force_strict:(f = false) ?init:(i = false) (filename : string) : string =
  match Unix.system (build_argstr f i filename) with
    | Unix.WEXITED n ->
        (if(n <> 0) then raise (Xml.File_not_found filename)); String.sub filename 0 (String.length filename - 3) ^ ".json"
    | _ -> raise JS_To_XML_parser_failure

let js_str_to_json ?force_strict:(f = false) ?init:(i = false) str =
  try
    let (in_ch, out_ch) = Unix.open_process (build_argstr f i "-") in
    output_string out_ch str;
    close_out out_ch;
    let json = Yojson.Safe.from_channel in_ch in
    close_in in_ch;
    json
  with
  | Json_error error -> raise (ParserFailure error)

let exp_from_string ?force_strict:(f = false) str =
  let expression = json_to_exp (js_str_to_json ~force_strict:f str) in
  add_strictness false expression

let exp_from_file ?force_strict:(f = false) ?init:(i = false) file =
  try
    let js_file = js_file_to_json ~force_strict:f ~init:i file in
    let data = Yojson.Safe.from_file js_file in
    let expression = json_to_exp data in
    add_strictness false expression
  with
  | Json_error error -> raise (ParserFailure error)

let exp_from_stdin =
  fun() ->
    try
      let data = Yojson.Safe.from_channel Pervasives.stdin in
      let expression = json_to_exp data in
      add_strictness false expression
    with
    | Json_error error -> raise (ParserFailure error)
