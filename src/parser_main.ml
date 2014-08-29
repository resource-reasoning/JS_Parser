open Parser
open Pretty_print
open Parser_syntax
open Unix
open Yojson.Safe

let js_to_xml_parser = ref ""
let verbose = ref false
let use_json = ref false

let js_to_xml (filename : string) : string =
  match Unix.system ("java -jar " ^ !js_to_xml_parser ^ " " ^ (Filename.quote filename)) with
    | Unix.WEXITED _ -> String.sub filename 0 (String.length filename - 3) ^ ".xml"
    | _ -> raise JS_To_XML_parser_failure

let js_to_json (filename : string) : string =
  match Unix.system ("nodejs simple_print.js" ^ " " ^ (Filename.quote filename)) with
    | Unix.WEXITED n -> 
        (if(n <> 0) then raise (Xml.File_not_found filename)); String.sub filename 0 (String.length filename - 3) ^ ".json"
    | _ -> raise JS_To_XML_parser_failure

let exp_from_stdin_json =
  fun() ->
    let data = Yojson.Safe.from_channel Pervasives.stdin in
    let expression = json_to_exp data in
    add_strictness false expression


let exp_from_file file =
  if(!use_json) then begin
    let js_file = js_to_json file in
    let data = Yojson.Safe.from_file js_file in
    let expression = json_to_exp data in
    add_strictness false expression
  end else begin
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
            raise Parser.XmlParserException
    end

let exp_from_string s =
  let (file, out) = Filename.open_temp_file "js_gen" ".js" in
  output_string out s;
  close_out out;
  exp_from_file file

let exp_from_main file = 
  fun() ->
    begin
      if(!use_json) then
        exp_from_stdin_json()
      else
        exp_from_file file
    end
