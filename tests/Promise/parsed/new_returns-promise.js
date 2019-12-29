var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p = (((Promise).allSettled)([]));
(assert)((p) instanceof (Promise));
((assert).sameValue)(((Object).getPrototypeOf)(p),(Promise).prototype)var p = (((Promise).allSettled)([]));
(assert)((p) instanceof (Promise));
((assert).sameValue)(((Object).getPrototypeOf)(p),(Promise).prototype)