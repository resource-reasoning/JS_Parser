var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var simulation = ({});
var thenable = ({then : function (_,reject) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (reject)(simulation) }
) }
});
((((((Promise).allSettled)([thenable])).then)(function (settleds) 
{ ((assert).sameValue)((settleds).length,1.);
((assert).sameValue)(((settleds)[0.]).status,"rejected");
((assert).sameValue)(((settleds)[0.]).reason,simulation) }
)).then)($DONE,$DONE)var thenable = ({then : function (_,reject) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (reject)() }
) }
});
((((Promise).race)([thenable])).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function () 
{ ($DONE)() }
)var thenable = ({then : function (_,reject) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (reject)() }
) }
});
((((Promise).all)([thenable])).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function (x) 
{ ($DONE)() }
)var simulation = ({});
var thenable = ({then : function (_,reject) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (reject)(simulation) }
) }
});
((((((Promise).allSettled)([thenable])).then)(function (settleds) 
{ ((assert).sameValue)((settleds).length,1.);
((assert).sameValue)(((settleds)[0.]).status,"rejected");
((assert).sameValue)(((settleds)[0.]).reason,simulation) }
)).then)($DONE,$DONE)var thenable = ({then : function (_,reject) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (reject)() }
) }
});
((((Promise).race)([thenable])).then)(function () 
{ ($DONE)("The promise should not be fulfilled.") }
,function () 
{ ($DONE)() }
)