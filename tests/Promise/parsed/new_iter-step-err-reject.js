var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterStepThrows = ({});
var poisonedDone = ({});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedDone,"done",{get : function () 
{ throw error }
});
((Object).defineProperty)(poisonedDone,"value",{get : function () 
{ ($DONE)("The `value` property should not be accessed.") }
});
(iterStepThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedDone }
} }
;
((((((Promise).allSettled)(iterStepThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var iterStepThrows = ({});
var poisonedDone = ({});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedDone,"done",{get : function () 
{ throw error }
});
((Object).defineProperty)(poisonedDone,"value",{get : function () 
{ ($ERROR)("The `value` property should not be accessed.") }
});
(iterStepThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedDone }
} }
;
((((((Promise).race)(iterStepThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var iterStepThrows = ({});
var poisonedDone = ({});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedDone,"done",{get : function () 
{ throw error }
});
((Object).defineProperty)(poisonedDone,"value",{get : function () 
{ ($DONE)("The `value` property should not be accessed.") }
});
(iterStepThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedDone }
} }
;
((((((Promise).all)(iterStepThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var iterStepThrows = ({});
var poisonedDone = ({});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedDone,"done",{get : function () 
{ throw error }
});
((Object).defineProperty)(poisonedDone,"value",{get : function () 
{ ($DONE)("The `value` property should not be accessed.") }
});
(iterStepThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedDone }
} }
;
((((((Promise).allSettled)(iterStepThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var iterStepThrows = ({});
var poisonedDone = ({});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedDone,"done",{get : function () 
{ throw error }
});
((Object).defineProperty)(poisonedDone,"value",{get : function () 
{ ($ERROR)("The `value` property should not be accessed.") }
});
(iterStepThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedDone }
} }
;
((((((Promise).race)(iterStepThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)