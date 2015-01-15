open Parser
open Pretty_print
open Parser_syntax
open Unix
open Yojson.Safe
(*IFDEF TARGETJS THEN
open Js
END*)

let js_to_xml_parser = ref ""
let verbose = ref false
let use_json = ref false

module type ParserImpl =
  sig
    val exp_from_file : ?force_strict:bool -> ?init:bool -> string -> Parser_syntax.exp
    val exp_from_string : ?force_strict:bool -> string -> Parser_syntax.exp
    val exp_from_stdin : unit -> Parser_syntax.exp
  end

module P = (Parser_xml : ParserImpl)

(*IFDEF TARGETJS THEN
let js_self_parser (s : string) : string =
  Js.to_string (Js.Unsafe.fun_call (Js.Unsafe.variable "jsref_parse") [|Js.Unsafe.inject s|]);;
END*)

let exp_from_stdin = P.exp_from_stdin

let exp_from_file = P.exp_from_file

let exp_from_string = P.exp_from_string

(*
let exp_from_file ?force_strict:(f = false) ?init:(i = false) file =
  try
    if(!use_json) then
      exp_from_file_json ~force_strict:f ~init:i file
    else
      exp_from_file_xml file
  with
    | Xml.File_not_found f -> raise (Parser.ParserFailure f)

let exp_from_string ?force_strict:(f = false) s =
(*  IFDEF TARGETJS THEN
	add_strictness f (json_to_exp (Yojson.Safe.from_string (js_self_parser s)))
  ELSE*) let (file, out) = Filename.open_temp_file "js_gen" ".js" in
  output_string out s;
  close_out out;
  exp_from_file ~force_strict:f file
  (*END*);;
*)
