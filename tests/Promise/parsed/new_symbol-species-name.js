var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var descriptor = (((Object).getOwnPropertyDescriptor)(Promise,(Symbol).species));
((assert).sameValue)(((descriptor).get).name,"get [Symbol.species]")var descriptor = (((Object).getOwnPropertyDescriptor)(Promise,(Symbol).species));
((assert).sameValue)(((descriptor).get).name,"get [Symbol.species]")