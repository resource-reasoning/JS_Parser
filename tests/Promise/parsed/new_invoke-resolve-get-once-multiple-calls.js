var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var p1 = (((Promise).resolve)(1.));
var p2 = (((Promise).resolve)(1.));
var p3 = (((Promise).reject)(1.));
var p4 = (((Promise).resolve)(1.));
var resolve = ((Promise).resolve);
var getCount = (0.);
var callCount = (0.);
((Object).defineProperty)(Promise,"resolve",{configurable : true; get : function () 
{ getCount += 1.;
return function () 
{ callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
 }
});
((Promise).all)([p1, p2, p3, p4]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,4.,"`resolve` invoked once for each iterated value")var p1 = (((Promise).resolve)(1.));
var p2 = (((Promise).resolve)(1.));
var p3 = (((Promise).reject)(1.));
var p4 = (((Promise).resolve)(1.));
var resolve = ((Promise).resolve);
var getCount = (0.);
var callCount = (0.);
((Object).defineProperty)(Promise,"resolve",{configurable : true; get : function () 
{ getCount += 1.;
return function () 
{ callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
 }
});
((Promise).allSettled)([p1, p2, p3, p4]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,4.,"`resolve` invoked once for each iterated value")var p1 = (((Promise).resolve)(1.));
var p2 = (((Promise).resolve)(1.));
var p3 = (((Promise).reject)(1.));
var p4 = (((Promise).resolve)(1.));
var resolve = ((Promise).resolve);
var getCount = (0.);
var callCount = (0.);
((Object).defineProperty)(Promise,"resolve",{configurable : true; get : function () 
{ getCount += 1.;
return function () 
{ callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
 }
});
((Promise).race)([p1, p2, p3, p4]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,4.,"`resolve` invoked once for each iterated value")var p1 = (((Promise).resolve)(1.));
var p2 = (((Promise).resolve)(1.));
var p3 = (((Promise).reject)(1.));
var p4 = (((Promise).resolve)(1.));
var resolve = ((Promise).resolve);
var getCount = (0.);
var callCount = (0.);
((Object).defineProperty)(Promise,"resolve",{configurable : true; get : function () 
{ getCount += 1.;
return function () 
{ callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
 }
});
((Promise).all)([p1, p2, p3, p4]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,4.,"`resolve` invoked once for each iterated value")var p1 = (((Promise).resolve)(1.));
var p2 = (((Promise).resolve)(1.));
var p3 = (((Promise).reject)(1.));
var p4 = (((Promise).resolve)(1.));
var resolve = ((Promise).resolve);
var getCount = (0.);
var callCount = (0.);
((Object).defineProperty)(Promise,"resolve",{configurable : true; get : function () 
{ getCount += 1.;
return function () 
{ callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
 }
});
((Promise).allSettled)([p1, p2, p3, p4]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,4.,"`resolve` invoked once for each iterated value")var p1 = (((Promise).resolve)(1.));
var p2 = (((Promise).resolve)(1.));
var p3 = (((Promise).reject)(1.));
var p4 = (((Promise).resolve)(1.));
var resolve = ((Promise).resolve);
var getCount = (0.);
var callCount = (0.);
((Object).defineProperty)(Promise,"resolve",{configurable : true; get : function () 
{ getCount += 1.;
return function () 
{ callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
 }
});
((Promise).race)([p1, p2, p3, p4]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,4.,"`resolve` invoked once for each iterated value")