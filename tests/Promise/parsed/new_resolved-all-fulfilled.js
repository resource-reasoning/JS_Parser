var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var obj = ({});
var p1 = (new (Promise)(function (resolve) 
{ (resolve)(1.) }
));
var p2 = (new (Promise)(function (resolve) 
{ (resolve)("test262") }
));
var p3 = (new (Promise)(function (resolve) 
{ (resolve)(obj) }
));
((((((Promise).allSettled)([p1, p2, p3])).then)(function (settled) 
{ (checkSettledPromises)(settled,[{status : "fulfilled"; value : 1.}, {status : "fulfilled"; value : "test262"}, {status : "fulfilled"; value : obj}],"settled") }
)).then)($DONE,$DONE)var obj = ({});
var p1 = (new (Promise)(function (resolve) 
{ (resolve)(1.) }
));
var p2 = (new (Promise)(function (resolve) 
{ (resolve)("test262") }
));
var p3 = (new (Promise)(function (resolve) 
{ (resolve)(obj) }
));
((((((Promise).allSettled)([p1, p2, p3])).then)(function (settled) 
{ (checkSettledPromises)(settled,[{status : "fulfilled"; value : 1.}, {status : "fulfilled"; value : "test262"}, {status : "fulfilled"; value : obj}],"settled") }
)).then)($DONE,$DONE)