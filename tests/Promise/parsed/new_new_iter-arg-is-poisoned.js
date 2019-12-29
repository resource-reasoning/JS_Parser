var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var poison = ([]);
var error = (new (Test262Error)());
((Object).defineProperty)(poison,(Symbol).iterator,{get : function () 
{ throw error }
});
try { ((((((Promise).allSettled)(poison)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (err) 
{ ((assert).sameValue)(err,error) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) };
var poison = ([]);
var error = (new (Test262Error)());
((Object).defineProperty)(poison,(Symbol).iterator,{get : function () 
{ throw error }
});
try { ((((((Promise).allSettled)(poison)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (err) 
{ ((assert).sameValue)(err,error) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) }