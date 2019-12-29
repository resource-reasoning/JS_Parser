var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var rejectP2, p1 = (((Promise).resolve)(1.)), p2 = (new (Promise)(function (resolve,reject) 
{ rejectP2 = reject }
));
((((((Promise).all)([p1, p2])).then)(function () 
{ ($ERROR)("Did not expect promise to be fulfilled.") }
,function (rejected) 
{ if ((rejected) !== (2.)) {
{ { ($ERROR)(("Expected promise to be rejected with 2, actually ") + (rejected)) } }
} }
)).then)($DONE,$DONE);
(rejectP2)(2.)