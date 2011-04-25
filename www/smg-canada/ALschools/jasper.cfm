<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SMG Canada:</title>
<link rel="shortcut icon" href="../BCschools/ALschools/favicon.ico" />
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
    <td width="583" rowspan="2"><a href="http://www.smg-canada.org/"><img src="..//images/logo.png" alt="Insert Logo Here" name="Insert_logo" width="583" height="81" id="Insert_logo" style=" display:block;" /></a></td>
    <td width="142" align="right">119 Cooper Street, <br />
      Babylon, NY 11702<br />
      Phone: 1-631-893-4549   <br />
      Toll-free: 1-877-669-0717</td>
  </tr>
  <tr>
    <td align="right"><img src="../images/login_03.png" width="48" height="17" alt="login" /></td>
  </tr>
</table></div>

    <!-- end header --></div>
  <div class="brownBar"></div>
  <div class="clearfix"></div>
  <div class="blackBar"><cfinclude template="../includes/menu.cfm"></div>
  <div class="IndexBanner">
    <div class="brownBox">

<div class="mainContent">
 <h1>Jasper Place High School</h1>
 <hr /> <hr />
 <div class="slideDisplay">
<a href="javascript:gotoshow()"><img src="jaspPics/pic1.jpg" name="slide" border=1></a>
<script>
<!--

//configure the paths of the images, plus corresponding target links
slideshowimages("jaspPics/pic1.jpg","jaspPics/pic1.jpg")

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
<p>Jasper Place High School is located in west Edmonton and has a student population of approximately 2,300, enrolled in grades 10-12, including approximately 45 international students each year.  Jasper Place is an outstanding school with a tradition of excellence that has been in place for over 50 years. The school offers a full range of academic and optional programs as well as a wide variety of extracurricular opportunities. All general academic courses are offered along with a diverse selection of electives and language courses. Some of the languages offered include American Sign Language, Latin, French, German, Japanese and Spanish. Elective courses in Sports Medicine, Sculpture, Performing Arts, Film Studies and Business Technology are just a few of the extraordinary programs offered at Jasper Place. Advanced Placement, International Baccalaureate, and ESL programs are all offered for International students attending Jasper Place. The school also has partnerships with NAIT, the University of Alberta, and MacEwan University College whereby students completing coursework at Jasper Place will be eligible to receive credit for introductory coursework at these post-secondary institutions. The school offers fine arts and physical education courses and a large selection of Career and Technology Studies courses. Jasper Place High School offers students many opportunities to become involved in extracurricular activities. The school has numerous clubs, school events and athletic teams. Athletic teams include badminton, basketball, curling, football, golf, indoor soccer, volleyball, rugby, swimming and water polo. Students build leadership and citizenship skills through community activities, academic support, and student activities that promote a school spirit as well as a positive environment for learning. </p>
<br />
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
<strong>Edmonton Public Schools</strong>
<ul>
<li><a href="harry.cfm">Harry Ainlay</a></li>
<li><a href="jPercy.cfm">J. Percy Page</a></li>
<li><a href="jasper.cfm">Jasper Place</a></li>
<li><a href="ross.cfm">Ross Sheppard</a></li>
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
