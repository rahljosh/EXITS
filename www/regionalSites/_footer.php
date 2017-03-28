 <footer>
  <div class="Col-Cont one" style="width: 810px; margin: 0 auto;">
  <div class="Column one" style="width: 175px; margin-left: 60px;">
  <p><strong><?PHP echo $_SESSION['regionname']; ?> Region</strong><br>
      <strong> <?PHP echo $_SESSION['regionalManagerName']; ?></strong>, <?PHP echo $_SESSION['regionalManagerTitle']; ?><br>
    <?PHP echo $_SESSION['regionalManagerPhone']; ?><br><a href="mailto:<?PHP echo $_SESSION['regionalManagerEmail']; ?>">
<?PHP echo $_SESSION['regionalManagerEmail']; ?></a>
  <!--end Column one--></div>

  <div class="Column two" style="width: 150px;">
      <ul style="font-weight: bold;">
        <li><a href="index.php" target="_self">Home</a></li>
        <li><a href="become-a-host-family.php">Host a Student</a></li>
        <li><a href="meet-our-students.php">Meet our Students</a></li>
        <li><a href="join-our-team.php">Join Our Team </a></li>
      </ul>
<!--end Column two--></div>

  <div class="Column three" style="width: 150px;">
     <ul style="font-weight: bold;">
        <li><a href="http://www.iseusa.com/student-project-help.cfm" target="_blank">Project H.E.L.P.</a></li>
        <li><a href="hosting-faq.php">FAQ</a></li>
        <li><a href="contact-us.php">Contact Us</a></li>
        <li><a href="exits-login.php">Login</a></li>
      </ul><br>
   <!--end Column three--></div>

  <div class="Column four" style="width: 100px;">

	<a href="<?PHP echo $_SESSION[facebook]; ?>" target="_blank">
    <img src="images/socialMedia/facebook.png" width="30" height="30"></a>
    <a href="<?PHP echo $_SESSION[twitter]; ?>" target="_blank">
    <img src="images/socialMedia/twitter.png" width="30" height="30"></a>
    <a href="<?PHP echo $_SESSION[googleplus]; ?>" target="_blank">
    <img src="images/socialMedia/googlePlus.png" width="30" height="30"></a>
    <a href="<?PHP echo $_SESSION[youtube]; ?>" target="_blank">
    <img src="images/socialMedia/youTube.png" width="30" height="30"></a>
    <a href="<?PHP echo $_SESSION[tumblr]; ?>" target="_blank">
    <img src="images/socialMedia/tumblr.png" width="30" height="30"></a>
    <a href="<?PHP echo $_SESSION[pintrest]; ?>" target="_blank">
    <img src="images/socialMedia/pinterest.png" width="30" height="30"></a>
</p><!--end Column four--></div>
<!--end Col-Cont --></div>

<div class="divCopyright">
<p style="padding-top: 8px; color: #efefef; text-align: center;">© COPYRIGHT <?PHP echo date("Y");?> INTERNATIONAL STUDENT EXCHANGE</p>
 </div>
  

  </footer>