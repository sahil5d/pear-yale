$(function() { //onload

	// home smooth scroll
	$('.scrollto, .gototop').bind('click',function(event){
		var $anchor = $(this);
		$('html, body').stop().animate({
			scrollTop: $($anchor.attr('href')).offset().top
		}, 1500,'easeInOutExpo');

		event.preventDefault();
	});

	// resize vimeo vid only on page load
	var vw = $("#vimeovid").width();
	$('#vimeovid').css({'height':vw*9/16.0+'px'});

});
