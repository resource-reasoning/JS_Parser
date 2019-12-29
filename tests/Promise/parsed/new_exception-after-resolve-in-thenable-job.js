var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thenable = ({then : function (resolve) 
{ (resolve)() }
});
var thenableWithError = ({then : function (resolve) 
{ (resolve)(thenable);
throw new (Error)("ignored exception") }
});
function executor(resolve,reject) 
{ (resolve)(thenableWithError) }
;
((new (Promise)(executor)).then)($DONE,$DONE)