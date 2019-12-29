var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]);
var obj = ({});
var p = (((Promise).resolve)(obj));
((((((((p).finally)(function () 
{ ((sequence).push)(1.);
((assert).sameValue)((arguments).length,0.,"onFinally receives zero args");
return {} }
)).then)(function (x) 
{ ((sequence).push)(2.);
((assert).sameValue)(x,obj,"onFinally can not override the resolution value") }
)).then)(function () 
{ (checkSequence)(sequence,"All expected callbacks called in correct order");
($DONE)() }
)).catch)($ERROR)var sequence = ([]);
var obj = ({});
var p = (((Promise).resolve)(obj));
((((((((p).finally)(function () 
{ ((sequence).push)(1.);
((assert).sameValue)((arguments).length,0.,"onFinally receives zero args");
return {} }
)).then)(function (x) 
{ ((sequence).push)(2.);
((assert).sameValue)(x,obj,"onFinally can not override the resolution value") }
)).then)(function () 
{ (checkSequence)(sequence,"All expected callbacks called in correct order");
($DONE)() }
)).catch)($ERROR)