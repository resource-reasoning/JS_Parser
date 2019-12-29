var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolveFunction;
new (Promise)(function (resolve,reject) 
{ resolveFunction = resolve }
);
((assert).sameValue)(((((Object).prototype).hasOwnProperty).call)(resolveFunction,"prototype"),false);
((assert).throws)(TypeError,function () 
{ new (resolveFunction)() }
)