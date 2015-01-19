open Parser_syntax
open Pretty_print

IFDEF TARGETJS THEN
let assert_equal a b = if a=b then print_string "."
		       else print_string "\nA test failed\n"
ELSE
open OUnit
let assert_equal_exp = assert_equal ~cmp:weak_cmp_exp ~printer:(string_of_exp true)
END

let add_script e =
  mk_exp (Script(false, [e])) 0
