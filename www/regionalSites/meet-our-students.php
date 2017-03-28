<?PHP
	session_start();
	include 'extensions/_pageHeader.php';
	//include 'dBug.php'; 
	//new dBug($_SESSION); 
	
$quotes = file("_quotes.txt");
srand((double)microtime() * 1000000);
$ranNum = rand(0, count($quotes)-1);

include 'extensions/_pageHeader.php'; ?>
<?php
$quotes = file("_quotes.txt");
srand((double)microtime() * 1000000);
$ranNum = rand(0, count($quotes)-1);
?>
<script language="javascript" type="text/javascript">
function showHide(shID) {
   if (document.getElementById(shID)) {
      if (document.getElementById(shID+'-show').style.display != 'none') {
         document.getElementById(shID+'-show').style.display = 'none';
         document.getElementById(shID).style.display = 'block';
      }
      else {
         document.getElementById(shID+'-show').style.display = 'inline';
         document.getElementById(shID).style.display = 'none';
      }
   }
}
</script>
<style type="text/css">
<!--

 /* This CSS is used for the Show/Hide functionality. */
   .more, .more1, .more2, .more3, .more4, .more5 {
	display: none;
	/* [disabled]border-top-width: 1px; */
	/* [disabled]border-bottom-width: 1px; */
	/* [disabled]border-top-style: solid; */
	/* [disabled]border-bottom-style: solid; */
	/* [disabled]border-top-color: #CCC; */
	/* [disabled]border-bottom-color: #CCC; */
}
   a.showLink {
	text-decoration: none;
	color: #00406B;
	padding-left: 8px;
	background: transparent url(down.gif) no-repeat left;
	font-size: 10px;
	font-weight: bold;
}
a.hideLink {
	text-decoration: none;
	color: #00406B;
	padding-left: 8px;
	background: transparent url(down.gif) no-repeat left;
	font-size: 9px;
	font-weight: bold;
}
   a.hideLink {
      background: transparent url(up.gif) no-repeat left; }
   a.showLink:hover, a.hideLink:hover {
      border-bottom: 1px dotted #36f; }

-->
</style>
<body>

<body>

<?php include '_slidingLogin.php'; ?>
<div class="container">
  <?php include '_header.php'; ?>
  <div class="clearfloat">&nbsp;</div>

<img src="images/header-pic.jpg" alt="" width="1024" height="250" align="absbottom"/>
  <?php include '_menu.php'; ?>
  <div class="sidebar2">
  <aside>
  <div class="dotLine">&nbsp;</div>
   <h2>View Our Students</h2>
     <div class="dotLine">&nbsp;</div> 
       <?php
  if(!isset($_COOKIE['iseLead']))
		{
		echo '<p>Due to Department of State regulations, we ask you to fill out this form to view our current students.  Once you fill out the form below, you will be permitted to view select student profiles.</p>';
		 include 'formTemplates/_ReadyHostForm.php'; 
		} else  {
		 echo '<h3>Thank you for your interest in becoming a host family!</h3>';
		  echo '<p>You can view limited profiles of students who are here or will be arriing in the US shorlty.</p>';
		  echo '<div align="center"><form method="post" action="viewStudents.php">
				<input type="hidden" name="lastName" value='.$_POST[lastname].'>
				<input type="hidden" name="iseLead" value=1>
				<input type="submit" value="View Student Profiles" class="basicBlueButton"> 
			</form></div>';
	};
   ?>
   <div class="clearfloat">&nbsp;</div>

  <div class="dotLine">&nbsp;</div>
  </aside>
  </div>
  <article class="contentLft">
<div class="dotLine">&nbsp;</div>
<h1>Meet Our Exchange Students</h1>
<p>Every ISE student is personally interviewed, screened and evaluated.</p><div class="dotLine">&nbsp;</div>
<h2>Every student application provides the following:</h2>
<ul>
<li>A biography and letters from the natural parents and student</li>
<li>Photographs</li>
<li>References</li>
<li>Original transcripts of grades</li>
<li>Medical records</li>
<li>Signed letter of agreement to abide by the ISE program guidelines.</li></ul><br>
<p>Every student is given an Orientation prior to departing his/her native country to inform and prepare them for their stay in the U.S.</p>



<div class="blueLine">&nbsp;</div>
<h3>This Is A Sample ISE Profile Based On Real Student Experiences</h3>

<div class="columnInline" style="font-size: 60%;">
<table border="0">
  <tr>
    <td align="center"><a href="pdfs/studentProfiles/Bolin-China.pdf" target="_blank" ><img src="images/meetStudents/china.jpg" alt="China Students" width="83" height="83" align="texttop" /> details >></a></td>
    <td>Bolin, China<br>
15, Female<br><br>
Program Length: Academic year<br><br>
Interests: Arts & Crafts, Reading, School Theatre, Movies</td>
  </tr>
</table>
</div>

<div class="columnInline" style="font-size: 60%;">
<table border="0">
  <tr>
    <td align="center"><a href="pdfs/studentProfiles/Camila-Brazil.pdf" target="_blank"><img src="images/meetStudents/brazil.jpg" alt="Brazil Students" width="83" height="83" align="texttop" /> details >></a></td>
    <td>Camila, Brazil<br>
16, Female<br>
<br>
Program Length: Academic year<br><br>
Interests: Horses, Writing, Surfing</td>
  </tr>
</table>
</div>

<div class="columnInline" style="font-size: 60%;">
<table border="0">
  <tr>
    <td align="center"><a href="pdfs/studentProfiles/Johann-Germany.pdf" target="_blank"><img src="images/meetStudents/germany.jpg" alt="German Students" width="83" height="83" align="texttop" /> details >></a></td>
    <td align="left">Johann, Germany<br>
17, Male<br>
<br>
Program Length: Academic year<br><br>
Interests: Music, Guitar, Trumpet, Basketball</td>
  </tr>
</table>
</div>

<div class="columnInline" style="font-size: 60%;">
<table border="0">
  <tr>
    <td align="center"><a href="pdfs/studentProfiles/mariana-spain.pdf" target="_blank"><img src="images/meetStudents/spain.jpg" alt="Spain Students" width="83" height="83" align="texttop" /> details >></a></td>
    <td>Mariana, Spain<br>
16, Female<br>
<br>
Program Length: Academic year<br><br>
Interests: Piano, Church, Travel</td>
  </tr>
</table>
</div>

<div class="columnInline" style="font-size: 60%;">
<table border="0">
  <tr>
    <td height="110" align="center"><a href="pdfs/studentProfiles/Mun-Hee-SouthKorea.pdf" target="_blank"><img src="images/meetStudents/korea.jpg" alt="Korea Students" width="83" height="83" align="texttop" /> details >></a></td>
    <td>Mun-Hee, S. Korea<br>
18, Female<br>
<br>
Program Length: Academic year<br><br>
Interests: Soccer, Popular music, School</td>
  </tr>
</table>
</div>

<div class="columnInline" style="font-size: 60%;">
<table border="0">
  <tr>
    <td align="center"><a href="pdfs/studentProfiles/Jussi-Finland.pdf" target="_blank"><img src="images/meetStudents/finland.jpg" alt="Finland Students" width="83" height="83" align="texttop" /> details >></a></td>
    <td>Jussi, Finland<br>
16, Male<br>
<br>
Program Length: Academic year<br><br>
Interest: Soccer, TV, Clubs, Travel</td>
  </tr>
</table>
</div>


<div class="clearfloat" style="height: 20px;">&nbsp;</div>
<div style="background-color: #FFC; padding: 20px 20px 5px 20px; font-style: italic; width: 90%; margin: 10px auto;">
<p style="color: #16468E; font-style: italic;">Due to Department of State regulations, we ask you to fill out the form on the right to view our current students.  Once you fill out this form, you will be permitted to view select student profiles.</p>
<p style="color: #16468E; font-style: italic;">If you have already spoken with an ISE representative and are ready to host, then please hit the login button at the top of the page to start your Host Family Application.  You must have an email from an ISE representative that contains instructions and login information before you can start your Host Family Application.</p>
</div> 
<div class="blueLine">&nbsp;</div>
<div class="clearfloat" style="height: 20px;">&nbsp;</div> 

<div class="column2" style="width: 53%; margin-left: 0px; text-align: justify;">
<p>The International Student Exchange Program provides full medical and accident insurance coverage for their students.  There will be a local representative to assist families and students during the hosting period. The foreign exchange students provide their own pocket money; Host families are asked only to cover the cost of room and board. While no compensation is paid to those volunteer host families experiencing the foreign exchange hosting experience. The Internal Revenue Service has authorized families hosting for government-designated NON-PROFIT exchange programs like ISE, to claim a $ 50.00 per month charitable contribution deduction on their itemized tax returns.</p>
<p>Just as there is no such thing as a typical student, there is also no such thing as a typical host family. Single-parent families, retired couples, families with only young children, as well as families with teenagers, have all had successful hosting experiences. The most important criteria for a host family is a genuine interest to share the American culture with a foreign exchange student while caring for the well-being of the foreign exchange student.</p>
<p>During the time of the student exchange hosting experience, we ask that you treat your new son or daughter exactly as you would your own children. The exchange student will share the ups and downs of your everyday life. By the time she or he leaves, they will have become a part of the very fabric of your own family.</p>
 <!-- end two column --></div> 

   <div class="column2" style="padding: 10px; background-color: #efefef; width:38%; border: thin solid #17468E;margin: 5px 5px 0px 20px;">
<h3>What International Exchange Students Say They Have Learned From Their Host Family</h3>
<div class="blueLine">&nbsp;</div>
<ul class="padding"><li>"The way of life in America" <em>– Sarah</em></li>
<li>"I learned to share and to live in a way I never did before" <em>– Laura</em></li>
<li>"I learned to love another family and to have the support of another person" <em>– Clara</em></li>
<li>"How to accept a different culture and how it is to have a sister"<em> – Karin</em></li>
<li>"Even though they have a family that they focus on, preparing their children for the next step in their lives" <em>– Susi</em></li>
</ul>
<div class="blueLine">&nbsp;</div>
 <!-- end two column --></div> 

 <div class="clearfloat">&nbsp;</div>
 <div class="dotLine">&nbsp;</div>

   <div class="clearfloat">&nbsp;</div>
</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>