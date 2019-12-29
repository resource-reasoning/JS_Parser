var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var other = (((($262).createRealm)()).global);
var C = (new ((other).Function)());
(C).prototype = null;
var o = (((Reflect).construct)(Promise,[function () 
{  }
],C));
((assert).sameValue)(((Object).getPrototypeOf)(o),((other).Promise).prototype)