FLAGS=-use-ocamlfind -verbose 1
JS_PARSER_JAR=./lib/js_parser.jar
JS_PARSER_JSON=./lib/run_esprima.js

all: build native build_cma

%: _build/test/% ;
%: _build/src/% ;

_build/%.byte: %.ml src/* test/*
	ocamlbuild ${FLAGS} $*.byte

_build/%.native: %.ml src/* test/*.ml
	ocamlbuild ${FLAGS} $*.native

_build/%.cma: %.ml src/*.ml test/*.ml
	ocamlbuild ${FLAGS} $*.cma

build: parser_tests.byte
native: parser_tests.native
build_cma: parser_main.cma

clean:
	ocamlbuild ${FLAGS} -clean

lib/node_modules: lib/npm-shrinkwrap.json lib/package.json
	cd lib && npm install

test_byte: build
	./parser_tests.byte -jsparser ${JS_PARSER_JAR}

test_json: build lib/node_modules
	./parser_tests.byte -json -jsparser ${JS_PARSER_JSON}

test_native: native
	./parser_tests.native -jsparser ${JS_PARSER_JAR}

test_json_native: native lib/node_modules
	./parser_tests.native -json -jsparser ${JS_PARSER_JSON}

test_all: test test_native test_json_native
test: test_byte test_json

.PHONY: all build native build_cma clean
.PHONY: test test_all test_byte test_native test_json test_json_native
.PRECIOUS: _build/%.byte _build/%.native _build/%.cma
