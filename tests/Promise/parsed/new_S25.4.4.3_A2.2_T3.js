var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterThrows = ({});
((Object).defineProperty)(iterThrows,(Symbol).iterator,{get : function () 
{ throw new (Error)("abrupt completion") }
});
((((((Promise).race)(iterThrows)).then)(function () 
{ ($ERROR)("Promise unexpectedly fulfilled: Promise.race(iterThrows) should throw") }
,function (err) 
{ if (! (err) instanceof (Error)) {
{ ($ERROR)(("Expected Promise to be rejected with an error, got ") + (err)) }
} }
)).then)($DONE,$DONE)var iterThrows = ({});
((Object).defineProperty)(iterThrows,(Symbol).iterator,{get : function () 
{ throw new (Error)("abrupt completion") }
});
((((((Promise).race)(iterThrows)).then)(function () 
{ ($ERROR)("Promise unexpectedly fulfilled: Promise.race(iterThrows) should throw") }
,function (err) 
{ if (! (err) instanceof (Error)) {
{ ($ERROR)(("Expected Promise to be rejected with an error, got ") + (err)) }
} }
)).then)($DONE,$DONE)