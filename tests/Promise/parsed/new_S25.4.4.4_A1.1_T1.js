var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

if ((typeof (Promise).reject) !== ("function")) {
{ ($ERROR)("Expected Promise.reject to be a function") }
}