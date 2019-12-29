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
var callCount = (0.);
var currentThis = (p1);
var nextThis = (p2);
var afterNextThis = (p3);
(p1).then = (p2).then = (p3).then = function (a,b) 
{ ((assert).sameValue)(typeof a,"function","type of first argument");
((assert).sameValue)((a).length,1.,"The length property of a promise resolve function is 1.");
((assert).sameValue)(typeof b,"function","type of second argument");
((assert).sameValue)((b).length,1.,"The length property of a promise reject function is 1.");
((assert).sameValue)((arguments).length,2.,"`then` invoked with two arguments");
((assert).sameValue)(this,currentThis,"`this` value");
currentThis = nextThis;
nextThis = afterNextThis;
afterNextThis = null;
callCount += 1. }
;
((Promise).allSettled)([p1, p2, p3]);
((assert).sameValue)(callCount,3.,"`then` invoked once for every iterated value")var p1 = (new (Promise)(function () 
{  }
));
var p2 = (new (Promise)(function () 
{  }
));
var p3 = (new (Promise)(function () 
{  }
));
var callCount = (0.);
var currentThis = (p1);
var nextThis = (p2);
var afterNextThis = (p3);
(p1).then = (p2).then = (p3).then = function (a,b) 
{ ((assert).sameValue)(typeof a,"function","type of first argument");
((assert).sameValue)((a).length,1.,"ES6 25.4.1.3.2: The length property of a promise resolve function is 1.");
((assert).sameValue)(typeof b,"function","type of second argument");
((assert).sameValue)((b).length,1.,"ES6 25.4.1.3.1: The length property of a promise reject function is 1.");
((assert).sameValue)((arguments).length,2.,"`then` invoked with two arguments");
((assert).sameValue)(this,currentThis,"`this` value");
currentThis = nextThis;
nextThis = afterNextThis;
afterNextThis = null;
callCount += 1. }
;
((Promise).race)([p1, p2, p3]);
((assert).sameValue)(callCount,3.,"`then` invoked once for every iterated value")var p1 = (new (Promise)(function () 
{  }
));
var p2 = (new (Promise)(function () 
{  }
));
var p3 = (new (Promise)(function () 
{  }
));
var callCount = (0.);
var currentThis = (p1);
var nextThis = (p2);
var afterNextThis = (p3);
(p1).then = (p2).then = (p3).then = function (a,b) 
{ ((assert).sameValue)(typeof a,"function","type of first argument");
((assert).sameValue)((a).length,1.,"ES6 25.4.1.3.2: The length property of a promise resolve function is 1.");
((assert).sameValue)(typeof b,"function","type of second argument");
((assert).sameValue)((b).length,1.,"ES6 25.4.1.3.1: The length property of a promise reject function is 1.");
((assert).sameValue)((arguments).length,2.,"`then` invoked with two arguments");
((assert).sameValue)(this,currentThis,"`this` value");
currentThis = nextThis;
nextThis = afterNextThis;
afterNextThis = null;
callCount += 1. }
;
((Promise).all)([p1, p2, p3]);
((assert).sameValue)(callCount,3.,"`then` invoked once for every iterated value")var p1 = (new (Promise)(function () 
{  }
));
var p2 = (new (Promise)(function () 
{  }
));
var p3 = (new (Promise)(function () 
{  }
));
var callCount = (0.);
var currentThis = (p1);
var nextThis = (p2);
var afterNextThis = (p3);
(p1).then = (p2).then = (p3).then = function (a,b) 
{ ((assert).sameValue)(typeof a,"function","type of first argument");
((assert).sameValue)((a).length,1.,"The length property of a promise resolve function is 1.");
((assert).sameValue)(typeof b,"function","type of second argument");
((assert).sameValue)((b).length,1.,"The length property of a promise reject function is 1.");
((assert).sameValue)((arguments).length,2.,"`then` invoked with two arguments");
((assert).sameValue)(this,currentThis,"`this` value");
currentThis = nextThis;
nextThis = afterNextThis;
afterNextThis = null;
callCount += 1. }
;
((Promise).allSettled)([p1, p2, p3]);
((assert).sameValue)(callCount,3.,"`then` invoked once for every iterated value")var p1 = (new (Promise)(function () 
{  }
));
var p2 = (new (Promise)(function () 
{  }
));
var p3 = (new (Promise)(function () 
{  }
));
var callCount = (0.);
var currentThis = (p1);
var nextThis = (p2);
var afterNextThis = (p3);
(p1).then = (p2).then = (p3).then = function (a,b) 
{ ((assert).sameValue)(typeof a,"function","type of first argument");
((assert).sameValue)((a).length,1.,"ES6 25.4.1.3.2: The length property of a promise resolve function is 1.");
((assert).sameValue)(typeof b,"function","type of second argument");
((assert).sameValue)((b).length,1.,"ES6 25.4.1.3.1: The length property of a promise reject function is 1.");
((assert).sameValue)((arguments).length,2.,"`then` invoked with two arguments");
((assert).sameValue)(this,currentThis,"`this` value");
currentThis = nextThis;
nextThis = afterNextThis;
afterNextThis = null;
callCount += 1. }
;
((Promise).race)([p1, p2, p3]);
((assert).sameValue)(callCount,3.,"`then` invoked once for every iterated value")