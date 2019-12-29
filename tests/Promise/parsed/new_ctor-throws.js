var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var BadCtor = (function () 
{ throw new (Test262Error)() }
);
var originalSpecies = (((Object).getOwnPropertyDescriptor)(Promise,(Symbol).species));
((Object).defineProperty)(Promise,(Symbol).species,{value : BadCtor});
try { var p = (new (Promise)(function (resolve) 
{ (resolve)() }
));
((assert).throws)(Test262Error,function () 
{ ((p).then)() }
) }
 finally { ((Object).defineProperty)(Promise,(Symbol).species,originalSpecies) }var BadCtor = (function () 
{ throw new (Test262Error)() }
);
var originalSpecies = (((Object).getOwnPropertyDescriptor)(Promise,(Symbol).species));
((Object).defineProperty)(Promise,(Symbol).species,{value : BadCtor});
try { var p = (new (Promise)(function (resolve) 
{ (resolve)() }
));
((assert).throws)(Test262Error,function () 
{ ((p).then)() }
) }
 finally { ((Object).defineProperty)(Promise,(Symbol).species,originalSpecies) }