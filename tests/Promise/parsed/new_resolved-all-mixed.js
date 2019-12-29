var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var obj1 = ({});
var obj2 = ({});
var r1 = (new (Promise)(function (_,reject) 
{ (reject)(1.) }
));
var f1 = (new (Promise)(function (resolve) 
{ (resolve)(2.) }
));
var f2 = (new (Promise)(function (resolve) 
{ (resolve)("tc39") }
));
var r2 = (new (Promise)(function (_,reject) 
{ (reject)("test262") }
));
var r3 = (new (Promise)(function (_,reject) 
{ (reject)(obj1) }
));
var f3 = (new (Promise)(function (resolve) 
{ (resolve)(obj2) }
));
((((((Promise).allSettled)([r1, f1, f2, r2, r3, f3])).then)(function (settled) 
{ (checkSettledPromises)(settled,[{status : "rejected"; reason : 1.}, {status : "fulfilled"; value : 2.}, {status : "fulfilled"; value : "tc39"}, {status : "rejected"; reason : "test262"}, {status : "rejected"; reason : obj1}, {status : "fulfilled"; value : obj2}],"settled") }
)).then)($DONE,$DONE)var obj1 = ({});
var obj2 = ({});
var r1 = (new (Promise)(function (_,reject) 
{ (reject)(1.) }
));
var f1 = (new (Promise)(function (resolve) 
{ (resolve)(2.) }
));
var f2 = (new (Promise)(function (resolve) 
{ (resolve)("tc39") }
));
var r2 = (new (Promise)(function (_,reject) 
{ (reject)("test262") }
));
var r3 = (new (Promise)(function (_,reject) 
{ (reject)(obj1) }
));
var f3 = (new (Promise)(function (resolve) 
{ (resolve)(obj2) }
));
((((((Promise).allSettled)([r1, f1, f2, r2, r3, f3])).then)(function (settled) 
{ (checkSettledPromises)(settled,[{status : "rejected"; reason : 1.}, {status : "fulfilled"; value : 2.}, {status : "fulfilled"; value : "tc39"}, {status : "rejected"; reason : "test262"}, {status : "rejected"; reason : obj1}, {status : "fulfilled"; value : obj2}],"settled") }
)).then)($DONE,$DONE)