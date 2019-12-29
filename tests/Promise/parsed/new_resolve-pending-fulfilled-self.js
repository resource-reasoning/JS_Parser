var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolve;
var p1 = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
var p2;
p2 = ((p1).then)(function () 
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
(resolve)()var resolve;
var p1 = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
var p2;
p2 = ((p1).then)(function () 
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
(resolve)()