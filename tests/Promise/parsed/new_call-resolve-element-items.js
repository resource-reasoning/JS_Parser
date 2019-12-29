var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var callCount = (0.);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
(checkSettledPromises)(values,[{status : "fulfilled"; value : "expectedValue-p1"}, {status : "fulfilled"; value : "expectedValue-p2"}],"values") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("expectedValue-p1");
(onFulfilled)("unexpectedValue-p1") }
});
var p2 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("expectedValue-p2");
(onFulfilled)("unexpectedValue-p2") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).allSettled).call)(Constructor,[p1, p2]);
((assert).sameValue)(callCount,1.,"callCount after call to all()")var callCount = (0.);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
(assert)(((Array).isArray)(values),"values is array");
((assert).sameValue)((values).length,2.,"values length");
((assert).sameValue)((values)[0.],"expectedValue-p1","values[0]");
((assert).sameValue)((values)[1.],"expectedValue-p2","values[1]") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("expectedValue-p1");
(onFulfilled)("unexpectedValue-p1") }
});
var p2 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("expectedValue-p2");
(onFulfilled)("unexpectedValue-p2") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).all).call)(Constructor,[p1, p2]);
((assert).sameValue)(callCount,1.,"callCount after call to all()")var callCount = (0.);
function Constructor(executor) 
{ function resolve(values) 
{ callCount += 1.;
(checkSettledPromises)(values,[{status : "fulfilled"; value : "expectedValue-p1"}, {status : "fulfilled"; value : "expectedValue-p2"}],"values") }
;
(executor)(resolve,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var p1 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("expectedValue-p1");
(onFulfilled)("unexpectedValue-p1") }
});
var p2 = ({then : function (onFulfilled,onRejected) 
{ (onFulfilled)("expectedValue-p2");
(onFulfilled)("unexpectedValue-p2") }
});
((assert).sameValue)(callCount,0.,"callCount before call to all()");
(((Promise).allSettled).call)(Constructor,[p1, p2]);
((assert).sameValue)(callCount,1.,"callCount after call to all()")