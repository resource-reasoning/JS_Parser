var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var rejectFunction;
new (Promise)(function (resolve,reject) 
{ rejectFunction = reject }
);
((assert).sameValue)((rejectFunction).length,1.);
(verifyNotEnumerable)(rejectFunction,"length");
(verifyNotWritable)(rejectFunction,"length");
(verifyConfigurable)(rejectFunction,"length")