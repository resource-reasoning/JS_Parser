var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var expectedThis = (this), obj = ({});
var p = (((((Promise).resolve)(obj)).then)(function (arg) 
{ if ((this) !== (expectedThis)) {
{ ($DONE)(("'this' must be global object, got ") + (this));
return }
};
if ((arg) !== (obj)) {
{ ($DONE)(("Expected promise to be fulfilled by obj, actually ") + (arg));
return }
};
if (((arguments).length) !== (1.)) {
{ ($DONE)("Expected handler function to be called with exactly 1 argument.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
))var expectedThis = (this), obj = ({});
var p = (((((Promise).resolve)(obj)).then)(function (arg) 
{ if ((this) !== (expectedThis)) {
{ ($DONE)(("'this' must be global object, got ") + (this));
return }
};
if ((arg) !== (obj)) {
{ ($DONE)(("Expected promise to be fulfilled by obj, actually ") + (arg));
return }
};
if (((arguments).length) !== (1.)) {
{ ($DONE)("Expected handler function to be called with exactly 1 argument.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
))