var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

function resolveFunction() 
{  }
;
function Constructor(executor) 
{ (executor)(resolveFunction,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var callCount1 = (0.), callCount2 = (0.);
var p1OnFulfilled;
var p1 = ({then : function (onFulfilled,onRejected) 
{ callCount1 += 1.;
p1OnFulfilled = onFulfilled;
((assert).notSameValue)(onFulfilled,resolveFunction,"p1.then") }
});
var p2 = ({then : function (onFulfilled,onRejected) 
{ callCount2 += 1.;
((assert).notSameValue)(onFulfilled,resolveFunction,"p2.then");
((assert).notSameValue)(onFulfilled,p1OnFulfilled,"p1.onFulfilled != p2.onFulfilled") }
});
(((Promise).allSettled).call)(Constructor,[p1, p2]);
((assert).sameValue)(callCount1,1.,"p1.then call count");
((assert).sameValue)(callCount2,1.,"p2.then call count")function resolveFunction() 
{  }
;
function Constructor(executor) 
{ (executor)(resolveFunction,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var callCount1 = (0.), callCount2 = (0.);
var p1OnFulfilled;
var p1 = ({then : function (onFulfilled,onRejected) 
{ callCount1 += 1.;
p1OnFulfilled = onFulfilled;
((assert).notSameValue)(onFulfilled,resolveFunction,"p1.then") }
});
var p2 = ({then : function (onFulfilled,onRejected) 
{ callCount2 += 1.;
((assert).notSameValue)(onFulfilled,resolveFunction,"p2.then");
((assert).notSameValue)(onFulfilled,p1OnFulfilled,"p1.onFulfilled != p2.onFulfilled") }
});
(((Promise).all).call)(Constructor,[p1, p2]);
((assert).sameValue)(callCount1,1.,"p1.then call count");
((assert).sameValue)(callCount2,1.,"p2.then call count")function resolveFunction() 
{  }
;
function Constructor(executor) 
{ (executor)(resolveFunction,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var callCount1 = (0.), callCount2 = (0.);
var p1OnFulfilled;
var p1 = ({then : function (onFulfilled,onRejected) 
{ callCount1 += 1.;
p1OnFulfilled = onFulfilled;
((assert).notSameValue)(onFulfilled,resolveFunction,"p1.then") }
});
var p2 = ({then : function (onFulfilled,onRejected) 
{ callCount2 += 1.;
((assert).notSameValue)(onFulfilled,resolveFunction,"p2.then");
((assert).notSameValue)(onFulfilled,p1OnFulfilled,"p1.onFulfilled != p2.onFulfilled") }
});
(((Promise).allSettled).call)(Constructor,[p1, p2]);
((assert).sameValue)(callCount1,1.,"p1.then call count");
((assert).sameValue)(callCount2,1.,"p2.then call count")