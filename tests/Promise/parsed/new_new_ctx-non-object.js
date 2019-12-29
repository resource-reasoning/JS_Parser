var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(undefined,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(null,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(86.,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)("string",[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(true,[]) }
);
((((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)((Symbol)(),[]) }
))((assert).throws))(TypeError,function () 
{ (((Promise).race).call)(undefined,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(null,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(86.,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)("string",[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(true,[]) }
);
((((assert).throws)(TypeError,function () 
{ (((Promise).race).call)((Symbol)(),[]) }
))((assert).throws))(TypeError,function () 
{ (((Promise).reject).call)(undefined,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(null,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(86.,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)("string",[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)(true,[]) }
);
((((assert).throws)(TypeError,function () 
{ (((Promise).reject).call)((Symbol)(),[]) }
))((assert).throws))(TypeError,function () 
{ (((Promise).resolve).call)(undefined,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(null,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(86.,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)("string",[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)(true,[]) }
);
((((assert).throws)(TypeError,function () 
{ (((Promise).resolve).call)((Symbol)(),[]) }
))((assert).throws))(TypeError,function () 
{ (((Promise).all).call)(undefined,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(null,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(86.,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)("string",[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).all).call)(true,[]) }
);
((((assert).throws)(TypeError,function () 
{ (((Promise).all).call)((Symbol)(),[]) }
))((assert).throws))(TypeError,function () 
{ (((Promise).allSettled).call)(undefined,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(null,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(86.,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)("string",[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)(true,[]) }
);
((((assert).throws)(TypeError,function () 
{ (((Promise).allSettled).call)((Symbol)(),[]) }
))((assert).throws))(TypeError,function () 
{ (((Promise).race).call)(undefined,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(null,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(86.,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)("string",[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)(true,[]) }
);
((assert).throws)(TypeError,function () 
{ (((Promise).race).call)((Symbol)(),[]) }
)