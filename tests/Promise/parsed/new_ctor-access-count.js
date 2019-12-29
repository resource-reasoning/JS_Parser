var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var callCount = (0.);
var prms = (new (Promise)(function (resolve) 
{ (resolve)() }
));
((Object).defineProperty)(prms,"constructor",{get : function () 
{ callCount += 1.;
return Promise }
});
((prms).then)(function () 
{ if ((callCount) !== (1.)) {
{ ($DONE)(("Expected constructor access count: 1. Actual: ") + (callCount));
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var callCount = (0.);
var prms = (new (Promise)(function (resolve) 
{ (resolve)() }
));
((Object).defineProperty)(prms,"constructor",{get : function () 
{ callCount += 1.;
return Promise }
});
((prms).then)(function () 
{ if ((callCount) !== (1.)) {
{ ($DONE)(("Expected constructor access count: 1. Actual: ") + (callCount));
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)