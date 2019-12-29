var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p1 = (((Promise).resolve)(3.));
var pAll = (((Promise).all)([p1]));
((((pAll).then)(function (result) 
{ if ((! pAll) instanceof (Promise)) {
{ { ($ERROR)(("Expected Promise.all() to be promise, actually ") + (pAll)) } }
};
Skip;
if ((! result) instanceof (Array)) {
{ { ($ERROR)(("Expected Promise.all() to be promise for an Array, actually ") + (result)) } }
};
Skip;
if (((result).length) !== (1.)) {
{ { ($ERROR)(("Expected Promise.all([p1]) to be a promise for one-element Array, actually ") + (result)) } }
};
Skip;
if (((result)[0.]) !== (3.)) {
{ { ($ERROR)(("Expected result[0] to be 3, actually ") + ((result)[0.])) } }
} }
)).then)($DONE,$DONE)