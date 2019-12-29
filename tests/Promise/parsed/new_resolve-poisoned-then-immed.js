var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var returnValue = (null);
var value = ({});
var poisonedThen = (((Object).defineProperty)({},"then",{get : function () 
{ throw value }
}));
var promise = (new (Promise)(function (resolve) 
{ returnValue = (resolve)(poisonedThen) }
));
((assert).sameValue)(returnValue,undefined,""resolve" return value");
((promise).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
($DONE)() }
)