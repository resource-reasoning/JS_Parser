var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

((assert).throws)(TypeError,function () 
{ new (Promise)("not callable") }
);
((assert).throws)(TypeError,function () 
{ new (Promise)(1.) }
);
((assert).throws)(TypeError,function () 
{ new (Promise)(null) }
);
((assert).throws)(TypeError,function () 
{ new (Promise)({}) }
)