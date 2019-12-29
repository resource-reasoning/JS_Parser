var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolveP1, rejectP2, p1, p2, sequence = ([]);
p1 = new (Promise)(function (resolve,reject) 
{ resolveP1 = resolve }
);
p2 = new (Promise)(function (resolve,reject) 
{ rejectP2 = reject }
);
(rejectP2)(3.);
(resolveP1)(2.);
((((Promise).resolve)()).then)(function () 
{ ((p1).then)(function (msg) 
{ ((sequence).push)(msg) }
);
((((((p2).catch)(function (msg) 
{ ((sequence).push)(msg) }
)).then)(function () 
{ (checkSequence)(sequence,"Expected 1,2,3") }
)).then)($DONE,$DONE) }
);
((sequence).push)(1.)var resolveP1, rejectP2, p1, p2, sequence = ([]);
p1 = new (Promise)(function (resolve,reject) 
{ resolveP1 = resolve }
);
p2 = new (Promise)(function (resolve,reject) 
{ rejectP2 = reject }
);
(rejectP2)(3.);
(resolveP1)(2.);
((((Promise).resolve)()).then)(function () 
{ ((p1).then)(function (msg) 
{ ((sequence).push)(msg) }
);
((((((p2).catch)(function (msg) 
{ ((sequence).push)(msg) }
)).then)(function () 
{ (checkSequence)(sequence,"Expected 1,2,3") }
)).then)($DONE,$DONE) }
);
((sequence).push)(1.)