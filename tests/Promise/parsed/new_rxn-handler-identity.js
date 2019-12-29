var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var obj = ({});
var p = (((((((Promise).resolve)(obj)).then)()).then)(function (arg) 
{ if ((arg) !== (obj)) {
{ ($DONE)(("Expected promise to be fulfilled with obj, actually ") + (arg));
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
))var obj = ({});
var p = (((((((Promise).resolve)(obj)).then)()).then)(function (arg) 
{ if ((arg) !== (obj)) {
{ ($DONE)(("Expected promise to be fulfilled with obj, actually ") + (arg));
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
))