 <script language="JavaScript1.1">
<!--

/*
JavaScript Image slideshow:
By JavaScript Kit (www.javascriptkit.com)
Over 200+ free JavaScript here!
*/

var slideimages=new Array()
var slidelinks=new Array()
function slideshowimages(){
for (i=0;i<slideshowimages.arguments.length;i++){
slideimages[i]=new Image()
slideimages[i].src=slideshowimages.arguments[i]
}
}

function slideshowlinks(){
for (i=0;i<slideshowlinks.arguments.length;i++)
slidelinks[i]=slideshowlinks.arguments[i]
}

function gotoshow(){
if (!window.winslide||winslide.closed)
winslide=window.open(slidelinks[whichlink])
else
winslide.location=slidelinks[whichlink]
winslide.focus()
}

//-->
</script>

<a href="javascript:gotoshow()"><img src="images/Promo/Promo_Banner_3.jpg" name="slide" width="620" height="150" alt="ISE News Banner"></a>
  <script>
<!--

//configure the paths of the images, plus corresponding target links
slideshowimages("images/Promo/Promo_Banner_3.jpg", "images/Promo/Promo_Banner_1.jpg")
slideshowlinks("https://youtube.googleapis.com/v/-ScNJmjdlGo", "student-project-help.cfm")

//configure the speed of the slideshow, in miliseconds
var slideshowspeed=5000

var whichlink=0
var whichimage=0
function slideit(){
if (!document.images)
return
document.images.slide.src=slideimages[whichimage].src
whichlink=whichimage
if (whichimage<slideimages.length-1)
whichimage++
else
whichimage=0
setTimeout("slideit()",slideshowspeed)
}
slideit()

//-->
</script>