var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]);
var original = ({});
var thrown = ({});
var p = (((Promise).reject)(original));
((((((((((p).finally)(function () 
{ ((sequence).push)(1.);
((assert).sameValue)((arguments).length,0.,"onFinally receives zero args");
throw thrown }
)).then)(function () 
{ ($ERROR)("promise is rejected; onFulfill should not be called") }
)).catch)(function (reason) 
{ ((sequence).push)(2.);
((assert).sameValue)(reason,thrown,"onFinally can override the rejection reason by throwing") }
)).then)(function () 
{ (checkSequence)(sequence,"All expected callbacks called in correct order");
($DONE)() }
)).catch)($ERROR)var sequence = ([]);
var original = ({});
var thrown = ({});
var p = (((Promise).reject)(original));
((((((((((p).finally)(function () 
{ ((sequence).push)(1.);
((assert).sameValue)((arguments).length,0.,"onFinally receives zero args");
throw thrown }
)).then)(function () 
{ ($ERROR)("promise is rejected; onFulfill should not be called") }
)).catch)(function (reason) 
{ ((sequence).push)(2.);
((assert).sameValue)(reason,thrown,"onFinally can override the rejection reason by throwing") }
)).then)(function () 
{ (checkSequence)(sequence,"All expected callbacks called in correct order");
($DONE)() }
)).catch)($ERROR)