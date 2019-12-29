var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterDoneSpy = ({});
var callCount = (0.);
(iterDoneSpy)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {value : null; done : false} }
; return : function () 
{ callCount += 1. }
} }
;
(Promise).resolve = function () 
{ throw new (Error)() }
;
((Promise).allSettled)(iterDoneSpy);
((assert).sameValue)(callCount,1.)var iterDoneSpy = ({});
var returnCount = (0.);
(iterDoneSpy)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {value : null; done : false} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
(Promise).resolve = function () 
{ throw err }
;
((Promise).race)(iterDoneSpy);
((assert).sameValue)(returnCount,1.)var iterDoneSpy = ({});
var callCount = (0.);
(iterDoneSpy)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {value : null; done : false} }
; return : function () 
{ callCount += 1. }
} }
;
(Promise).resolve = function () 
{ throw new (Test262Error)() }
;
((Promise).all)(iterDoneSpy);
((assert).sameValue)(callCount,1.)var iterDoneSpy = ({});
var callCount = (0.);
(iterDoneSpy)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {value : null; done : false} }
; return : function () 
{ callCount += 1. }
} }
;
(Promise).resolve = function () 
{ throw new (Error)() }
;
((Promise).allSettled)(iterDoneSpy);
((assert).sameValue)(callCount,1.)var iterDoneSpy = ({});
var returnCount = (0.);
(iterDoneSpy)[(Symbol).iterator] = function () 
{ return {next : function () 
{ return {value : null; done : false} }
; return : function () 
{ returnCount += 1.;
return {} }
} }
;
(Promise).resolve = function () 
{ throw err }
;
((Promise).race)(iterDoneSpy);
((assert).sameValue)(returnCount,1.)