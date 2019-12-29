var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (new (Promise)(function () 
{  }
));
(p).constructor = null;
((assert).throws)(TypeError,function () 
{ ((p).then)() }
)var p = (new (Promise)(function () 
{  }
));
(p).constructor = null;
((assert).throws)(TypeError,function () 
{ ((p).then)() }
)