var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thenable = ({then : function (resolve) 
{ (resolve)() }
});
function executor(resolve,reject) 
{ (resolve)(thenable);
throw new (Error)("ignored exception") }
;
Skip;
((new (Promise)(executor)).then)($DONE,$DONE)