open Parser
open Pretty_print
open Parser_syntax
open Unix
open Yojson.Safe

let verbose = ref false
let use_json = ref false
let from_stdin = ref false

let xml_parser_path = ref ""
let json_parser_path = ref ""

let init ?path () =
  try
    let libdir = (match path with
      | None -> Findlib.init (); Findlib.package_property [] "JS_Parser" "share"
      | Some s -> s) in
    xml_parser_path := Filename.concat libdir "js_parser.jar";
    json_parser_path := Filename.concat libdir "run_esprima.js";
    let _ = Unix.stat !xml_parser_path in
    ()
  with
    | Findlib.No_such_package _   ->
        raise (Parser.ParserFailure "JS_Parser not installed. Please supply parser path.")
    | Unix.Unix_error (err, _, f) ->
        raise (Parser.ParserFailure (Printf.sprintf "Could not find parser at %s (%s)" f (Unix.error_message err)))

let js_to_xml (filename : string) : string =
  match Unix.system ("java -jar " ^ !xml_parser_path ^ " " ^ (Filename.quote filename)) with
    | Unix.WEXITED _ -> String.sub filename 0 (String.length filename - 3) ^ ".xml"
    | _ -> raise JS_To_XML_parser_failure

let js_to_json ?force_strict:(f = false) ?init:(i = false) (filename : string) : string =
  let force_strict = (if (f) then " -force_strict" else "") in
  let init = (if (i) then " -builtin_init" else "") in
  match Unix.system ("node " ^ !json_parser_path ^ " " ^ (Filename.quote filename) ^ force_strict ^ init) with
    | Unix.WEXITED n -> 
        (if(n <> 0) then raise (Xml.File_not_found filename)); String.sub filename 0 (String.length filename - 3) ^ ".json"
    | _ -> raise JS_To_XML_parser_failure

let exp_from_stdin_json =
  fun() ->
    let data = Yojson.Safe.from_channel Pervasives.stdin in
    let expression = json_to_exp data in
    add_strictness false expression

let exp_from_stdin_xml =
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

let exp_from_stdin =
  fun() ->
    if(!use_json) then
      exp_from_stdin_json()
    else
      exp_from_stdin_xml()

let exp_from_file_json ?force_strict:(f = false) ?init:(i = false) file =
  let js_file = js_to_json ~force_strict:f ~init:i file in
  let data = Yojson.Safe.from_file js_file in
  let expression = json_to_exp data in
  add_strictness f expression

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
        Printf.eprintf "Xml Parsing error occurred in line %d : %s \n"
          (Xml.line (snd error)) (Xml.error_msg (fst error)); 
        raise Parser.XmlParserException
    | Xml.File_not_found f -> raise (Parser.ParserFailure (Printf.sprintf "XML File not found: %s" f))
    | JS_To_XML_parser_failure -> raise JS_To_XML_parser_failure

let exp_from_file ?force_strict:(f = false) ?init:(i = false) file =
  try
    if(!use_json) then
      exp_from_file_json ~force_strict:f ~init:i file
    else
      exp_from_file_xml file
  with
    | Xml.File_not_found f -> raise (Parser.ParserFailure f)

let exp_from_string ?force_strict:(f = false) s =
  let (file, out) = Filename.open_temp_file "js_gen" ".js" in
  output_string out s;
  close_out out;
  exp_from_file ~force_strict:f file

let exp_from_main ?force_strict:(str = false) file = 
  fun() ->
    if(!from_stdin) then
      exp_from_stdin()
    else
      exp_from_file ~force_strict:str file
