var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

((((((((Promise).race)(new (Error)("abrupt"))).then)(function () 
{ ($ERROR)("Promise unexpectedly resolved: Promise.race(abruptCompletion) should throw TypeError") }
,function (err) 
{ if ((! err) instanceof (TypeError)) {
{ { ($ERROR)(("Expected TypeError, got ") + (err)) } }
} }
)).then)($DONE,$DONE))((((((Promise).race)(new (Error)("abrupt"))).then)(function () 
{ ($ERROR)("Promise unexpectedly resolved: Promise.race(abruptCompletion) should throw TypeError") }
,function (err) 
{ if ((! err) instanceof (TypeError)) {
{ { ($ERROR)(("Expected TypeError, got ") + (err)) } }
} }
)).then))($DONE,$DONE)