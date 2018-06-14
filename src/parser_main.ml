open Parser
open Pretty_print
open Parser_syntax
open Unix
open Yojson.Safe

let verbose = ref false
let from_stdin = ref false

let json_parser_path = ref ""

let init ?path () =
  try
    let libdir = (match path with
      | None -> Findlib.init (); Findlib.resolve_path "@JS_Parser-runtime"
      | Some s -> s) in
    json_parser_path := Filename.concat libdir "run_esprima.js";
    Parser.doctrine_path := Filename.concat libdir "run_doctrine.js";
  with
    | Findlib.No_such_package _   ->
        raise (Parser.ParserFailure "JS_Parser not installed. Please supply parser path.")
    | Unix.Unix_error (err, _, f) ->
        raise (Parser.ParserFailure (Printf.sprintf "Could not find parser at %s (%s)" f (Unix.error_message err)))

let js_to_json ?force_strict:(f = false) ?init:(i = false) (filename : string) : string =
  let force_strict = (if (f) then " -force_strict" else "") in
  let init = (if (i) then " -builtin_init" else "") in
  match Unix.system ("node " ^ !json_parser_path ^ " " ^ (Filename.quote filename) ^ force_strict ^ init) with
    | Unix.WEXITED n ->
        (if (n <> 0) then raise (Xml.File_not_found filename)); String.sub filename 0 (String.length filename - 3) ^ ".json"
    | _ -> raise (ParserFailure "Parser exited in an unacceptable manner.")

let exp_from_stdin =
  fun() ->
    let data = Yojson.Safe.from_channel Pervasives.stdin in
    let expression = json_to_exp data in
    add_strictness false expression

let exp_from_file ?force_strict:(f = false) ?init:(i = false) file =
	let js_file = js_to_json ~force_strict:f ~init:i file in
  Printf.printf "Parsed js file.\n%!";
	let data = Yojson.Safe.from_file js_file in
  Printf.printf "Parsed json from js file.\n%!";
	(* Printf.printf "JSON:\n%s" (Yojson.Safe.pretty_to_string data); *)
	let expression = json_to_exp data in
  Printf.printf "Converted json to AST.\n%!";
	(* Printf.printf "EXP:\n%s" (string_of_exp true expression); *)
  	add_strictness f expression

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
