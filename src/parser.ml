open Xml
open Parser_syntax
open List
open Yojson.Safe

let doctrine_path = ref ""
let doctrine_file = ref "doctrine.json"

exception Parser_No_Program
exception ParserFailure of string
exception Parser_Unknown_Tag of string * int
exception Parser_PCData
exception Parser_ObjectLit
exception OnlyIntegersAreImplemented
exception Parser_Name_Element of string
exception Parser_Param_List
exception Unknown_Annotation of string
exception InvalidArgument
exception Unknown_Dec_Inc_Position
exception More_Than_One_Finally
exception CannotHappen
exception Empty_list

let time = ref 0.

(* ******************** 
   *       JSON       *
   ******************** *)
	
let get_json_field field_name json =
  let start_time = Sys.time() in 
  let result = match json with
    | `Assoc contents ->
        snd (List.find (fun (str, _) -> (str = field_name)) contents)
    | _ -> print_string field_name; raise Empty_list
  in 
    let end_time = Sys.time() in
    time := !time +. end_time -. start_time;
    Printf.printf "GJF: %f\n%!" !time;
    result

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

let process_annotation annot =
	let atype = get_json_string "title" annot in
	let atype = (match atype with
	
		(* Compatibility with Closure Parser *)
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
		| annot -> raise (Unknown_Annotation annot)) in
	
	let adesc = get_json_string "description" annot in
	{ annot_type = atype; annot_formula = adesc }

let get_esprima_annotations json =
	let leadingComments = try (get_json_list "leadingComments" json) with _ -> [] in
	let actualComments = List.map (fun x -> "/* " ^ (get_json_string "value" x) ^ " */") leadingComments in
	(* Printf.printf ("\nNumber of comments: %d\n") (List.length actualComments);
	List.iter (fun x -> Printf.printf "%s\n" x) actualComments; *)
	let doctrinise x =
                let (input, output) = Unix.open_process ("node " ^ !doctrine_path) in
                output_string output x;
                close_out output;
                let data = Yojson.Safe.from_channel input in
                (match Unix.close_process (input, output) with
    	| Unix.WEXITED n ->
        	(if (n <> 0) then raise (ParserFailure "Doctrine failed.") else data)
    	| _ -> raise (ParserFailure "Doctrine failed.")) in
	let annotations = List.fold_left
	(fun ac x ->
		let data = doctrinise x in
		let annots = get_json_list "tags" data in
		let annots = List.fold_left
		(fun ac x ->
			ac @ [ process_annotation x ]) [] annots in
		ac @ annots) [] actualComments in
	annotations

let rec json_to_exp json : exp =
  let json_type = get_json_type json in
  let annotations = get_esprima_annotations json in
  match json_type with
    | "Program" ->
      let children = get_json_list "body" json in
      let stmts = map json_to_exp children in
      mk_exp (Script (false, stmts)) (get_json_offset json) annotations
    | "BlockStatement" ->
      let children = get_json_list "body" json in
      json_mk_block_exp children (get_json_offset json) annotations
    | "FunctionExpression" ->
      let fn_name = get_json_field "id" json in
      let fn_params = map get_json_ident_name (get_json_list "params" json) in
      let fn_body = json_to_exp (get_json_field "body" json) in
      begin match fn_name with
        | `Null -> mk_exp (FunctionExp (false,None,fn_params,fn_body)) (get_json_offset json) annotations
        | ident -> mk_exp (FunctionExp (false,Some (get_json_ident_name fn_name),fn_params,fn_body)) (get_json_offset json) annotations
      end
    | "FunctionDeclaration" ->
      let fn_name = get_json_field "id" json in
      let fn_params = map get_json_ident_name (get_json_list "params" json) in
      let fn_body = json_to_exp (get_json_field "body" json) in
      begin match fn_name with
        | `Null -> mk_exp (Function (false,None,fn_params,fn_body)) (get_json_offset json) annotations
        | ident -> mk_exp (Function (false,Some (get_json_ident_name fn_name),fn_params,fn_body)) (get_json_offset json) annotations
      end
    | "VariableDeclaration" ->
      let offset = (get_json_offset json) in
      begin match (get_json_list "declarations" json) with
        | [] -> raise Empty_list
        | children ->
            let vars = map (json_var_declaration offset) children in
            mk_exp (VarDec vars) offset annotations
      end
			
    | "ExpressionStatement" ->
			(* Get the leading comments *)
			let leadingComments = try (get_json_list "leadingComments" json) with _ -> [] in
			(* Get the body of the expression *)
			let jfexp = get_json_field "expression" json in
			let jfexp = (match jfexp with
	      | `Assoc (contents : (string * json) list) ->
					let ylCom, nlCom = List.partition (fun (k, _) -> k = "leadingComments") contents in
					let newLeadingComments = (match ylCom with
					  | [] -> leadingComments
					  | [ (_, `List innerLeadingComments) ] -> leadingComments @ innerLeadingComments
					  | _ -> raise (Failure "JSON with two fields of the same name.")) in
					let enriched_contents = nlCom @ [ "leadingComments", `List newLeadingComments ] in
	        `Assoc enriched_contents
	      | _ -> raise (Failure "Unexpected non-assoc.")) in
      json_to_exp jfexp
			
    | "IfStatement" ->
      let offset = get_json_offset json in
      let test = json_to_exp (get_json_field "test" json) in
      let cons = json_to_exp (get_json_field "consequent" json) in
      let alt =
      begin match (get_json_field "alternate" json) with
        | `Null -> None
        | stat  -> Some (json_to_exp stat)
      end in
      mk_exp (If (test, cons, alt)) offset annotations

    | "LabeledStatement" ->
      let lname = get_json_ident_name (get_json_field "label" json) in
      let body = json_to_exp (get_json_field "body" json) in
      mk_exp (Label (lname, body)) (get_json_offset json) annotations

    | "BreakStatement" ->
      let label =
      begin match (get_json_field "label" json) with
        | `Null -> None
        | ident -> Some (get_json_ident_name ident)
      end in
      mk_exp (Break label) (get_json_offset json) annotations

    | "ContinueStatement" ->
      let label =
      begin match (get_json_field "label" json) with
        | `Null -> None
        | ident -> Some (get_json_ident_name ident)
      end in
      mk_exp (Continue label) (get_json_offset json) annotations

    | "WithStatement" ->
      let obj = json_to_exp (get_json_field "object" json) in
      let body = json_to_exp (get_json_field "body" json) in
      mk_exp (With (obj, body)) (get_json_offset json) annotations

    | "SwitchStatement" ->
      let offset = get_json_offset json in
      let disc = json_to_exp (get_json_field "discriminant" json) in
      let cases = get_json_list "cases" json in
      let cases = map(fun c -> json_parse_case c offset) cases in
      mk_exp (Switch (disc, cases)) offset annotations

    | "ThrowStatement" ->
      let e = get_json_field "argument" json in
      mk_exp (Throw (json_to_exp e)) (get_json_offset json) annotations

    | "TryStatement" ->
      let offset = get_json_offset json in
      let block_obj = get_json_field "block" json in
      let block = json_mk_block_exp (get_json_list "body" block_obj) (get_json_offset block_obj) annotations in
      let handler = get_json_list "handlers" json in
      let guardedHandlers = get_json_list "guardedHandlers" json in
      let finaliser = get_json_field "finalizer" json in
      let catch, finally = json_get_catch_finally handler guardedHandlers finaliser offset in
      mk_exp (Try (block, catch, finally)) offset annotations

    | "WhileStatement" ->
      let condition = json_to_exp (get_json_field "test" json) in
      let block = json_to_exp (get_json_field "body" json) in
      mk_exp (While (condition, block)) (get_json_offset json) annotations

    | "DoWhileStatement" ->
      let condition = json_to_exp (get_json_field "test" json) in
      let block = json_to_exp (get_json_field "body" json) in
      mk_exp (DoWhile (block, condition)) (get_json_offset json) annotations

    | "ForStatement" ->
      let offset = get_json_offset json in
      let init = json_parse_for_exp (get_json_field "init" json) offset in
      let condition = json_parse_for_exp (get_json_field "test" json) offset in
      let incr = json_parse_for_exp (get_json_field "update" json) offset in
      let block = json_to_exp (get_json_field "body" json) in
      mk_exp (For (init, condition, incr, block)) offset annotations

    | "ForInStatement" ->
      let offset = get_json_offset json in
      let var = json_to_exp (get_json_field "left" json) in
      let obj = json_to_exp (get_json_field "right" json) in
      let block = json_to_exp (get_json_field "body" json) in
      mk_exp (ForIn (var, obj, block)) offset annotations

    | "DebuggerStatement" ->
      mk_exp Debugger (get_json_offset json) annotations

    | "UnaryExpression" ->
      let child = json_to_exp (get_json_field "argument" json) in
      let op = get_json_string "operator" json in
      json_mk_un_op child op (get_json_offset json) annotations

    | "BinaryExpression" ->
      json_mk_left_right_op json json_mk_bin_op annotations

    | "AssignmentExpression" ->
      json_mk_left_right_op json json_mk_assign_op annotations

    | "LogicalExpression" ->
      json_mk_left_right_op json json_mk_logical_op annotations

    | "UpdateExpression" ->
      let child = json_to_exp (get_json_field "argument" json) in
      let op = get_json_string "operator" json in
      let is_prefix = get_json_bool "prefix" json in
      json_mk_update_op child op is_prefix (get_json_offset json) annotations

    | "MemberExpression" ->
      let obj = json_to_exp (get_json_field "object" json) in
      let prop = get_json_field "property" json in
      begin if (get_json_bool "computed" json) then
        mk_exp (CAccess (obj, json_to_exp prop)) (get_json_offset json) annotations
      else
        mk_exp (Access (obj, get_json_ident_name prop)) (get_json_offset json) annotations
      end

    | "ThisExpression" ->
      mk_exp This (get_json_offset json) annotations

    | "ArrayExpression" ->
      let members = get_json_list "elements" json in
      json_parse_array_literal members (get_json_offset json) annotations

    | "ObjectExpression" ->
      let l = map (fun obj ->
        let key = json_propname_element (get_json_field "key" obj) in
        let leadingComments = try (get_json_list "leadingComments" obj) with _ -> [] in
        let obj = (match obj with
          | `Assoc (contents : (string * json) list) ->
            let (enriched_contents : (string * json) list)=
              List.map (fun ((k, v) : (string * json)) ->
                (match k with
                  | "value" -> (match (v : json) with
                    | `Assoc (lst : (string * json) list) ->
                      let (new_contents : json) = `List leadingComments in
                      (k, `Assoc (("leadingComments", new_contents) :: lst))
                    | _ -> raise (Failure "Unexpected non-assoc."))
                  | _ -> (k, v))) contents in
            `Assoc enriched_contents
          | _ -> raise (Failure "Unexpected non-assoc.")) in
        let value = json_to_exp (get_json_field "value" obj) in
        match (get_json_string "kind" obj) with
          | "init" -> (key, PropbodyVal, value)
          | "get"  -> (key, PropbodyGet, value)
          | "set"  -> (key, PropbodySet, value)
          | _ -> raise Parser_ObjectLit
      ) (get_json_list "properties" json)
    in (mk_exp (Obj l) (get_json_offset json)) annotations

    | "SequenceExpression" ->
      json_nest_sequence (get_json_list "expressions" json) (get_json_offset json) annotations

    | "ConditionalExpression" ->
      let test = json_to_exp (get_json_field "test" json) in
      let cons = json_to_exp (get_json_field "consequent" json) in
      let alt = json_to_exp (get_json_field "alternate" json) in
      mk_exp (ConditionalOp (test, cons, alt)) (get_json_offset json) annotations

    | "NewExpression" ->
      let callee = json_to_exp (get_json_field "callee" json) in
      let arguments = (get_json_list "arguments" json) in
      mk_exp (New (callee, (map json_to_exp arguments))) (get_json_offset json) annotations

    | "ReturnStatement" ->
      let offset = (get_json_offset json) in
      begin match (get_json_field "argument" json) with
        | `Null -> mk_exp (Return None) offset annotations
        | expr  -> mk_exp (Return (Some (json_to_exp expr))) offset annotations
      end

    | "CallExpression" ->
      let callee = json_to_exp (get_json_field "callee" json) in
      let arguments = (get_json_list "arguments" json) in
      mk_exp (Call (callee, (map json_to_exp arguments))) (get_json_offset json) annotations

    | "Identifier" ->
      mk_exp (Var (get_json_ident_name json)) (get_json_offset json) annotations

    | "Literal" ->
      mk_exp (json_parse_literal json) (get_json_offset json) annotations

    | "EmptyStatement" ->
      mk_exp Skip (get_json_offset json) annotations

    | _ -> Printf.printf "Ooops!\n"; raise (Parser_Unknown_Tag (json_type, (get_json_offset json)))
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
json_mk_left_right_op json json_mk_op annotations =
  let child1 = json_to_exp (get_json_field "left" json) in
  let child2 = json_to_exp (get_json_field "right" json) in
  let op = get_json_string "operator" json in
  json_mk_op child1 child2 op (get_json_offset json) annotations
and
json_mk_block_exp children off annotations =
  let stmts = map json_to_exp children in
  mk_exp (Block stmts) off annotations
and
json_parse_literal lit =
  let value = get_json_field "value" lit in
  let raw = get_json_string "raw" lit in
  match value with
    | `Bool(b)     -> Bool(b)
    | `Float(f)    -> Num(f)
    | `Int(i)      -> Num(float_of_int(i))
    | `Intlit(s)   -> Num(float_of_string(s))
    | `Null        -> if (raw = "null") then Null else Num(infinity) (*This is a very bad workaround*)
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
json_mk_assign_op e1 e2 op off annotations =
  match op with
    | "=" -> mk_exp (Assign (e1, e2)) off annotations
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
           mk_exp (AssignOp (e1, op_enum, e2)) off annotations
and
json_mk_un_op e op off annotations =
  match op with
    | "delete" -> mk_exp (Delete e) off annotations
    | _ -> let op_enum = begin match op with
             | "-" -> Negative
             | "+" -> Positive
             | "!" -> Not
             | "~" -> Bitnot
             | "typeof" -> TypeOf
             | "void"   -> Void
             | _ -> raise InvalidArgument
           end in
           mk_exp (Unary_op (op_enum, e)) off annotations
and
json_mk_bin_op e1 e2 op off annotations =
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
  mk_exp (BinOp (e1, op_enum, e2)) off annotations
and
json_mk_logical_op e1 e2 op off annotations =
  match op with
    | "||" -> mk_exp (BinOp (e1, (Boolean Or), e2)) off annotations
    | "&&" -> mk_exp (BinOp (e1, (Boolean And), e2)) off annotations
    | _ -> raise InvalidArgument
and
json_mk_update_op e op pre off annotations =
  let op_enum = begin match op with
    | "++" -> if (pre) then Pre_Incr else Post_Incr
    | "--" -> if (pre) then Pre_Decr else Post_Decr
    | _ -> raise InvalidArgument
  end in
  mk_exp (Unary_op (op_enum, e)) off annotations
and
json_parse_case child offset =
  let stat_list = get_json_list "consequent" child in
  let test_obj = get_json_field "test" child in
  let test =
  begin match test_obj with
    | `Null -> DefaultCase
    | expr  -> Case (json_to_exp expr)
  end in
  let annotations = get_esprima_annotations child in
  let block = json_mk_block_exp stat_list (get_json_offset child) annotations in
  test, block
and
json_parse_for_exp exp off =
  match exp with
    | `Null -> None
    | expr  -> Some (json_to_exp exp)
and
json_parse_array_literal members offset annotations =
  let l = mapi (fun index child ->
    match child with
      | `Null -> None
      | expr  -> Some (json_to_exp child)
  ) members in
  mk_exp (Array l) offset annotations
and
json_nest_sequence expressions off annotations =
  match expressions with
    | fst :: snd :: rest ->
      let init = mk_exp (Comma (json_to_exp fst, json_to_exp snd)) off [] in
      let seq = List.fold_left (fun acc e -> mk_exp (Comma (acc, json_to_exp e)) off []) init rest in
	  { seq with exp_annot = annotations }
    | _ -> raise CannotHappen
