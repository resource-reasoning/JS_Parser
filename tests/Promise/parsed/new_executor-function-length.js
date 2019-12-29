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
((assert).sameValue)((executorFunction).length,2.);
(verifyNotEnumerable)(executorFunction,"length");
(verifyNotWritable)(executorFunction,"length");
(verifyConfigurable)(executorFunction,"length")