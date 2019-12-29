var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var promise;
try { ((Array).prototype).then = function (resolve) 
{ (resolve)(value) }
;
promise = ((Promise).allSettled)([]) }
 finally { delete ((Array).prototype).then };
((((promise).then)(function (val) 
{ ((assert).sameValue)(val,value) }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)).then)($DONE,$DONE)var value = ({});
var thenableValue = ({then : function (resolve) 
{ (resolve)(value) }
});
var thenable = ({then : function (resolve) 
{ (resolve)(thenableValue) }
});
((((Promise).race)([thenable])).then)(function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be resolved with the correct value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var value = ({});
var thenable = ({then : function (resolve) 
{ (resolve)(value) }
});
((((Promise).resolve)(thenable)).then)(function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var value = ({});
var promise;
try { ((Array).prototype).then = function (resolve) 
{ (resolve)(value) }
;
promise = ((Promise).all)([]) }
 finally { delete ((Array).prototype).then };
((promise).then)(function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be resolved with the expected value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var value = ({});
var promise;
try { ((Array).prototype).then = function (resolve) 
{ (resolve)(value) }
;
promise = ((Promise).allSettled)([]) }
 finally { delete ((Array).prototype).then };
((((promise).then)(function (val) 
{ ((assert).sameValue)(val,value) }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)).then)($DONE,$DONE)var value = ({});
var thenableValue = ({then : function (resolve) 
{ (resolve)(value) }
});
var thenable = ({then : function (resolve) 
{ (resolve)(thenableValue) }
});
((((Promise).race)([thenable])).then)(function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be resolved with the correct value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)