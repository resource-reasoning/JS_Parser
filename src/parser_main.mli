val use_parser_xml : ?path:string -> ?verbose:bool -> unit
val use_parser_json : unit -> unit

val exp_from_stdin : unit -> Parser_syntax.exp
val exp_from_file :
  ?force_strict:bool -> ?init:bool -> string -> Parser_syntax.exp
val exp_from_string : ?force_strict:bool -> string -> Parser_syntax.exp
val supports_annots : unit -> bool
