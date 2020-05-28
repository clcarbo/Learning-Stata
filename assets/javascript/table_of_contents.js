$( document ).ready(function(){

    let toc_nodes = $("h1, h2, h3, h4, h5, h6")
        .clone(false, false)
        .slice(start=2);
    toc_nodes.each(
        function(node){
            $("<a class="
              + this.localName
              + " href=#"
              + this.id
              + ">"
              + this.innerText
              + "</a>")
                .appendTo("#ToC")
        }
    )

});

$("#toc-btn").click(function(){
    if ($("#ToC").css("width") === "0px"){
        $("#ToC").css("width", "400px");
        $("#ToC").css("padding", "50px 10px 10px 20px");
    } else {
        $("#ToC").css("width", "0px");
        $("#ToC").css("padding", "50px 0px");
    }
});

$("#toc-close").click(function(){
    $("#ToC").css("width", "0px");
    $("#ToC").css("padding", "50px 0px");
});
