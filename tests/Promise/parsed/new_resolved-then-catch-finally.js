var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p0 = (((((Promise).resolve)(2.)).then)(function (v) 
(v) + (1.)
));
var p1 = (((((Promise).reject)(21.)).catch)(function (v) 
(v) * (2.)
));
var p2 = (((((Promise).resolve)("nope")).then)(function () 
{ throw "foo" }
));
var p3 = (((((Promise).reject)("yes")).then)(function () 
{ throw "nope" }
));
var p4 = (((((Promise).resolve)("here")).finally)(function () 
"nope"
));
var p5 = (((((Promise).reject)("here too")).finally)(function () 
"nope"
));
var p6 = (((((Promise).resolve)("nope")).finally)(function () 
{ throw "finally" }
));
var p7 = (((((Promise).reject)("nope")).finally)(function () 
{ throw "finally after rejected" }
));
var p8 = (((((Promise).reject)(1.)).then)(function () 
"nope"
,function () 
0.
));
((((((Promise).allSettled)([p0, p1, p2, p3, p4, p5, p6, p7, p8])).then)(function (settled) 
{ (checkSettledPromises)(settled,[{status : "fulfilled"; value : 3.}, {status : "fulfilled"; value : 42.}, {status : "rejected"; reason : "foo"}, {status : "rejected"; reason : "yes"}, {status : "fulfilled"; value : "here"}, {status : "rejected"; reason : "here too"}, {status : "rejected"; reason : "finally"}, {status : "rejected"; reason : "finally after rejected"}, {status : "fulfilled"; value : 0.}],"settled") }
)).then)($DONE,$DONE)var p0 = (((((Promise).resolve)(2.)).then)(function (v) 
(v) + (1.)
));
var p1 = (((((Promise).reject)(21.)).catch)(function (v) 
(v) * (2.)
));
var p2 = (((((Promise).resolve)("nope")).then)(function () 
{ throw "foo" }
));
var p3 = (((((Promise).reject)("yes")).then)(function () 
{ throw "nope" }
));
var p4 = (((((Promise).resolve)("here")).finally)(function () 
"nope"
));
var p5 = (((((Promise).reject)("here too")).finally)(function () 
"nope"
));
var p6 = (((((Promise).resolve)("nope")).finally)(function () 
{ throw "finally" }
));
var p7 = (((((Promise).reject)("nope")).finally)(function () 
{ throw "finally after rejected" }
));
var p8 = (((((Promise).reject)(1.)).then)(function () 
"nope"
,function () 
0.
));
((((((Promise).allSettled)([p0, p1, p2, p3, p4, p5, p6, p7, p8])).then)(function (settled) 
{ (checkSettledPromises)(settled,[{status : "fulfilled"; value : 3.}, {status : "fulfilled"; value : 42.}, {status : "rejected"; reason : "foo"}, {status : "rejected"; reason : "yes"}, {status : "fulfilled"; value : "here"}, {status : "rejected"; reason : "here too"}, {status : "rejected"; reason : "finally"}, {status : "rejected"; reason : "finally after rejected"}, {status : "fulfilled"; value : 0.}],"settled") }
)).then)($DONE,$DONE)