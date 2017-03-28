<?php 
	session_start();
		if (strpos($_SERVER[SERVER_NAME],'www.') !== false) {
		
		//if ($_SERVER['REMOTE_ADDR'] == '184.155.136.106' or $_SERVER['REMOTE_ADDR'] == '96.56.128.61'){
	  	//echo '<div style="margin: 0 auto;"><img src="http://zephyrthedog.com/zephyrSubdomainError.jpg" width=400></div>';
		//echo 'You really need to just type in this: '.substr($_SERVER[SERVER_NAME], 4).'';
		//echo '<meta http-equiv="refresh" content="10; url=http://'.substr($_SERVER[SERVER_NAME], 4).'">';
		//exit();
		//}else{
	   header( 'Location: http://'.substr($_SERVER[SERVER_NAME], 4).'');
		//}
	}
	
	session_start();
	include 'extensions/_pageHeader.php';
	//include 'dBug.php'; 
	//new dBug($_SESSION); 

?>
<body>
<?php include '_slidingLogin.php'; ?>
<div class="container">
  <?php include '_header.php'; ?>
<div class="clearfloat">&nbsp;</div>

<img src="images/index-header.jpg" alt="" width="1024" height="250" align="absbottom"/>
  <?php include '_menu.php'; ?>
<div class="clearfloat">&nbsp;</div>
 
 <div class="bannerCallout">
 <div class="fltrt" style="width: 150px; padding: 45px 20px;"><a href="become-a-host-family.php" class="basicBlueButton">Apply to Host</a></div>
   <h1>Welcome to <?PHP echo $_SESSION['regionname']; ?> Region</h1>
  
   <p style="font-size: 95%;">The  <?PHP echo $_SESSION['regionname']; ?> Region is part of International Student Exchange (ISE), a not-for-profit organization that was founded in 1982.  ISE is dedicated to bringing people of the world closer together through student exchange and intercultural education.  We place students from over 40 countries all throughout the US.  Our commitment to our students and host families is what makes us the leader in Student Exchange.</p>
    <?php
   	if ($_SESSION[websiteBlurb] != ''){
	echo '<p style="font-size: 95%;">'.$_SESSION[websiteBlurb].'</p>';
	};
   ?>
<!--end bannerCallout --></div>
   
<div class="clearfloat">&nbsp;</div>
   <div class="Col-Cont">
     <div class="Column one">
     <a href="become-a-host-family.php" ><img src="images/host-student.jpg" alt="" width="450" height="230" align="absbottom"/>
</a><div class="ColHeader"><a href="become-a-host-family.php" class="whiteLink">HOST A STUDENT</a></div>
<p>Hosting a foreign exchange student is a life changing experience that brings the world closer together. ISE students are excited about their upcoming exchange program in the United States. Will you be the loving host family that opens the door for an international student?</p>
  <!--end Col one --></div>
  <div class="Column two">
  <a href="join-our-team.php"><img src="images/joinTeam.jpg" alt="" width="450" height="230" align="absbottom"/></a>
<div class="ColHeader"><a href="join-our-team.php" class="whiteLink">JOIN OUR TEAM</a></div>
<p>Being an Area Representative is a great opportunity for people who are involved in their community and local schools. If you are that kind of individual, we look forward to having you apply to our program.</p>
  <!--end Col two --></div>
    <div class="clearfloat" style="height: 5px;">&nbsp;</div>
  <div class="dotLine">&nbsp;</div>
  <div class="clearfloat" style="height: 10px;">&nbsp;</div>
    <div class="sidebar1">
 <aside>
    <h2 style="margin-left: -1px;"><a href="become-a-host-family.php" target="_blank" class="blueLink" >Be a Host Family</a></h2>
    <p style="line-height: 17px; font-size: 14px; margin-right: 5px;">We followed one of our exchange students for an entire semester. She played sports, went to her homecoming, made friends . . . and most importantly, she became a family member.</p>
     <p style="line-height: 17px; font-size: 14px; margin-right: 5px;">Watch the video below and see what it's like to host an exchange student.</p>
     <div class="asideImg" style="margin-bottom: 15px;">
     
   <?php 
     if ($_SESSION[layoutType] == 'classic' ){
			
			$vidLink =  'https://youtube.googleapis.com/v/-ScNJmjdlGo';
    }else
     { 
        $vidLink =  'https://youtube.googleapis.com/v/-ScNJmjdlGo';
     }
	?>

<a href="<?PHP echo $vidLink ?>" target="_blank"><img src="images/maries-journey-video.jpg" width="200" height="150" alt="Be a Host Family" class="asideBrd" /></a></div>
<p style="line-height: 17px; font-size: 14px; margin-right: 5px;">Hosting a foreign exchange student is a life changing experience that brings the world closer together. ISE students are excited about their upcoming exchange program in the United States. Will you be the loving host family that opens the door for an international student?</p>
  </aside>
 <!-- end sidebar --> </div>
<article>
     <?php include '_featureList.php'; ?>
   <div class="imgBtnArea">
   <div class="blueBtn"><img src="images/HELP-icon.png" width="31" height="30" alt="ISE Student Trips" /><a href="http://www.iseusa.com/student-project-help.cfm" target="_blank" class="whiteLink" > Project H.E.L.P</a></div>
   <div class="orgBtn"><img src="images/plane-icon.png" width="31" height="30" alt="ISE Student Trips" /><a href="https://trips.exitsapplication.com/" target="new" class="whiteLink">Student Trips</a></div>
    <div class="redBtn"><a href="hosting-faq.php" class="whiteLink"><img src="images/faq-icon.png" width="31" height="30" alt="ISE Testimonial" /> &nbsp;FAQ</a></div>
   <div class="clearfloat">&nbsp;</div>
   <!-- end .imgBtnArea --></div></article>

 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>