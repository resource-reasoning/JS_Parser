open Parser

let parser_json = (module Parser_json : ParserImpl)
let parser_xml = (module Parser_xml : ParserImpl)

let parser_impl = ref parser_json

(*IFDEF TARGETJS THEN
let js_self_parser (s : string) : string =
  Js.to_string (Js.Unsafe.fun_call (Js.Unsafe.variable "jsref_parse") [|Js.Unsafe.inject s|]);;
END*)

let use_parser_xml ?path:(s = "") ?verbose:(v = false) =
  let path = (if s = "" then "lib/js_parser.jar" else s) in
  Parser_xml.js_to_xml_parser := path;
  Parser_xml.verbose := v;
  parser_impl := parser_xml

let use_parser_json () =
  parser_impl := parser_json

let exp_from_stdin =
  let module P = (val !parser_impl : ParserImpl) in
  P.exp_from_stdin

let exp_from_file =
  let module P = (val !parser_impl : ParserImpl) in
  P.exp_from_file

let exp_from_string =
  let module P = (val !parser_impl : ParserImpl) in
  P.exp_from_string

