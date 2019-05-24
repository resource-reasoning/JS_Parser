module Syntax = Syntax
module PrettyPrint = PrettyPrint
module Error = Error

let parse_string_exn ?(parse_annotations = true) ?(force_strict = false) program =
  let parse_options =
    Some
      Flow_parser.Parser_env.
        {default_parse_options with types= false; use_strict= force_strict}
  in
  let p, e =
    Flow_parser.Parser_flow.program_file ~fail:false ~parse_options program
      None
  in
  if List.length e > 0 then
    let messages =
      String.concat "\n"
        (List.map
           (fun (loc, err) ->
             Flow_parser.Loc.to_string loc
             ^ " : "
             ^ Flow_parser.Parse_error.PP.error err )
           e)
    in
    raise (Error.ParserError (Error.FlowParser messages))
  else
    let trans_prog = OfFlow.transform_program ~parse_annotations ~parent_strict:force_strict p in
    trans_prog

let parse_string ?(parse_annotations = true) ?(force_strict = false) program =
  try Ok (parse_string_exn ~parse_annotations ~force_strict program)
  with Error.ParserError err -> Error err
