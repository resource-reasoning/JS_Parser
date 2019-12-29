var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var obj = ({});
var p = (((Promise).reject)(obj));
((((((p).then)(function () 
{ ($ERROR)("Should not be called: did not expect promise to be fulfilled") }
)).catch)(function (arg) 
{ if ((arg) !== (obj)) {
{ ($ERROR)(("Should have been rejected with reason obj, got ") + (arg)) }
} }
)).then)($DONE,$DONE)var obj = ({});
var p = (((Promise).reject)(obj));
((((((p).then)(function () 
{ ($ERROR)("Should not be called: did not expect promise to be fulfilled") }
)).catch)(function (arg) 
{ if ((arg) !== (obj)) {
{ ($ERROR)(("Should have been rejected with reason obj, got ") + (arg)) }
} }
)).then)($DONE,$DONE)