var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

((((((Promise).all)(new (Error)("abrupt"))).then)(function () 
{ ($ERROR)("Promise unexpectedly resolved: Promise.all(abruptCompletion) should throw TypeError") }
,function (err) 
{ if (! (err) instanceof (TypeError)) {
{ ($ERROR)(("Expected TypeError, got ") + (err)) }
} }
)).then)($DONE,$DONE)