var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var sequence = ([]);
var p = (new (Promise)(function (resolve,reject) 
{ ((sequence).push)(1.);
(resolve)("") }
));
((((((p).then)(function () 
{ ((sequence).push)(3.) }
)).then)(function () 
{ ((sequence).push)(5.) }
)).then)(function () 
{ ((sequence).push)(7.) }
);
((((((((((p).then)(function () 
{ ((sequence).push)(4.) }
)).then)(function () 
{ ((sequence).push)(6.) }
)).then)(function () 
{ ((sequence).push)(8.) }
)).then)(function () 
{ (checkSequence)(sequence,"Sequence should be as expected") }
)).then)($DONE,$DONE);
((sequence).push)(2.)var sequence = ([]);
var p = (new (Promise)(function (resolve,reject) 
{ ((sequence).push)(1.);
(resolve)("") }
));
((((((p).then)(function () 
{ ((sequence).push)(3.) }
)).then)(function () 
{ ((sequence).push)(5.) }
)).then)(function () 
{ ((sequence).push)(7.) }
);
((((((((((p).then)(function () 
{ ((sequence).push)(4.) }
)).then)(function () 
{ ((sequence).push)(6.) }
)).then)(function () 
{ ((sequence).push)(8.) }
)).then)(function () 
{ (checkSequence)(sequence,"Sequence should be as expected") }
)).then)($DONE,$DONE);
((sequence).push)(2.)