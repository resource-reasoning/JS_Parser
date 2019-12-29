var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p1 = (new (Promise)(function () 
{  }
));
delete (p1).constructor;
var p2 = (((p1).then)());
(assert)((p2) instanceof (Promise))var p1 = (new (Promise)(function () 
{  }
));
delete (p1).constructor;
var p2 = (((p1).then)());
(assert)((p2) instanceof (Promise))