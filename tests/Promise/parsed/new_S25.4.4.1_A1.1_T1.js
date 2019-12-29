var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

if ((typeof (Promise).all) !== ("function")) {
{ ($ERROR)("Expected Promise.all to be a function") }
}