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
((assert).sameValue)(((((Object).prototype).hasOwnProperty).call)(executorFunction,"prototype"),false);
((assert).sameValue)((isConstructor)(executorFunction),false)