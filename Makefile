JS_PARSER_JAR=./lib/js_parser.jar
JS_PARSER_JSON=./lib/run_esprima.js

BUILD_FLAGS=-I,$(shell ocamlfind query oUnit),-I,$(shell ocamlfind query xml-light, yojson)

PACKAGES=xml-light,oUnit,yojson,batteries

LIBS=nums,str,bigarray

build: 
	ocamlbuild -use-ocamlfind -pkgs ${PACKAGES} \
	-Is src,test \
	test/parser_tests.byte
native:
	ocamlbuild -use-ocamlfind -pkgs ${PACKAGES} \
	-Is src,test \
	test/parser_tests.native

build_cma: 
	ocamlbuild -use-ocamlfind -pkgs ${PACKAGES} \
	-Is src \
	src/parser_main.cma

clean:
	ocamlbuild -clean

lib/node_modules: lib/npm-shrinkwrap.json lib/package.json
	cd lib && npm install

test: build
	./parser_tests.byte -jsparser ${JS_PARSER_JAR}

test_json: build lib/node_modules
	./parser_tests.byte -json -jsparser ${JS_PARSER_JSON}

test_native: native
	./parser_tests.native -jsparser ${JS_PARSER_JAR}

