var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolveP1, rejectP2, sequence = ([]);
((((((new (Promise)(function (resolve,reject) 
{ resolveP1 = resolve }
)).then)(function (msg) 
{ ((sequence).push)(msg) }
)).then)(function () 
{ (checkSequence)(sequence,"Expected 1,2,3") }
)).then)($DONE,$DONE);
((new (Promise)(function (resolve,reject) 
{ rejectP2 = reject }
)).catch)(function (msg) 
{ ((sequence).push)(msg) }
);
(rejectP2)(2.);
(resolveP1)(3.);
((sequence).push)(1.)var resolveP1, rejectP2, sequence = ([]);
((((((new (Promise)(function (resolve,reject) 
{ resolveP1 = resolve }
)).then)(function (msg) 
{ ((sequence).push)(msg) }
)).then)(function () 
{ (checkSequence)(sequence,"Expected 1,2,3") }
)).then)($DONE,$DONE);
((new (Promise)(function (resolve,reject) 
{ rejectP2 = reject }
)).catch)(function (msg) 
{ ((sequence).push)(msg) }
);
(rejectP2)(2.);
(resolveP1)(3.);
((sequence).push)(1.)