var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var callCount = (0.);
var resolve, reject, argCount;
new (Promise)(function (a,b) 
{ resolve = a;
reject = b;
argCount = (arguments).length }
);
((assert).sameValue)(typeof resolve,"function","type of first argument");
((assert).sameValue)((resolve).length,1.,"length of first argument");
((assert).sameValue)(typeof reject,"function","type of second argument");
((assert).sameValue)((reject).length,1.,"length of second argument");
((assert).sameValue)(argCount,2.)