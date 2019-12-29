var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (((Promise).all)([]));
((((p).then)(function (result) 
{ if ((! result) instanceof (Array)) {
{ { ($ERROR)(("Expected Promise.all([]) to be Array, actually ") + (result)) } }
};
Skip;
if (((result).length) !== (0.)) {
{ { ($ERROR)(("Expected Promise.all([]) to be empty Array, actually ") + (result)) } }
} }
)).then)($DONE,$DONE)