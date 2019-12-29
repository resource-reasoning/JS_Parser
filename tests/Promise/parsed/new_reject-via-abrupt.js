var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thenable = (new (Promise)(function () 
{  }
));
var p = (new (Promise)(function () 
{ throw thenable }
));
((p).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (x) 
{ if ((x) !== (thenable)) {
{ ($DONE)("The promise should be rejected with the resolution value.");
return }
};
($DONE)() }
)