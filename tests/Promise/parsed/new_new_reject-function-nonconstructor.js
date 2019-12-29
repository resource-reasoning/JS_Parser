var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var rejectFunction;
new (Promise)(function (resolve,reject) 
{ rejectFunction = reject }
);
((assert).sameValue)(((((Object).prototype).hasOwnProperty).call)(rejectFunction,"prototype"),false);
((assert).throws)(TypeError,function () 
{ new (rejectFunction)() }
)