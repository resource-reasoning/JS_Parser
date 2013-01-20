JS_PARSER_JAR=./lib/js_parser.jar

BUILD_FLAGS=-I,+site-lib/oUnit

LIBS=xml-light,unix,nums,str,bigarray,Ounit

build: 
	ocamlbuild -libs ${LIBS} \
	-cflags ${BUILD_FLAGS} \
	-lflags ${BUILD_FLAGS} \
	-Is src,test \
	test/parser_tests.byte
	
native:
	ocamlbuild -libs ${LIBS} \
	-cflags ${BUILD_FLAGS} \
	-lflags ${BUILD_FLAGS} \
	-Is src,test \
	test/parser_tests.native

build_cma: 
	ocamlbuild -libs ${LIBS} \
	-cflags ${BUILD_FLAGS} \
	-lflags ${BUILD_FLAGS} \
	-Is src \
	src/parser_main.cma

clean:
	ocamlbuild -clean

test: build
	./parser_tests.byte -jsparser ${JS_PARSER_JAR}

test_native: native
	./parser_tests.native -jsparser ${JS_PARSER_JAR}

