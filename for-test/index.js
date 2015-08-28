$(function(){
    function g(){
        var a=!1,c=$("#t-words").val();
        0>=$("#i-title").val().length&&(a=!0);
        var c=c.replace(/[^a-zA-Z ]/g," ").trim(), b=c.split(" ");
        0<c.length&&0<b.length&&36>=b.length?(e={},e.words=b):a=!0;
        $("#btn-go").prop("disabled",a);
        return a
    }
    function f(){
        var a=$("#div-ctrl").offset().top,c=$("#pb-area").offset();
        $("#info-area").css("top",c.top+$("#btn-replay").height()+25);
        c=$("#info-area").offset().top;
        $("#info-area").css("height",a-c-5);
        $("#info-area").css("width",$("#pb-area").width());
        $("#div-info").css("height",a-$("#div-info").offset().top-50);
        $("#div-acc").css("top",a-$("#div-info").offset().top);
        $("#div-acc").css("width",$("#div-info").width());
        parseInt($("#div-ctrl").css("width").replace("px",""))>mwinWidth&&$("#div-ctrl").css("width",mwinWidth-10)
    }
    function h(){
        $.ajax({url:"ads",type:"GET",success:function(a){
                $("#ads-0").html(a)
            }
        })
    }
    $("table#group td").click(function(){
            var a="#"+this.id.replace("t_","g_");
            $(".sub").hide();
            $(a).show()
        });
    var e=null;
    $("#btn-extract").click(function(){
        var a={};
        a.url=$("#i-url").val();
        $.ajax({url:"mine",data:a,type:"GET",success:function(a){
            for(var a=JSON.parse(a),b="",d=0;d<a.words.length;d++)
                b+='<li class="ui-widget-content">'+a.words[d]+"</li>";
            $("#o-right").html(b);
            b="";
            for(d=0;d<a.odds.length;d++)
                b+='<li class="ui-widget-content">'+a.odds[d]+"</li>";
            $("#o-left").html(b);
            e=a
            }})
        });
    $("#i-title").keydown(function(){g()});
    $("#t-words").keydown(function(){g()});
    $("#btn-go").click(function(){
        var a=$("#t-words").val(),c=$("#i-title").val(),a=a.replace(/[^a-zA-Z ]/g," "),a=a.split(" ");
        e.title=c;
        $.ajax({url:"mywords",
                data:JSON.stringify(e),
                type:"POST",
                success:function(a){window.location.href="/?book="+a}
        })
    });
    $(".t-menu td").click(function(){
        var a=$(this).attr("id");
        "m-danci"===a?
            1<$("#s-secname").html().length?
                ($(".active-area").hide(),$("#div-danci").show(),f()):
                "undefined"!==typeof localStorage.url&&null!=getURLParameter("book",localStorage.url)?
                    window.location.href=localStorage.url:alert('Please select a book first or add your words to "My Words".'):
                        "m-contact"!==a&&($(".active-area").hide(),"m-myword"===a?$("#div-mywords").show():"m-about"===a?$("#div-about").show():($(".t-items").hide(),a="#t-"+a.replace("m-",""),$(a).show(),$("#div-books").show()))});
    $("#logo").click(function(){window.location.href="/"});
    $("#menu-icon").click(function(){640>mwinWidth&&($(".active-area").hide(),$("#l-column").show())});
    640>mwinWidth&&($("#l-column").appendTo("#c-column"),$("#l-column").addClass("active-area"));
    window.addEventListener("resize",function(){f()},!1);
    f();
    window.setInterval(h,6E5);
    h()
});
