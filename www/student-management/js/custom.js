jQuery(document).ready(function(){

/*-----------------------------------------*/
//				TOGGLE CONTENT
/*-----------------------------------------*/
	
var toggleContent = function(){
	
	jQuery('.toggle-content').hide();  //hides the toggled content, if the javascript is disabled the content is visible
	jQuery('.toggle-link').click(function (e) {
		e.preventDefault();
		if (jQuery(this).is('.toggle-close')) {
			jQuery(this).removeClass('toggle-close').addClass('toggle-open').parent().next('.toggle-content').slideToggle(300);
			return false;
		} 
		
		else {
			jQuery(this).removeClass('toggle-open').addClass('toggle-close').parent().next('.toggle-content').slideToggle(300);
			return false;
		}
	});
}	
	
/*-----------------------------------------*/
//				PAGE SCROLL
/*-----------------------------------------*/

var rizalPageScroll = function(){
	
	$('#main-nav').localScroll();
	$('#main-nav li').click( function () {
		$('#main-nav li').removeClass("current");
		$(this).addClass("current");
	});	
	
	$('#logo h1 a').click(function(){ 		
		$('#main-nav li').removeClass("current");
		$('#main-nav li:first').addClass("current");
		$('html, body').animate({scrollTop: 0});
		
	});
}


	


/*-----------------------------------------*/
//				PORTFOLIO HOVER
/*-----------------------------------------*/


var rizalPortfolioHover = function(){
	$('#filter_container li').hover(function(){  
         $(".overlay", this).stop().animate({top:'0px'},{queue:false,duration:300});
		 $(this).stop().animate({ backgroundColor: "#febd1f"}, 800);  
		 
     }, function() {  
        $(".overlay", this).stop().animate({top:'220px'},{queue:false,duration:300});  
		$(this).stop().animate({ backgroundColor: "#fff" }, 800); 
	});
}	

            
/*-----------------------------------------*/
//				RIZAL LIGTHBOX
/*-----------------------------------------*/


var rizalLightbox = function(){
	$("a[rel^='prettyPhoto']").prettyPhoto({theme:'light_square'}); //choose between different styles / dark_rounded / light_rounded / dark_square / light_square / facebook /
}


/*-----------------------------------------*/
//				TAB
/*-----------------------------------------*/

var rizalTab = function(){
	$('.tab:first').show();
	$('.tabs li a').click(function(e){
		e.preventDefault();
		var id = $(this).attr('href');
		$('.tab').hide();
		$(id).fadeIn();
		$('.tabs li').find('a').removeClass('current-tab');
		$(this).addClass('current-tab');
		return false;
	});

}


/*-----------------------------------------*/
//				FILTERABLE PORTFOLIO
/*-----------------------------------------*/

var rizalFilterable = function(){
	var $filterType=$('.filter');
	var $applications=$('#filter_container');
	var $data=$applications.clone();
	$filterType.click(function(e){
		//alert("hello");
		e.preventDefault();
		$('html').css('overflow-y','scroll');
		$(this).parent().find("li").removeClass("active");
		$(this).addClass("active");
		if($(this).attr("data-type")=='all'){
			var $filteredData=$data.find('li');
		}else{
			var $filteredData=$data.find('li[data-type~='+$(this).attr("data-type")+']');
		}
	
	$applications.quicksand($filteredData,{duration:500,easing:'easeInOutQuad'},function(){
		rizalPortfolioHover();
		rizalLightbox();
	});
	
	});
}


var flickrHover = function(){
	$('#flickr-photos li a').hover(function(){
			//alert('hello');
			$(this).stop().animate({ backgroundColor: "#febd1f"}, 800);  
                },
		function() {  
			$(this).stop().animate({ backgroundColor: "#fff" }, 800);  
              }
		  
		);  
			
}



var getTweet = function(){
	$('#twitter').tweet({
		username: "microsoft",  //just enter your twitter username
		join_text: "auto",
		avatar_size: null,
		count: 1, //number of tweets showing
		auto_join_text_default: "",
		loading_text: "loading latest tweets..." //text displayed while loading tweets
	});	
}



/*-----------------------------------------*/
//				ICON HOVER EFFECTS
/*-----------------------------------------*/

var iconHover = function(){
	$("#social-icons li").append("<span></span>");	

	// Animate buttons, move reflection and fade

	$("#social-icons li a img").hover(function() {

		$(this).stop().animate({ marginTop: "-5px" }, 200);
		$(this).parent().find("span").stop().animate({ marginTop: "18px", opacity: 0.25 }, 200);
		},function(){
		$(this).stop().animate({ marginTop: "0px" }, 300);
		$(this).parent().find("span").stop().animate({ marginTop: "1px", opacity: 1 }, 300);
	});
}

//Icon Hover Effects
iconHover();
//Porfolio hover	
rizalPortfolioHover(); 
//lightbox	
rizalLightbox();
//Tab
rizalTab();	
//page scroll
rizalPageScroll();
//Porfolio Filterable
rizalFilterable();
//Fade links
$('a').hoverFadeColor();
//Flickr widget hover	
flickrHover();	
//get tweet text
getTweet();
//Toogle content
toggleContent();

	
	
});
	
/*-----------------------------------------*/
//				ACCORDION SLIDER
/*-----------------------------------------*/

function rizalAccordionSlider(){
	jQuery('.slideimage:hidden').fadeIn(2000); 
	jQuery("#accordion-slider.horizontal li").css('background', '#FFF'); 
	jQuery('.accordian-slider-caption').show();
	jQuery('.accordian-slider-captiontitle').show(); 
	jQuery('#accordion-slider').kwicks({ max : 655, spacing : -3 }); 
		jQuery(".accordian-slider-caption").fadeTo(1, 0); 
		jQuery(".slide-minicaption").fadeTo(1, 0.9); 
		jQuery("#accordion-slider").each(function () { 
			jQuery(".accordian-slider-image").hover(function() { 
					jQuery('.accordian-slider-caption').stop().animate({opacity: 0, left: '655'}, 900 );
					 
					jQuery(this).next('.accordian-slider-caption').stop().animate({opacity: 0.9, left: '0'}, 900 );
					jQuery(this).prev('.accordian-slider-logo').stop().animate({opacity: 0, left: '0'}, 300 ); 
				});	
				
			jQuery('#accordion-slider').mouseleave(function(){
					jQuery('.accordian-slider-caption').stop().animate({opacity: 0, left: '655'}, 900 ); 
					jQuery('.accordian-slider-logo').stop().animate({opacity: 1, left: '-20'}, 900 );
			});	
			
		}); 
}		




$(window).scroll(function(){
    if ($(this).scrollTop() > 100) {
        $('.scrollup').fadeIn();
    } else {
        $('.scrollup').fadeOut();
    }
});


$('.scrollup').click(function(){
    $("html, body").animate({ scrollTop: 0 }, 600);
    return false;
});


$(document).ready(function(){
 
    $(window).scroll(function(){
        if ($(this).scrollTop() > 100) {
            $('.scrollup').fadeIn();
        } else {
            $('.scrollup').fadeOut();
        }
    });

    $('.scrollup').click(function(){
        $("html, body").animate({ scrollTop: 0 }, 600);
        return false;
    });

});