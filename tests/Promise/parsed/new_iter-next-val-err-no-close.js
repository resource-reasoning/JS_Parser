var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterNextValThrows = ({});
var returnCount = (0.);
var nextCount = (0.);
var poisonedVal = ({done : false});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedVal,"value",{get : function () 
{ throw error }
});
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ nextCount += 1.;
return poisonedVal }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Promise).allSettled)(iterNextValThrows);
((assert).sameValue)(returnCount,0.);
((assert).sameValue)(nextCount,1.)var iterNextValThrows = ({});
var returnCount = (0.);
var poisonedVal = ({done : false});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedVal,"value",{get : function () 
{ throw error }
});
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedVal }
; return : function () 
{ returnCount += 1. }
} }
;
((Promise).race)(iterNextValThrows);
((assert).sameValue)(returnCount,0.)var iterNextValThrows = ({});
var returnCount = (0.);
var poisonedVal = ({done : false});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedVal,"value",{get : function () 
{ throw error }
});
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedVal }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Promise).all)(iterNextValThrows);
((assert).sameValue)(returnCount,0.)var iterNextValThrows = ({});
var returnCount = (0.);
var nextCount = (0.);
var poisonedVal = ({done : false});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedVal,"value",{get : function () 
{ throw error }
});
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ nextCount += 1.;
return poisonedVal }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Promise).allSettled)(iterNextValThrows);
((assert).sameValue)(returnCount,0.);
((assert).sameValue)(nextCount,1.)var iterNextValThrows = ({});
var returnCount = (0.);
var poisonedVal = ({done : false});
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedVal,"value",{get : function () 
{ throw error }
});
(iterNextValThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedVal }
; return : function () 
{ returnCount += 1. }
} }
;
((Promise).race)(iterNextValThrows);
((assert).sameValue)(returnCount,0.)