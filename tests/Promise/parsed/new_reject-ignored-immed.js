var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var simulation = ({});
var fulfiller = ({then : function (resolve) 
{ (resolve)(42.) }
});
var lateRejector = ({then : function (resolve,reject) 
{ (resolve)(simulation);
(reject)() }
});
((((((Promise).allSettled)([fulfiller, lateRejector])).then)(function (settleds) 
{ ((assert).sameValue)((settleds).length,2.);
((assert).sameValue)(((settleds)[0.]).status,"fulfilled");
((assert).sameValue)(((settleds)[0.]).value,42.);
((assert).sameValue)(((settleds)[1.]).status,"fulfilled");
((assert).sameValue)(((settleds)[1.]).value,simulation) }
)).then)($DONE,$DONE)var fulfiller = ({then : function (resolve) 
{ (resolve)() }
});
var rejector = ({then : function (_,reject) 
{ (reject)() }
});
((((Promise).race)([fulfiller, rejector])).then)(function () 
{ ($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var fulfiller = ({then : function (resolve) 
{ (resolve)() }
});
var lateRejector = ({then : function (resolve,reject) 
{ (resolve)();
(reject)() }
});
((((Promise).all)([fulfiller, lateRejector])).then)(function () 
{ ($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var simulation = ({});
var fulfiller = ({then : function (resolve) 
{ (resolve)(42.) }
});
var lateRejector = ({then : function (resolve,reject) 
{ (resolve)(simulation);
(reject)() }
});
((((((Promise).allSettled)([fulfiller, lateRejector])).then)(function (settleds) 
{ ((assert).sameValue)((settleds).length,2.);
((assert).sameValue)(((settleds)[0.]).status,"fulfilled");
((assert).sameValue)(((settleds)[0.]).value,42.);
((assert).sameValue)(((settleds)[1.]).status,"fulfilled");
((assert).sameValue)(((settleds)[1.]).value,simulation) }
)).then)($DONE,$DONE)var fulfiller = ({then : function (resolve) 
{ (resolve)() }
});
var rejector = ({then : function (_,reject) 
{ (reject)() }
});
((((Promise).race)([fulfiller, rejector])).then)(function () 
{ ($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)