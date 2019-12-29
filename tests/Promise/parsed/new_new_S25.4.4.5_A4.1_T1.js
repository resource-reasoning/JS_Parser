var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolveP, p = (new (Promise)(function (resolve) 
{ resolveP = resolve }
));
(resolveP)(p);
((((p).then)(function () 
{ ($ERROR)("Should not fulfill: should reject with TypeError.") }
,function (err) 
{ if ((! err) instanceof (TypeError)) {
{ { ($ERROR)(("Expected TypeError, got ") + (err)) } }
} }
)).then)($DONE,$DONE)