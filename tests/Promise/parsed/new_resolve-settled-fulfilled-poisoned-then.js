var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var value = ({});
var poisonedThen = (((Object).defineProperty)({},"then",{get : function () 
{ throw value }
}));
var p1 = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p2;
p2 = ((p1).then)(function () 
{ return poisonedThen }
);
((p2).then)(function (x) 
{ ($DONE)("The promise should not be fulfilled.") }
,function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The promise should be rejected with the thrown exception.");
return }
};
($DONE)() }
)var value = ({});
var poisonedThen = (((Object).defineProperty)({},"then",{get : function () 
{ throw value }
}));
var p1 = (new (Promise)(function (resolve) 
{ (resolve)() }
));
var p2;
p2 = ((p1).then)(function () 
{ return poisonedThen }
);
((p2).then)(function (x) 
{ ($DONE)("The promise should not be fulfilled.") }
,function (x) 
{ if ((x) !== (value)) {
{ ($DONE)("The promise should be rejected with the thrown exception.");
return }
};
($DONE)() }
)