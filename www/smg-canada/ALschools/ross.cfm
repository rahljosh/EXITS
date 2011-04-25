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
 <h1>Ross Sheppard High School</h1>
 <hr /> <hr />
 <div class="slideDisplay">
<a href="javascript:gotoshow()"><img src="Rpics/pic1.jpg" name="slide" border=1></a>
<script>
<!--

//configure the paths of the images, plus corresponding target links
slideshowimages("Rpics/pic1.jpg","Rpics/pic1.jpg")

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
<p>Ross Sheppard High School is located in a northwest Edmonton neighborhood, called Coronation Park, and is surrounded by an abundance of community facilities. The school serves the needs of over 2,000 students attending grades 10-12, including approximately 35 international students annually. Ross Sheppard provides a student environment that emphasizes commitment, responsibility and accountability characterized by high expectations for students and staff. Ross Sheppard School has a long history of excellence in all areas of instruction, including the standard academic program as well as International Baccalaureate (IB), physical education, careers and technology, fine arts, and practical arts. Languages offered other than English include American Sign Language, German, Mandarin, Spanish and all levels in French. Ross Sheppard offers an extensive co-curricular program of athletics, the arts, recreational and academic interests. It also boasts some impressive facilities such as an Olympic-sized swimming pool, covered ice arena, football and track stadium, three major playing fields, tennis courts, Telus World of Science, and the Commonwealth bowling green and clubhouse facilities. Ross Sheppard offers a unique, Elite Athlete Program that provides flexible scheduling for student athletes competing at provincial, national and/or international levels. The school features a Hockey, Soccer and Golf Skills Academy. Two resource centers, one located on each floor, are easily accessible and offer students a great deal of support with their academic studies. In addition, the Bookloft is a technology resource center for student use with word processing and tutorial programs for PC and Macintosh computers. The school has online access to both the University of Alberta and Edmonton Public Library Catalogues. They offer an outstanding selection of reference materials and literature. Students, faculty and staff also assist international students in adapting to their new environment and making the transition into Canadian culture as easy and seamless as possible.</p>
<p>. </p>
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
