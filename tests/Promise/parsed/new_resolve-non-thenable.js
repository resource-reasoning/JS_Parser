var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var v1 = ({});
var v2 = ({});
var v3 = ({});
((((((Promise).allSettled)([v1, v2, v3])).then)(function (values) 
{ (checkSettledPromises)(values,[{status : "fulfilled"; value : v1}, {status : "fulfilled"; value : v2}, {status : "fulfilled"; value : v3}],"values") }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)).then)($DONE,$DONE)var value = ({});
var thenable = ({then : function (resolve) 
{ (resolve)(value) }
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
((((Promise).resolve)(value)).then)(function (value) 
{ if ((value) !== (value)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var v1 = ({});
var v2 = ({});
var v3 = ({});
((((Promise).all)([v1, v2, v3])).then)(function (values) 
{ if (! values) {
{ ($DONE)("The promise should be resolved with a value.");
return }
};
if (((values).constructor) !== (Array)) {
{ ($DONE)("The promise should be resolved with an Array instance.");
return }
};
if (((values).length) !== (3.)) {
{ ($DONE)("The promise should be resolved with an array of proper length.");
return }
};
if (((values)[0.]) !== (v1)) {
{ ($DONE)("The promise should be resolved with the correct element values (#1)");
return }
};
if (((values)[1.]) !== (v2)) {
{ ($DONE)("The promise should be resolved with the correct element values (#2)");
return }
};
if (((values)[2.]) !== (v3)) {
{ ($DONE)("The promise should be resolved with the correct element values (#3)");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var v1 = ({});
var v2 = ({});
var v3 = ({});
((((((Promise).allSettled)([v1, v2, v3])).then)(function (values) 
{ (checkSettledPromises)(values,[{status : "fulfilled"; value : v1}, {status : "fulfilled"; value : v2}, {status : "fulfilled"; value : v3}],"values") }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)).then)($DONE,$DONE)var value = ({});
var thenable = ({then : function (resolve) 
{ (resolve)(value) }
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