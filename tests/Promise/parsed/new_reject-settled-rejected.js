var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thenable = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p1 = (new (Promise)(function (_,reject) 
{ (reject)() }
));
var p2;
p2 = ((p1).then)(function () 
{  }
,function () 
{ throw thenable }
);
((p2).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (x) 
{ if ((x) !== (thenable)) {
{ ($DONE)("The promise should be rejected with the resolution value of the provided promise.");
return }
};
($DONE)() }
)var thenable = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p1 = (new (Promise)(function (_,reject) 
{ (reject)() }
));
var p2;
p2 = ((p1).then)(function () 
{  }
,function () 
{ throw thenable }
);
((p2).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (x) 
{ if ((x) !== (thenable)) {
{ ($DONE)("The promise should be rejected with the resolution value of the provided promise.");
return }
};
($DONE)() }
)