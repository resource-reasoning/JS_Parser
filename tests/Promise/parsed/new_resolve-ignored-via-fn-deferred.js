var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var returnValue = (null);
var thenable = (new (Promise)(function () 
{  }
));
var resolve, reject;
var p = (new (Promise)(function (_resolve,_reject) 
{ resolve = _resolve;
reject = _reject }
));
((p).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function () 
{ ($DONE)() }
);
(reject)(thenable);
returnValue = (resolve)();
((assert).sameValue)(returnValue,undefined,""resolve" function return value")