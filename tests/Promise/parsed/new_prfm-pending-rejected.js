var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var reject;
var p = (new (Promise)(function (_,_reject) 
{ reject = _reject }
));
((p).then)(function () 
{ ($DONE)("The `onFulfilled` handler should not be invoked.") }
,function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onRejected` handler should be invoked with the promise result.");
return }
};
($DONE)() }
);
(reject)(value)var value = ({});
var reject;
var p = (new (Promise)(function (_,_reject) 
{ reject = _reject }
));
((p).then)(function () 
{ ($DONE)("The `onFulfilled` handler should not be invoked.") }
,function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onRejected` handler should be invoked with the promise result.");
return }
};
($DONE)() }
);
(reject)(value)