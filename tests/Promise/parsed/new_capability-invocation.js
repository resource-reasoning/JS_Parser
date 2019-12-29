var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var expectedThis = ((function () 
{ return this }
)());
var resolveCount = (0.);
var thisValue, args;
var P = (function (executor) 
{ return new (Promise)(function () 
{ (executor)(function () 
{ resolveCount += 1. }
,function () 
{ thisValue = this;
args = arguments }
) }
) }
);
(((Promise).reject).call)(P,24601.);
((assert).sameValue)(resolveCount,0.);
((assert).sameValue)(thisValue,expectedThis);
((assert).sameValue)(typeof args,"object");
((assert).sameValue)((args).length,1.);
((assert).sameValue)((args)[0.],24601.)