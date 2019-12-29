var assert = require("../harness/assert").assert;
var Promise = require("../../../js/Promises/Promise").Promise;

var desc = (((Object).getOwnPropertyDescriptor)(Promise,(Symbol).species));
var thisValue = ({});
((assert).sameValue)((((desc).get).call)(thisValue),thisValue)var desc = (((Object).getOwnPropertyDescriptor)(Promise,(Symbol).species));
var thisValue = ({});
((assert).sameValue)((((desc).get).call)(thisValue),thisValue)