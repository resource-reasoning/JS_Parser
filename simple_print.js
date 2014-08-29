var esprima = require('esprima');
var fs = require('fs');
var filename = process.argv[2];
fs.readFile(filename, "utf8", f);

function f(err, data) {
  var out = JSON.stringify(esprima.parse(data, {range: true}), null, 4);
  var output = filename.substring(0, (filename.length - 3)) + ".json";
  fs.writeFile(output, out, [], null);
}
