var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolve;
var thenable = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
var p1 = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p2;
p2 = ((p1).then)(function () 
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
);
(resolve)()var resolve;
var thenable = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
var p1 = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p2;
p2 = ((p1).then)(function () 
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
);
(resolve)()