
<a href="javascript:gotoshow()"><img src="../images/schools/school1/pic9.jpg" name="slide" border=0 width=412 height=308></a>
<script>
<!--

//configure the paths of the images, plus corresponding target links
slideshowimages("../images/school1/pic1.jpg","../images/school1/pic2.jpg","../images/school1/pic3.jpg","../images/school1/pic4.jpg","../images/school1/pic5.jpg","../images/school1/pic6.jpg","../images/school1/pic7.jpg","../images/school1/pic8.jpg","../images/school1/pic9.jpg","../images/school1/pic10.jpg","../images/school1/pic11.jpg","../images/school1/pic12.jpg","../images/school1/pic13.jpg","../images/school1/pic14.jpg","../images/school1/pic15.jpg","../images/school1/pic16.jpg","../images/school1/pic17.jpg","../images/school1/pic18.jpg","../images/school1/pic19.jpg","../images/school1/pic20.jpg","../images/school1/pic21.jpg","../images/school1/pic22.jpg","../images/school1/pic23.jpg","../images/school1/pic24.jpg","../images/school1/pic25.jpg")

//configure the speed of the slideshow, in miliseconds
var slideshowspeed=2000

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
