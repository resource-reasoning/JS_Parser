var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolveP1, p1 = (new (Promise)(function (resolve) 
{ resolveP1 = resolve }
)), p2 = (((Promise).resolve)(p1)), obj = ({});
if ((p1) !== (p2)) {
{ { ($ERROR)("Expected p1 === Promise.resolve(p1) because they have same constructor") } }
};
Skip;
((((p2).then)(function (arg) 
{ if ((arg) !== (obj)) {
{ { ($ERROR)(("Expected promise to be resolved with obj, actually ") + (arg)) } }
} }
)).then)($DONE,$DONE);
(resolveP1)(obj)