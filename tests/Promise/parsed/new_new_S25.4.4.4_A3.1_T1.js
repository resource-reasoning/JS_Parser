var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

function ZeroArgConstructor() 
{  }
;
Skip;
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(ZeroArgConstructor,4.) }
)