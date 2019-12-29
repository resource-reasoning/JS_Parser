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
(verifyProperty)(resolveElementFunction,"length",{value : 1.; enumerable : false; writable : false; configurable : true})var resolveElementFunction;
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
((assert).sameValue)((resolveElementFunction).length,1.);
(verifyNotEnumerable)(resolveElementFunction,"length");
(verifyNotWritable)(resolveElementFunction,"length");
(verifyConfigurable)(resolveElementFunction,"length")var resolveElementFunction;
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
(verifyProperty)(resolveElementFunction,"length",{value : 1.; enumerable : false; writable : false; configurable : true})