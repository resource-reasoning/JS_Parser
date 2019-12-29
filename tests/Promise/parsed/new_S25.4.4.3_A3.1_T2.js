var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

function BadPromiseConstructor(f) 
{ (f)(undefined,undefined) }
;
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(BadPromiseConstructor,[]) }
)function BadPromiseConstructor(f) 
{ (f)(undefined,undefined) }
;
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(BadPromiseConstructor,[]) }
)