module type ParserImpl =
  sig
    val exp_from_file : ?force_strict:bool -> ?init:bool -> string -> Parser_syntax.exp
    val exp_from_string : ?force_strict:bool -> string -> Parser_syntax.exp
    val exp_from_stdin : unit -> Parser_syntax.exp
  end

let parser_json = (module Parser_json : ParserImpl)
let parser_xml = (module Parser_xml : ParserImpl)

let parser_impl = ref parser_json


(*IFDEF TARGETJS THEN
let js_self_parser (s : string) : string =
  Js.to_string (Js.Unsafe.fun_call (Js.Unsafe.variable "jsref_parse") [|Js.Unsafe.inject s|]);;
END*)

let exp_from_stdin = let module P = (val !parser_impl : ParserImpl) in
  P.exp_from_stdin

let exp_from_file = let module P = (val !parser_impl : ParserImpl) in
  P.exp_from_file

let exp_from_string = let module P = (val !parser_impl : ParserImpl) in
  P.exp_from_string

