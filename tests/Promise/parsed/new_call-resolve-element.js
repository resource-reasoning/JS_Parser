var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var callCount = (0.);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
(checkSettledPromises)(values,[{status : "fulfilled"; value : "expectedValue"}],"values") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("expectedValue");
(onFulfilled)("unexpectedValue") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).allSettled).call)(Constructor,[p1]);
((assert).sameValue)(callCount,1.,"callCount after call to all()")var callCount = (0.);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
(assert)(((Array).isArray)(values),"values is array");
((assert).sameValue)((values).length,1.,"values length");
((assert).sameValue)((values)[0.],"expectedValue","values[0]") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("expectedValue");
(onFulfilled)("unexpectedValue") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).all).call)(Constructor,[p1]);
((assert).sameValue)(callCount,1.,"callCount after call to all()")var callCount = (0.);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
(checkSettledPromises)(values,[{status : "fulfilled"; value : "expectedValue"}],"values") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("expectedValue");
(onFulfilled)("unexpectedValue") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).allSettled).call)(Constructor,[p1]);
((assert).sameValue)(callCount,1.,"callCount after call to all()")