// We should be able to remove terms that are not actually
// referenced from the common definitions
var termNames = [] ;

function restrictReferences(utils, content) {
    var base = document.createElement("div");
    base.innerHTML = content;

    // strategy: Traverse the content finding all of the terms defined
    $.each(base.querySelectorAll("dfn"), function(i, item) {
        var $t = $(item) ;
        var titles = $t.getDfnTitles();
        var n = $t.makeID("dfn", titles[0]);
        if (n) {
            termNames[n] = $t.parent() ;
        }
    });

    // add a handler to come in after all the definitions are resolved

    respecEvents.sub('end', function(message) {
        if (message == 'core/link-to-dfn') {
            // all definitions are linked
            $("a.internalDFN").each(function () {
                var $item = $(this) ;
                var r = $item.attr('href').replace(/^#/,"") ;
                if (termNames[r]) {
                    delete termNames[r] ;
                }
            });
    // delete any terms that were not referenced.
            Object.keys(termNames).forEach(function(term) {
                var $p = $("#"+term) ;
                if ($p) {
                    var tList = $p.getDfnTitles();
                    $p.parent().next().remove();
                    $p.remove() ;
                    tList.forEach(function( item ) {
                        if (respecConfig.definitionMap[item]) {
                            delete respecConfig.definitionMap[item];
                        }
                    });
                }
            });
        }
    });

    return (base.innerHTML);
}