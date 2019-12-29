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
(verifyProperty)(rejectElementFunction,"name",{value : ""; writable : false; enumerable : false; configurable : true})var rejectElementFunction;
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
(verifyProperty)(rejectElementFunction,"name",{value : ""; writable : false; enumerable : false; configurable : true})