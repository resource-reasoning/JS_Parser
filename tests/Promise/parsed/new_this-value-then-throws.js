var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thrower = ({then : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(Test262Error,function () 
{ ((((Promise).prototype).catch).call)(thrower) }
)var thrower = (new (Promise)(function () 
{  }
));
(thrower).then = function () 
{ throw new (Test262Error)() }
;
((assert).throws)(Test262Error,function () 
{ ((((Promise).prototype).finally).call)(thrower) }
);
((assert).throws)(Test262Error,function () 
{ ((thrower).finally)() }
)var thrower = ({then : function () 
{ throw new (Test262Error)() }
});
((assert).throws)(Test262Error,function () 
{ ((((Promise).prototype).catch).call)(thrower) }
)var thrower = (new (Promise)(function () 
{  }
));
(thrower).then = function () 
{ throw new (Test262Error)() }
;
((assert).throws)(Test262Error,function () 
{ ((((Promise).prototype).finally).call)(thrower) }
);
((assert).throws)(Test262Error,function () 
{ ((thrower).finally)() }
)