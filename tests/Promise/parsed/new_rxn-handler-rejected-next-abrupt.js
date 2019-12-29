var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var promise = (new (Promise)(function (_,reject) 
{ (reject)() }
));
var fulfilledCallCount = (0.);
var rejectedCallCount = (0.);
((promise).then)(function () 
{ fulfilledCallCount += 1. }
,function () 
{ rejectedCallCount += 1.;
throw new (Error)() }
);
((promise).then)(function () 
{ ($DONE)("This promise should not be fulfilled.") }
,function () 
{ if ((fulfilledCallCount) !== (0.)) {
{ ($DONE)("Expected "onFulfilled" handler to not be invoked.");
return }
};
if ((rejectedCallCount) !== (1.)) {
{ ($DONE)("Expected "onRejected" handler to be invoked exactly once.");
return }
};
($DONE)() }
)var promise = (new (Promise)(function (_,reject) 
{ (reject)() }
));
var fulfilledCallCount = (0.);
var rejectedCallCount = (0.);
((promise).then)(function () 
{ fulfilledCallCount += 1. }
,function () 
{ rejectedCallCount += 1.;
throw new (Error)() }
);
((promise).then)(function () 
{ ($DONE)("This promise should not be fulfilled.") }
,function () 
{ if ((fulfilledCallCount) !== (0.)) {
{ ($DONE)("Expected "onFulfilled" handler to not be invoked.");
return }
};
if ((rejectedCallCount) !== (1.)) {
{ ($DONE)("Expected "onRejected" handler to be invoked exactly once.");
return }
};
($DONE)() }
)