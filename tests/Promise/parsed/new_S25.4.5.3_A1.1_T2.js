var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (new (Promise)(function () 
{  }
));
if (! ((p).then) instanceof (Function)) {
{ ($ERROR)("Expected p.then to be a function") }
};
if ((((p).then).length) !== (2.)) {
{ ($ERROR)("Expected p.then to be a function of two arguments") }
}var p = (new (Promise)(function () 
{  }
));
if (! ((p).then) instanceof (Function)) {
{ ($ERROR)("Expected p.then to be a function") }
};
if ((((p).then).length) !== (2.)) {
{ ($ERROR)("Expected p.then to be a function of two arguments") }
}