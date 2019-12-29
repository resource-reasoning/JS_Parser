var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var obj = ({});
var p = (((Promise).reject)(obj));
((((((p).then)(undefined,undefined)).then)(function () 
{ ($ERROR)("Should not be called -- promise was rejected.") }
,function (arg) 
{ if ((arg) !== (obj)) {
{ ($ERROR)(("Expected resolution object to be passed through, got ") + (arg)) }
} }
)).then)($DONE,$DONE)var obj = ({});
var p = (((Promise).reject)(obj));
((((((p).then)(undefined,undefined)).then)(function () 
{ ($ERROR)("Should not be called -- promise was rejected.") }
,function (arg) 
{ if ((arg) !== (obj)) {
{ ($ERROR)(("Expected resolution object to be passed through, got ") + (arg)) }
} }
)).then)($DONE,$DONE)