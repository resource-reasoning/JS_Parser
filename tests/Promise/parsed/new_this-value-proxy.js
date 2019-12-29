var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var called = (false);
var p = (new (Proxy)(((Promise).resolve)(),{}));
var oldThen = (((Promise).prototype).then);
((Promise).prototype).then = function () 
{ called = true }
;
((((Promise).prototype).finally).call)(p);
((assert).sameValue)(called,true);
((Promise).prototype).then = oldThenvar called = (false);
var p = (new (Proxy)(((Promise).resolve)(),{}));
var oldThen = (((Promise).prototype).then);
((Promise).prototype).then = function () 
{ called = true }
;
((((Promise).prototype).finally).call)(p);
((assert).sameValue)(called,true);
((Promise).prototype).then = oldThen