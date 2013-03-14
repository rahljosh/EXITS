jQuery(document).ready(function(){
		jQuery('#rizal-option .openclose-feedback').click(function(){
		var target = jQuery(this).parent('.switch');
		var animator = {left: "-50"};
		var animator2 = {left: "-310"};
		
		if(target.is('.form-open')){
			
			target.animate(animator, function(){
				target.removeClass('rizal-option-false').addClass('feedback-form');
			});
			
			target.removeClass('form-open').addClass('form-close');
		}
		else{
			
			target.animate(animator2, function(){
				target.removeClass('rizal-option').addClass('rizal-option-false');
			});
			
			target.removeClass('form-close').addClass('form-open');
		}
		
	});
	
});