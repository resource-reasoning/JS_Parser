var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]);
var p1 = (new (Promise)(function (resolve) 
{ (resolve)({}) }
));
((sequence).push)(1.);
((((((Promise).allSettled)([p1])).then)(function (resolved) 
{ ((sequence).push)(4.);
(checkSequence)(sequence,"Expected Promise.allSettled().then to queue second") }
)).catch)($DONE);
((((((p1).then)(function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"Expected p1.then to queue first") }
)).then)(function () 
{ ((sequence).push)(5.);
(checkSequence)(sequence,"Expected final then to queue last") }
)).then)($DONE,$DONE);
((sequence).push)(2.)var sequence = ([]);
var p1 = (new (Promise)(function (resolve) 
{ (resolve)({}) }
));
((sequence).push)(1.);
((((((Promise).allSettled)([p1])).then)(function (resolved) 
{ ((sequence).push)(4.);
(checkSequence)(sequence,"Expected Promise.allSettled().then to queue second") }
)).catch)($DONE);
((((((p1).then)(function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"Expected p1.then to queue first") }
)).then)(function () 
{ ((sequence).push)(5.);
(checkSequence)(sequence,"Expected final then to queue last") }
)).then)($DONE,$DONE);
((sequence).push)(2.)