(function($) {

$(function() {



	$('ul.tabs').each(function() {

		$(this).find('li').each(function(i) {

			$(this).click(function(){

				$(this).addClass('current').siblings().removeClass('current')

					.parents('div.section').find('div.box').eq($(this).index()).fadeIn(150).siblings('div.box').hide();

			});

		});

	});



})

})(jQuery)