var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

function rejectFunction() 
{  }
;
function Constructor(executor) 
{ (executor)(rejectFunction,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var callCount1 = (0.), callCount2 = (0.);
var p1OnRejected;
var p1 = ({then : function (_,onRejected) 
{ callCount1 += 1.;
p1OnRejected = onRejected;
((assert).notSameValue)(onRejected,rejectFunction,"p1.then") }
});
var p2 = ({then : function (_,onRejected) 
{ callCount2 += 1.;
((assert).notSameValue)(onRejected,rejectFunction,"p2.then");
((assert).notSameValue)(onRejected,p1OnRejected,"p1.onRejected != p2.onRejected") }
});
(((Promise).allSettled).call)(Constructor,[p1, p2]);
((assert).sameValue)(callCount1,1.,"p1.then call count");
((assert).sameValue)(callCount2,1.,"p2.then call count")function rejectFunction() 
{  }
;
function Constructor(executor) 
{ (executor)(rejectFunction,$ERROR) }
;
(Constructor).resolve = function (v) 
{ return v }
;
var callCount1 = (0.), callCount2 = (0.);
var p1OnRejected;
var p1 = ({then : function (_,onRejected) 
{ callCount1 += 1.;
p1OnRejected = onRejected;
((assert).notSameValue)(onRejected,rejectFunction,"p1.then") }
});
var p2 = ({then : function (_,onRejected) 
{ callCount2 += 1.;
((assert).notSameValue)(onRejected,rejectFunction,"p2.then");
((assert).notSameValue)(onRejected,p1OnRejected,"p1.onRejected != p2.onRejected") }
});
(((Promise).allSettled).call)(Constructor,[p1, p2]);
((assert).sameValue)(callCount1,1.,"p1.then call count");
((assert).sameValue)(callCount2,1.,"p2.then call count")