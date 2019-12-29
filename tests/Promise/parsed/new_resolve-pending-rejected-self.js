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
{ return p2 }
);
((p2).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (reason) 
{ if (! reason) {
{ ($DONE)("The promise should be rejected with a value.");
return }
};
if (((reason).constructor) !== (TypeError)) {
{ ($DONE)("The promise should be rejected with a TypeError instance.");
return }
};
($DONE)() }
);
(reject)()var reject;
var p1 = (new (Promise)(function (_,_reject) 
{ reject = _reject }
));
var p2;
p2 = ((p1).then)(function () 
{  }
,function () 
{ return p2 }
);
((p2).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (reason) 
{ if (! reason) {
{ ($DONE)("The promise should be rejected with a value.");
return }
};
if (((reason).constructor) !== (TypeError)) {
{ ($DONE)("The promise should be rejected with a TypeError instance.");
return }
};
($DONE)() }
);
(reject)()