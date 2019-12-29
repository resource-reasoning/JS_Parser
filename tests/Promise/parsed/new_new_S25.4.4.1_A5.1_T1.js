var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterThrows = ({});
var error = (new (Test262Error)());
(iterThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ throw error }
} }
;
((((((Promise).all)(iterThrows)).then)(function () 
{ ($ERROR)("Promise unexpectedly resolved: Promise.all(iterThrows) should throw TypeError") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)