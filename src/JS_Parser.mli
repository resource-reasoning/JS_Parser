module Syntax : module type of struct
  include Syntax
end

module PrettyPrint : module type of struct
  include PrettyPrint
end

module Error : module type of struct
  include Error
end

val parse_string_exn : ?force_strict:bool -> string -> Syntax.exp
(** [parse_string_exn ~force_strict prog] the given string as a program.
    The string given should be the entire program.
    If [force_strict] is true, the program has to be strict.
    If there is an error during the parsing, an exception of type [Error.ParserError] is raised *)

val parse_string : ?force_strict:bool -> string -> (Syntax.exp, Error.t) result
(** Same as [parse_string_exn] except that it returns a result instead of raising an error. *)
