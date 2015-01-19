exception Parser_No_Program
exception ParserFailure of string
exception Parser_Xml_To_String
exception Parser_Xml_To_Var
exception Parser_Unknown_Tag of (string * int)
exception Parser_PCData
exception Parser_ObjectLit
exception JS_To_XML_parser_failure
exception OnlyIntegersAreImplemented
exception Parser_Name_Element of string
exception Parser_Param_List
exception Unknown_Annotation of string
exception InvalidArgument
exception XmlParserException
exception Unknown_Dec_Inc_Position
exception Parser_Xml_To_Label_Name
exception More_Than_One_Finally
exception CannotHappen
exception Empty_list

module type ParserImpl =
  sig
    val exp_from_file : ?force_strict:bool -> ?init:bool -> string -> Parser_syntax.exp
    val exp_from_string : ?force_strict:bool -> string -> Parser_syntax.exp
    val exp_from_stdin : unit -> Parser_syntax.exp
    val supports_annots : bool
  end
