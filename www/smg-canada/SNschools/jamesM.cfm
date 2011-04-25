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
 <h1>Bishop James Mahoney High School</h1>
 <hr /> <hr />
 <div class="slideDisplay">
<a href="javascript:gotoshow()"><img src="jamesPic/pic1.jpg" name="slide" border=1></a>
<script>
<!--

//configure the paths of the images, plus corresponding target links
slideshowimages("jamesPic/pic1.jpg","jamesPic/pic1.jpg")

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
Bishop James Mahoney High School offers some great programs for students in grades 9-12. There are currently just over 700 students attending and participating in the academic program at Bishop James Mahoney High School. Students are given the option to take classes in either French or English. Honors courses are also offered and designed for students whose academic achievement and rate of learning is well above average. The Advanced Placement Program offers college level courses and exams for high school students and is offered to students in grade 12. On the other end of the learning spectrum, modified courses are designed to meet the needs of students who are academically challenged in regular courses due to content or the pace of instruction. A wide range of services are available to students at Bishop James Mahoney High School such as chaplaincy, student's services counselors, learning assistance and ESL.  Bishop James Mahoney High School is dedicated to taking the extra step and helping each of their students succeed in every aspect of their program.<br />
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
<strong>Greater Saskatoon Catholic School District</strong>
  <ul>
  <li><a href="bethlehem.cfm">Bethlehem Catholic</a></li>
<li><a href="holycross.cfm">Holy Cross</a></li>
<li><a href="stJoseph.cfm">St. Joseph</a></li>
<li><a href="jamesM.cfm">Bishop James Mahoney</a></li>
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
