var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)(undefined) }
,"undefined");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)(null) }
,"null")((assert).sameValue)(typeof ((Promise).prototype).finally,"function");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(undefined) }
,"undefined");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(null) }
,"null")((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)(undefined) }
,"undefined");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)(null) }
,"null")((assert).sameValue)(typeof ((Promise).prototype).finally,"function");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(undefined) }
,"undefined");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(null) }
,"null")