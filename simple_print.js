var esprima = require('esprima');
var fs = require('fs');

var filename = process.argv[2];
var outfile;

if (filename == '-') {
  // *nix only, but that's what we're targeting
  filename = '/dev/stdin';
  outfile = '-';
} else {
  outfile = filename.substring(0, (filename.length - 3)) + ".json";
}

fs.readFile(filename, "utf8", f);

function f(err, data) {
  var out = JSON.stringify(esprima.parse(data, {range: true}), null, 4);
  if (outfile == '-') {
    console.log(out);
  } else {
    fs.writeFile(outfile, out, function(){});
  }
}
