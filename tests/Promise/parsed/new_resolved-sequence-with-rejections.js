var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]);
var p1 = (new (Promise)(function (_,reject) 
{ (reject)("foo") }
));
var p2 = (new (Promise)(function (_,reject) 
{ (reject)("bar") }
));
((sequence).push)(1.);
((((p1).catch)(function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"Expected to be called first.") }
)).catch)($DONE);
((((((Promise).allSettled)([p1, p2])).then)(function () 
{ ((sequence).push)(5.);
(checkSequence)(sequence,"Expected to be called third.") }
)).then)($DONE,$DONE);
((((p2).catch)(function () 
{ ((sequence).push)(4.);
(checkSequence)(sequence,"Expected to be called second.") }
)).catch)($DONE);
((sequence).push)(2.)var sequence = ([]);
var p1 = (new (Promise)(function (_,reject) 
{ (reject)("foo") }
));
var p2 = (new (Promise)(function (_,reject) 
{ (reject)("bar") }
));
((sequence).push)(1.);
((((p1).catch)(function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"Expected to be called first.") }
)).catch)($DONE);
((((((Promise).allSettled)([p1, p2])).then)(function () 
{ ((sequence).push)(5.);
(checkSequence)(sequence,"Expected to be called third.") }
)).then)($DONE,$DONE);
((((p2).catch)(function () 
{ ((sequence).push)(4.);
(checkSequence)(sequence,"Expected to be called second.") }
)).catch)($DONE);
((sequence).push)(2.)