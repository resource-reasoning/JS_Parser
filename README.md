# JavaScript Parser
[![Build Status](https://travis-ci.org/resource-reasoning/JS_Parser.svg?branch=master)](https://travis-ci.org/resource-reasoning/JS_Parser)

This is a JavaScript Parser Wrapper for OCaml that uses swappable backends.

## Dependencies
It is recommended to use OPAM to install dependencies for this package
Execute the following line to install the development version of JS_Parser in opam:
```sh
opam pin add JS_Parser https://github.com/resource-reasoning/JS_Parser.git
```

Or, if you need to develop the parser, then clone the repository and then execute
this line from the repository directory:
```sh
opam pin add .
```

The current set of OCaml dependencies are maintained in the [opam](opam) file.

### Google Closure Parser Backend
The Google Closure parser backend additionally requires:

1. [Java](http://www.oracle.com/technetwork/java/index.html)

You can get this on Ubuntu with:
```shell
sudo apt-get install java7-jdk
```
### Esprima Backend
The Esprima backend uses a [forked version](https://github.com/resource-reasoning/esprima)
of Esprima, to find the version in use and a summary of the patches applied,
check that repository's commit log.

The Esprima parser backend additionally requires:
1. [NodeJS](https://nodejs.org/)

You can install this on Ubuntu/Debian based systems using:
```shell
sudo apt-get install node-legacy
```

It is important that the legacy package is installed as we depend on the NodeJS
executable being called `node`, another package got there first on Debian based
systems! :(

# Development Notes
To update the version of Esprima installed use `npm install --save esprima`, and check that
the relevant changes to package.json and npm-shrinkwrap.json are appropriate before
committing all changed/new files.
