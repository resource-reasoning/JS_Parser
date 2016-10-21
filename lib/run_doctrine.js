var doctrine = require('doctrine');
var fs = require('fs');

if ((doctrine == undefined) || (doctrine == null))
{
	console.log("Doctrine not found.\n");
}
else {
	console.log (doctrine);
}

var comment = process.argv[2];
var output = process.argv[3];

var out = JSON.stringify(doctrine.parse(comment,
	{ unwrap : true,
	  tags : ["toprequires", "topensures", "topensureserr", "pre", "post", "posterr", "invariant", "codename", "preddefn"] }), null);
fs.writeFile(output, out, [], null);
