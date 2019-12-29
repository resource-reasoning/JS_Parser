var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

if ((typeof (Promise).resolve) !== ("function")) {
{ { ($ERROR)("Expected Promise.resolve to be a function") } }
}