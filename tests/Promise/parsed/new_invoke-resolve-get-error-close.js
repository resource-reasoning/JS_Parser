var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iter = ({});
var returnCount = (0.);
var nextCount = (0.);
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ nextCount += 1.;
return {done : false} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Object).defineProperty)(Promise,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((Promise).allSettled)(iter);
((assert).sameValue)(nextCount,0.);
((assert).sameValue)(returnCount,1.)var iter = ({});
var returnCount = (0.);
var nextCount = (0.);
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ nextCount += 1.;
return {done : false} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Object).defineProperty)(Promise,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((Promise).race)(iter);
((assert).sameValue)(nextCount,0.);
((assert).sameValue)(returnCount,1.)var iter = ({});
var returnCount = (0.);
var nextCount = (0.);
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ nextCount += 1.;
return {done : false} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Object).defineProperty)(Promise,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((Promise).all)(iter);
((assert).sameValue)(nextCount,0.);
((assert).sameValue)(returnCount,1.)var iter = ({});
var returnCount = (0.);
var nextCount = (0.);
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ nextCount += 1.;
return {done : false} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Object).defineProperty)(Promise,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((Promise).allSettled)(iter);
((assert).sameValue)(nextCount,0.);
((assert).sameValue)(returnCount,1.)var iter = ({});
var returnCount = (0.);
var nextCount = (0.);
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ nextCount += 1.;
return {done : false} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Object).defineProperty)(Promise,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((Promise).race)(iter);
((assert).sameValue)(nextCount,0.);
((assert).sameValue)(returnCount,1.)