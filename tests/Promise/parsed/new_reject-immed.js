var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var simulation = ({});
var thenable = ({then : function (_,reject) 
{ (reject)(simulation) }
});
((((((Promise).allSettled)([thenable])).then)(function (settleds) 
{ (checkSettledPromises)(settleds,[{status : "rejected"; reason : simulation}]) }
)).then)($DONE,$DONE)var thenable = ({then : function (_,reject) 
{ (reject)() }
});
((((Promise).race)([thenable])).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function () 
{ ($DONE)() }
)var thenable = ({then : function (_,reject) 
{ (reject)() }
});
((((Promise).all)([thenable])).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (x) 
{ ($DONE)() }
)var simulation = ({});
var thenable = ({then : function (_,reject) 
{ (reject)(simulation) }
});
((((((Promise).allSettled)([thenable])).then)(function (settleds) 
{ (checkSettledPromises)(settleds,[{status : "rejected"; reason : simulation}]) }
)).then)($DONE,$DONE)var thenable = ({then : function (_,reject) 
{ (reject)() }
});
((((Promise).race)([thenable])).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function () 
{ ($DONE)() }
)