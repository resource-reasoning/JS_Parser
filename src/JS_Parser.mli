module Syntax : module type of struct
  include Syntax
end

module PrettyPrint : module type of struct
  include PrettyPrint
end

val parse_string_exn : ?force_strict:bool -> string -> Syntax.exp
