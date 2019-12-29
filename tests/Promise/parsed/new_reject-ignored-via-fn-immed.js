var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var returnValue = (null);
var thenable = (new (Promise)(function () 
{  }
));
var p = (new (Promise)(function (resolve,reject) 
{ (resolve)();
returnValue = (reject)(thenable) }
));
((assert).sameValue)(returnValue,undefined,""reject" function return value");
((p).then)(function () 
{ ($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)