var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolveElementFunction;
var thenable = ({then : function (fulfill) 
{ resolveElementFunction = fulfill }
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
(verifyProperty)(resolveElementFunction,"name",{value : ""; writable : false; enumerable : false; configurable : true})var resolveElementFunction;
var thenable = ({then : function (fulfill) 
{ resolveElementFunction = fulfill }
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
(((Promise).all).call)(NotPromise,[thenable]);
(verifyProperty)(resolveElementFunction,"name",{value : ""; writable : false; enumerable : false; configurable : true})var resolveElementFunction;
var thenable = ({then : function (fulfill) 
{ resolveElementFunction = fulfill }
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
(verifyProperty)(resolveElementFunction,"name",{value : ""; writable : false; enumerable : false; configurable : true})