var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]), pResolve, p = (new (Promise)(function (resolve,reject) 
{ pResolve = resolve }
));
((sequence).push)(1.);
(pResolve)();
((((p).then)(function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"Should be first") }
)).catch)($DONE);
((((((Promise).resolve)()).then)(function () 
{ ((((p).then)(function () 
{ ((sequence).push)(5.);
(checkSequence)(sequence,"Should be third") }
)).then)($DONE,$DONE);
((sequence).push)(4.);
(checkSequence)(sequence,"Should be second") }
)).catch)($DONE);
((sequence).push)(2.)var sequence = ([]), pResolve, p = (new (Promise)(function (resolve,reject) 
{ pResolve = resolve }
));
((sequence).push)(1.);
(pResolve)();
((((p).then)(function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"Should be first") }
)).catch)($DONE);
((((((Promise).resolve)()).then)(function () 
{ ((((p).then)(function () 
{ ((sequence).push)(5.);
(checkSequence)(sequence,"Should be third") }
)).then)($DONE,$DONE);
((sequence).push)(4.);
(checkSequence)(sequence,"Should be second") }
)).catch)($DONE);
((sequence).push)(2.)