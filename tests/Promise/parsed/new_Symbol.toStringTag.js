var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

((assert).sameValue)(((Promise).prototype)[(Symbol).toStringTag],"Promise");
(verifyNotEnumerable)((Promise).prototype,(Symbol).toStringTag);
(verifyNotWritable)((Promise).prototype,(Symbol).toStringTag);
(verifyConfigurable)((Promise).prototype,(Symbol).toStringTag)((assert).sameValue)(((Promise).prototype)[(Symbol).toStringTag],"Promise");
(verifyNotEnumerable)((Promise).prototype,(Symbol).toStringTag);
(verifyNotWritable)((Promise).prototype,(Symbol).toStringTag);
(verifyConfigurable)((Promise).prototype,(Symbol).toStringTag)