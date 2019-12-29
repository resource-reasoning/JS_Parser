var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var simulation = ({});
var fulfiller = ({then : function (resolve) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (resolve)(42.) }
) }
});
var rejector = ({then : function (resolve,reject) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (resolve)(simulation);
(reject)() }
) }
});
((((((Promise).allSettled)([fulfiller, rejector])).then)(function (settleds) 
{ ((assert).sameValue)((settleds).length,2.);
((assert).sameValue)(((settleds)[0.]).status,"fulfilled");
((assert).sameValue)(((settleds)[0.]).value,42.);
((assert).sameValue)(((settleds)[1.]).status,"fulfilled");
((assert).sameValue)(((settleds)[1.]).value,simulation) }
)).then)($DONE,$DONE)var fulfiller = ({then : function (resolve) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (resolve)() }
) }
});
var rejector = ({then : function (_,reject) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (reject)() }
) }
});
((((Promise).race)([fulfiller, rejector])).then)(function () 
{ ($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var fulfiller = ({then : function (resolve) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (resolve)() }
) }
});
var rejector = ({then : function (resolve,reject) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (resolve)();
(reject)() }
) }
});
((((Promise).all)([fulfiller, rejector])).then)(function () 
{ ($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)var simulation = ({});
var fulfiller = ({then : function (resolve) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (resolve)(42.) }
) }
});
var rejector = ({then : function (resolve,reject) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (resolve)(simulation);
(reject)() }
) }
});
((((((Promise).allSettled)([fulfiller, rejector])).then)(function (settleds) 
{ ((assert).sameValue)((settleds).length,2.);
((assert).sameValue)(((settleds)[0.]).status,"fulfilled");
((assert).sameValue)(((settleds)[0.]).value,42.);
((assert).sameValue)(((settleds)[1.]).status,"fulfilled");
((assert).sameValue)(((settleds)[1.]).value,simulation) }
)).then)($DONE,$DONE)var fulfiller = ({then : function (resolve) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (resolve)() }
) }
});
var rejector = ({then : function (_,reject) 
{ ((new (Promise)(function (resolve) 
{ (resolve)() }
)).then)(function () 
{ (reject)() }
) }
});
((((Promise).race)([fulfiller, rejector])).then)(function () 
{ ($DONE)() }
,function () 
{ ($DONE)("The promise should not be rejected.") }
)