var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

((assert).sameValue)((((Promise).prototype).finally) instanceof (Function),true,"Expected Promise.prototype.finally to be instanceof Function");
((assert).sameValue)(typeof ((Promise).prototype).finally,"function","Expected Promise.prototype.finally to be a function")((assert).sameValue)((((Promise).prototype).finally) instanceof (Function),true,"Expected Promise.prototype.finally to be instanceof Function");
((assert).sameValue)(typeof ((Promise).prototype).finally,"function","Expected Promise.prototype.finally to be a function")