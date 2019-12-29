var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var returnCount = (0.);
var iter = ({});
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {done : true} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
var P = (function (executor) 
{ return new (Promise)(function (_,reject) 
{ (executor)(function () 
{ throw new (Test262Error)() }
,reject) }
) }
);
(P).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).allSettled).call)(P,iter);
((assert).sameValue)(returnCount,0.)var nextCount = (0.);
var returnCount = (0.);
var iter = ({});
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ nextCount += 1.;
return {done : true} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
var P = (function (executor) 
{ return new (Promise)(function (_,reject) 
{ (executor)(function () 
{ throw new (Test262Error)() }
,reject) }
) }
);
(P).resolve = (Promise).resolve;
(((Promise).all).call)(P,iter);
((assert).sameValue)(nextCount,1.);
((assert).sameValue)(returnCount,0.)var returnCount = (0.);
var iter = ({});
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {done : true} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
var P = (function (executor) 
{ return new (Promise)(function (_,reject) 
{ (executor)(function () 
{ throw new (Test262Error)() }
,reject) }
) }
);
(P).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).allSettled).call)(P,iter);
((assert).sameValue)(returnCount,0.)