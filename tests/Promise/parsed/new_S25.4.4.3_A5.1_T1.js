var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (((Promise).race)([]));
((((p).then)(function () 
{ ($ERROR)("Never settles.") }
,function () 
{ ($ERROR)("Never settles.") }
)).then)($DONE,$DONE);
((((((((Promise).resolve)()).then)()).then)()).then)($DONE,$DONE)var p = (((Promise).race)([]));
((((p).then)(function () 
{ ($ERROR)("Never settles.") }
,function () 
{ ($ERROR)("Never settles.") }
)).then)($DONE,$DONE);
((((((((Promise).resolve)()).then)()).then)()).then)($DONE,$DONE)