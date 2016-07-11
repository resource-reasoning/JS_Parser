FLAGS=-use-ocamlfind -verbose 1
JS_PARSER_JAR=./lib/js_parser.jar
JS_PARSER_JSON=./lib/run_esprima.js

_build: src/* test/* JS_Parser.itarget
	ocamlbuild ${FLAGS} JS_Parser.otarget

clean:
	ocamlbuild ${FLAGS} -clean

test_byte: _build
	./parser_tests.byte -jsparser ${JS_PARSER_JAR}

test_json: _build lib/node_modules
	./parser_tests.byte -json -jsparser ${JS_PARSER_JSON}

test_native: _build
	./parser_tests.native -jsparser ${JS_PARSER_JAR}

test_json_native: _build lib/node_modules
	./parser_tests.native -json -jsparser ${JS_PARSER_JSON}

test_all: test test_native test_json_native
test: test_byte test_json

.PHONY: clean
.PHONY: test test_all test_byte test_native test_json test_json_native
