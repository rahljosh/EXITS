<?PHP
	
if(isset($_COOKIE['iseLead']))
{
	header( 'Location: viewStudents.php' );
}

?>
<?php include 'extensions/includes/_pageHeader.php'; ?>
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
<?php include '_slidingLogin.php'; ?>
<div class="container">
  <?php include '_header.php'; ?>
  <div class="clearfloat">&nbsp;</div>
  <?php include '_menu.php'; ?>
<img src="images/ready-host-family-header.jpg" width="1024" height="250" alt=" ISE student Scholarships" />
<div style="width: 960px; margin: 5px auto;">
<div class="dotLine">&nbsp;</div>
<h1>Be a Host Family</h1>
<div class="dotLine" style="margin-bottom: 0px;">&nbsp;</div>
 <div class="clearfloat">&nbsp;</div>
 </div>
    <div class="sidebar1">
 <aside>
   <h2>Interested in Hosting</h2> 
 <p>Fill out this form to learn more about being a host family through ISE!</p>

<?php include 'formTemplates/_ReadyHostForm.php'; ?>

<div class="dotLine">&nbsp;</div>

  </aside>
  </div>

<article class="content">
<div class="fltrt" style="width: 320px; margin: 5px 20px;"><img src="images/host-family-app.png" width="320" height="213" alt="host family app" /></div>

<p>Due  to Department of State regulations, we ask you to fill out this form to  view our current students.  Once you fill out the form to the left, you will be permitted to view select student profiles.</p>
<p>If you have already spoken with an ISE representative and are ready to  host, then please hit the login button at the top of the page to start  your Host Family Application.  You must have an email from an ISE  representative that contains instructions and login information before  you can start your Host Family Application.</p>
<div class="dotLine">&nbsp;</div>
<div class="clearfloat">&nbsp;</div>

<div style="background-color: #FFC; padding: 20px; font-style: italic; width: 85%; margin: 5px 20px 5px 20px;">
	<p><?php echo $quotes[$ranNum]; ?></p>
</div>
<div class="clearfloat">&nbsp;</div>
<div class="dotLine">&nbsp;</div>
</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>