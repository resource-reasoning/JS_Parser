var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var promise = (new (Promise)(function (_,reject) 
{ (reject)() }
));
var log = ("");
((promise).then)(function () 
{ log += "A" }
,function () 
{ log += "a" }
);
((promise).then)(function () 
{ log += "B" }
,function () 
{ log += "b" }
);
((promise).then)(function () 
{ log += "C" }
,function () 
{ log += "c" }
);
((promise).then)(function () 
{ ($DONE)("This promise should not be fulfilled.") }
,function () 
{ if ((log) !== ("abc")) {
{ ($DONE)((("Expected each "onFulfilled" handler to be invoked exactly once in series. ") + ("Expected: abc. Actual: ")) + (log));
return }
};
($DONE)() }
)var promise = (new (Promise)(function (_,reject) 
{ (reject)() }
));
var log = ("");
((promise).then)(function () 
{ log += "A" }
,function () 
{ log += "a" }
);
((promise).then)(function () 
{ log += "B" }
,function () 
{ log += "b" }
);
((promise).then)(function () 
{ log += "C" }
,function () 
{ log += "c" }
);
((promise).then)(function () 
{ ($DONE)("This promise should not be fulfilled.") }
,function () 
{ if ((log) !== ("abc")) {
{ ($DONE)((("Expected each "onFulfilled" handler to be invoked exactly once in series. ") + ("Expected: abc. Actual: ")) + (log));
return }
};
($DONE)() }
)