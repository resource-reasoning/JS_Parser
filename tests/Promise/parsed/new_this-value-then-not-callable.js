var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var symbol = ((Symbol)());
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({}) }
,"undefined");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : null}) }
,"null");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : 1.}) }
,"number");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : ""}) }
,"string");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : true}) }
,"boolean");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : symbol}) }
,"symbol");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : {}}) }
,"ordinary object")((assert).sameValue)(typeof ((Promise).prototype).finally,"function");
var symbol = ((Symbol)());
var thrower = (function () 
{ throw new (Test262Error)("this should never happen") }
);
var p = (new (Promise)(function () 
{  }
));
(p).then = undefined;
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"undefined");
(p).then = null;
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"null");
(p).then = 1.;
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"number");
(p).then = "";
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"string");
(p).then = true;
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"boolean");
(p).then = symbol;
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"symbol");
(p).then = {};
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"ordinary object")var symbol = ((Symbol)());
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({}) }
,"undefined");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : null}) }
,"null");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : 1.}) }
,"number");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : ""}) }
,"string");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : true}) }
,"boolean");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : symbol}) }
,"symbol");
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).catch).call)({then : {}}) }
,"ordinary object")((assert).sameValue)(typeof ((Promise).prototype).finally,"function");
var symbol = ((Symbol)());
var thrower = (function () 
{ throw new (Test262Error)("this should never happen") }
);
var p = (new (Promise)(function () 
{  }
));
(p).then = undefined;
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"undefined");
(p).then = null;
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"null");
(p).then = 1.;
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"number");
(p).then = "";
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"string");
(p).then = true;
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"boolean");
(p).then = symbol;
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"symbol");
(p).then = {};
((assert).throws)(TypeError,function () 
{ ((((Promise).prototype).finally).call)(p,thrower) }
,"ordinary object")