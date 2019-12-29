var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var callCount = (0.);
var valuesArray;
var expected = ([{status : "fulfilled"; value : "expectedValue"}]);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
valuesArray = values;
(checkSettledPromises)(values,expected,"values") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1OnFulfilled;
var p1 = ({then : function (onFulfilled,onRejected) 
{ p1OnFulfilled = onFulfilled;
(onFulfilled)("expectedValue") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).allSettled).call)(Constructor,[p1]);
((assert).sameValue)(callCount,1.,"callCount after call to all()");
(checkSettledPromises)(valuesArray,expected,"valuesArray after call to all()");
(p1OnFulfilled)("unexpectedValue");
((assert).sameValue)(callCount,1.,"callCount after call to onFulfilled()");
(checkSettledPromises)(valuesArray,expected,"valuesArray after call to onFulfilled()")var callCount = (0.);
var valuesArray;
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
valuesArray = values;
(assert)(((Array).isArray)(values),"values is array");
((assert).sameValue)((values).length,1.,"values.length");
((assert).sameValue)((values)[0.],"expectedValue","values[0]") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1OnFulfilled;
var p1 = ({then : function (onFulfilled,onRejected) 
{ p1OnFulfilled = onFulfilled;
(onFulfilled)("expectedValue") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).all).call)(Constructor,[p1]);
((assert).sameValue)(callCount,1.,"callCount after call to all()");
((assert).sameValue)((valuesArray)[0.],"expectedValue","valuesArray after call to all()");
(p1OnFulfilled)("unexpectedValue");
((assert).sameValue)(callCount,1.,"callCount after call to onFulfilled()");
((assert).sameValue)((valuesArray)[0.],"expectedValue","valuesArray after call to onFulfilled()")var callCount = (0.);
var valuesArray;
var expected = ([{status : "fulfilled"; value : "expectedValue"}]);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
valuesArray = values;
(checkSettledPromises)(values,expected,"values") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1OnFulfilled;
var p1 = ({then : function (onFulfilled,onRejected) 
{ p1OnFulfilled = onFulfilled;
(onFulfilled)("expectedValue") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).allSettled).call)(Constructor,[p1]);
((assert).sameValue)(callCount,1.,"callCount after call to all()");
(checkSettledPromises)(valuesArray,expected,"valuesArray after call to all()");
(p1OnFulfilled)("unexpectedValue");
((assert).sameValue)(callCount,1.,"callCount after call to onFulfilled()");
(checkSettledPromises)(valuesArray,expected,"valuesArray after call to onFulfilled()")