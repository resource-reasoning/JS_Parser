var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var nonThenable = ({then : null});
((((((Promise).resolve)(nonThenable)).then)(function (value) 
{ ((assert).sameValue)(value,nonThenable) }
)).then)($DONE,$DONE)