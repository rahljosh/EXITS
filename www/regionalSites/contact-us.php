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
  

<img src="http://www.iseusa.com/images/contact-ise.jpg" width="1024" height="250" alt="Contact ISE student Exchange" />
  <?php include '_menu.php'; ?>
 <div class="clearfloat">&nbsp;</div>
    <div class="sidebar1">
 <aside>
 <div class="dotLine">&nbsp;</div>
    <h2>Contact Us</h2>
 <p><strong><?PHP echo $_SESSION['regionname']; ?> Region</strong><br>
   <strong>Name: </strong><?PHP echo $_SESSION['regionalManagerName']; ?><br>
    <strong>Phone: </strong><?PHP echo $_SESSION['regionalManagerPhone']; ?><br>
    <a href="mailto:<?PHP echo $_SESSION['regionalManagerEmail']; ?>">
<?PHP echo $_SESSION['regionalManagerEmail']; ?></a></p>
<!----<div align="center"><a href="<?PHP echo $_SESSION['regionalManagerEmail']; ?>" class="basicBlueButton">Send Email</a></div><br>---->
<div class="dotLine">&nbsp;</div>

<h2>Host a Student</h2>
      <p>If you are interested in hosting a student please contact us at
        <br>
      <strong><?PHP echo $_SESSION['regionalManagerPhone']; ?></strong></p>
      <div class="dotLine">&nbsp;</div>

<h2>ISE Headquarters</h2>
<p><strong>Mailing Address:</strong><br />
International Student Exchange<br />
119 Cooper Street<br />
Babylon NY, 11702<br />
<br />
<strong>Phone:</strong><br />
Toll free: 800.766.4656<br />
Local: 631.893.4540<br />
Fax: 631.893.4550</p>
  </aside>
  </div>

<article class="content">
<div class="dotLine">&nbsp;</div>
<h2><?PHP echo $_SESSION['regionname']; ?> Student Exchange</h2>
<div class="dotLine">&nbsp;</div>
<p><strong>Questions? Comments?</strong> The <?PHP echo $_SESSION['regionname']; ?> Region is happy to respond to any inquiries you may have. If you have questions regarding hosting, working as an Area Representative, or anything related to student exchange, we would be more than happy to answer your question!</p>


<div class="fltlt" style="width: 40%; margin-left: 30px;">
<?php 
include_once ('formTemplates/_contact-us.php');
?></div>

<div class="dotLine">&nbsp;</div>
</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>