var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thenable = (new (Promise)(function () 
{  }
));
var returnValue = (null);
var p = (new (Promise)(function (_,reject) 
{ returnValue = (reject)(thenable) }
));
((assert).sameValue)(returnValue,undefined,""reject" function return value");
((p).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (x) 
{ if ((x) !== (thenable)) {
{ ($DONE)("The promise should be rejected with the resolution value.");
return }
};
($DONE)() }
)