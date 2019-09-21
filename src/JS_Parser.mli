module Syntax : module type of struct
  include Syntax
end

module PrettyPrint : module type of struct
  include PrettyPrint
end

module Error : sig
  type t =
  | Overlapping_Syntax
      (** Something went wrong with the parser, some syntax is overlapping *)
  | Unhandled_Statement of int
      (** The statement at the given offset is not handled. Maybe because it is not part of ES5 *)
  | Unhandled_Expression of int
      (** The expression at the given offset is not handled. Maybe because it is not part of ES5 *)
  | NotEcmaScript5 of string * int
      (** Something used in the script is not part of ES5 *)
  | UnusedAnnotations of string list * int
      (** Some JS_Logic annotations were in the wrong place *)
  | FlowParser of string * string  (** Some Error happened at the flow_parser lever. *)

  val str : t -> string

  exception ParserError of t
end

val parse_string_exn : ?parse_annotations:bool -> ?force_strict:bool -> string -> Syntax.exp
(** [parse_string_exn ~parse_annotations ~force_strict prog] parses the given string as a program.
    The string given should be the entire program.
    If [parse_annotations] is set to false the possible JS_Logic annotations in the comments will not be parse. It is true by default.
    If [force_strict] is true, the program has to be strict. Default value for [force_strict] is [false].
    If there is an error during the parsing, an exception of type {!Error.ParserError} is raised *)

val parse_string : ?parse_annotations:bool -> ?force_strict:bool -> string -> (Syntax.exp, Error.t) result
(** Same as [parse_string_exn] except that it returns a result instead of raising an error. *)
