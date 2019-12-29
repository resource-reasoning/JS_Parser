var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var bound = (((function () 
{  }
).bind)());
((Object).defineProperty)(bound,"prototype",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(Test262Error,function () 
{ ((Reflect).construct)(Promise,[function () 
{  }
],bound) }
)