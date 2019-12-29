var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var executorFunction;
function NotPromise(executor) 
{ executorFunction = executor;
(executor)(function () 
{  }
,function () 
{  }
) }
;
(((Promise).resolve).call)(NotPromise);
(verifyProperty)(executorFunction,"name",{value : ""; writable : false; enumerable : false; configurable : true})