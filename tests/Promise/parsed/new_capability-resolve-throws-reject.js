var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thrown = (new (Test262Error)());
var P = (function (executor) 
{ return new (Promise)(function (_,reject) 
{ (executor)(function () 
{ throw thrown }
,reject) }
) }
);
(P).resolve = function () 
{ throw new (Test262Error)() }
;
(((((Promise).allSettled).call)(P,[])).then)(function () 
{ ($DONE)("Promise incorrectly fulfilled.") }
,function (reason) 
{ if ((reason) !== (thrown)) {
{ ($DONE)("Promise rejected with incorrect "reason."");
return }
};
($DONE)() }
)var thrown = (new (Test262Error)());
var P = (function (executor) 
{ return new (Promise)(function (_,reject) 
{ (executor)(function () 
{ throw thrown }
,reject) }
) }
);
(P).resolve = (Promise).resolve;
(((((Promise).all).call)(P,[])).then)(function () 
{ ($DONE)("Promise incorrectly fulfilled.") }
,function (reason) 
{ if ((reason) !== (thrown)) {
{ ($DONE)("Promise rejected with incorrect "reason."");
return }
};
($DONE)() }
)var thrown = (new (Test262Error)());
var P = (function (executor) 
{ return new (Promise)(function (_,reject) 
{ (executor)(function () 
{ throw thrown }
,reject) }
) }
);
(P).resolve = function () 
{ throw new (Test262Error)() }
;
(((((Promise).allSettled).call)(P,[])).then)(function () 
{ ($DONE)("Promise incorrectly fulfilled.") }
,function (reason) 
{ if ((reason) !== (thrown)) {
{ ($DONE)("Promise rejected with incorrect "reason."");
return }
};
($DONE)() }
)