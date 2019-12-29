var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var checkPoint = ("");
function fn1(executor) 
{ checkPoint += "a" }
;
((Object).defineProperty)(fn1,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn1,[]) }
,"executor not called at all");
((assert).sameValue)(checkPoint,"a","executor not called at all");
checkPoint = "";
function fn2(executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b" }
;
((Object).defineProperty)(fn2,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn2,[]) }
,"executor called with no arguments");
((assert).sameValue)(checkPoint,"ab","executor called with no arguments");
checkPoint = "";
function fn3(executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b" }
;
((Object).defineProperty)(fn3,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn3,[]) }
,"executor called with (undefined, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, undefined)");
checkPoint = "";
function fn4(executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b" }
;
((Object).defineProperty)(fn4,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn4,[]) }
,"executor called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, function)");
checkPoint = "";
function fn5(executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b" }
;
((Object).defineProperty)(fn5,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn5,[]) }
,"executor called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (function, undefined)");
checkPoint = "";
function fn6(executor) 
{ checkPoint += "a";
(executor)(123.,"invalid value");
checkPoint += "b" }
;
((Object).defineProperty)(fn6,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn6,[]) }
,"executor called with (Number, String)");
((assert).sameValue)(checkPoint,"ab","executor called with (Number, String)")var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a" }
,[]) }
,"executor not called at all");
((assert).sameValue)(checkPoint,"a","executor not called at all");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b" }
,[]) }
,"executor called with no arguments");
((assert).sameValue)(checkPoint,"ab","executor called with no arguments");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b" }
,[]) }
,"executor called with (undefined, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b" }
,[]) }
,"executor called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, function)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b" }
,[]) }
,"executor called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (function, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a";
(executor)(123.,"invalid value");
checkPoint += "b" }
,[]) }
,"executor called with (Number, String)");
((assert).sameValue)(checkPoint,"ab","executor called with (Number, String)")var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(function (executor) 
{ checkPoint += "a" }
,{}) }
,"executor not called at all");
((assert).sameValue)(checkPoint,"a","executor not called at all");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(function (executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b" }
,{}) }
,"executor called with no arguments");
((assert).sameValue)(checkPoint,"ab","executor called with no arguments");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b" }
,{}) }
,"executor called with (undefined, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b" }
,{}) }
,"executor called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, function)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(function (executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b" }
,{}) }
,"executor called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (function, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(function (executor) 
{ checkPoint += "a";
(executor)(123.,"invalid value");
checkPoint += "b" }
,{}) }
,"executor called with (Number, String)");
((assert).sameValue)(checkPoint,"ab","executor called with (Number, String)")var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(function (executor) 
{ checkPoint += "a" }
,{}) }
,"executor not called at all");
((assert).sameValue)(checkPoint,"a","executor not called at all");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(function (executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b" }
,{}) }
,"executor called with no arguments");
((assert).sameValue)(checkPoint,"ab","executor called with no arguments");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b" }
,{}) }
,"executor called with (undefined, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b" }
,{}) }
,"executor called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, function)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(function (executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b" }
,{}) }
,"executor called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (function, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(function (executor) 
{ checkPoint += "a";
(executor)(123.,"invalid value");
checkPoint += "b" }
,{}) }
,"executor called with (Number, String)");
((assert).sameValue)(checkPoint,"ab","executor called with (Number, String)")var checkPoint = ("");
function fn1(executor) 
{ checkPoint += "a" }
;
((Object).defineProperty)(fn1,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(fn1,[]) }
,"executor not called at all");
((assert).sameValue)(checkPoint,"a","executor not called at all");
checkPoint = "";
function fn2(executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b" }
;
((Object).defineProperty)(fn2,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(fn2,[]) }
,"executor called with no arguments");
((assert).sameValue)(checkPoint,"ab","executor called with no arguments");
checkPoint = "";
function fn3(executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b" }
;
((Object).defineProperty)(fn3,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(fn3,[]) }
,"executor called with (undefined, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, undefined)");
checkPoint = "";
function fn4(executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b" }
;
((Object).defineProperty)(fn4,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(fn4,[]) }
,"executor called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, function)");
checkPoint = "";
function fn5(executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b" }
;
((Object).defineProperty)(fn5,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(fn5,[]) }
,"executor called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (function, undefined)");
checkPoint = "";
function fn6(executor) 
{ checkPoint += "a";
(executor)(123.,"invalid value");
checkPoint += "b" }
;
((Object).defineProperty)(fn6,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(fn6,[]) }
,"executor called with (Number, String)");
((assert).sameValue)(checkPoint,"ab","executor called with (Number, String)")var checkPoint = ("");
function fn1(executor) 
{ checkPoint += "a" }
;
((Object).defineProperty)(fn1,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn1,[]) }
,"executor not called at all");
((assert).sameValue)(checkPoint,"a","executor not called at all");
checkPoint = "";
function fn2(executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b" }
;
((Object).defineProperty)(fn2,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn2,[]) }
,"executor called with no arguments");
((assert).sameValue)(checkPoint,"ab","executor called with no arguments");
checkPoint = "";
function fn3(executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b" }
;
((Object).defineProperty)(fn3,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn3,[]) }
,"executor called with (undefined, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, undefined)");
checkPoint = "";
function fn4(executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b" }
;
((Object).defineProperty)(fn4,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn4,[]) }
,"executor called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, function)");
checkPoint = "";
function fn5(executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b" }
;
((Object).defineProperty)(fn5,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn5,[]) }
,"executor called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (function, undefined)");
checkPoint = "";
function fn6(executor) 
{ checkPoint += "a";
(executor)(123.,"invalid value");
checkPoint += "b" }
;
((Object).defineProperty)(fn6,"resolve",{get : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(fn6,[]) }
,"executor called with (Number, String)");
((assert).sameValue)(checkPoint,"ab","executor called with (Number, String)")var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a" }
,[]) }
,"executor not called at all");
((assert).sameValue)(checkPoint,"a","executor not called at all");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a";
(executor)();
checkPoint += "b" }
,[]) }
,"executor called with no arguments");
((assert).sameValue)(checkPoint,"ab","executor called with no arguments");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,undefined);
checkPoint += "b" }
,[]) }
,"executor called with (undefined, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a";
(executor)(undefined,function () 
{  }
);
checkPoint += "b" }
,[]) }
,"executor called with (undefined, function)");
((assert).sameValue)(checkPoint,"ab","executor called with (undefined, function)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a";
(executor)(function () 
{  }
,undefined);
checkPoint += "b" }
,[]) }
,"executor called with (function, undefined)");
((assert).sameValue)(checkPoint,"ab","executor called with (function, undefined)");
var checkPoint = ("");
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(function (executor) 
{ checkPoint += "a";
(executor)(123.,"invalid value");
checkPoint += "b" }
,[]) }
,"executor called with (Number, String)");
((assert).sameValue)(checkPoint,"ab","executor called with (Number, String)")