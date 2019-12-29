var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (new (Promise)(function () 
{  }
));
((assert).throws)(TypeError,function () 
{ (((p).then).call)(3.,function () 
{  }
,function () 
{  }
) }
)var p = (new (Promise)(function () 
{  }
));
((assert).throws)(TypeError,function () 
{ (((p).then).call)(3.,function () 
{  }
,function () 
{  }
) }
)