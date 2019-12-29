var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p1 = (((Promise).resolve)(1.)), p2 = (((Promise).resolve)(p1));
if ((p1) !== (p2)) {
{ ($ERROR)("Expected p1 === Promise.resolve(p1) because they have same constructor") }
}