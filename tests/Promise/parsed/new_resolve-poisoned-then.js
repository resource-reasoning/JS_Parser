var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var promise;
try { ((Object).defineProperty)((Array).prototype,"then",{get : function () 
{ throw value }
; configurable : true});
promise = ((Promise).allSettled)([]) }
 finally { delete ((Array).prototype).then };
((promise).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be rejected with the expected value.");
return }
};
($DONE)() }
)var value = ({});
var poisonedThen = (((Object).defineProperty)({},"then",{get : function () 
{ throw value }
}));
var thenable = ({then : function (resolve) 
{ (resolve)(poisonedThen) }
});
((((Promise).race)([thenable])).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be rejected with the correct value.");
return }
};
($DONE)() }
)var value = ({});
var resolve;
var poisonedThen = (((Object).defineProperty)({},"then",{get : function () 
{ throw value }
}));
((((Promise).resolve)(poisonedThen)).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be rejected with the provided value.");
return }
};
($DONE)() }
)var value = ({});
var promise;
try { ((Object).defineProperty)((Array).prototype,"then",{get : function () 
{ throw value }
; configurable : true});
promise = ((Promise).all)([]) }
 finally { delete ((Array).prototype).then };
((promise).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be rejected with the expected value.");
return }
};
($DONE)() }
)var value = ({});
var promise;
try { ((Object).defineProperty)((Array).prototype,"then",{get : function () 
{ throw value }
; configurable : true});
promise = ((Promise).allSettled)([]) }
 finally { delete ((Array).prototype).then };
((promise).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be rejected with the expected value.");
return }
};
($DONE)() }
)var value = ({});
var poisonedThen = (((Object).defineProperty)({},"then",{get : function () 
{ throw value }
}));
var thenable = ({then : function (resolve) 
{ (resolve)(poisonedThen) }
});
((((Promise).race)([thenable])).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (val) 
{ if ((val) !== (value)) {
{ ($DONE)("The promise should be rejected with the correct value.");
return }
};
($DONE)() }
)