var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var p = (new (Promise)(function (resolve) 
{ (resolve)(value) }
));
((p).then)(function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onFulfilled` handler should be invoked with the promise result.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The `onRejected` handler should not be invoked.") }
)var value = ({});
var p = (new (Promise)(function (resolve) 
{ (resolve)(value) }
));
((p).then)(function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onFulfilled` handler should be invoked with the promise result.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The `onRejected` handler should not be invoked.") }
)