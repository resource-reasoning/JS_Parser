var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

try { ((((((Promise).allSettled)(true)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (error) 
{ ((assert).sameValue)(((Object).getPrototypeOf)(error),(TypeError).prototype);
(assert)((error) instanceof (TypeError)) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).race)(true)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (error) 
{ (assert)((error) instanceof (TypeError)) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).all)(true)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (error) 
{ (assert)((error) instanceof (TypeError)) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).allSettled)(true)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (error) 
{ ((assert).sameValue)(((Object).getPrototypeOf)(error),(TypeError).prototype);
(assert)((error) instanceof (TypeError)) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).race)(true)).then)(function () 
{ ($DONE)("The promise should be rejected, but was resolved") }
,function (error) 
{ (assert)((error) instanceof (TypeError)) }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be rejected, but threw an exception: ") + ((error).message)) + (("") + (""))) }