var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (((Promise).race)([]));
if ((! p) instanceof (Promise)) {
{ { ($ERROR)("Expected Promise.race([]) to return a promise.") } }
};
var p = (((Promise).race)([]));
if ((! p) instanceof (Promise)) {
{ { ($ERROR)("Expected Promise.race([]) to return a promise.") } }
}