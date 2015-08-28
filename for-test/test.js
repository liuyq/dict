$(function(){
function testAccess(j){
/*
    for(var q={},j=(j+"").split(""),u=j[0],s=u,v=[u],B=256,z,E=1;E<j.length;E++){
        z=j[E].charCodeAt(0);
        if(256 > z ){
            z = j[E];
        }else{
            z=q[z]?q[z]:s+u;
        }
        //z=256>z?j[E]:q[z]?q[z]:s+u;
        v.push(z);
        u=z.charAt(0);
        q[B]=s+u;
        B++;
        s=z;
    }
    alert(decodeURIComponent(escape(v.join(""))));
*/
    alert(j);
}
function clcikBtn(){
    var testUrl="http://danci.daydayup.info/nw";
    //var testUrl="bbb";
    
    var param = {};
    param.lg="zh";
    param.ID="test101";
    param.book="l_6/l_4";
    param.w="5";
    param.word="actual";
    $.ajax({url:testUrl,
            dataType : 'jsonp',
            data:param,
            crossDomain:true,
            type:"GET",
            success:testAccess});
};
$("#testBtn").click(
    function(){
        clcikBtn();
    }
);
});
