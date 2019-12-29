var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var returnValue = (null);
var value = ({});
var lateCallCount = (0.);
var thenable = (new (Promise)(function (resolve) 
{ (resolve)() }
));
(thenable).then = function (resolve) 
{ (resolve)(value) }
;
var promise = (new (Promise)(function (resolve) 
{ returnValue = (resolve)(thenable) }
));
((assert).sameValue)(returnValue,undefined,""resolve" return value");
(thenable).then = function () 
{ lateCallCount += 1. }
;
((promise).then)(function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
if ((lateCallCount) > (0.)) {
{ ($DONE)("The `then` method should be executed synchronously.") }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)