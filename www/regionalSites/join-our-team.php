<?PHP
	


	session_start();
	include 'extensions/_pageHeader.php';
	//include 'dBug.php'; 
	//new dBug($_SESSION); 
	
$quotes = file("_quotes.txt");
srand((double)microtime() * 1000000);
$ranNum = rand(0, count($quotes)-1);

include 'extensions/includes/_pageHeader.php'; ?>
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

<img src="images/join-team-header.jpg" alt="" width="1024" height="250" align="absbottom"/>
  <?php include '_menu.php'; ?>
<div style="width: 960px; margin: 5px auto;">
<div class="dotLine">&nbsp;</div>
<h1>Join the ISE Team</h1>
<div class="dotLine" style="margin-bottom: 0px;">&nbsp;</div>
 <div class="clearfloat">&nbsp;</div>
 </div>
     <div class="sidebar1">
 <aside>
    <h2>Apply Now</h2>
<?php include 'formTemplates/_JoinOurTeam.php'; ?>
<div class="dotLine">&nbsp;</div>

  </aside>
  </div>

<article class="content">
<h2>Area Representative</h2>

<p>ISE is searching for Area Representatives to help place and supervise exchange students for the upcoming school year.</p>
<div class="fltrt" style="width: 250px;"><img src="http://www.iseusa.com/images/JO-AreaRep.jpg" width="250" height="293"  alt=""/></div>
<p><strong>SUPPORT:</strong> ISE Area Representatives receive unparalleled support in the field. Each Area Representative is paired with a Regional Manager who trains, develops, and coaches you throughout the placing season. In short, you are never alone.</p>

<p><strong>TRAINING:</strong> ISE uses a web-based training platform that is both visual and audio. During the year, New York office staff will run these trainings and all representatives are required to attend. Also, your Regional Manager will provide an in-person training for you with the rest of the region during the year. There are ample training guides and hands-on material for you to learn all about student exchange!</p>

<p><strong>NETWORKING:</strong> Our Area Representatives are skillful networkers, able to meet with people and develop long lasting relationships which foster positive environments for student exchange to thrive. Area Representatives are able to meet with school officials and host families on a regular basis to provide the extra support that these individuals need.</p>

<p><strong>FLEXIBILITY:</strong> Area Representatives work from home and develop their own schedule to work in the field with families, students, and schools.</p>

<p><strong>COMMUNITY:</strong> Through networking and outreach Area Representatives develop long lasting bonds with exchange students, schools, and families. Area representatives reinforce positive growth and development within their communities.</p>

<div class="clearfloat">&nbsp;</div>
<div class="dotLine">&nbsp;</div>
<div class="clearfloat">&nbsp;</div>

</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>