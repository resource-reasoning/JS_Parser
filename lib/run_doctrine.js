var doctrine = require('doctrine');
var getStdin = require('get-stdin');

getStdin().then(function (str) {
	var out = JSON.stringify(doctrine.parse(str,
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
		          "tactic",
		          "lemma"] }), null);
	process.stdout.write(out);
});
