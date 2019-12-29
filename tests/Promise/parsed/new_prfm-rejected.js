var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var p = (new (Promise)(function (_,reject) 
{ (reject)(value) }
));
((p).then)(function () 
{ ($DONE)("The `onFulfilled` handler should not be invoked.") }
,function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onRejected` handler should be invoked with the promise result.");
return }
};
($DONE)() }
)var value = ({});
var p = (new (Promise)(function (_,reject) 
{ (reject)(value) }
));
((p).then)(function () 
{ ($DONE)("The `onFulfilled` handler should not be invoked.") }
,function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onRejected` handler should be invoked with the promise result.");
return }
};
($DONE)() }
)