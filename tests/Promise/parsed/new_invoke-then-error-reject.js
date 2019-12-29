var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var promise = (new (Promise)(function () 
{  }
));
var error = (new (Test262Error)());
(promise).then = function () 
{ throw error }
;
((((((Promise).allSettled)([promise])).then)(function () 
{ throw new (Test262Error)("The promise should be rejected") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var promise = (new (Promise)(function () 
{  }
));
var error = (new (Test262Error)());
(promise).then = function () 
{ throw error }
;
((((((Promise).race)([promise])).then)(function () 
{ ($ERROR)("The promise should be rejected") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var promise = (new (Promise)(function () 
{  }
));
var error = (new (Test262Error)());
(promise).then = function () 
{ throw error }
;
((((((Promise).all)([promise])).then)(function () 
{ ($ERROR)("The promise should be rejected") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var promise = (new (Promise)(function () 
{  }
));
var error = (new (Test262Error)());
(promise).then = function () 
{ throw error }
;
((((((Promise).allSettled)([promise])).then)(function () 
{ throw new (Test262Error)("The promise should be rejected") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var promise = (new (Promise)(function () 
{  }
));
var error = (new (Test262Error)());
(promise).then = function () 
{ throw error }
;
((((((Promise).race)([promise])).then)(function () 
{ ($ERROR)("The promise should be rejected") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)