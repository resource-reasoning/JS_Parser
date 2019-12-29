var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thenable = ({then : function (onResolve,onReject) 
{ return (onResolve)("resolved") }
});
var p = (((Promise).resolve)(thenable));
((((p).then)(function (r) 
{ ((assert).sameValue)(r,"resolved") }
)).then)($DONE,$DONE)