var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]);
var thenable = ({then : function (onResolve,onReject) 
{ ((sequence).push)(3.);
(checkSequence)(sequence,"thenable.then called");
((assert).sameValue)(this,thenable,"thenable.then called with `thenable` as `this`");
return (onResolve)("resolved") }
});
((sequence).push)(1.);
(checkSequence)(sequence,"no async calls yet");
var p = (((Promise).resolve)(thenable));
((sequence).push)(2.);
(checkSequence)(sequence,"thenable.then queued but not yet called");
((((p).then)(function (r) 
{ ((sequence).push)(4.);
(checkSequence)(sequence,"all done");
((assert).sameValue)(r,"resolved") }
)).then)($DONE,$DONE)