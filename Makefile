JS_PARSER_JAR=./lib/js_parser.jar

BUILD_FLAGS=-I,$(shell ocamlfind query oUnit),-I,$(shell ocamlfind query xml-light, yojson)

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

test_json: build
	./parser_tests.byte -json -jsparser ${JS_PARSER_JAR}

test_native: native
	./parser_tests.native -jsparser ${JS_PARSER_JAR}

