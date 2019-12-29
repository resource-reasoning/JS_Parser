var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var rejectP1, p1 = (new (Promise)(function (resolve,reject) 
{ rejectP1 = reject }
)), p2 = (((Promise).resolve)(p1)), obj = ({});
if ((p1) !== (p2)) {
{ { ($ERROR)("Expected p1 === Promise.resolve(p1) because they have same constructor") } }
};
Skip;
((((p2).then)(function () 
{ ($ERROR)("Expected p2 to be rejected, not fulfilled.") }
,function (arg) 
{ if ((arg) !== (obj)) {
{ { ($ERROR)(("Expected promise to be rejected with reason obj, actually ") + (arg)) } }
} }
)).then)($DONE,$DONE);
(rejectP1)(obj)