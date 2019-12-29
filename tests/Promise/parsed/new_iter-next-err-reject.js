var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterNextValThrows = ({});
var error = (new (Test262Error)());
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ throw error }
} }
;
((((((Promise).allSettled)(iterNextValThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var iterNextValThrows = ({});
var error = (new (Test262Error)());
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ throw error }
} }
;
((((((Promise).allSettled)(iterNextValThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)