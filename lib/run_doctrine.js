var doctrine = require('doctrine');
var fs = require('fs');

var comment = process.argv[2];
var output = process.argv[3];

var out = JSON.stringify(doctrine.parse(comment, { unwrap : true, tags : ["toprequire", "topensure", "topensureerr", "require", "ensure", "ensureerr", "invariant", "codename", "preddefn"] }), null);
fs.writeFile(output, out, [], null);
