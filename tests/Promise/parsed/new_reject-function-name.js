var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var rejectFunction;
new (Promise)(function (resolve,reject) 
{ rejectFunction = reject }
);
(verifyProperty)(rejectFunction,"name",{value : ""; writable : false; enumerable : false; configurable : true})