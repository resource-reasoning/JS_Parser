JS_PARSER_JAR=./lib/js_parser.jar

PACKAGES=xml-light,oUnit,yojson

LIBS=nums,str,bigarray

build: 
	ocamlbuild -use-ocamlfind -pkgs ${PACKAGES} \
	-libs ${LIBS} \
	-Is src,test \
	test/parser_tests.byte
	
native:
	ocamlbuild -use-ocamlfind -pkgs ${PACKAGES} \
	-libs ${LIBS} \
	-Is src,test \
	test/parser_tests.native

build_cma: 
	ocamlbuild -use-ocamlfind -pkgs ${PACKAGES} \
	-libs ${LIBS} \
	-Is src \
	src/parser_main.cma

clean:
	ocamlbuild -clean

test: build
	./parser_tests.byte -jsparser ${JS_PARSER_JAR}

test_native: native
	./parser_tests.native -jsparser ${JS_PARSER_JAR}

.PHONY: build native build_cma clean test test_native
