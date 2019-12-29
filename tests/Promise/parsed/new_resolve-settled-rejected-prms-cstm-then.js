var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var thenable = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p1 = (new (Promise)(function (_,reject) 
{ (reject)() }
));
var p2;
(thenable).then = function (resolve) 
{ (resolve)(value) }
;
p2 = ((p1).then)(function () 
{  }
,function () 
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
)var value = ({});
var thenable = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p1 = (new (Promise)(function (_,reject) 
{ (reject)() }
));
var p2;
(thenable).then = function (resolve) 
{ (resolve)(value) }
;
p2 = ((p1).then)(function () 
{  }
,function () 
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
)