var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterStepThrows = ({});
var poisonedDone = ({});
var returnCount = (0.);
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedDone,"done",{get : function () 
{ throw error }
});
((Object).defineProperty)(poisonedDone,"value",{get : function () 
{  }
});
(iterStepThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedDone }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Promise).allSettled)(iterStepThrows);
((assert).sameValue)(returnCount,0.)var iterStepThrows = ({});
var poisonedDone = ({});
var returnCount = (0.);
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
; return : function () 
{ returnCount += 1. }
} }
;
((Promise).race)(iterStepThrows);
((assert).sameValue)(returnCount,0.)var iterStepThrows = ({});
var poisonedDone = ({});
var returnCount = (0.);
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
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Promise).all)(iterStepThrows);
((assert).sameValue)(returnCount,0.)var iterStepThrows = ({});
var poisonedDone = ({});
var returnCount = (0.);
var error = (new (Test262Error)());
((Object).defineProperty)(poisonedDone,"done",{get : function () 
{ throw error }
});
((Object).defineProperty)(poisonedDone,"value",{get : function () 
{  }
});
(iterStepThrows)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return poisonedDone }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Promise).allSettled)(iterStepThrows);
((assert).sameValue)(returnCount,0.)var iterStepThrows = ({});
var poisonedDone = ({});
var returnCount = (0.);
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
; return : function () 
{ returnCount += 1. }
} }
;
((Promise).race)(iterStepThrows);
((assert).sameValue)(returnCount,0.)