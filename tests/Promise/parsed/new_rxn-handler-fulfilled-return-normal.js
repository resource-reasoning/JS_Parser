var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var p1 = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p2;
p2 = ((p1).then)(function () 
{ return value }
,function () 
{  }
);
((p2).then)(function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onFulfilled` handler should be invoked with the promise result.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The `onRejected` handler should not be invoked.") }
)var value = ({});
var p1 = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p2;
p2 = ((p1).then)(function () 
{ return value }
,function () 
{  }
);
((p2).then)(function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onFulfilled` handler should be invoked with the promise result.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The `onRejected` handler should not be invoked.") }
)