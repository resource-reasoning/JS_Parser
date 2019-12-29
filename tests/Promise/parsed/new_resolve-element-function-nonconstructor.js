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
((assert).sameValue)(((((Object).prototype).hasOwnProperty).call)(resolveElementFunction,"prototype"),false);
((assert).throws)(TypeError,function () 
{ new (resolveElementFunction)() }
)var resolveElementFunction;
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
((assert).sameValue)(((((Object).prototype).hasOwnProperty).call)(resolveElementFunction,"prototype"),false);
((assert).throws)(TypeError,function () 
{ new (resolveElementFunction)() }
)var resolveElementFunction;
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
((assert).sameValue)(((((Object).prototype).hasOwnProperty).call)(resolveElementFunction,"prototype"),false);
((assert).throws)(TypeError,function () 
{ new (resolveElementFunction)() }
)