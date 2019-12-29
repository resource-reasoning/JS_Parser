var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var obj = ({});
var p = (((Promise).resolve)(obj));
((((((p).catch)(function () 
{ ($ERROR)("Should not be called - promise is fulfilled") }
)).then)(function (arg) 
{ if ((arg) !== (obj)) {
{ ($ERROR)(("Expected promise to be fulfilled with obj, got ") + (arg)) }
} }
)).then)($DONE,$DONE)var obj = ({});
var p = (((Promise).resolve)(obj));
((((((p).catch)(function () 
{ ($ERROR)("Should not be called - promise is fulfilled") }
)).then)(function (arg) 
{ if ((arg) !== (obj)) {
{ ($ERROR)(("Expected promise to be fulfilled with obj, got ") + (arg)) }
} }
)).then)($DONE,$DONE)