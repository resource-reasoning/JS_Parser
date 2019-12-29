var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolveFunction;
new (Promise)(function (resolve,reject) 
{ resolveFunction = resolve }
);
((assert).sameValue)((resolveFunction).length,1.);
(verifyNotEnumerable)(resolveFunction,"length");
(verifyNotWritable)(resolveFunction,"length");
(verifyConfigurable)(resolveFunction,"length")