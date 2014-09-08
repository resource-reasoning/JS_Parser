JS_PARSER_JAR=./lib/js_parser.jar

JS_OF_OCAML_LOCATION=$(shell ocamlfind query js_of_ocaml)

PACKAGES=xml-light,oUnit,yojson

LIBS=nums,str,bigarray

NODE=node			# How to call node.js

build: 
	ocamlbuild -use-ocamlfind -pkgs ${PACKAGES} \
	-pp "camlp4o pa_macro.cmo -UTARGETJS" \
	-libs ${LIBS} \
	-Is src,test \
	test/parser_tests.byte

native:
	ocamlbuild -use-ocamlfind -pkgs ${PACKAGES} \
	-pp "camlp4o pa_macro.cmo -UTARGETJS" \
	-libs ${LIBS} \
	-Is src,test \
	test/parser_tests.native

build_cma: 
	ocamlbuild -use-ocamlfind -pkgs ${PACKAGES} \
	-pp "camlp4o pa_macro.cmo -UTARGETJS" \
	-libs ${LIBS} \
	-Is src \
	src/parser_main.cma

targetjs:
	ocamlbuild -use-ocamlfind -pkgs ${PACKAGES},js_of_ocaml \
	-pp "camlp4o ${JS_OF_OCAML_LOCATION}/pa_js.cmo pa_macro.cmo -DTARGETJS" \
	-libs ${LIBS} \
	-Is src,test \
	test/parser_tests.byte

test/parser_tests.js: targetjs
	js_of_ocaml +nat.js -opt 0 run_tests.js -o _build/test/parser_tests.js _build/test/parser_tests.byte

clean:
	ocamlbuild -clean

test: build
	./parser_tests.byte -jsparser ${JS_PARSER_JAR}

test_json: build
	./parser_tests.byte -json -jsparser ${JS_PARSER_JAR}

test_native: native
	./parser_tests.native -jsparser ${JS_PARSER_JAR}

test_js: test/parser_tests.js
	./run_node.sh _build/test/parser_tests.js


.PHONY: build native build_cma clean test test_native
