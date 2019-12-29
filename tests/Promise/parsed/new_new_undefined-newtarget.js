var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

((assert).throws)(TypeError,function () 
{ (Promise)(function () 
{  }
) }
);
((assert).throws)(TypeError,function () 
{ ((Promise).call)(null,function () 
{  }
) }
);
var p = (new (Promise)(function () 
{  }
));
((assert).throws)(TypeError,function () 
{ ((Promise).call)(p,function () 
{  }
) }
)