type t =
  | Overlapping_Syntax
  | Unhandled_Statement of int
  | Unhandled_Expression of int
  | NotEcmaScript5 of string * int
  | UnusedAnnotations of string list * int
  | FlowParser of string

let str = function
  | Overlapping_Syntax ->
      Printf.sprintf
        "Something went wrong with the parser, some syntax is overlapping "
  | Unhandled_Statement i ->
      Printf.sprintf
        "The statement at offset %d is not handled. Maybe because it is not \
         part of ES5"
        i
  | Unhandled_Expression i ->
      Printf.sprintf
        "The expression at offset %d is not handled. Maybe because it is not \
         part of ES5"
        i
  | NotEcmaScript5 (s, i) -> Printf.sprintf "%s at offset %d" s i
  | UnusedAnnotations (sl, i) ->
      Printf.sprintf
        "At offset %d, the following annotations could not be placed in the \
         AST:\n\
         %s"
        i (String.concat "\n" sl)
  | FlowParser s -> Printf.sprintf "Flow_parser failed saying :\n%s" s

exception ParserError of t
