var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

try { ((((((Promise).allSettled)(false)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (error) 
{ ((assert).sameValue)(((Object).getPrototypeOf)(error),(TypeError).prototype);
(assert)((error) instanceof (TypeError)) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).race)(false)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (error) 
{ (assert)((error) instanceof (TypeError)) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).all)(false)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (error) 
{ (assert)((error) instanceof (TypeError)) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).allSettled)(false)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (error) 
{ ((assert).sameValue)(((Object).getPrototypeOf)(error),(TypeError).prototype);
(assert)((error) instanceof (TypeError)) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).race)(false)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (error) 
{ (assert)((error) instanceof (TypeError)) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) }