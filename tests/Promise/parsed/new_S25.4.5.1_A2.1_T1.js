var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (((Promise).resolve)(3.));
if (! ((p).catch) instanceof (Function)) {
{ ($ERROR)("Expected p.catch to be a function") }
}var p = (((Promise).resolve)(3.));
if (! ((p).catch) instanceof (Function)) {
{ ($ERROR)("Expected p.catch to be a function") }
}