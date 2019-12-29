var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var CustomPromise = (function () 
{ throw new (Test262Error)() }
);
((assert).throws)(Test262Error,function () 
{ (((Promise).allSettled).call)(CustomPromise) }
)var CustomPromise = (function () 
{ throw new (Test262Error)() }
);
((assert).throws)(Test262Error,function () 
{ (((Promise).race).call)(CustomPromise) }
)var CustomPromise = (function () 
{ throw new (Test262Error)() }
);
((assert).throws)(Test262Error,function () 
{ (((Promise).reject).call)(CustomPromise) }
)var CustomPromise = (function () 
{ throw new (Test262Error)() }
);
((assert).throws)(Test262Error,function () 
{ (((Promise).resolve).call)(CustomPromise) }
)var CustomPromise = (function () 
{ throw new (Test262Error)() }
);
((assert).throws)(Test262Error,function () 
{ (((Promise).all).call)(CustomPromise) }
)var CustomPromise = (function () 
{ throw new (Test262Error)() }
);
((assert).throws)(Test262Error,function () 
{ (((Promise).allSettled).call)(CustomPromise) }
)var CustomPromise = (function () 
{ throw new (Test262Error)() }
);
((assert).throws)(Test262Error,function () 
{ (((Promise).race).call)(CustomPromise) }
)