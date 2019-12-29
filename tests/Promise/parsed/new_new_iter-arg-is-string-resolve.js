var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

try { ((((((Promise).allSettled)("")).then)(function (v) 
{ ((assert).sameValue)((v).length,0.) }
,function () 
{ ($DONE)("The promise should be resolved, but was rejected") }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be resolved, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).race)("a")).then)(function (v) 
{ ((assert).sameValue)(v,"a") }
,function () 
{ ($DONE)("The promise should be resolved, but was rejected") }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be resolved, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).all)("")).then)(function (v) 
{ ((assert).sameValue)((v).length,0.) }
,function () 
{ ($DONE)("The promise should be resolved, but was rejected") }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be resolved, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).allSettled)("")).then)(function (v) 
{ ((assert).sameValue)((v).length,0.) }
,function () 
{ ($DONE)("The promise should be resolved, but was rejected") }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be resolved, but threw an exception: ") + ((error).message)) + (("") + (""))) };
try { ((((((Promise).race)("a")).then)(function (v) 
{ ((assert).sameValue)(v,"a") }
,function () 
{ ($DONE)("The promise should be resolved, but was rejected") }
)).then)($DONE,$DONE) }
catch (error) { ($DONE)((("The promise should be resolved, but threw an exception: ") + ((error).message)) + (("") + (""))) }