$( document ).ready(function(){

    let toc_nodes = $("h1, h2, h3, h4, h5, h6").clone(false, false);
    toc_nodes.each(
        function(node){
            $("<a class="
              + this.localName
              + " href=#"
              + this.id
              + ">"
              + this.innerText
              + "</a>")
                .appendTo("#test")
        }
    )

});
