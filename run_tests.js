var esprima = require("esprima");

function jsref_parse(s) {
    var parsed = esprima.parse(s, {range: true});
    var json = JSON.stringify(parsed, null, 4);
    return json;
}
