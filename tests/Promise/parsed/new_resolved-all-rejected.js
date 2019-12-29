var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var obj = ({});
var p1 = (new (Promise)(function (_,reject) 
{ (reject)(1.) }
));
var p2 = (new (Promise)(function (_,reject) 
{ (reject)("test262") }
));
var p3 = (new (Promise)(function (_,reject) 
{ (reject)(obj) }
));
((((((Promise).allSettled)([p1, p2, p3])).then)(function (settled) 
{ (checkSettledPromises)(settled,[{status : "rejected"; reason : 1.}, {status : "rejected"; reason : "test262"}, {status : "rejected"; reason : obj}],"settled") }
)).then)($DONE,$DONE)var obj = ({});
var p1 = (new (Promise)(function (_,reject) 
{ (reject)(1.) }
));
var p2 = (new (Promise)(function (_,reject) 
{ (reject)("test262") }
));
var p3 = (new (Promise)(function (_,reject) 
{ (reject)(obj) }
));
((((((Promise).allSettled)([p1, p2, p3])).then)(function (settled) 
{ (checkSettledPromises)(settled,[{status : "rejected"; reason : 1.}, {status : "rejected"; reason : "test262"}, {status : "rejected"; reason : obj}],"settled") }
)).then)($DONE,$DONE)