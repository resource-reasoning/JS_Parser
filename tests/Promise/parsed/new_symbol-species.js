var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

((assert).sameValue)((Promise)[(Symbol).species],Promise,"Promise[Symbol.species] is Promise");
(verifyNotWritable)(Promise,(Symbol).species,(Symbol).species);
(verifyNotEnumerable)(Promise,(Symbol).species);
(verifyConfigurable)(Promise,(Symbol).species)((assert).sameValue)((Promise)[(Symbol).species],Promise,"Promise[Symbol.species] is Promise");
(verifyNotWritable)(Promise,(Symbol).species,(Symbol).species);
(verifyNotEnumerable)(Promise,(Symbol).species);
(verifyConfigurable)(Promise,(Symbol).species)