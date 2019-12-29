var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (((Promise).all)([]));
if (! (p) instanceof (Promise)) {
{ ($ERROR)("Expected p to be a Promise") }
}