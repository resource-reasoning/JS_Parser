var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var resolveFunction;
new (Promise)(function (resolve,reject) 
{ resolveFunction = resolve }
);
(assert)(((Object).isExtensible)(resolveFunction))