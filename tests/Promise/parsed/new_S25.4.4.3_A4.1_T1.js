var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterThrows = ({});
var error = (new (Test262Error)());
(iterThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ throw error }
} }
;
((((((Promise).race)(iterThrows)).then)(function () 
{ ($ERROR)("Promise unexpectedly fulfilled: Promise.race(iterThrows) should throw TypeError") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var iterThrows = ({});
var error = (new (Test262Error)());
(iterThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ throw error }
} }
;
((((((Promise).race)(iterThrows)).then)(function () 
{ ($ERROR)("Promise unexpectedly fulfilled: Promise.race(iterThrows) should throw TypeError") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)