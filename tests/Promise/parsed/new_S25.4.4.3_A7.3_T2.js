var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolveP1, rejectP2, p1 = (new (Promise)(function (resolve) 
{ resolveP1 = resolve }
)), p2 = (new (Promise)(function (resolve,reject) 
{ rejectP2 = reject }
));
((((((Promise).race)([p1, p2])).then)(function () 
{ ($ERROR)("Should not be fulfilled: expected rejection.") }
,function (arg) 
{ if ((arg) !== (2.)) {
{ ($ERROR)(("Expected rejection reason to be 2, got ") + (arg)) }
} }
)).then)($DONE,$DONE);
(rejectP2)(2.);
(resolveP1)(1.)var resolveP1, rejectP2, p1 = (new (Promise)(function (resolve) 
{ resolveP1 = resolve }
)), p2 = (new (Promise)(function (resolve,reject) 
{ rejectP2 = reject }
));
((((((Promise).race)([p1, p2])).then)(function () 
{ ($ERROR)("Should not be fulfilled: expected rejection.") }
,function (arg) 
{ if ((arg) !== (2.)) {
{ ($ERROR)(("Expected rejection reason to be 2, got ") + (arg)) }
} }
)).then)($DONE,$DONE);
(rejectP2)(2.);
(resolveP1)(1.)