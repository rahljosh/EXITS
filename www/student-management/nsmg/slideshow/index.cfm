

<style type="text/css">
/*--Main Container--*/
.main_view {
	float: left;
	position: relative;
	margin-bottom: 5px;
	top: 0px;
	width: 400px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
	margin-left: 10px;
}
/*--Window/Masking Styles--*/
.window {
	height:200px;
	width: 400px;
	overflow: hidden; /*--Hides anything outside of the set width/height--*/
	position: relative;
}
.blackBar {
	display: block;
	height: 12px;
	width: 400px;
	background-image: url(slideshow/images/menu-bottom.png);
	background-repeat: repeat-x;
	background-color: #000;
	margin-left: 0px;
}
.image_reel {
	position: absolute;
	top: 0; left: 0;
}
.image_reel img {float: left;}

/*--Paging Styles--*/
.paging {
	position: absolute;
	bottom: 14px;
	right: -5px;
	width: 178px;
	height:37px;
	z-index: 100; /*--Assures the paging stays on the top layer--*/
	text-align: center;
	line-height: 28px;
	display: none; /*--Hidden by default, will be later shown with jQuery--*/
	background-image: url(slideshow/images/paging_bg2sm.png);
	background-repeat: no-repeat;
}
.paging a {
	padding: 3px;
	text-decoration: none;
	color: #fff;
}
.paging a.active {
	font-weight: bold;
	background: #920000;
	border: 1px solid #610000;
	-moz-border-radius: 3px;
	-khtml-border-radius: 3px;
	-webkit-border-radius: 3px;
}
.paging a:hover {font-weight: bold;}
</style>

<script>$(document).ready(function() {
//Show the paging and activate its first link
$(".paging").show();
$(".paging a:first").addClass("active");

//Get size of the image, how many images there are, then determin the size of the image reel.
var imageWidth = $(".window").width();
var imageSum = $(".image_reel img").size();
var imageReelWidth = imageWidth * imageSum;

//Adjust the image reel to its new size
$(".image_reel").css({'width' : imageReelWidth});
//Paging  and Slider Function
rotate = function(){
    var triggerID = $active.attr("rel") - 1; //Get number of times to slide
    var image_reelPosition = triggerID * imageWidth; //Determines the distance the image reel needs to slide

    $(".paging a").removeClass('active'); //Remove all active class
    $active.addClass('active'); //Add active class (the $active is declared in the rotateSwitch function)

    //Slider Animation
    $(".image_reel").animate({
        left: -image_reelPosition
    }, 500 );

}; 

//Rotation  and Timing Event
rotateSwitch = function(){
    play = setInterval(function(){ //Set timer - this will repeat itself every 7 seconds
        $active = $('.paging a.active').next(); //Move to the next paging
        if ( $active.length === 0) { //If paging reaches the end...
            $active = $('.paging a:first'); //go back to first
        }
        rotate(); //Trigger the paging and slider function
    }, 7000); //Timer speed in milliseconds (7 seconds)
};

rotateSwitch(); //Run function on launch
//On Hover
$(".image_reel a").hover(function() {
    clearInterval(play); //Stop the rotation
}, function() {
    rotateSwitch(); //Resume rotation timer
});	

//On Click
$(".paging a").click(function() {
    $active = $(this); //Activate the clicked paging
    //Reset Timer
    clearInterval(play); //Stop the rotation
    rotate(); //Trigger rotation immediately
    rotateSwitch(); // Resume rotation timer
    return false; //Prevent browser jump to link anchor
});

});</script>
<cfoutput>
<cfif client.companyshort is 'ISE'>
<div class="main_view">
    <div class="window">
        <div class="image_reel">
        <a href="slideshow/pdfs/ISE/Bonus-Sheet.pdf" rel="1" target="_new"> <img src="slideshow/images/ISE/BonusSheet.png" alt="" /></a>
        	<!---<a href="slideshow/pdfs/ISE/IncentiveTrip.pdf" rel="2" target="_new"> <img src="slideshow/images/ISE/londonIcon.png" alt="" /></a>--->
            <a href="slideshow/pdfs/ISE/PreAypBonus.pdf" rel="2" target="_new"> <img src="slideshow/images/ISE/slide_1.jpg" alt="" /></a>
           
            
            
        </div>
    </div>
    <div class="paging">
        <a href="slideshow/pdfs/ISE/Bonus-Sheet.pdf" rel="1">1</a>
    	 <!---<a href="slideshow/pdfs/ISE/IncentiveTrip.pdf" rel="2">2</a>--->
         <a href="slideshow/pdfs/ISE/PreAypBonus.pdf" rel="2">2</a>

         
    </div>
</div>
<cfelse>
<div class="main_view">
    <div class="window">
        <div class="image_reel">
        <a href="slideshow/pdfs/CASE/25th_anniversary_Bonus.pdf" rel="1" target="_new"><img src="slideshow/images/CASE/slide_3.jpg" alt="" /></a>
<!---         <a href="slideshow/pdfs/CASE/Early_Placement_Bonus_2013.pdf" rel="2" target="_new"><img src="slideshow/images/CASE/slide_2.jpg" alt="" /></a> ----> 
<!---        <a href="slideshow/pdfs/CASE/PreAypBonus.pdf" rel="3" target="_new"> <img src="slideshow/images/CASE/slide_1.jpg" alt="" /></a> ---->
       <a href="slideshow/pdfs/CASE/IncentiveTrip.pdf" rel="2" target="_new"> <img src="slideshow/images/CASE/londonIcon.png" alt="" /></a> 
        </div>
    </div>
    <div class="paging">
   		 <a href="slideshow/pdfs/CASE/25th_anniversary_Bonus.pdf" rel="1">1</a>
<!---        <a href="slideshow/pdfs/CASE/Early_Placement_Bonus_2013.pdf" rel="2">2</a> ----> 
<!---         <a href="slideshow/pdfs/CASE/PreAypBonus.pdf" rel="3">3</a> ---->
        <a href="slideshow/pdfs/CASE/IncentiveTrip.pdf" rel="2">2</a>
        
    </div>
</div>

</cfif>
</cfoutput>

