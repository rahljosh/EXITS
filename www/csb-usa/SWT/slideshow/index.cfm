
<script type="text/javascript" src="js/jquery-1.3.1.min.js"></script>
<script type="text/javascript">

$(document).ready(function() {		
	
	//Execute the slideShow, set 4 seconds for each images
	slideShow(3000);

});

function slideShow(speed) {


	//append a LI item to the UL list for displaying caption
	$('ul.slideshow').append('<li id="slideshow-caption" class="caption"><div class="slideshow-caption-container"><h3></h3><p></p></div></li>');

	//Set the opacity of all images to 0
	$('ul.slideshow li').css({opacity: 0.0});
	
	//Get the first image and display it (set it to full opacity)
	$('ul.slideshow li:first').css({opacity: 1.0});
	
	//Get the caption of the first image from REL attribute and display it
	$('#slideshow-caption h3').html($('ul.slideshow a:first').find('img').attr('title'));
	$('#slideshow-caption p').html($('ul.slideshow a:first').find('img').attr('alt'));
		
	//Display the caption
	$('#slideshow-caption').css({opacity: 0.7, bottom:0});
	
	//Call the gallery function to run the slideshow	
	var timer = setInterval('gallery()',speed);
	
	//pause the slideshow on mouse over
	$('ul.slideshow').hover(
		function () {
			clearInterval(timer);	
		}, 	
		function () {
			timer = setInterval('gallery()',speed);			
		}
	);
	
}

function gallery() {


	//if no IMGs have the show class, grab the first image
	var current = ($('ul.slideshow li.show')?  $('ul.slideshow li.show') : $('#ul.slideshow li:first'));

	//Get next image, if it reached the end of the slideshow, rotate it back to the first image
	var next = ((current.next().length) ? ((current.next().attr('id') == 'slideshow-caption')? $('ul.slideshow li:first') :current.next()) : $('ul.slideshow li:first'));
		
	//Get next image caption
	var title = next.find('img').attr('title');	
	var desc = next.find('img').attr('alt');	

	//Set the fade in effect for the next image, show class has higher z-index
	next.css({opacity: 0.0}).addClass('show').animate({opacity: 1.0}, 1000);
	
	//Hide the caption first, and then set and display the caption
	$('#slideshow-caption').slideToggle(300, function () { 
		$('#slideshow-caption h3').html(title); 
		$('#slideshow-caption p').html(desc); 
		$('#slideshow-caption').slideToggle(500); 
	});		

	//Hide the current image
	current.animate({opacity: 0.0}, 2000).removeClass('show');

}
</script>
<style type="text/css">

ul.slideshow {
	list-style:none;
	width:275px;
	height:206px;
	overflow:hidden;
	position:relative;
	margin:0;
	padding:0;
	
}	

ul.slideshow li {
	position:absolute;
	left:0;
	right:0;
}

ul.slideshow li.show {
	z-index:500;	
}

ul img {
	border:none;	
}


#slideshow-caption {
	width:275px;
	height:55px;
	position:absolute;
	bottom:0;
	left:0;
	color:#fff;
	background:#000;
	z-index:500;
	
}

#slideshow-caption .slideshow-caption-container {
	padding:5px 10px;		
	z-index:1000;
}

#slideshow-caption h3 {
	padding:0;
	font-size:12px;
	font-family: Arial, Helvetica, sans-serif;
	line-height: 15px;
	margin-top: 0;
	margin-right: 0;
	margin-bottom: 0;
	margin-left: 0;
}

#slideshow-caption p {
	padding:0;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	text-align: left;
	line-height: 12px;
	margin-top: 0px;
	margin-right: 0;
	margin-bottom: 0;
	margin-left: 0;
}

</style>

<ul class="slideshow">
	<li class="show"><a href="http://www.csb-usa.com/SWT/participants.cfm?section=photo"><img src="slideshow/images/pic3.jpg" width="275" height="206" title="Photo Summer 2011" alt="Galveston, TX (Katerina S. & Eliska S., Czech Republic)"/></a></li>
	<li><a href="http://www.csb-usa.com/SWT/participants.cfm?section=photo"><img src="slideshow/images/pic4.jpg" width="275" height="206" title="Photo Summer 2011" alt="Galveston, TX (Katerina S., Czech Republic)"/></a></li>
	<li><a href="http://www.csb-usa.com/SWT/participants.cfm?section=photo"><img src="slideshow/images/pic1.jpg"width="275" height="206" title="Photo Summer 2011" alt="Rocky Mountain National Park in Estes Park, CO (Iryna G., Ukraine)"/></a></li>
    <li><a href="http://www.csb-usa.com/SWT/participants.cfm?section=photo"><img src="slideshow/images/pic2.jpg" width="275" height="206" title="Photo Summer 2011" alt="Rocky Mountain National Park in Estes Park, CO (Iryna G., Ukraine)"/></a></li>
    <li><a href="http://www.csb-usa.com/SWT/participants.cfm?section=photo"><img src="slideshow/images/pic5.jpg" width="275" height="206" title="Photo Summer 2011" alt="Rocky Mountain National Park in Estes Park, CO (Iryna G., Ukraine)"/></a></li>
    <li><a href="http://www.csb-usa.com/SWT/participants.cfm?section=photo"><img src="slideshow/images/pic6.jpg" width="275" height="206" title="Photo Summer 2011" alt="Rocky Mountain National Park in Estes Park, CO (Iryna G., Ukraine)"/></a></li>
     <li><a href="http://www.csb-usa.com/SWT/participants.cfm?section=photo"><img src="slideshow/images/pic7.jpg" width="275" height="206" title="Photo Summer 2011" alt="Niagara Falls, NY (Biao C., China)"/></a></li>
</ul>


