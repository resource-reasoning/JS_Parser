FLAGS=-use-ocamlfind 

build: src/*
	ocamlbuild ${FLAGS} src/JS_Parser.cma src/JS_Parser.cmxa

build_test: src/* test/*
	ocamlbuild ${FLAGS} test/JSParserTests.byte test/JSParserTests.native

build_main: src/* 
	ocamlbuild ${FLAGS} JSParserConsole.byte JSParserConsole.native


init:
	opam pin -yn add JS_Parser .
	opam install -y JS_Parser --deps-only -t

install:
	opam install -y JS_Parser

clean:
	ocamlbuild ${FLAGS} -clean

doc:
	ocamlbuild ${FLAGS} src/JS_Parser.docdir/index.html

test: build_test
	./JSParserTests.native

.PHONY: build init install clean doc
.PHONY: test
