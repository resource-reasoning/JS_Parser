var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var thenableValue = ({then : function (resolve) 
{ (resolve)(value) }
});
var thenable = (new (Promise)(function (resolve) 
{ (resolve)() }
));
(thenable).then = function (resolve) 
{ (resolve)(thenableValue) }
;
((((Promise).race)([thenable])).then)(function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be resolved with the correct value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var value = ({});
var rejectCallCount = (0.);
var thenable = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var resolvedValue;
(thenable).then = function (resolve) 
{ (resolve)(value) }
;
((((Promise).resolve)(thenable)).then)(function (val) 
{ resolvedValue = val }
,function () 
{ rejectCallCount += 1. }
);
((assert).sameValue)(resolvedValue,value);
((assert).sameValue)(rejectCallCount,0.)var value = ({});
var thenableValue = ({then : function (resolve) 
{ (resolve)(value) }
});
var thenable = (new (Promise)(function (resolve) 
{ (resolve)() }
));
(thenable).then = function (resolve) 
{ (resolve)(thenableValue) }
;
((((Promise).race)([thenable])).then)(function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be resolved with the correct value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)