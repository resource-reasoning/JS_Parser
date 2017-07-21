var doctrine = require('doctrine');
var fs = require('fs');

var comment = process.argv[2];
var output = process.argv[3];

fs.readFile(comment, 'utf8', function (err,data) {
	if (err) {
		process.stdout.write("Horrible error.\n")
	}

	comment = data;

	var out = JSON.stringify(doctrine.parse(comment,
		{ unwrap : true,
		  tags : ["toprequires", 
		          "topensures", 
		          "topensureserr", 
		          "pre", 
		          "post", 
		          "posterr", 
		          "id", 
		          "pred", 
		          "onlyspec",
		          "invariant",
		          "tactic"] }), null);
	fs.writeFile(output, out, [], null);
});
