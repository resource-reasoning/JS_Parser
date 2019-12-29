var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var arg = ([]);
((((((Promise).all)(arg)).then)(function (result) 
{ if (((result).length) !== (0.)) {
{ { ($ERROR)(("expected an empty array from Promise.all([]), got ") + (result)) } }
} }
)).then)($DONE,$DONE)