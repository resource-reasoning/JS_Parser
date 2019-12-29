var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thenable = (new (Promise)(function () 
{  }
));
var p = (new (Promise)(function (resolve) 
{ (resolve)();
throw thenable }
));
((p).then)(function () 
{ ($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)