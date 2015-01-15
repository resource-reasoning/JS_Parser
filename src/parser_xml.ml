open Xml
open Parser
open Parser_syntax
open List

let js_to_xml (filename : string) : string =
  match Unix.system ("java -jar " ^ !js_to_xml_parser ^ " " ^ (Filename.quote filename)) with
    | Unix.WEXITED _ -> String.sub filename 0 (String.length filename - 3) ^ ".xml"
    | _ -> raise JS_To_XML_parser_failure

let exp_from_stdin =
  fun() ->
    try
      let data = Xml.parse_in Pervasives.stdin in
      let expression = xml_to_exp data in
      add_strictness false expression
    with
        | Xml.Error error -> 
            Printf.printf "Xml Parsing error occurred in line %d : %s \n" 
              (Xml.line (snd error)) (Xml.error_msg (fst error)); 
            raise Parser.XmlParserException

let exp_from_file_xml file =
  try
    let xml_file = js_to_xml file in 
    let data = Xml.parse_file xml_file in
    if (!verbose) then print_string (Xml.to_string_fmt data);
    let expression = xml_to_exp data in
    if (!verbose) then print_string (string_of_exp true expression);
    add_strictness false expression
  with 
    | Xml.Error error -> 
        Printf.printf "Xml Parsing error occurred in line %d : %s \n" 
          (Xml.line (snd error)) (Xml.error_msg (fst error)); 
        raise Parser.XmlParserException

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

(* Helper functions *)

let flat_map f l = flatten (map f l)

let get_attr attrs attr_name =
  let _, value = List.find (fun (name, value) -> name = attr_name) attrs in
    unescape_html value

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
