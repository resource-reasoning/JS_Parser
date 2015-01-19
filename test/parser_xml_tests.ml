open OUnit
open Pretty_print
open Parser_main
open Parser_syntax
open Utils

let test_unescape_html () =
  assert_equal "<>&\"'" (Parser_xml.unescape_html "&lt;&gt;&amp;&quot;&apos;")

let test_unescape_html_number () =
  assert_equal "a\009a" (Parser_xml.unescape_html "a&#9;a")

let test_unescape_html_hex () =
  assert_equal "abb\009abb\010" (Parser_xml.unescape_html "abb&#x9;abb&#xA;")

let test_unescape_html_1 () =
  let exp = exp_from_string "var o = \"3 < 2\"" in
  let s = mk_exp (String "3 < 2") 8 in
  assert_equal_exp (add_script(mk_exp(VarDec ["o", Some s]) 0)) exp

let test_get_invariant () =
  let xml = " <WHILE pos=\"0\">
                <GT pos=\"7\">
                  <NAME pos=\"7\" value=\"a\"/>
                  <NUMBER pos=\"11\" value=\"5.0\"/>
                </GT>
                <BLOCK pos=\"14\">
                  <EXPR_RESULT pos=\"49\">
                    <INC decpos=\"post\" pos=\"49\">
                      <ANNOTATION formula=\"#cScope = [#lg]\" pos=\"49\" type=\"invariant\"/>
                      <NAME pos=\"49\" value=\"a\"/>
                    </INC>
                  </EXPR_RESULT>
                  <CONTINUE pos=\"54\"/>
                </BLOCK>
              </WHILE>" in
  let xml = Xml.parse_string xml in
  assert_equal ~printer:string_of_annots [{annot_type = Invariant; annot_formula = "#cScope = [#lg]"}] (Parser_xml.get_invariant xml)

let tests =
  [
    "test_unescape_html" >:: test_unescape_html;
    "test_unescape_html_number" >:: test_unescape_html_number;
    "test_unescape_html_hex" >:: test_unescape_html_hex;
    "test_unescape_html_1" >:: test_unescape_html_1;
    "test_get_invariant" >:: test_get_invariant;
  ]
