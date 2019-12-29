var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolve;
var p1 = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
var p2;
p2 = ((p1).then)(function () 
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
(resolve)()var resolve;
var p1 = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
var p2;
p2 = ((p1).then)(function () 
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
(resolve)()