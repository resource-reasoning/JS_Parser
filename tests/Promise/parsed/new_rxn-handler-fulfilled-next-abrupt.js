var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var promise = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var fulfilledCallCount = (0.);
var rejectedCallCount = (0.);
((promise).then)(function () 
{ fulfilledCallCount += 1.;
throw new (Error)() }
,function () 
{ rejectedCallCount += 1. }
);
((promise).then)(function () 
{ if ((fulfilledCallCount) !== (1.)) {
{ ($DONE)("Expected "onFulfilled" handler to be invoked exactly once.");
return }
};
if ((rejectedCallCount) !== (0.)) {
{ ($DONE)("Expected "onRejected" handler to not be invoked.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("This promise should not be rejected.") }
)var promise = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var fulfilledCallCount = (0.);
var rejectedCallCount = (0.);
((promise).then)(function () 
{ fulfilledCallCount += 1.;
throw new (Error)() }
,function () 
{ rejectedCallCount += 1. }
);
((promise).then)(function () 
{ if ((fulfilledCallCount) !== (1.)) {
{ ($DONE)("Expected "onFulfilled" handler to be invoked exactly once.");
return }
};
if ((rejectedCallCount) !== (0.)) {
{ ($DONE)("Expected "onRejected" handler to not be invoked.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("This promise should not be rejected.") }
)