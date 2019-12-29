var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]), pResolve, p = (new (Promise)(function (resolve,reject) 
{ pResolve = resolve }
));
((sequence).push)(1.);
((((p).then)(function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"Should be second") }
)).catch)($DONE);
((((((Promise).resolve)()).then)(function () 
{ ((((p).then)(function () 
{ ((sequence).push)(4.);
(checkSequence)(sequence,"Should be third") }
)).then)($DONE,$DONE);
((sequence).push)(2.);
(checkSequence)(sequence,"Should be first");
(pResolve)() }
)).catch)($DONE)var sequence = ([]), pResolve, p = (new (Promise)(function (resolve,reject) 
{ pResolve = resolve }
));
((sequence).push)(1.);
((((p).then)(function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"Should be second") }
)).catch)($DONE);
((((((Promise).resolve)()).then)(function () 
{ ((((p).then)(function () 
{ ((sequence).push)(4.);
(checkSequence)(sequence,"Should be third") }
)).then)($DONE,$DONE);
((sequence).push)(2.);
(checkSequence)(sequence,"Should be first");
(pResolve)() }
)).catch)($DONE)