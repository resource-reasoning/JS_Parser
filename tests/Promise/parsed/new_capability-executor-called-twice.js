var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var checkPoint = ("");
function fn1(executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
(fn1).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).allSettled).call)(fn1,[]);
((assert).sameValue)(checkPoint,"abc","executor initially called with no arguments");
checkPoint = "";
function fn2(executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
(fn2).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).allSettled).call)(fn2,[]);
((assert).sameValue)(checkPoint,"abc","executor initially called with (undefined, undefined)");
checkPoint = "";
function fn3(executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn3,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn3,[]) }
,"executor initially called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (undefined, function)");
checkPoint = "";
function fn4(executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn4,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn4,[]) }
,"executor initially called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (function, undefined)");
checkPoint = "";
function fn5(executor) 
{ checkPoint += "a";
(executor)("invalid value",123.);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn5,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn5,[]) }
,"executor initially called with (String, Number)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (String, Number)")var checkPoint = ("");
function fn1(executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
(fn1).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).race).call)(fn1,[]);
((assert).sameValue)(checkPoint,"abc","executor initially called with no arguments");
checkPoint = "";
function fn2(executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
(fn2).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).race).call)(fn2,[]);
((assert).sameValue)(checkPoint,"abc","executor initially called with (undefined, undefined)");
checkPoint = "";
function fn3(executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn3,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(fn3,[]) }
,"executor initially called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (undefined, function)");
checkPoint = "";
function fn4(executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn4,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(fn4,[]) }
,"executor initially called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (function, undefined)");
checkPoint = "";
function fn5(executor) 
{ checkPoint += "a";
(executor)("invalid value",123.);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn5,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(fn5,[]) }
,"executor initially called with (String, Number)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (String, Number)")var checkPoint = ("");
(((Promise).reject).call)(function (executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
,{});
((assert).sameValue)(checkPoint,"abc","executor initially called with no arguments");
var checkPoint = ("");
(((Promise).reject).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
,{});
((assert).sameValue)(checkPoint,"abc","executor initially called with (undefined, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
,{}) }
,"executor initially called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (undefined, function)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(function (executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
,{}) }
,"executor initially called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (function, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(function (executor) 
{ checkPoint += "a";
(executor)("invalid value",123.);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
,{}) }
,"executor initially called with (String, Number)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (String, Number)")var checkPoint = ("");
(((Promise).resolve).call)(function (executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
,{});
((assert).sameValue)(checkPoint,"abc","executor initially called with no arguments");
var checkPoint = ("");
(((Promise).resolve).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
,{});
((assert).sameValue)(checkPoint,"abc","executor initially called with (undefined, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
,{}) }
,"executor initially called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (undefined, function)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(function (executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
,{}) }
,"executor initially called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (function, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(function (executor) 
{ checkPoint += "a";
(executor)("invalid value",123.);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
,{}) }
,"executor initially called with (String, Number)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (String, Number)")var checkPoint = ("");
function fn1(executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
(fn1).resolve = function () 
{  }
;
(((Promise).all).call)(fn1,[]);
((assert).sameValue)(checkPoint,"abc","executor initially called with no arguments");
checkPoint = "";
function fn2(executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
(fn2).resolve = function () 
{  }
;
(((Promise).all).call)(fn2,[]);
((assert).sameValue)(checkPoint,"abc","executor initially called with (undefined, undefined)");
checkPoint = "";
function fn3(executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn3,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(fn3,[]) }
,"executor initially called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (undefined, function)");
checkPoint = "";
function fn4(executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn4,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(fn4,[]) }
,"executor initially called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (function, undefined)");
checkPoint = "";
function fn5(executor) 
{ checkPoint += "a";
(executor)("invalid value",123.);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn5,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(fn5,[]) }
,"executor initially called with (String, Number)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (String, Number)")var checkPoint = ("");
function fn1(executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
(fn1).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).allSettled).call)(fn1,[]);
((assert).sameValue)(checkPoint,"abc","executor initially called with no arguments");
checkPoint = "";
function fn2(executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
(fn2).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).allSettled).call)(fn2,[]);
((assert).sameValue)(checkPoint,"abc","executor initially called with (undefined, undefined)");
checkPoint = "";
function fn3(executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn3,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn3,[]) }
,"executor initially called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (undefined, function)");
checkPoint = "";
function fn4(executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn4,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn4,[]) }
,"executor initially called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (function, undefined)");
checkPoint = "";
function fn5(executor) 
{ checkPoint += "a";
(executor)("invalid value",123.);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn5,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn5,[]) }
,"executor initially called with (String, Number)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (String, Number)")var checkPoint = ("");
function fn1(executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
(fn1).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).race).call)(fn1,[]);
((assert).sameValue)(checkPoint,"abc","executor initially called with no arguments");
checkPoint = "";
function fn2(executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
(fn2).resolve = function () 
{ throw new (Test262Error)() }
;
(((Promise).race).call)(fn2,[]);
((assert).sameValue)(checkPoint,"abc","executor initially called with (undefined, undefined)");
checkPoint = "";
function fn3(executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn3,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(fn3,[]) }
,"executor initially called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (undefined, function)");
checkPoint = "";
function fn4(executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn4,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(fn4,[]) }
,"executor initially called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (function, undefined)");
checkPoint = "";
function fn5(executor) 
{ checkPoint += "a";
(executor)("invalid value",123.);
checkPoint += "b";
(executor)(function () 
{  }
,function () 
{  }
);
checkPoint += "c" }
;
((Object).defineProperty)(fn5,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(fn5,[]) }
,"executor initially called with (String, Number)");
((assert).sameValue)(checkPoint,"ab","executor initially called with (String, Number)")