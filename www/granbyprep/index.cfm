<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<link rel="shortcut icon" href="favicon.ico" />
<script src="SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
<link href="SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />
<link href="css/granby.css" rel="stylesheet" type="text/css" />
<!--<script language="JavaScript1.1">


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


</script>//-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Granby Prep Academy</title>
<style type="text/css">
<!--
-->
</style></head>

<body class="oneColElsCtrHdr">

<div id="container">
  <div id="header">
  <div class="events">
  <a href="http://www.granbyprep.com/announcement.cfm"><img src="images/slideshow/pic5.jpg" name="slide" border=0 width=150 height=275></a>
<!--<script>
<a href="javascript:gotoshow()">

//configure the paths of the images, plus corresponding target links
slideshowimages("images/slideshow/pic5.jpg", "images/slideshow/pic2.jpg","images/slideshow/pic3.jpg","images/slideshow/pic4.jpg", "images/slideshow/pic5.jpg")
slideshowlinks("http://www.granbyprep.com/announcement.cfm", "https://www.granbyprep.com/admissions/index.cfm?","http://www.sss.nais.org/parents/","http://www.granbyprep.com/openhouse/openhouse.cfm", "http://www.granbyprep.com/announcement.cfm")

//configure the speed of the slideshow, in miliseconds
var slideshowspeed=3000

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

</script>
//-->


    </div>
    
    <!---- announcement 
  <div class="announcement">We are currently finalizing the changes to our site. <br /><br /> If you have any questions please email us at <br />
  info@granbyprep.com <br /><br /></div>---->
  
  <!-- end header --></div>
   <div id="menu">
<cfinclude template ="menu.cfm">
  </div>
  <div class="clearfix"></div>
<div id="mainIndex">
	<!-- end mainIndex --></div>
  <div id="footerIndex">
    <div class="info"><a href="/admissions"><img src="images/apply.png" width="78" height="21" alt="apply" border="0" /></a><img src="images/spacer.png" width="78" height="7" /><a href="requestInfo.cfm"><img src="images/request.png" width="78" height="20" alt="request" border="0" /></a></div>
    <div class="twitter"><a href="http://twitter.com/GranbyPrep"><img src="images/twitter.png" width="29" height="31" alt="twitter" border="0" /></a></div>
    <div class="infoLeft">International EC, LLC</div>
<!-- end footer --></div>
<!-- end container --></div>
<script type="text/javascript">
<!--
var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"SpryAssets/SpryMenuBarDownHover.gif", imgRight:"SpryAssets/SpryMenuBarRightHover.gif"});
//-->
</script>
</body>
</html>
