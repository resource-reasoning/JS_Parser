var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var promise = (new (Promise)(function () 
{  }
));
var returnCount = (0.);
var iter = ({});
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {done : false; value : promise} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Object).defineProperty)(promise,"then",{get : function () 
{ throw new (Test262Error)() }
});
((Promise).allSettled)(iter);
((assert).sameValue)(returnCount,1.)var promise = (new (Promise)(function () 
{  }
));
var iter = ({});
var returnCount = (0.);
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {done : false; value : promise} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Object).defineProperty)(promise,"then",{get : function () 
{ throw new (Test262Error)() }
});
((Promise).race)(iter);
((assert).sameValue)(returnCount,1.)var promise = (new (Promise)(function () 
{  }
));
var returnCount = (0.);
var iter = ({});
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {done : false; value : promise} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Object).defineProperty)(promise,"then",{get : function () 
{ throw new (Test262Error)() }
});
((Promise).all)(iter);
((assert).sameValue)(returnCount,1.)var promise = (new (Promise)(function () 
{  }
));
var returnCount = (0.);
var iter = ({});
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {done : false; value : promise} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Object).defineProperty)(promise,"then",{get : function () 
{ throw new (Test262Error)() }
});
((Promise).allSettled)(iter);
((assert).sameValue)(returnCount,1.)var promise = (new (Promise)(function () 
{  }
));
var iter = ({});
var returnCount = (0.);
(iter)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {done : false; value : promise} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
((Object).defineProperty)(promise,"then",{get : function () 
{ throw new (Test262Error)() }
});
((Promise).race)(iter);
((assert).sameValue)(returnCount,1.)