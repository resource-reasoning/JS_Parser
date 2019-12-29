var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var rejectElementFunction;
var thenable = ({then : function (_,reject) 
{ rejectElementFunction = reject }
});
function NotPromise(executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
;
(NotPromise).resolve = function (v) 
{ return v }
;
(((Promise).allSettled).call)(NotPromise,[thenable]);
((assert).sameValue)((rejectElementFunction).length,1.);
(verifyProperty)(rejectElementFunction,"length",{value : 1.; enumerable : false; writable : false; configurable : true})var rejectElementFunction;
var thenable = ({then : function (_,reject) 
{ rejectElementFunction = reject }
});
function NotPromise(executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
;
(NotPromise).resolve = function (v) 
{ return v }
;
(((Promise).allSettled).call)(NotPromise,[thenable]);
((assert).sameValue)((rejectElementFunction).length,1.);
(verifyProperty)(rejectElementFunction,"length",{value : 1.; enumerable : false; writable : false; configurable : true})