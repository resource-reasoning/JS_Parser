var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var obj = ({});
var p = (((((((Promise).reject)(obj)).then)()).then)(function () 
{ ($DONE)("Unexpected fulfillment - promise should reject.") }
,function (arg) 
{ if ((arg) !== (obj)) {
{ ($DONE)(("Expected reject reason to be obj, actually ") + (arg));
return }
};
($DONE)() }
))var obj = ({});
var p = (((((((Promise).reject)(obj)).then)()).then)(function () 
{ ($DONE)("Unexpected fulfillment - promise should reject.") }
,function (arg) 
{ if ((arg) !== (obj)) {
{ ($DONE)(("Expected reject reason to be obj, actually ") + (arg));
return }
};
($DONE)() }
))