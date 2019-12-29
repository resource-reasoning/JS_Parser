var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var resolve;
var thenable = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p1 = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
var p2;
(thenable).then = function (resolve) 
{ (resolve)(value) }
;
p2 = ((p1).then)(function () 
{ return thenable }
);
((p2).then)(function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The promise should be fulfilled with the resolution value of the provided promise.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
);
(resolve)()var value = ({});
var resolve;
var thenable = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p1 = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
var p2;
(thenable).then = function (resolve) 
{ (resolve)(value) }
;
p2 = ((p1).then)(function () 
{ return thenable }
);
((p2).then)(function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The promise should be fulfilled with the resolution value of the provided promise.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
);
(resolve)()