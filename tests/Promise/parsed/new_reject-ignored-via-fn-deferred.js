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
{ ($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
);
(resolve)();
returnValue = (reject)(thenable);
((assert).sameValue)(returnValue,undefined,""reject" function return value")