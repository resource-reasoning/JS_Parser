var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var originalCallCount = (0.);
var newCallCount = (0.);
var P = (function (executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
);
(P).resolve = function () 
{ return newThenable }
;
var originalThenable = ({then : function () 
{ originalCallCount += 1. }
});
var newThenable = ({then : function () 
{ newCallCount += 1. }
});
(((Promise).allSettled).call)(P,[originalThenable]);
((assert).sameValue)(originalCallCount,0.,"original `then` method not invoked");
((assert).sameValue)(newCallCount,1.,"new `then` method invoked exactly once")var originalCallCount = (0.);
var newCallCount = (0.);
var P = (function (executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
);
(P).resolve = function () 
{ return newThenable }
;
var originalThenable = ({then : function () 
{ originalCallCount += 1. }
});
var newThenable = ({then : function () 
{ newCallCount += 1. }
});
(((Promise).race).call)(P,[originalThenable]);
((assert).sameValue)(originalCallCount,0.,"original `then` method not invoked");
((assert).sameValue)(newCallCount,1.,"new `then` method invoked exactly once")var originalCallCount = (0.);
var newCallCount = (0.);
var P = (function (executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
);
(P).resolve = function () 
{ return newThenable }
;
var originalThenable = ({then : function () 
{ originalCallCount += 1. }
});
var newThenable = ({then : function () 
{ newCallCount += 1. }
});
(((Promise).all).call)(P,[originalThenable]);
((assert).sameValue)(originalCallCount,0.,"original `then` method not invoked");
((assert).sameValue)(newCallCount,1.,"new `then` method invoked exactly once")var originalCallCount = (0.);
var newCallCount = (0.);
var P = (function (executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
);
(P).resolve = function () 
{ return newThenable }
;
var originalThenable = ({then : function () 
{ originalCallCount += 1. }
});
var newThenable = ({then : function () 
{ newCallCount += 1. }
});
(((Promise).allSettled).call)(P,[originalThenable]);
((assert).sameValue)(originalCallCount,0.,"original `then` method not invoked");
((assert).sameValue)(newCallCount,1.,"new `then` method invoked exactly once")var originalCallCount = (0.);
var newCallCount = (0.);
var P = (function (executor) 
{ (executor)(function () 
{  }
,function () 
{  }
) }
);
(P).resolve = function () 
{ return newThenable }
;
var originalThenable = ({then : function () 
{ originalCallCount += 1. }
});
var newThenable = ({then : function () 
{ newCallCount += 1. }
});
(((Promise).race).call)(P,[originalThenable]);
((assert).sameValue)(originalCallCount,0.,"original `then` method not invoked");
((assert).sameValue)(newCallCount,1.,"new `then` method invoked exactly once")