open Xml
open Parser_syntax
open List
open Yojson.Safe

exception Parser_No_Program
exception Parser_Xml_To_String
exception Parser_Xml_To_Var
exception Parser_Unknown_Tag of (string * int)
exception Parser_PCData
exception Parser_ObjectLit
exception JS_To_XML_parser_failure
exception OnlyIntegersAreImplemented
exception Parser_Name_Element of string
exception Parser_Param_List
exception Unknown_Annotation of string
exception InvalidArgument
exception XmlParserException
exception Unknown_Dec_Inc_Position
exception Parser_Xml_To_Label_Name
exception More_Than_One_Finally
exception CannotHappen
exception Empty_list

let unescape_html s =
  Str.global_substitute
    (Str.regexp "&lt;\\|&gt;\\|&amp;\\|&quot;\\|&apos;\\|&#[0-9]*;\\|&#x[0-9a-fA-F]*;")
    (fun s -> 
      let sm = Str.matched_string s in
      match sm with
          "&lt;" -> "<"
        | "&gt;" -> ">"
        | "&amp;" -> "&"
        | "&quot;" -> "\""
        | "&apos;" -> "'"
        | _ -> 
          if String.sub sm 0 3 = "&#x" then 
            begin 
              let len = String.length sm in 
              let x = String.sub sm 3 (len - 4) in
              let c = Char.chr (int_of_string ("0x" ^ x)) in
              String.make 1 c
            end 
          else if String.sub sm 0 2 = "&#" then 
            begin 
              let len = String.length sm in 
              let x = String.sub sm 2 (len - 3) in
              let c = Char.chr (int_of_string x) in
              String.make 1 c
            end 
          else assert false)
    s
    
let flat_map f l = flatten (map f l)

let get_attr attrs attr_name =
  let _, value = List.find (fun (name, value) -> name = attr_name) attrs in unescape_html value

let get_offset attrs : int =
  int_of_string (get_attr attrs "pos")
  
let get_value attrs : string =
  get_attr attrs "value"

let get_flags attrs : string =
  try
    get_attr attrs "flags"
  with Not_found -> ""
  
let get_label_name xml : string =
  match xml with
    | Element ("LABEL", attrs, _) -> get_attr attrs "name"
    | _ -> raise Parser_Xml_To_Label_Name
  
let string_element xml : string =
  match xml with
    | Element ("STRING", attrs, _) -> get_value attrs
    | _ -> raise Parser_Xml_To_String

let name_element xml : string =
  match xml with
    | Element ("NAME", attrs, _) -> get_value attrs
    | Element (el, _, _) -> raise (Parser_Name_Element el)
    | _ -> raise (Parser_Name_Element "")

let propname_element xml : propname =
  match xml with
    | Element ("NAME", attrs, _) -> PropnameId (get_value attrs)
    | Element ("STRING", attrs, _) -> PropnameString (get_value attrs)
    | Element ("NUMBER", attrs, _) -> PropnameNum (float_of_string (get_value attrs))
    | Element (el, _, _) -> raise (Parser_Name_Element el)
    | _ -> raise (Parser_Name_Element "")

let remove_annotation_elements children =
  filter (fun child -> 
    match child with
      | Element ("ANNOTATION", _, _) -> false
      | _ -> true
  ) children

let rec xml_to_vars xml : string list = 
  match xml with
    | Element ("PARAM_LIST", _, children) -> 
      map name_element (remove_annotation_elements children)
    | _ -> raise Parser_Param_List
  
let get_annot attrs : annotation =
  let atype = get_attr attrs "type" in
  let f = get_attr attrs "formula" in
  match atype with
    | "toprequires" -> {annot_type = TopRequires; annot_formula = f}
    | "topensures" -> {annot_type = TopEnsures; annot_formula = f}
    | "requires" -> {annot_type = Requires; annot_formula = f}
    | "ensures" -> {annot_type = Ensures; annot_formula = f}
    | "invariant" -> {annot_type = Invariant; annot_formula = f}
    | "codename" -> {annot_type = Codename; annot_formula = f}
    | "preddefn" -> {annot_type = PredDefn; annot_formula = f}
    | annot -> raise (Unknown_Annotation annot)

type dec_inc_pos =
  | DI_PRE
  | DI_POST

let get_dec_inc_pos attrs : dec_inc_pos = 
  let pos = get_attr attrs "incdec_pos" in
  match pos with
    | "pre" -> DI_PRE
    | "post" -> DI_POST
    | _ -> raise Unknown_Dec_Inc_Position
 
let rec get_program_spec_inner (f : xml) = 
  match f with
    | Element ("FUNCTION", _, children) -> 
      let not_block = filter (fun child -> 
        match child with
          | Element ("BLOCK", _, _) -> false
          | _ -> true
      ) children in
      flat_map get_program_spec_inner not_block
    | Element ("ANNOTATION", attrs, []) -> 
      let annot = get_annot attrs in
      if is_top_spec annot then [annot] else []
    | Element (_, _, children) -> flat_map get_program_spec_inner children
    | _ -> []
 
let get_program_spec (f : xml) =
  match f with
    | Element ("SCRIPT", _, children) ->
      flat_map (fun child -> get_program_spec_inner child) children
    | _ -> raise InvalidArgument

let get_annotations children =
  flat_map (fun child -> 
    match child with
      | Element ("ANNOTATION", attrs, []) -> [get_annot attrs] 
      | _ -> []
   ) children
      
let get_function_spec (f : xml) =
  match f with
    | Element ("FUNCTION", _, children) -> List.filter is_function_spec (get_annotations children)
    | _ -> raise InvalidArgument

let rec get_invariant_inner (w : xml) =
  match w with 
    | Element ("WHILE", _, _) -> []
    | Element ("FOR", _, _) -> []
    | Element ("DO", _, _) -> []
    | Element ("ANNOTATION", attrs, []) -> 
      let annot = get_annot attrs in
      if is_invariant annot then [annot] else []
    | Element (_, _, children) -> flat_map (fun child -> get_invariant_inner child) children
    | PCData _ -> []

let rec get_invariant (w : xml) =
  match w with
    | Element ("WHILE", _, children) 
    | Element ("FOR", _, children) 
    | Element ("DO", _, children) ->
      flat_map (fun child -> get_invariant_inner child) children
    | _ -> raise InvalidArgument

let get_xml_child xml =
  match xml with 
    | Element (tag, attrs, children) ->
		  begin match (remove_annotation_elements children) with
		    | [child1] -> child1
		    | _ -> raise (Parser_Unknown_Tag (tag, (get_offset attrs))) 
		  end
    | _ -> raise CannotHappen

let get_xml_two_children xml =
  match xml with 
    | Element (tag, attrs, children) ->
      begin match (remove_annotation_elements children) with
        | [child1; child2] -> child1, child2
        | _ -> raise (Parser_Unknown_Tag (tag, (get_offset attrs))) 
      end
    | _ -> raise CannotHappen 

let get_xml_three_children xml =
  match xml with 
    | Element (tag, attrs, children) ->
      begin match (remove_annotation_elements children) with
        | [child1; child2; child3] -> child1, child2, child3
        | _ -> raise (Parser_Unknown_Tag (tag, (get_offset attrs))) 
      end
    | _ -> raise CannotHappen

let split_last stmts = 
  match stmts with
    | [] -> raise Empty_list 
    | hd :: tl ->
      let rec aux l acc = function
          | [] -> l, rev acc
          | hd :: tl -> aux hd (l::acc) tl
      in aux hd [] tl
      
let mapi f l = 
  let rec aux i = function
    | [] -> []
    | hd :: tl -> (f i hd) :: (aux (i + 1) tl)
  in aux 0 l

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

let rec xml_to_exp xml : exp =
  match xml with
    (*Element (tag name, attributes, children )*)
    | Element ("SCRIPT", attrs, children) -> 
      let stmts = map xml_to_exp children in
      let program_spec = get_program_spec xml in 
      mk_exp_with_annot (Script (false, stmts)) (get_offset attrs) program_spec
    | Element ("EXPR_VOID", attrs, children) -> xml_to_exp (get_xml_child xml)
    | Element ("EXPR_RESULT", attrs, children) -> xml_to_exp (get_xml_child xml)
    | Element ("ASSIGN", attrs, children) -> 
      let child1, child2 = get_xml_two_children xml in
      mk_exp (Assign (xml_to_exp child1, xml_to_exp child2)) (get_offset attrs)
    | Element ("NAME", attrs, _) -> mk_exp (Var (get_value attrs)) (get_offset attrs)
    | Element ("NULL", attrs, _) -> mk_exp Null (get_offset attrs)
    | Element ("FUNCTION", attrs, children) -> 
      let name, params, block = get_xml_three_children xml in
      let fn_name = name_element name in
      let fn_params = xml_to_vars params in
      let fn_body = xml_to_exp block in
      let fn_spec = get_function_spec xml in
      if (fn_name = "") then mk_exp_with_annot (AnnonymousFun (false,fn_params,fn_body)) (get_offset attrs) fn_spec
      else mk_exp_with_annot (NamedFun (false,fn_name,fn_params,fn_body)) (get_offset attrs) fn_spec
    | Element ("BLOCK", attrs, children) ->  
      let stmts = map xml_to_exp (remove_annotation_elements children) in
      mk_exp (Block stmts) (get_offset attrs)
    | Element ("VAR", attrs, children) -> 
      let offset = get_offset attrs in
      begin match (remove_annotation_elements children) with
        | [] -> raise (Parser_Unknown_Tag ("VAR", offset))
        | children ->
          let vars = map (var_declaration offset) children in
          mk_exp (VarDec vars) offset
      end 
    | Element ("CALL", attrs, children) -> 
      begin match (remove_annotation_elements children) with
        | (child1 :: children) -> mk_exp (Call (xml_to_exp child1, (map xml_to_exp children))) (get_offset attrs)
        | _ -> raise (Parser_Unknown_Tag ("CALL", get_offset attrs)) 
      end  
    | Element ("NEW", attrs, children) -> 
      begin match (remove_annotation_elements children) with
        | (child1 :: children) -> mk_exp (New (xml_to_exp child1, (map xml_to_exp children))) (get_offset attrs)
        | _ -> raise (Parser_Unknown_Tag ("NEW", get_offset attrs)) 
      end
    | Element ("NUMBER", attrs, _) -> 
      let n_float = float_of_string (get_value attrs) in
      mk_exp (Num n_float) (get_offset attrs)
    | Element ("OBJECTLIT", attrs, objl) ->
      let l = map (fun obj -> 
        match obj with
          | Element ("COLON", attrs, children) ->
            let child1, child2 = get_xml_two_children obj in
            (propname_element child1, PropbodyVal, xml_to_exp child2) 
          (* TODO: Have a flag for the EcmaScript version *)
          | Element ("GET", attrs, children) ->
            let child1, child2 = get_xml_two_children obj in
            (propname_element child1, PropbodyGet, xml_to_exp child2)
          | Element ("SET", attrs, children) ->
            let child1, child2 = get_xml_two_children obj in
            (propname_element child1, PropbodySet, xml_to_exp child2)
          | _ -> raise Parser_ObjectLit
      ) (remove_annotation_elements objl)
      in (mk_exp (Obj l) (get_offset attrs))
    | Element ("WITH", attrs, children) ->
      let obj, block = get_xml_two_children xml in  
      mk_exp (With (xml_to_exp obj, xml_to_exp block)) (get_offset attrs)
    | Element ("EMPTY", attrs, _) -> mk_exp Skip (get_offset attrs)
    | Element ("IF", attrs, children) ->
      let offset = get_offset attrs in
      begin match (remove_annotation_elements children) with
        | [condition; t_block] ->
          mk_exp (If (xml_to_exp condition, xml_to_exp t_block, None)) offset
        | [condition; t_block; f_block] ->
          mk_exp (If (xml_to_exp condition, xml_to_exp t_block, Some (xml_to_exp f_block))) offset
        | _ -> raise (Parser_Unknown_Tag ("IF", offset)) 
      end
    | Element ("HOOK", attrs, children) ->
      let condition, t_block, f_block = get_xml_three_children xml in
      mk_exp (ConditionalOp (xml_to_exp condition, xml_to_exp t_block, xml_to_exp f_block)) (get_offset attrs)    
    | Element ("EQ", attrs, children) -> parse_comparison_op Equal attrs children "EQ"
    | Element ("NE", attrs, children) -> parse_comparison_op NotEqual attrs children "NE"
    | Element ("SHEQ", attrs, children) -> parse_comparison_op TripleEqual attrs children "SHEQ"
    | Element ("SHNE", attrs, children) -> parse_comparison_op NotTripleEqual attrs children "SHNE"
    | Element ("LT", attrs, children) -> parse_comparison_op Lt attrs children "LT"
    | Element ("LE", attrs, children) -> parse_comparison_op Le attrs children "LE"
    | Element ("GT", attrs, children) -> parse_comparison_op Gt attrs children "GT"
    | Element ("GE", attrs, children) -> parse_comparison_op Ge attrs children "GE"
    | Element ("IN", attrs, children) -> parse_comparison_op In attrs children "IN"
    | Element ("INSTANCEOF", attrs, children) -> parse_comparison_op InstanceOf attrs children "INSTANCEOF"
    | Element ("ADD", attrs, children) -> parse_arith_op Plus attrs children "ADD"
    | Element ("SUB", attrs, children) -> parse_arith_op Minus attrs children "SUB"
    | Element ("MUL", attrs, children) -> parse_arith_op Times attrs children "MUL"
    | Element ("DIV", attrs, children) -> parse_arith_op Div attrs children "DIV"
    | Element ("MOD", attrs, children) -> parse_arith_op Mod attrs children "MOD"
    | Element ("URSH", attrs, children) -> parse_arith_op Ursh attrs children "URSH" 
    | Element ("LSH", attrs, children) -> parse_arith_op Lsh attrs children "LSH" 
    | Element ("RSH", attrs, children) -> parse_arith_op Rsh attrs children "RSH"
    | Element ("BITAND", attrs, children) -> parse_arith_op Bitand attrs children "BITAND"
    | Element ("BITOR", attrs, children) -> parse_arith_op Bitor attrs children "BITOR"
    | Element ("BITXOR", attrs, children) -> parse_arith_op Bitxor attrs children "BITXOR"
    | Element ("AND", attrs, children) -> parse_bool_op And attrs children "AND"
    | Element ("OR", attrs, children) -> parse_bool_op Or attrs children "OR"
    | Element ("COMMA", attrs, children) -> 
      let child1, child2 = get_xml_two_children xml in
      mk_exp (Comma (xml_to_exp child1, xml_to_exp child2)) (get_offset attrs)
    | Element ("THROW", attrs, children) ->
      let e = get_xml_child xml in
      mk_exp (Throw (xml_to_exp e)) (get_offset attrs)
    | Element ("WHILE", attrs, children) ->
      let invariant = get_invariant xml in
      let condition, block = get_xml_two_children xml in
      mk_exp_with_annot (While (xml_to_exp condition, xml_to_exp block)) (get_offset attrs) invariant
    | Element ("GETPROP", attrs, children) ->
      let child1, child2 = get_xml_two_children xml in
      mk_exp (Access (xml_to_exp child1, name_element child2)) (get_offset attrs)
    | Element ("STRING", attrs, _) -> mk_exp (String (string_element xml)) (get_offset attrs)
    | Element ("TRUE", attrs, _) -> mk_exp (Bool true) (get_offset attrs)
    | Element ("FALSE", attrs, _) -> mk_exp (Bool false) (get_offset attrs)
    | Element ("THIS", attrs, _) -> mk_exp This (get_offset attrs)
    | Element ("RETURN", attrs, children) ->
      let offset = get_offset attrs in
      begin match (remove_annotation_elements children) with
        | [] -> mk_exp (Return None) offset 
        | [child]-> mk_exp (Return (Some (xml_to_exp child))) offset
        | _ -> raise (Parser_Unknown_Tag ("RETURN", offset)) 
      end
    | Element ("REGEXP", attrs, _) ->
      let offset = get_offset attrs in
      let value = get_value attrs in
      let flags = get_flags attrs in
      mk_exp (RegExp (value, flags)) offset
    | Element ("NOT", attrs, children) -> parse_unary_op Not attrs children "NOT"
    | Element ("TYPEOF", attrs, children) -> parse_unary_op TypeOf attrs children "TYPEOF"
    | Element ("POS", attrs, children) -> parse_unary_op Positive attrs children "POS"
    | Element ("NEG", attrs, children) -> parse_unary_op Negative attrs children "NEG"
    | Element ("BITNOT", attrs, children) -> parse_unary_op Bitnot attrs children "BITNOT"
    | Element ("VOID", attrs, children) -> parse_unary_op Void attrs children "VOID" 
    | Element ("ASSIGN_ADD", attrs, children) -> parse_assign_op Plus attrs children "ASSIGN_ADD"
    | Element ("ASSIGN_SUB", attrs, children) -> parse_assign_op Minus attrs children "ASSIGN_SUB"
    | Element ("ASSIGN_MUL", attrs, children) -> parse_assign_op Times attrs children "ASSIGN_MUL"
    | Element ("ASSIGN_DIV", attrs, children) -> parse_assign_op Div attrs children "ASSIGN_DIV"
    | Element ("ASSIGN_MOD", attrs, children) -> parse_assign_op Mod attrs children "ASSIGN_MOD"
    | Element ("ASSIGN_URSH", attrs, children) -> parse_assign_op Ursh attrs children "ASSIGN_URSH"
    | Element ("ASSIGN_LSH", attrs, children) -> parse_assign_op Lsh attrs children "ASSIGN_LSH"
    | Element ("ASSIGN_RSH", attrs, children) -> parse_assign_op Rsh attrs children "ASSIGN_RSH"
    | Element ("ASSIGN_BITAND", attrs, children) -> parse_assign_op Bitand attrs children "ASSIGN_BITAND"
    | Element ("ASSIGN_BITXOR", attrs, children) -> parse_assign_op Bitxor attrs children "ASSIGN_BITXOR"
    | Element ("ASSIGN_BITOR", attrs, children) -> parse_assign_op Bitor attrs children "ASSIGN_BITOR" 
    | Element ("DEC", attrs, children) -> 
      begin match (get_dec_inc_pos attrs) with
        | DI_PRE -> parse_unary_op Pre_Decr attrs children "DEC"
        | DI_POST -> parse_unary_op Post_Decr attrs children "DEC"
      end
    | Element ("INC", attrs, children) -> 
      begin match (get_dec_inc_pos attrs) with
        | DI_PRE -> parse_unary_op Pre_Incr attrs children "INC"
        | DI_POST -> parse_unary_op Post_Incr attrs children "INC"
      end
    | Element ("GETELEM", attrs, children) -> 
      let child1, child2 = get_xml_two_children xml in
      mk_exp (CAccess (xml_to_exp child1, xml_to_exp child2)) (get_offset attrs)
    | Element ("ARRAYLIT", attrs, children) ->
      parse_array_literal attrs children
    | Element ("FOR", attrs, children) ->
      let offset = get_offset attrs in
      begin match (remove_annotation_elements children) with
        | [init; condition; incr; exp] ->
          let invariant = get_invariant xml in
          let block = xml_to_exp exp in
          mk_exp_with_annot (For (parse_for_exp init, parse_for_exp condition, parse_for_exp incr, block)) offset invariant
        | [var; obj; exp] ->
        (* TODO: Add invariant *)
          mk_exp (ForIn (xml_to_exp var, xml_to_exp obj, xml_to_exp exp)) offset
        | _ -> raise (Parser_Unknown_Tag ("FOR", offset)) 
      end
    | Element ("DO", attrs, children) -> 
      let offset = get_offset attrs in
      let invariant = get_invariant xml in
      let body, condition = get_xml_two_children xml in
      let body = xml_to_exp body in
      mk_exp_with_annot (DoWhile (body, xml_to_exp condition)) offset invariant
    | Element ("DELPROP", attrs, children) -> 
      let child = get_xml_child xml in
      mk_exp (Delete (xml_to_exp child)) (get_offset attrs)
    | Element ("LABELED_STATEMENT", attrs, children) -> 
      let lname, child = get_xml_two_children xml in
      mk_exp (Label (get_label_name lname, xml_to_exp child)) (get_offset attrs)
    | Element ("CONTINUE", attrs, children) -> 
      let offset = get_offset attrs in
      begin match (remove_annotation_elements children) with
        | [] -> mk_exp (Continue None) offset
        | [name] -> mk_exp (Continue (Some (name_element name))) offset 
        | _ -> raise (Parser_Unknown_Tag ("CONTINUE", offset)) 
      end 
    | Element ("BREAK", attrs, children) -> 
      let offset = get_offset attrs in
      begin match (remove_annotation_elements children) with
        | [] -> mk_exp (Break None) offset
        | [name] -> mk_exp (Break (Some (name_element name))) offset 
        | _ -> raise (Parser_Unknown_Tag ("BREAK", offset)) 
      end 
    | Element ("TRY", attrs, children) ->
      let offset = get_offset attrs in
      begin match remove_annotation_elements children with
        | (child1 :: children) ->
          let catch, finally = get_catch_finally children offset in 
          mk_exp (Try (xml_to_exp child1, catch, finally)) offset
        | _ -> raise (Parser_Unknown_Tag ("TRY", offset))
      end  
    | Element ("SWITCH", attrs, children) -> 
      let offset = get_offset attrs in
      begin match (remove_annotation_elements children) with
         | (child1 :: cases) ->
           let cases = remove_annotation_elements cases in
           let cases = map (fun c -> parse_case c offset) cases in
           mk_exp (Switch (xml_to_exp child1, cases)) offset
         | _ -> raise (Parser_Unknown_Tag ("SWITCH", offset))
      end
    | Element ("DEBUGGER", attrs, _) -> mk_exp Debugger (get_offset attrs)
    | Element (tag_name, attrs, _) -> raise (Parser_Unknown_Tag (tag_name, get_offset attrs))
    | PCData _ -> raise Parser_PCData
and 
var_declaration offset vd = 
  match vd with
    | Element ("VAR", attrs, children) ->
      let offset = get_offset attrs in
      let name, child = begin match (remove_annotation_elements children) with 
        | [name] -> name, None
        | [name; child] -> name, Some (xml_to_exp child)
        | _ -> raise (Parser_Unknown_Tag ("VAR", offset))
      end in
      let name = match name with
		    | Element ("NAME", attrs, children) -> get_value attrs
        | _ -> raise (Parser_Unknown_Tag ("VAR", offset))
      in
      name, child 
    | _ -> raise (Parser_Unknown_Tag ("VAR", offset))
and
parse_array_literal attrs children =
  let l = mapi (fun index child -> 
    match child with
      | Element ("EMPTY", attrs, _) -> None
      | _ -> Some (xml_to_exp child)
  ) (remove_annotation_elements children) in
  mk_exp (Array l) (get_offset attrs)
and 
parse_unary_op uop attrs children uops =
  begin match (remove_annotation_elements children) with
    | [child] -> mk_exp (Unary_op (uop, xml_to_exp child)) (get_offset attrs)
    | _ -> raise (Parser_Unknown_Tag (uops, get_offset attrs)) 
  end 
and
parse_binary_op bop attrs children tag =  
  begin match (remove_annotation_elements children) with
    | [child1; child2] -> mk_exp (BinOp (xml_to_exp child1, bop, xml_to_exp child2)) (get_offset attrs)
    | _ -> raise (Parser_Unknown_Tag (tag, get_offset attrs)) 
  end
and
parse_comparison_op op attrs children tag =
  parse_binary_op (Comparison op) attrs children tag
and
parse_arith_op op attrs children tag =
  parse_binary_op (Arith op) attrs children tag
and
parse_bool_op op attrs children tag =
  parse_binary_op (Boolean op) attrs children tag
and parse_assign_op op attrs children tag =
   begin match (remove_annotation_elements children) with
     | [child1; child2] -> mk_exp (AssignOp (xml_to_exp child1, op, xml_to_exp child2)) (get_offset attrs)
     | _ -> raise (Parser_Unknown_Tag (tag, get_offset attrs)) 
   end
and parse_catch_element catch offset =
  match catch with
      | Element ("CATCH", attrs, children) -> 
          let name, exp = get_xml_two_children catch in
          (name_element name, xml_to_exp exp)
      | _ -> raise (Parser_Unknown_Tag ("CATCH", offset))
and get_catch_finally children offset =
  begin match children with
    | [catch_block; finally_block] ->
      Some (parse_catch_element catch_block offset), Some (xml_to_exp finally_block)
    | [block] ->
      begin match block with
        | Element ("CATCH", _, _) -> Some (parse_catch_element block offset), None
        | Element ("BLOCK", _, _) -> None, Some (xml_to_exp block)
        | _ -> raise (Parser_Unknown_Tag ("TRY", offset))
      end 
    | _ -> raise (Parser_Unknown_Tag ("TRY", offset))
  end
and parse_for_exp child =
  match child with
    | Element ("EMPTY", attrs, children) -> None
    | _ -> Some (xml_to_exp child)

and parse_case child offset =
  begin match child with
    | Element ("CASE", attrs, children) ->
      let exp, block = get_xml_two_children child in
      Case (xml_to_exp exp), xml_to_exp block
    | Element ("DEFAULT_CASE", attrs, children) ->
      let block = get_xml_child child in
      DefaultCase, xml_to_exp block
    | _ -> raise (Parser_Unknown_Tag ("SWITCH", offset))
  end
