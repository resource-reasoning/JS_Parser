var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var poisonedThen = ({});
var err = (new (Test262Error)());
((Object).defineProperty)(poisonedThen,"then",{get : function () 
{ throw err }
});
((((((Promise).resolve)(poisonedThen)).then)(function () 
{ ($ERROR)("Promise should be rejected when retrieving `then` property throws an error") }
,function (reason) 
{ ((assert).sameValue)(reason,err) }
)).then)($DONE,$DONE)