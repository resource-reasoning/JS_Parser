var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]);
((((((Promise).allSettled)([])).then)(function () 
{ ((sequence).push)(2.) }
)).catch)($DONE);
((((((((Promise).resolve)()).then)(function () 
{ ((sequence).push)(3.) }
)).then)(function () 
{ ((sequence).push)(4.);
(checkSequence)(sequence,"Promises resolved in unexpected sequence") }
)).then)($DONE,$DONE);
((sequence).push)(1.)var sequence = ([]);
((((((Promise).allSettled)([])).then)(function () 
{ ((sequence).push)(2.) }
)).catch)($DONE);
((((((((Promise).resolve)()).then)(function () 
{ ((sequence).push)(3.) }
)).then)(function () 
{ ((sequence).push)(4.);
(checkSequence)(sequence,"Promises resolved in unexpected sequence") }
)).then)($DONE,$DONE);
((sequence).push)(1.)