var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var object = ({get constructor function () 
{ ($ERROR)("get constructor called") }
});
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).then).call)(object) }
)var object = ({get constructor function () 
{ ($ERROR)("get constructor called") }
});
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).then).call)(object) }
)