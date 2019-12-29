var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var promise = (new (Promise)(function () 
{  }
));
(promise).constructor = undefined;
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(undefined,promise) }
,"`this` value is undefined");
(promise).constructor = null;
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(null,promise) }
,"`this` value is null");
(promise).constructor = true;
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(true,promise) }
,"`this` value is a Boolean");
(promise).constructor = 1.;
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(1.,promise) }
,"`this` value is a Number");
(promise).constructor = "";
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)("",promise) }
,"`this` value is a String");
var symbol = ((Symbol)());
(promise).constructor = symbol;
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(symbol,promise) }
,"`this` value is a Symbol")