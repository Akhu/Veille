
var GetURL = function() {};
GetURL.prototype = {
run: function(arguments) {
    arguments.completionFunction({"bite": document.URL});
}
};
var ExtensionPreprocessingJS = new GetURL;
