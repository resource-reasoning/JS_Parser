var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var expectedThis = (undefined), obj = ({});
var p = (((((Promise).reject)(obj)).then)(function () 
{ ($DONE)("Unexpected fulfillment; expected rejection.") }
,function (arg) 
{ if ((this) !== (expectedThis)) {
{ ($DONE)(("'this' must be undefined, got ") + (this));
return }
};
if ((arg) !== (obj)) {
{ ($DONE)(("Expected promise to be rejected with obj, actually ") + (arg));
return }
};
if (((arguments).length) !== (1.)) {
{ ($DONE)("Expected handler function to be called with exactly 1 argument.");
return }
};
($DONE)() }
))var expectedThis = (undefined), obj = ({});
var p = (((((Promise).reject)(obj)).then)(function () 
{ ($DONE)("Unexpected fulfillment; expected rejection.") }
,function (arg) 
{ if ((this) !== (expectedThis)) {
{ ($DONE)(("'this' must be undefined, got ") + (this));
return }
};
if ((arg) !== (obj)) {
{ ($DONE)(("Expected promise to be rejected with obj, actually ") + (arg));
return }
};
if (((arguments).length) !== (1.)) {
{ ($DONE)("Expected handler function to be called with exactly 1 argument.");
return }
};
($DONE)() }
))