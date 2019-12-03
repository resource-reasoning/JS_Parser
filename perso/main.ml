let read_file filename = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      lines := input_line chan :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines ;;

let program =
  let file_lines = read_file "test.js" in
  String.concat "\n" file_lines

let parse_options =
Some
  Flow_parser.Parser_env.
    {default_parse_options with types = false; use_strict = false}
    
let p, e =
Flow_parser.Parser_flow.program_file ~fail:true ~parse_options program
  None

let c = JS_Parser.parse_string_exn program