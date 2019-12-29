var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var callCount = (0.);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
(checkSettledPromises)(values,[{status : "fulfilled"; value : "p1-fulfill"}, {status : "fulfilled"; value : "p2-fulfill"}, {status : "fulfilled"; value : "p3-fulfill"}],"values") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1OnFulfilled;
var p1 = ({then : function (onFulfilled,onRejected) 
{ p1OnFulfilled = onFulfilled }
});
var p2 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("p2-fulfill");
(onFulfilled)("p2-fulfill-unexpected") }
});
var p3 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("p3-fulfill") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).allSettled).call)(Constructor,[p1, p2, p3]);
((assert).sameValue)(callCount,0.,"callCount after call to all()");
(p1OnFulfilled)("p1-fulfill");
((assert).sameValue)(callCount,1.,"callCount after resolving p1")var callCount = (0.);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
(assert)(((Array).isArray)(values),"values is array");
((assert).sameValue)((values).length,3.,"values length");
((assert).sameValue)((values)[0.],"p1-fulfill","values[0]");
((assert).sameValue)((values)[1.],"p2-fulfill","values[1]");
((assert).sameValue)((values)[2.],"p3-fulfill","values[2]") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1OnFulfilled;
var p1 = ({then : function (onFulfilled,onRejected) 
{ p1OnFulfilled = onFulfilled }
});
var p2 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("p2-fulfill");
(onFulfilled)("p2-fulfill-unexpected") }
});
var p3 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("p3-fulfill") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).all).call)(Constructor,[p1, p2, p3]);
((assert).sameValue)(callCount,0.,"callCount after call to all()");
(p1OnFulfilled)("p1-fulfill");
((assert).sameValue)(callCount,1.,"callCount after resolving p1")var callCount = (0.);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
(checkSettledPromises)(values,[{status : "fulfilled"; value : "p1-fulfill"}, {status : "fulfilled"; value : "p2-fulfill"}, {status : "fulfilled"; value : "p3-fulfill"}],"values") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1OnFulfilled;
var p1 = ({then : function (onFulfilled,onRejected) 
{ p1OnFulfilled = onFulfilled }
});
var p2 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("p2-fulfill");
(onFulfilled)("p2-fulfill-unexpected") }
});
var p3 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("p3-fulfill") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).allSettled).call)(Constructor,[p1, p2, p3]);
((assert).sameValue)(callCount,0.,"callCount after call to all()");
(p1OnFulfilled)("p1-fulfill");
((assert).sameValue)(callCount,1.,"callCount after resolving p1")