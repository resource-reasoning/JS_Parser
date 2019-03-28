# JavaScript Parser
[![Build Status](https://travis-ci.org/resource-reasoning/JS_Parser.svg?branch=master)](https://travis-ci.org/resource-reasoning/JS_Parser)

Javascript Parser, based on flow-parser, which adds support for JS_Logic from the JaVerT toolchain.

## Dependencies
OCaml >= 4.04 is required.
esy 0.5.6 is required

## Build Locally
```bash
npm install -g esy@0.5.6
esy
```

## Test
```bash
esy test
```

## Documentation
To build te documentation, execute :
```bash
esy build:doc
```

and then open the doc in `_esy/default/build/default/_doc/_html/index.html`

## Add JS_Parser as a dependency of an `esy` project

the `package.json` should contain
```json
"dependencies": {
  ...
  "JS_Parser": "*",
  ...
},
"resolutions": {
  "JS_Parser": "resource-reasoning/JS_Parser#COMMITHASH"
}
```

Where `COMMITHASH` is the commit you want to depend on.
It has to me a commit hash that is more recent than `702e11a`, otherewise the project does not yet support `esy`.

If not commit hash is added, it will simply depend on the current master branch. (See [esy documentation](https://esy.sh/docs/en/using-repo-sources-workflow.html) for more details.)