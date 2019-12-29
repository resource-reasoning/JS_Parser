var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var self, resolve;
var builtinResolve = ((Promise).resolve);
var thenable = ({then : function (r) 
{ resolve = r }
});
try { (Promise).resolve = function (v) 
{ return v }
;
self = ((Promise).race)([thenable]) }
 finally { (Promise).resolve = builtinResolve };
(resolve)(self);
((self).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (value) 
{ if (! value) {
{ ($DONE)("The promise should be rejected with a value.");
return }
};
if (((value).constructor) !== (TypeError)) {
{ ($DONE)("The promise should be rejected with a TypeError instance.");
return }
};
($DONE)() }
)var returnValue = (null);
var resolve;
var promise = (new (Promise)(function (_resolve) 
{ resolve = _resolve }
));
((promise).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (reason) 
{ if (! reason) {
{ ($DONE)("The promise should be rejected with a value.");
return }
};
if (((reason).constructor) !== (TypeError)) {
{ ($DONE)("The promise should be rejected with a TypeError instance.");
return }
};
($DONE)() }
);
returnValue = (resolve)(promise);
((assert).sameValue)(returnValue,undefined,""resolve" return value")var resolve, reject;
var promise = (new (Promise)(function (_resolve,_reject) 
{ resolve = _resolve;
reject = _reject }
));
var P = (function (executor) 
{ (executor)(resolve,reject);
return promise }
);
(((((Promise).resolve).call)(P,promise)).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (value) 
{ if (! value) {
{ ($DONE)("The promise should be rejected with a value.");
return }
};
if (((value).constructor) !== (TypeError)) {
{ ($DONE)("The promise should be rejected with a TypeError instance.");
return }
};
($DONE)() }
)var self, resolve;
var builtinResolve = ((Promise).resolve);
var thenable = ({then : function (r) 
{ resolve = r }
});
try { (Promise).resolve = function (v) 
{ return v }
;
self = ((Promise).race)([thenable]) }
 finally { (Promise).resolve = builtinResolve };
(resolve)(self);
((self).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (value) 
{ if (! value) {
{ ($DONE)("The promise should be rejected with a value.");
return }
};
if (((value).constructor) !== (TypeError)) {
{ ($DONE)("The promise should be rejected with a TypeError instance.");
return }
};
($DONE)() }
)