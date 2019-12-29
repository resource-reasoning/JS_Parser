var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (((Promise).resolve)("foo"));
((Object).defineProperty)(p,"constructor",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(Test262Error,function () 
{ ((p).then)(function () 
{ ($ERROR)("Should never be called.") }
,function () 
{ ($ERROR)("Should never be called.") }
) }
)var p = (((Promise).resolve)("foo"));
((Object).defineProperty)(p,"constructor",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(Test262Error,function () 
{ ((p).then)(function () 
{ ($ERROR)("Should never be called.") }
,function () 
{ ($ERROR)("Should never be called.") }
) }
)