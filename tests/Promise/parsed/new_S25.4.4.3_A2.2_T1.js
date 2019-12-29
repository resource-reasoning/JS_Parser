var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var nonIterable = (3.);
((((((Promise).race)(nonIterable)).then)(function () 
{ ($ERROR)("Promise unexpectedly fulfilled: Promise.race(nonIterable) should throw TypeError") }
,function (err) 
{ if (! (err) instanceof (TypeError)) {
{ ($ERROR)(("Expected TypeError, got ") + (err)) }
} }
)).then)($DONE,$DONE)var nonIterable = (3.);
((((((Promise).race)(nonIterable)).then)(function () 
{ ($ERROR)("Promise unexpectedly fulfilled: Promise.race(nonIterable) should throw TypeError") }
,function (err) 
{ if (! (err) instanceof (TypeError)) {
{ ($ERROR)(("Expected TypeError, got ") + (err)) }
} }
)).then)($DONE,$DONE)