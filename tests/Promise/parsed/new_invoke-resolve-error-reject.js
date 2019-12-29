var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thrown = (new (Test262Error)());
(Promise).resolve = function () 
{ throw thrown }
;
((((((Promise).allSettled)([1.])).then)(function () 
{ ($ERROR)("The promise should not be fulfilled.") }
,function (reason) 
{ if ((reason) !== (thrown)) {
{ ($ERROR)("The promise should be rejected with the thrown error object") }
} }
)).then)($DONE,$DONE)var err = (new (Test262Error)());
var CustomPromise = (function (executor) 
{ return new (Promise)(executor) }
);
(CustomPromise).resolve = function () 
{ throw err }
;
(((((Promise).race).call)(CustomPromise,[1.])).then)(function () 
{ ($ERROR)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,err);
($DONE)() }
)var thrown = (new (Test262Error)());
(Promise).resolve = function () 
{ throw thrown }
;
((((((Promise).all)([1.])).then)(function () 
{ ($ERROR)("The promise should not be fulfilled.") }
,function (reason) 
{ if ((reason) !== (thrown)) {
{ ($ERROR)("The promise should be rejected with the thrown error object") }
} }
)).then)($DONE,$DONE)var thrown = (new (Test262Error)());
(Promise).resolve = function () 
{ throw thrown }
;
((((((Promise).allSettled)([1.])).then)(function () 
{ ($ERROR)("The promise should not be fulfilled.") }
,function (reason) 
{ if ((reason) !== (thrown)) {
{ ($ERROR)("The promise should be rejected with the thrown error object") }
} }
)).then)($DONE,$DONE)var err = (new (Test262Error)());
var CustomPromise = (function (executor) 
{ return new (Promise)(executor) }
);
(CustomPromise).resolve = function () 
{ throw err }
;
(((((Promise).race).call)(CustomPromise,[1.])).then)(function () 
{ ($ERROR)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,err);
($DONE)() }
)