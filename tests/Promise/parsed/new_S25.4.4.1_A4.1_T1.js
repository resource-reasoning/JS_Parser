var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

function ZeroArgConstructor() 
{  }
;
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(ZeroArgConstructor,[]) }
)