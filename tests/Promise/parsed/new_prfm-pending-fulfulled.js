var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var resolve;
var p = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
((p).then)(function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onFulfilled` handler should be invoked with the promise result.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The `onRejected` handler should not be invoked.") }
);
(resolve)(value)var value = ({});
var resolve;
var p = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
((p).then)(function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The `onFulfilled` handler should be invoked with the promise result.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The `onRejected` handler should not be invoked.") }
);
(resolve)(value)