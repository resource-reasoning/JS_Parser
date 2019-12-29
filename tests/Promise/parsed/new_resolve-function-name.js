var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolveFunction;
new (Promise)(function (resolve,reject) 
{ resolveFunction = resolve }
);
(verifyProperty)(resolveFunction,"name",{value : ""; writable : false; enumerable : false; configurable : true})