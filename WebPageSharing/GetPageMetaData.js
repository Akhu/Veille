var GetURL = function() {};
GetURL.prototype = {
    run: function(arguments) {
        
        var metas = document.getElementsByTagName('meta');
        var ogMetasKey = "og:";
        var ogData = {}
        
        for(var i = 0; i < metas.length; i++){
            if(metas[i] !== undefined){
                var currentMeta = metas[i];
                if(currentMeta.getAttribute('property') !== null && currentMeta.getAttribute('content') !== null){
                    if(currentMeta.getAttribute('property').indexOf(ogMetasKey) !== -1) {
                        var propertyKey = currentMeta.getAttribute('property')
                        ogData[propertyKey] = currentMeta.getAttribute('content');
                    }
                }
            }
        }
        arguments.completionFunction({ "ogTags" : ogData, "url" : document.URL, "title" : document.title });
    }
};
var ExtensionPreprocessingJS = new GetURL;

