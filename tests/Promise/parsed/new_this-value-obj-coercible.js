var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var booleanCount = (0.);
((Boolean).prototype).then = function () 
{ booleanCount += 1. }
;
((((Promise).prototype).catch).call)(true);
((assert).sameValue)(booleanCount,1.,"boolean");
var numberCount = (0.);
((Number).prototype).then = function () 
{ numberCount += 1. }
;
((((Promise).prototype).catch).call)(34.);
((assert).sameValue)(numberCount,1.,"number");
var stringCount = (0.);
((String).prototype).then = function () 
{ stringCount += 1. }
;
((((Promise).prototype).catch).call)("");
((assert).sameValue)(stringCount,1.,"string");
var symbolCount = (0.);
((Symbol).prototype).then = function () 
{ symbolCount += 1. }
;
((((Promise).prototype).catch).call)((Symbol)());
((assert).sameValue)(symbolCount,1.,"symbol")var booleanCount = (0.);
((Boolean).prototype).then = function () 
{ booleanCount += 1. }
;
((((Promise).prototype).catch).call)(true);
((assert).sameValue)(booleanCount,1.,"boolean");
var numberCount = (0.);
((Number).prototype).then = function () 
{ numberCount += 1. }
;
((((Promise).prototype).catch).call)(34.);
((assert).sameValue)(numberCount,1.,"number");
var stringCount = (0.);
((String).prototype).then = function () 
{ stringCount += 1. }
;
((((Promise).prototype).catch).call)("");
((assert).sameValue)(stringCount,1.,"string");
var symbolCount = (0.);
((Symbol).prototype).then = function () 
{ symbolCount += 1. }
;
((((Promise).prototype).catch).call)((Symbol)());
((assert).sameValue)(symbolCount,1.,"symbol")