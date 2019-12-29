var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterThrows = ({});
((Object).defineProperty)(iterThrows,(Symbol).iterator,{get : function () 
{ throw new (Error)("abrupt completion") }
});
((((((Promise).all)(iterThrows)).then)(function () 
{ ($ERROR)("Promise unexpectedly fulfilled: Promise.all(iterThrows) should throw TypeError") }
,function (err) 
{ if ((! err) instanceof (Error)) {
{ { ($ERROR)(("Expected promise to be rejected with error, got ") + (err)) } }
} }
)).then)($DONE,$DONE)