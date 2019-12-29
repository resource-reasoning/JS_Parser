var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (((Promise).reject)(3.));
if ((! p) instanceof (Promise)) {
{ { ($ERROR)("Expected Promise.reject to return a promise.") } }
};
Skip;
((((p).then)(function () 
{ ($ERROR)("Promise should not be fulfilled.") }
,function (arg) 
{ if ((arg) !== (3.)) {
{ { ($ERROR)(("Expected promise to be rejected with supplied arg, got ") + (arg)) } }
} }
)).then)($DONE,$DONE)