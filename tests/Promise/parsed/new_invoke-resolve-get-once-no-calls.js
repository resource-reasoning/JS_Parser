var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

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
((Promise).allSettled)([]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,0.,"`resolve` not called for empty iterator")var resolve = ((Promise).resolve);
var getCount = (0.);
var callCount = (0.);
((Object).defineProperty)(Promise,"resolve",{configurable : true; get : function () 
{ getCount += 1.;
return function () 
{ callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
 }
});
((Promise).race)([]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,0.,"`resolve` not called for empty iterator")var resolve = ((Promise).resolve);
var getCount = (0.);
var callCount = (0.);
((Object).defineProperty)(Promise,"resolve",{configurable : true; get : function () 
{ getCount += 1.;
return function () 
{ callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
 }
});
((Promise).all)([]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,0.,"`resolve` not called for empty iterator")var resolve = ((Promise).resolve);
var getCount = (0.);
var callCount = (0.);
((Object).defineProperty)(Promise,"resolve",{configurable : true; get : function () 
{ getCount += 1.;
return function () 
{ callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
 }
});
((Promise).allSettled)([]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,0.,"`resolve` not called for empty iterator")var resolve = ((Promise).resolve);
var getCount = (0.);
var callCount = (0.);
((Object).defineProperty)(Promise,"resolve",{configurable : true; get : function () 
{ getCount += 1.;
return function () 
{ callCount += 1.;
return ((resolve).apply)(Promise,arguments) }
 }
});
((Promise).race)([]);
((assert).sameValue)(getCount,1.,"Got `resolve` only once for each iterated value");
((assert).sameValue)(callCount,0.,"`resolve` not called for empty iterator")