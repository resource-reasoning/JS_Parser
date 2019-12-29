var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

((Object).defineProperty)((Array).prototype,0.,{set : function () 
{ throw new (Test262Error)("Setter on Array.prototype called") }
});
((((Promise).allSettled)([42.])).then)(function () 
{ ($DONE)() }
,$DONE)((Object).defineProperty)((Array).prototype,0.,{set : function () 
{ ($ERROR)("Setter on Array.prototype called") }
});
((((Promise).all)([42.])).then)(function () 
{ ($DONE)() }
,$DONE)((Object).defineProperty)((Array).prototype,0.,{set : function () 
{ throw new (Test262Error)("Setter on Array.prototype called") }
});
((((Promise).allSettled)([42.])).then)(function () 
{ ($DONE)() }
,$DONE)