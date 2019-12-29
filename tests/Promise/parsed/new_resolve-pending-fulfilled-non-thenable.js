var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var nonThenable = ({then : null});
var resolve;
var p1 = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
var p2;
p2 = ((p1).then)(function () 
{ return nonThenable }
);
((p2).then)(function (value) 
{ if ((value) !== (nonThenable)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
);
(resolve)()var nonThenable = ({then : null});
var resolve;
var p1 = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
var p2;
p2 = ((p1).then)(function () 
{ return nonThenable }
);
((p2).then)(function (value) 
{ if ((value) !== (nonThenable)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
);
(resolve)()