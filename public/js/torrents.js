$(".results ol").ready(function() {
    $.getJSON("/api/"+$page, function(data) {
	console.log(data);
	$.each(data['contents'], function(key,val) {
	    $(".results ol").append("<li><div class='actions'><a href='/magnet/"+val["id"]+"'><button class='btn-magnet'><img src='/img/magnet-icon.png' />Magnet</button></a></div>"+"<div class='name'>"+val['name']+"</div>"+"<div class='meta'><span class='downloads'>"+val["downloads"]+" download"+((parseInt(val["downloads"]) > 1)?"s":"")+"</span><span>&nbsp;|&nbsp;</span><span class='date'>Uploaded on "+new Date(Date.parse(val['created_at'])).toLocaleDateString()+"</span></div></li>");
	    console.log("ELEMENT MADE: "+val['name']);
	});
    })
});
