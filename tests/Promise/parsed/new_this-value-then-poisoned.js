var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var poisonedThen = (((Object).defineProperty)({},"then",{get : function () 
{ throw new (Test262Error)() }
}));
((assert).throws)(Test262Error,function () 
{ ((((Promise).prototype).catch).call)(poisonedThen) }
)var poisonedThen = (((Object).defineProperty)(new (Promise)(function () 
{  }
),"then",{get : function () 
{ throw new (Test262Error)() }
}));
((assert).throws)(Test262Error,function () 
{ ((((Promise).prototype).finally).call)(poisonedThen) }
);
((assert).throws)(Test262Error,function () 
{ ((poisonedThen).finally)() }
)var poisonedThen = (((Object).defineProperty)({},"then",{get : function () 
{ throw new (Test262Error)() }
}));
((assert).throws)(Test262Error,function () 
{ ((((Promise).prototype).catch).call)(poisonedThen) }
)var poisonedThen = (((Object).defineProperty)(new (Promise)(function () 
{  }
),"then",{get : function () 
{ throw new (Test262Error)() }
}));
((assert).throws)(Test262Error,function () 
{ ((((Promise).prototype).finally).call)(poisonedThen) }
);
((assert).throws)(Test262Error,function () 
{ ((poisonedThen).finally)() }
)