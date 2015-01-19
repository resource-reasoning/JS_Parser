val exp_from_file : ?force_strict:bool -> ?init:bool -> string -> Parser_syntax.exp
val exp_from_string : ?force_strict:bool -> string -> Parser_syntax.exp
val exp_from_stdin : unit -> Parser_syntax.exp
val supports_annots : bool

(* Configuration *)
val js_to_xml_parser : string ref
val verbose : bool ref

(* For testing only *)
val unescape_html : string -> string
val get_invariant : Xml.xml -> Parser_syntax.annotation list
