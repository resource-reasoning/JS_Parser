var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var iterThrows = ({});
((Object).defineProperty)(iterThrows,(Symbol).iterator,{get : function () 
{ return {next : function () 
{ var v = ({});
((Object).defineProperty)(v,"value",{get : function () 
{ throw new (Error)("abrupt completion") }
});
return v }
} }
});
((((((Promise).race)(iterThrows)).then)(function () 
{ ($ERROR)("Promise unexpectedly fulfilled: Promise.race(iterThrows) should throw TypeError") }
,function (err) 
{ if (! (err) instanceof (TypeError)) {
{ ($ERROR)(("Expected TypeError, got ") + (err)) }
} }
)).then)($DONE,$DONE)var iterThrows = ({});
((Object).defineProperty)(iterThrows,(Symbol).iterator,{get : function () 
{ return {next : function () 
{ var v = ({});
((Object).defineProperty)(v,"value",{get : function () 
{ throw new (Error)("abrupt completion") }
});
return v }
} }
});
((((((Promise).race)(iterThrows)).then)(function () 
{ ($ERROR)("Promise unexpectedly fulfilled: Promise.race(iterThrows) should throw TypeError") }
,function (err) 
{ if (! (err) instanceof (TypeError)) {
{ ($ERROR)(("Expected TypeError, got ") + (err)) }
} }
)).then)($DONE,$DONE)