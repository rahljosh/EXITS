<?php include 'extensions/includes/_pageHeader.php'; ?>


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
<body>
<?php include '_slidingLogin.php'; ?>
<div class="container">
  <?php include '_header.php'; ?>
  <div class="clearfloat">&nbsp;</div>
  <?php include '_menu.php'; ?>
<img src="images/study-abroad-header.jpg" width="1024" height="250" alt=" ISE student Scholarships" />

 <div class="clearfloat">&nbsp;</div>
  <div class="bannerCallout">
 <div class="fltrt" style="width: 200px; padding: 35px;"><a href="outbound-Information-Request.cfm" class="basicBlueButton">Request Information</a></div>
   <h1>Welcome to ISE Outbound Study Abroad</h1>
  <p>ISE is proud of the mission and objectives of Outbound and we know that American students make it the best program possible. ISE is dedicated to continuing this mission in the years to come and will do all it can to support and foster greater world peace and understanding.</p>
<!--end bannerCallout --></div>
 <div class="sidebar2">
   <div class="ltblueBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Study Abroad</h1></div>
  <div class="boxBrdRt">
    <p>Find out what ISE Outbound is all about!<a href="study-abroad-OUTBOUND.cfm"><br><br>
      details&#187;</a></p>
  </div>
   <div class="boxBrdLt"><a href="study-abroad-outbound.cfm"><img src="images/study-abroad-widget.jpg" width="109" height="111" alt="Ready to Host an exchange student"></a></div>
<!-- ltGreenBorder --></div>

  <div class="redBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Our Programs</h1></div>
      <div class="boxFlipRt"><a href="study-abroad-programs.cfm"><img src="images/study-abroad-programs.jpg" width="110" height="109" alt="Why host an exchange student"></a></div>
  <div class="boxFlipLt">
    <p>Check out what kind of Study Abroad Programs ISE has to offer!<a href="study-abroad-programs.cfm"><br>
      details&#187;</a></p>
  </div>

<!-- redBorder --></div>

  <div class="greenBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Available Countries</h1></div>
  <div class="boxBrdRt">
    <p>ISE puts the world at your fingertips, offering programs in many countries.<br> <a href="study-abroad-countries.cfm">
      details&#187;</a></p>
  </div>
   <div class="boxBrdLt"><a href="study-abroad-countries.cfm"><img src="images/travel_abroad_countries.jpg" width="109" height="110" alt="meet our students"></a></div>
<!-- greenBorder --></div>

  <div class="orangeBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Outbound FAQ</h1></div>
       <div class="boxFlipRt"><a href="study-abroad-faq.cfm"><img src="images/travel-abroad-faq.jpg" width="109" height="110" alt="Hosting Requirements"></a></div>
  <div class="boxFlipLt">
    <p>Almost any question you have about studying abroad is covered in this section.<a href="study-abroad-faq.cfm">
        details&#187;</a></p>
  </div>
<!-- orangeBorder --></div>

  <div class="dkblueBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Contact Information</h1></div>
     <p style="font-size: 80%; text-align: center;"><strong>Tom Policastro</strong><br>
       <em>Program Director</em><br>
      <a href="mailto:tom@iseusa.com">tom@iseusa.com</a><br>
<a href="tel:631-893-4540">(631) 893-4540</a> Ext: 104<br>
<br>
<strong>International Student Exchange</strong><br>
119 Cooper Street<br>
Babylon, NY 11702</p>
<!-- dk Blue Border --></div>

    <div class="clearfloat">&nbsp;</div>  
<!-- end sidebar 2 --></div>

<article class="contentLft">
<div class="dotLine">&nbsp;</div>
<div class="ImgR" style="width: 300px; margin: 5px 20px;"> <a href="javascript:gotoshow()"><img src="images/outbound/pic_02.jpg" name="slide" alt="study abroad" border=0 width=300 height=198></a>
<script>
<!--

//configure the paths of the images, plus corresponding target links
slideshowimages("images/outbound/pic_01.jpg", "images/outbound/pic_02.jpg","images/outbound/pic_03.jpg","images/outbound/pic_04.jpg","images/outbound/pic_05.jpg","images/outbound/pic_06.jpg","images/outbound/pic_07.jpg","images/outbound/pic_08.jpg","images/outbound/pic_09.jpg","images/outbound/pic_10.jpg")
slideshowlinks(
"http://www.119cooper.com",
"http://www.119cooper.com",
"http://www.119cooper.com",
"http://www.119cooper.com",
"http://www.119cooper.com",
"http://www.119cooper.com",
"http://www.119cooper.com",
"http://www.119cooper.com",
"http://www.119cooper.com",
"http://www.119cooper.com")

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
</div>
<h1>Study Abroad</h1>
<p>Outbound is a life-changing experience that allows high school students in the United States to learn the culture of another country. Outbound provides students an opportunity to gain new perspectives on an ever-changing world. International Student Exchange is dedicated to ensuring students get the most out of their Outbound experience, allowing them to grow and learn in preparation for their future:</p><br><br>
<h2>A Few Reasons to Study Abroad</h2>
<ul style="margin: 20px;">
  <li>Learn a new culture and gain a perspective on your own life in the United States that you can only obtain by living and studying in another country.</li>

<li>Stand out on a college application. As college admissions become more and more competitive, nothing is more unique and makes you shine brighter than studying abroad in another country for a semester or a year.</li>

<li>Knowledge of a second language is a valuable skill-set to have that can set you apart from others as you move forward in college and beyond.</li>

<li>In the 21st century, the world has become a more connected global community through the Internet and new technologies. However, there is no substitute for the in-person experience of meeting new people from other countries and exchanging our different cultures.</li>
<li>In a time where differences divide us, studying abroad is a fantastic way to remove boundaries and borders to learn that there is more that unites us than separates us.</li></ul>
   <div class="clearfloat">&nbsp;</div>

<div class="dotLine">&nbsp;</div>
<div class="clearfloat">&nbsp;</div>
<div align="center"><img src="images/outbound/outbound-countries.jpg" alt="" width="600" height="339" usemap="#Map"/>
  <map name="Map">
    <area shape="circle" coords="147,217,7" href="study-abroad-countries.cfm#div7">
   
      <area shape="rect" coords="163,258,184,317" href="study-abroad-countries.cfm#div1">
      <area shape="rect" coords="163,203,226,257" href="study-abroad-countries.cfm#div5">
      <area shape="rect" coords="472,229,548,289" href="study-abroad-countries.cfm#div2">
      <area shape="rect" coords="264,120,286,137" href="study-abroad-countries.cfm#div14">
      <area shape="rect" coords="295,113,312,133" href="study-abroad-countries.cfm#div12">
      <area shape="rect" coords="263,94,272,104" href="study-abroad-countries.cfm#div11">
      <area shape="rect" coords="272,80,286,105" href="study-abroad-countries.cfm#div8">
      <area shape="rect" coords="291,69,301,84" href="study-abroad-countries.cfm#div13">
      <area shape="rect" coords="301,60,314,88" href="study-abroad-countries.cfm#div15">
      <area shape="rect" coords="292,87,304,95" href="study-abroad-countries.cfm#div6">
      <area shape="rect" coords="278,105,295,121" href="study-abroad-countries.cfm#div9">
      <area shape="rect" coords="294,97,308,109" href="study-abroad-countries.cfm#div10">
      <area shape="rect" coords="296,109,314,114" href="study-abroad-countries.cfm#div3">
  </map>
</div>
</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>