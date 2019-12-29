var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]), pReject, p = (new (Promise)(function (resolve,reject) 
{ pReject = reject }
));
((sequence).push)(1.);
(pReject)();
((((p).then)(function () 
{ ($ERROR)("Should not be called -- Promise rejected.") }
,function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"Should be first") }
)).catch)($DONE);
((((((Promise).resolve)()).then)(function () 
{ ((((p).then)(function () 
{ ($ERROR)("Should not be called (2) -- Promise rejected.") }
,function () 
{ ((sequence).push)(5.);
(checkSequence)(sequence,"Should be third") }
)).then)($DONE,$DONE);
((sequence).push)(4.);
(checkSequence)(sequence,"Should be second") }
)).catch)($DONE);
((sequence).push)(2.)var sequence = ([]), pReject, p = (new (Promise)(function (resolve,reject) 
{ pReject = reject }
));
((sequence).push)(1.);
(pReject)();
((((p).then)(function () 
{ ($ERROR)("Should not be called -- Promise rejected.") }
,function () 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"Should be first") }
)).catch)($DONE);
((((((Promise).resolve)()).then)(function () 
{ ((((p).then)(function () 
{ ($ERROR)("Should not be called (2) -- Promise rejected.") }
,function () 
{ ((sequence).push)(5.);
(checkSequence)(sequence,"Should be third") }
)).then)($DONE,$DONE);
((sequence).push)(4.);
(checkSequence)(sequence,"Should be second") }
)).catch)($DONE);
((sequence).push)(2.)