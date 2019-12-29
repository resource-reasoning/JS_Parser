var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var _this;
new (Promise)(function () 
{ _this = this }
);
((assert).sameValue)(_this,this)