var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var arg = ([]);
((((((Promise).allSettled)([])).then)(function (result) 
{ (assert)(((Array).isArray)(result));
((assert).sameValue)(((Object).getPrototypeOf)(result),(Array).prototype);
((assert).notSameValue)(result,arg,"the resolved array is a new array") }
)).then)($DONE,$DONE)var arg = ([]);
((((((Promise).allSettled)([])).then)(function (result) 
{ (assert)(((Array).isArray)(result));
((assert).sameValue)(((Object).getPrototypeOf)(result),(Array).prototype);
((assert).notSameValue)(result,arg,"the resolved array is a new array") }
)).then)($DONE,$DONE)