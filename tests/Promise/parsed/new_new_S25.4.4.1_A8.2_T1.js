var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var rejectP1, p1 = (new (Promise)(function (resolve,reject) 
{ rejectP1 = reject }
)), p2 = (((Promise).resolve)(2.));
((((((Promise).all)([p1, p2])).then)(function (resolve) 
{ ($ERROR)("Did not expect promise to be fulfilled.") }
,function (rejected) 
{ if ((rejected) !== (1.)) {
{ { ($ERROR)(("Expected promise to be rejected with 1, actually ") + (rejected)) } }
} }
)).then)($DONE,$DONE);
(rejectP1)(1.)