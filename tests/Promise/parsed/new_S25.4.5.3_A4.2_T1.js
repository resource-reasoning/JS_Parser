var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var obj = ({});
var p = (((Promise).resolve)(obj));
((((((p).then)(3.,5.)).then)(function (arg) 
{ if ((arg) !== (obj)) {
{ ($ERROR)(("Expected resolution object to be passed through, got ") + (arg)) }
} }
)).then)($DONE,$DONE)var obj = ({});
var p = (((Promise).resolve)(obj));
((((((p).then)(3.,5.)).then)(function (arg) 
{ if ((arg) !== (obj)) {
{ ($ERROR)(("Expected resolution object to be passed through, got ") + (arg)) }
} }
)).then)($DONE,$DONE)