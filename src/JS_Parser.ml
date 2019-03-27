module Syntax = Syntax
module PrettyPrint = PrettyPrint

exception FlowParseError of string list

let parse_string_exn ?(force_strict=false) program =
  let parse_options =
    Some (
      Flow_parser.Parser_env.{ default_parse_options with types = false; use_strict = force_strict }
    )
  in
  let (p, e) = Flow_parser.Parser_flow.program_file ~fail:false ~parse_options program None in
  if List.length e > 0 then
    let messages = List.map
      (fun (loc, err) -> (Flow_parser.Loc.to_string loc) ^ " : " ^ (Flow_parser.Parse_error.PP.error err))
      e
    in
    raise (FlowParseError messages)
  else
    let trans_prog = OfFlow.transform_program p in
    let trans_annotated_prog = Syntax.add_strictness force_strict trans_prog in
    trans_annotated_prog