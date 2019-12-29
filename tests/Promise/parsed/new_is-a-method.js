var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (((Promise).resolve)(3.));
((assert).sameValue)((p).finally,((Promise).prototype).finally,"Expected the `finally` method on a Promise to be `Promise.prototype.finally`")var p = (((Promise).resolve)(3.));
((assert).sameValue)((p).finally,((Promise).prototype).finally,"Expected the `finally` method on a Promise to be `Promise.prototype.finally`")