var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var returnValue = (null);
var value = ({});
var resolve;
var thenable = (new (Promise)(function (resolve) 
{ (resolve)(value) }
));
var promise = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
((promise).then)(function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
);
returnValue = (resolve)(thenable);
((assert).sameValue)(returnValue,undefined,""resolve" return value")