<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SMG Canada:</title>
<link rel="shortcut icon" href="favicon.ico" />
<style type="text/css">
<!--
-->
</style>
<link href="../css/smgCanada.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="JavaScript">
<!--
function HideDIV(d) { document.getElementById(d).style.display = "none"; }
function DisplayDIV(d) { document.getElementById(d).style.display = "block"; }
//-->
</script>

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
</head>

<body>

<div class="container">
  <div class="brownBar"></div>
<div class="header">
<div class="clearfix"></div>
<div align="center"><table width="735" border="0">
  <tr>
    <td width="583" rowspan="2"><a href="http://www.smg-canada.org/"><img src="../images/logo.png" alt="Insert Logo Here" name="Insert_logo" width="583" height="81" id="Insert_logo" style=" display:block;" /></a></td>
    <td width="142" align="right">119 Cooper Street, <br />
      Babylon, NY 11702<br />
      Phone: 1-631-893-4549   <br />
      Toll-free: 1-877-669-0717</td>
  </tr>
  <tr>
    <td align="right"><img src="images/login_03.png" width="48" height="17" alt="login" /></td>
  </tr>
</table></div>

    <!-- end header --></div>
  <div class="brownBar"></div>
  <div class="clearfix"></div>
  <div class="blackBar"><cfinclude template="../includes/menu.cfm"></div>
  <div class="IndexBanner">
    <div class="brownBox">

<div class="mainContent">
 <h1>David Thompson Secondary</h1>
 <hr /> <hr />
 <div class="slideDisplay">
<a href="javascript:gotoshow()"><img src="DTpics/pic1.jpg" name="slide" border=1></a>
<script>
<!--

//configure the paths of the images, plus corresponding target links
slideshowimages("DTpics/pic1.jpg","DTpics/pic1.jpg")

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
</div>
<hr />
 David Thompson Secondary is the largest school in the district hosting close to 600 students from grades 8-12. Recently built, David Thompson Secondary is an architecturally impressive campus located just 20 minutes from Panorama ski resort. Some of its unique offerings are the onsite greenhouse, full production theatre, and chef training program.  Sports, such as baseball, cross country running, and curling compliment the traditional offering of sports like volleyball, basketball, golf, and badminton.  Unique academic course offerings include accounting, music composition, and digital media.   <br />
<hr />
<br />


 
 <!--end subcontent--> </div>
 
<div class="submenu">
	<cfinclude template="../includes/provinces.cfm">
<!--end submenu --></div>

   
   <!-- end brownBox --> </div>
  <!-- end indexBanner --></div>
  
  
<div class="content">
<div class="rightColumn">
<strong>Central Okanagan 
School District</strong>
  <ul>
<li><a href="Kelowna.cfm">Kelowna Senior</a></li>
<li><a href="rutland.cfm">Rutland Senior</a></li>
<li><a href="mtB.cfm">Mount Boucherie</a></li>
<li><a href="george.cfm">George Elliot</a></li>
<li><a href="okanagan.cfm">Okanagan Mission</a></li>
</ul>
<br />
<hr />
<strong>Sea to Sky School District</strong>
  <ul>
<li><a href="whistler.cfm">Whistler Secondary</a></li>
<li><a href="pemberton.cfm">Pemberton Secondary</a></li>
<li><a href="howe.cfm">Howe Sound Secondary</a></li>
</ul>
<br />
<hr />
<strong>Rocky Mountain School District</strong>
  <ul>
<li><a href="selkirk.cfm">Selkirk Secondary</a></li>
<li><a href="golden.cfm">Golden Secondary</a></li>
<li><a href="david.cfm">David Thompson</a></li>
</ul>
<br />
<hr />

<img src="../images/facebook.png" width="82" height="31" alt="facebook" align="center" />
<!-- end rightColumn --></div>

  
    <div class="clearfix"></div>
  <!-- end content --></div>
  <cfinclude template="../includes/footer.cfm">
  <!-- end container --></div>
</body>
</html>
