var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]);
var p1 = (((Promise).resolve)(1.)), p2 = (((Promise).resolve)(2.)), p = (((Promise).race)([p1, p2]));
((sequence).push)(1.);
((((p).then)(function (arg) 
{ if ((arg) !== (1.)) {
{ ($ERROR)(("Expected promise to be fulfilled with 1, got ") + (arg)) }
};
((sequence).push)(4.);
(checkSequence)(sequence,"This happens second") }
)).catch)($DONE);
((((((((Promise).resolve)()).then)(function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"This happens first") }
)).then)(function () 
{ ((sequence).push)(5.);
(checkSequence)(sequence,"This happens third") }
)).then)($DONE,$DONE);
((sequence).push)(2.)var sequence = ([]);
var p1 = (((Promise).resolve)(1.)), p2 = (((Promise).resolve)(2.)), p = (((Promise).race)([p1, p2]));
((sequence).push)(1.);
((((p).then)(function (arg) 
{ if ((arg) !== (1.)) {
{ ($ERROR)(("Expected promise to be fulfilled with 1, got ") + (arg)) }
};
((sequence).push)(4.);
(checkSequence)(sequence,"This happens second") }
)).catch)($DONE);
((((((((Promise).resolve)()).then)(function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"This happens first") }
)).then)(function () 
{ ((sequence).push)(5.);
(checkSequence)(sequence,"This happens third") }
)).then)($DONE,$DONE);
((sequence).push)(2.)