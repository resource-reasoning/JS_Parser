var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var thenResult = ({});
var Thenable = (function () 
{  }
);
((Thenable).prototype).then = function () 
{ return thenResult }
;
((assert).sameValue)(((((Promise).prototype).finally).call)(new (Thenable)()),thenResult)var thenResult = ({});
var Thenable = (function () 
{  }
);
((Thenable).prototype).then = function () 
{ return thenResult }
;
((assert).sameValue)(((((Promise).prototype).finally).call)(new (Thenable)()),thenResult)