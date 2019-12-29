var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var nonIterable = (3.);
((((((Promise).all)(nonIterable)).then)(function () 
{ ($ERROR)("Promise unexpectedly resolved: Promise.all(nonIterable) should throw TypeError") }
,function (err) 
{ if (! (err) instanceof (TypeError)) {
{ ($ERROR)(("Expected TypeError, got ") + (err)) }
} }
)).then)($DONE,$DONE)