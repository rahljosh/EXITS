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
    <td width="583" rowspan="2"><a href="http://www.smg-canada.org/"><img src="../images/logo.png" alt="Insert Logo Here" name="Insert_logo" width="583" height="81" id="Insert_logo" style=" display:block;" /></a></td>
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
 <h1>Harry Ainlay High School</h1>
 <hr /> <hr />
 <div class="slideDisplay">
<a href="javascript:gotoshow()"><img src="../ALschools/hPics/pic1.jpg" name="slide" border=1></a>
<script>
<!--

//configure the paths of the images, plus corresponding target links
slideshowimages("hPics/pic1.jpg","hPics/pic1.jpg")

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
 <br />  
 <p>Harry Ainlay is a large high school, ideally located in southern Edmonton. There are just under 2,200 students enrolled in grades 10-12 with approximately 85 international students attending each year. Harry Ainlay facilities are recognized as being among the best in the province. The school is equipped with computer labs, a fitness and weight training facility, a drama theater, two music labs, one of which is electronic, a language lab, a pottery studio, a cafeteria, and a bookstore. Community facilities adjacent to the school include a swimming pool, arena, playing fields, and tennis courts. Harry Ainlay High School offers many opportunities for students to become involved in both clubs and athletics including: Computer Club, Concert Band, Debate, Drama, International Club, Math, Ping-Pong, Science Olympics, School Newspaper, Badminton, Basketball, Cheerleading, Curling, Football, Golf, Soccer, Swimming, Track and Field, Volleyball and Wrestling. Harry Ainlay has a very extensive range of course offerings, a modern well equipped building, a talented and dedicated staff and a student group that is second to none. Ainlay students achieve superb results in academics, fine arts, career and technology studies and athletics. In addition to general academic courses, the school offers the International Baccalaureate (IB) program as well as an extensive ESL program. Harry Ainlay offers courses in Spanish, German and Japanese for study as second languages. The school also offers multilevel courses in French including French language arts and social studies. Students, faculty and staff assist international students in adapting to their new environment and creating an academic program at Harry Ainlay High School which is both challenging and exciting!  

</p>

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
