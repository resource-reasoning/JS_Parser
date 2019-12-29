var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p1 = (new (Promise)(function () 
{  }
));
var p2 = (new (Promise)(function () 
{  }
));
var p3 = (new (Promise)(function () 
{  }
));
var resolve = ((Promise).resolve);
var callCount = (0.);
var current = (p1);
var next = (p2);
var afterNext = (p3);
(Promise).resolve = function (nextValue) 
{ ((assert).sameValue)(nextValue,current,"`resolve` invoked with next iterated value");
((assert).sameValue)((arguments).length,1.,"`resolve` invoked with a single argument");
((assert).sameValue)(this,Promise,"`this` value is the constructor");
current = next;
next = afterNext;
afterNext = null;
callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
;
((Promise).allSettled)([p1, p2, p3]);
((assert).sameValue)(callCount,3.,"`resolve` invoked once for each iterated value")var p1 = (new (Promise)(function () 
{  }
));
var p2 = (new (Promise)(function () 
{  }
));
var p3 = (new (Promise)(function () 
{  }
));
var resolve = ((Promise).resolve);
var callCount = (0.);
var current = (p1);
var next = (p2);
var afterNext = (p3);
(Promise).resolve = function (nextValue) 
{ ((assert).sameValue)(nextValue,current,"`resolve` invoked with next iterated value");
((assert).sameValue)((arguments).length,1.,"`resolve` invoked with a single argument");
((assert).sameValue)(this,Promise,"`this` value set to the constructor");
current = next;
next = afterNext;
afterNext = null;
callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
;
((Promise).race)([p1, p2, p3]);
((assert).sameValue)(callCount,3.,"`resolve` invoked once for each iterated value")var p1 = (new (Promise)(function () 
{  }
));
var p2 = (new (Promise)(function () 
{  }
));
var p3 = (new (Promise)(function () 
{  }
));
var resolve = ((Promise).resolve);
var callCount = (0.);
var current = (p1);
var next = (p2);
var afterNext = (p3);
(Promise).resolve = function (nextValue) 
{ ((assert).sameValue)(nextValue,current,"`resolve` invoked with next iterated value");
((assert).sameValue)((arguments).length,1.,"`resolve` invoked with a single argument");
((assert).sameValue)(this,Promise,"`this` value is the constructor");
current = next;
next = afterNext;
afterNext = null;
callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
;
((Promise).all)([p1, p2, p3]);
((assert).sameValue)(callCount,3.,"`resolve` invoked once for each iterated value")var p1 = (new (Promise)(function () 
{  }
));
var p2 = (new (Promise)(function () 
{  }
));
var p3 = (new (Promise)(function () 
{  }
));
var resolve = ((Promise).resolve);
var callCount = (0.);
var current = (p1);
var next = (p2);
var afterNext = (p3);
(Promise).resolve = function (nextValue) 
{ ((assert).sameValue)(nextValue,current,"`resolve` invoked with next iterated value");
((assert).sameValue)((arguments).length,1.,"`resolve` invoked with a single argument");
((assert).sameValue)(this,Promise,"`this` value is the constructor");
current = next;
next = afterNext;
afterNext = null;
callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
;
((Promise).allSettled)([p1, p2, p3]);
((assert).sameValue)(callCount,3.,"`resolve` invoked once for each iterated value")var p1 = (new (Promise)(function () 
{  }
));
var p2 = (new (Promise)(function () 
{  }
));
var p3 = (new (Promise)(function () 
{  }
));
var resolve = ((Promise).resolve);
var callCount = (0.);
var current = (p1);
var next = (p2);
var afterNext = (p3);
(Promise).resolve = function (nextValue) 
{ ((assert).sameValue)(nextValue,current,"`resolve` invoked with next iterated value");
((assert).sameValue)((arguments).length,1.,"`resolve` invoked with a single argument");
((assert).sameValue)(this,Promise,"`this` value set to the constructor");
current = next;
next = afterNext;
afterNext = null;
callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
;
((Promise).race)([p1, p2, p3]);
((assert).sameValue)(callCount,3.,"`resolve` invoked once for each iterated value")