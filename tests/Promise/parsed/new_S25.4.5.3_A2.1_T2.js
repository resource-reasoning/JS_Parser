var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

function ZeroArgConstructor() 
{  }
;
var z = (new (ZeroArgConstructor)());
((assert).throws)(TypeError,function () 
{ (((Promise).then).call)(z,function () 
{  }
,function () 
{  }
) }
)function ZeroArgConstructor() 
{  }
;
var z = (new (ZeroArgConstructor)());
((assert).throws)(TypeError,function () 
{ (((Promise).then).call)(z,function () 
{  }
,function () 
{  }
) }
)