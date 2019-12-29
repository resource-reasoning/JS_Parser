var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var promise = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var log = ("");
((promise).then)(function () 
{ log += "a" }
,function () 
{ log += "A" }
);
((promise).then)(function () 
{ log += "b" }
,function () 
{ log += "B" }
);
((promise).then)(function () 
{ log += "c" }
,function () 
{ log += "C" }
);
((promise).then)(function () 
{ if ((log) !== ("abc")) {
{ ($DONE)((("Expected each "onFulfilled" handler to be invoked exactly once in series. ") + ("Expected: abc. Actual: ")) + (log));
return }
};
($DONE)() }
,function () 
{ ($DONE)("This promise should not be rejected.") }
)var promise = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var log = ("");
((promise).then)(function () 
{ log += "a" }
,function () 
{ log += "A" }
);
((promise).then)(function () 
{ log += "b" }
,function () 
{ log += "B" }
);
((promise).then)(function () 
{ log += "c" }
,function () 
{ log += "C" }
);
((promise).then)(function () 
{ if ((log) !== ("abc")) {
{ ($DONE)((("Expected each "onFulfilled" handler to be invoked exactly once in series. ") + ("Expected: abc. Actual: ")) + (log));
return }
};
($DONE)() }
,function () 
{ ($DONE)("This promise should not be rejected.") }
)