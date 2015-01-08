val json_to_exp :
  ([> `Assoc of (string * 'a) list
    | `Bool of bool
    | `Float of float
    | `Int of int
    | `Intlit of string
    | `List of 'a list
    | `Null
    | `String of Parser_syntax.var ]
   as 'a) ->
  Parser_syntax.exp
