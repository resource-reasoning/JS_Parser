var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterNextValThrows = ({});
var poisonedVal = ({done : false});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedVal,"value",{get : function () 
{ throw error }
});
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedVal }
} }
;
((((((Promise).allSettled)(iterNextValThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var iterNextValThrows = ({});
var poisonedVal = ({done : false});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedVal,"value",{get : function () 
{ throw error }
});
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedVal }
} }
;
((((((Promise).race)(iterNextValThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var iterNextValThrows = ({});
var poisonedVal = ({done : false});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedVal,"value",{get : function () 
{ throw error }
});
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedVal }
} }
;
((((((Promise).all)(iterNextValThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var iterNextValThrows = ({});
var poisonedVal = ({done : false});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedVal,"value",{get : function () 
{ throw error }
});
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedVal }
} }
;
((((((Promise).allSettled)(iterNextValThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)var iterNextValThrows = ({});
var poisonedVal = ({done : false});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedVal,"value",{get : function () 
{ throw error }
});
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedVal }
} }
;
((((((Promise).race)(iterNextValThrows)).then)(function () 
{ ($DONE)("The promise should be rejected.") }
,function (reason) 
{ ((assert).sameValue)(reason,error) }
)).then)($DONE,$DONE)