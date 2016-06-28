open Parser
open Pretty_print
open Parser_syntax

let js_to_xml_parser = ref ""
let verbose = ref true

let js_to_xml (filename : string) : string =
  match Unix.system ("java -jar " ^ !js_to_xml_parser ^ " " ^ (Filename.quote filename)) with
    | Unix.WEXITED _ -> String.sub filename 0 (String.length filename - 3) ^ ".xml"
    | _ -> raise JS_To_XML_parser_failure

let exp_from_file file =
  try
    let xml_file = js_to_xml file in 
    let data = Xml.parse_file xml_file in
    if (!verbose) then print_string (Xml.to_string_fmt data);
    let expression = xml_to_exp data in
    if (!verbose) then print_string (string_of_exp true expression);
    add_strictness false expression    
  with 
    | Xml.Error error -> 
      Printf.printf "Xml Parsing error occurred in line %d : %s \n" (Xml.line (snd error)) (Xml.error_msg (fst error)); 
      raise (Failure "Parser squealed!") (* Parser.XmlParserException *)
    | Xml.File_not_found f -> raise (Parser.ParserFailure f)

let exp_from_string s =
  let (file, out) = Filename.open_temp_file "js_gen" ".js" in
  output_string out s;
  close_out out;
  exp_from_file file
