JS_PARSER_JAR=./lib/js_parser.jar

PACKAGES=xml-light,oUnit,yojson

LIBS=nums,str,bigarray

NODE=node			# How to call node.js

OCAMLBUILD=ocamlbuild -verbose 1

build: 
	${OCAMLBUILD} -use-ocamlfind -pkgs ${PACKAGES} \
	-pp "camlp4of -UTARGETJS" \
	-libs ${LIBS} \
	-Is src,test \
	test/parser_tests.byte

native:
	${OCAMLBUILD} -use-ocamlfind -pkgs ${PACKAGES} \
	-pp "camlp4of -UTARGETJS" \
	-libs ${LIBS} \
	-Is src,test \
	test/parser_tests.native

build_cma: 
	${OCAMLBUILD} -use-ocamlfind -pkgs ${PACKAGES} \
	-pp "camlp4of -UTARGETJS" \
	-libs ${LIBS} \
	-Is src \
	src/parser_main.cma

targetjs:
	${OCAMLBUILD} -use-ocamlfind -pkgs ${PACKAGES},js_of_ocaml \
	-pp "camlp4of -DTARGETJS" \
	-libs ${LIBS} \
	-Is src,test \
	test/parser_tests.byte

test/parser_tests.js: targetjs
	js_of_ocaml +nat.js run_tests.js -o _build/test/parser_tests.js _build/test/parser_tests.byte

clean:
	${OCAMLBUILD} -clean

test: build
	./parser_tests.byte

test_json: build
	./parser_tests.byte -json -jsparser ${JS_PARSER_JAR}

test_native: native
	./parser_tests.native -jsparser ${JS_PARSER_JAR}

test_js: test/parser_tests.js
	./run_node.sh _build/test/parser_tests.js


.PHONY: build native build_cma clean test test_native
