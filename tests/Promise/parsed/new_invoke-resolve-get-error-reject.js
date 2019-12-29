var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var error = (new (Test262Error)());
((Object).defineProperty)(Promise,"resolve",{get : function () 
{ throw error }
});
((((((Promise).allSettled)([new (Promise)(function () 
{  }
)])).then)(function () 
{ ($ERROR)("The promise should be rejected") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var error = (new (Test262Error)());
((Object).defineProperty)(Promise,"resolve",{get : function () 
{ throw error }
});
((((((Promise).race)([new (Promise)(function () 
{  }
)])).then)(function () 
{ ($ERROR)("The promise should be rejected") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var error = (new (Test262Error)());
((Object).defineProperty)(Promise,"resolve",{get : function () 
{ throw error }
});
((((((Promise).all)([new (Promise)(function () 
{  }
)])).then)(function () 
{ ($ERROR)("The promise should be rejected") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var error = (new (Test262Error)());
((Object).defineProperty)(Promise,"resolve",{get : function () 
{ throw error }
});
((((((Promise).allSettled)([new (Promise)(function () 
{  }
)])).then)(function () 
{ ($ERROR)("The promise should be rejected") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var error = (new (Test262Error)());
((Object).defineProperty)(Promise,"resolve",{get : function () 
{ throw error }
});
((((((Promise).race)([new (Promise)(function () 
{  }
)])).then)(function () 
{ ($ERROR)("The promise should be rejected") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)