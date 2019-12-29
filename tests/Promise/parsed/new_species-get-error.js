var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

function C(executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
;
((Object).defineProperty)(C,(Symbol).species,{get : function () 
{ throw new (Test262Error)("Getter for Symbol.species called") }
});
(C).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).allSettled).call)(C,[])function C(executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
;
((Object).defineProperty)(C,(Symbol).species,{get : function () 
{ throw new (Test262Error)("Getter for Symbol.species called") }
});
(C).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).race).call)(C,[])function C(executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
;
(C).resolve = function () 
{  }
;
((Object).defineProperty)(C,(Symbol).species,{get : function () 
{ ($ERROR)("Getter for Symbol.species called") }
});
(((Promise).all).call)(C,[])function C(executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
;
((Object).defineProperty)(C,(Symbol).species,{get : function () 
{ throw new (Test262Error)("Getter for Symbol.species called") }
});
(C).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).allSettled).call)(C,[])function C(executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
;
((Object).defineProperty)(C,(Symbol).species,{get : function () 
{ throw new (Test262Error)("Getter for Symbol.species called") }
});
(C).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).race).call)(C,[])