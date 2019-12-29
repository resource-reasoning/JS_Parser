var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var p1 = (new (Promise)(function (_,reject) 
{ (reject)() }
));
var p2;
p2 = ((p1).then)(function () 
{  }
,function () 
{ throw value }
);
((p2).then)(function () 
{ ($DONE)("The `onFulfilled` handler should not be invoked.") }
,function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onRejected` handler should be invoked with the promise result.");
return }
};
($DONE)() }
)var value = ({});
var p1 = (new (Promise)(function (_,reject) 
{ (reject)() }
));
var p2;
p2 = ((p1).then)(function () 
{  }
,function () 
{ throw value }
);
((p2).then)(function () 
{ ($DONE)("The `onFulfilled` handler should not be invoked.") }
,function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onRejected` handler should be invoked with the promise result.");
return }
};
($DONE)() }
)