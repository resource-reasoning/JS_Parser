var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var reject;
var p1 = (new (Promise)(function (_,_reject) 
{ reject = _reject }
));
var p2;
p2 = ((p1).then)(function () 
{  }
,function () 
{ return 23. }
);
((p2).then)(function (value) 
{ if ((value) !== (23.)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
);
(reject)()var reject;
var p1 = (new (Promise)(function (_,_reject) 
{ reject = _reject }
));
var p2;
p2 = ((p1).then)(function () 
{  }
,function () 
{ return 23. }
);
((p2).then)(function (value) 
{ if ((value) !== (23.)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
);
(reject)()