JS_PARSER_JAR=./lib/js_parser.jar
FLAGS=-use-ocamlfind -verbose 1

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

test_byte: build
	./parser_tests.byte -jsparser ${JS_PARSER_JAR}

test_native: native
	./parser_tests.native -jsparser ${JS_PARSER_JAR}

test: test_byte test_native

.PHONY: all build native build_cma clean test_byte test_native test
.PRECIOUS: _build/%.byte _build/%.native _build/%.cma
