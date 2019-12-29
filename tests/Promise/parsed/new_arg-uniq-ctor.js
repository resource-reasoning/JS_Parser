var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var promise1 = (new (Promise)(function () 
{  }
));
var promise2;
(promise1).constructor = null;
promise2 = ((Promise).resolve)(promise1);
((assert).sameValue)((promise1) === (promise2),false)