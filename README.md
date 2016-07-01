# JavaScript Parser

This is a JavaScript Parser Wrapper for OCaml that uses swappable backends.

Prerequisites:

1. [ocaml 3.11 or higher]([http://caml.inria.fr/ocaml/index.en.html)
    You can get this in ubuntu with:

    `sudo apt-get install ocaml`

2. [the XML-light library](http://tech.motion-twin.com/xmllight)
    You can get this in ubuntu with:

    `sudo apt-get install libxml-light-ocaml-dev`

3. [ocaml batteries included](http://batteries.forge.ocamlcore.org/)
    You can get this in ubuntu with:

    `sudo apt-get install ocaml-batteries-included`

4. [The ocaml unit testing library OUnit](http://ounit.forge.ocamlcore.org/)
    You can get this in ubuntu with:

    `sudo apt-get install libounit-ocaml-dev`

5. [Java](http://www.oracle.com/technetwork/java/index.html )
    You can get this in ubuntu with:

    `sudo apt-get install java7-jdk`

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
