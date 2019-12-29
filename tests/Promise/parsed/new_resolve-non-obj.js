var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thenable = ({then : function (resolve) 
{ (resolve)(23.) }
});
((((Promise).race)([thenable])).then)(function (value) 
{ if ((value) !== (23.)) {
{ ($DONE)("The promise should be resolved with the correct value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)((((Promise).resolve)(23.)).then)(function (value) 
{ if ((value) !== (23.)) {
{ ($DONE)("The promise should be fulfilled with the provided value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var thenable = ({then : function (resolve) 
{ (resolve)(23.) }
});
((((Promise).race)([thenable])).then)(function (value) 
{ if ((value) !== (23.)) {
{ ($DONE)("The promise should be resolved with the correct value.");
return }
};
($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)