open Parser
open Parser_json
open Parser_xml
open Pretty_print
open Parser_syntax
open Unix
open Yojson.Safe
IFDEF TARGETJS THEN
open Js
END

let js_to_xml_parser = ref ""
let verbose = ref false
let use_json = ref false
let from_stdin = ref false

IFDEF TARGETJS THEN
let js_self_parser (s : string) : string =
  Js.to_string (Js.Unsafe.fun_call (Js.Unsafe.variable "jsref_parse") [|Js.Unsafe.inject s|]);;
END		       
		     
let js_to_xml (filename : string) : string =
  match Unix.system ("java -jar " ^ !js_to_xml_parser ^ " " ^ (Filename.quote filename)) with
    | Unix.WEXITED _ -> String.sub filename 0 (String.length filename - 3) ^ ".xml"
    | _ -> raise JS_To_XML_parser_failure

let js_to_json ?force_strict:(f = false) ?init:(i = false) (filename : string) : string =
  let force_strict = (if (f) then " -force_strict" else "") in
  let init = (if (i) then " -builtin_init" else "") in
  match Unix.system ("nodejs simple_print.js" ^ " " ^ (Filename.quote filename) ^ force_strict ^ init) with
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
  add_strictness false expression

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

let exp_from_file ?force_strict:(f = false) ?init:(i = false) file =
  try
    if(!use_json) then
      exp_from_file_json ~force_strict:f ~init:i file
    else
      exp_from_file_xml file
  with
    | Xml.File_not_found f -> raise (Parser.ParserFailure f)

let exp_from_string ?force_strict:(f = false) s =
  IFDEF TARGETJS THEN
	add_strictness f (json_to_exp (Yojson.Safe.from_string (js_self_parser s)))
  ELSE let (file, out) = Filename.open_temp_file "js_gen" ".js" in
  output_string out s;
  close_out out;
  exp_from_file ~force_strict:f file
  END;;

let exp_from_main file = 
  fun() ->
    if(!from_stdin) then
      exp_from_stdin()
    else
      exp_from_file file

