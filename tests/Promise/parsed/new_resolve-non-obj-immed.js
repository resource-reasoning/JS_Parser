var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var returnValue = (null);
var promise = (new (Promise)(function (resolve) 
{ returnValue = (resolve)(45.) }
));
((assert).sameValue)(returnValue,undefined,""resolve" return value");
((promise).then)(function (value) 
{ if ((value) !== (45.)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)