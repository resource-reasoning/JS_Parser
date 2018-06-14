FLAGS=-use-ocamlfind 

build: src/*
	ocamlbuild ${FLAGS} src/JS_Parser.cma src/JS_Parser.cmxa

build_test: src/* test/*
	ocamlbuild ${FLAGS} test/parser_tests.byte test/parser_tests.native

init:
	opam pin -yn add JS_Parser-runtime .
	opam pin -yn add JS_Parser .
	opam install -y JS_Parser --deps-only -t

install:
	opam install -y JS_Parser

clean:
	ocamlbuild ${FLAGS} -clean

doc:
	ocamlbuild ${FLAGS} src/JS_Parser.docdir/index.html

test: build_test
	./parser_tests.native

.PHONY: build init install clean doc
.PHONY: test
