(* Configuration *)
val nodebin : string ref

val exp_from_file : ?force_strict:bool -> ?init:bool -> string -> Parser_syntax.exp
val exp_from_string : ?force_strict:bool -> string -> Parser_syntax.exp
val exp_from_stdin : unit -> Parser_syntax.exp
