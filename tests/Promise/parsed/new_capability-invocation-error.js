var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var P = (function (executor) 
{ return new (Promise)(function () 
{ (executor)(function () 
{  }
,function () 
{ throw new (Test262Error)() }
) }
) }
);
((assert).throws)(Test262Error,function () 
{ (((Promise).reject).call)(P) }
)var P = (function (executor) 
{ return new (Promise)(function () 
{ (executor)(function () 
{ throw new (Test262Error)() }
,function () 
{  }
) }
) }
);
((assert).throws)(Test262Error,function () 
{ (((Promise).resolve).call)(P) }
)