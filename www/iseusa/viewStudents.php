<?PHP
if(!isset($_COOKIE['iseLead']))
	{
		if (isset($_POST['iseLead'])){
			setcookie("iseLead", 'viewStudents', time()+3600*24*365);  /* expire in 1 year */	
		}
	}
if(!isset($_COOKIE['iseLead']))
{
	header( 'Location: ready-host-student.php' );
}

?>

<?php include 'extensions/includes/_pageHeader.php'; ?>

<?PHP  

 $db_conn = new mysqli('204.12.102.10', 'rahljosh', 'f8qvVpF[@v', 'smg');

   if (mysqli_connect_errno()) {

   exit();
  } else {

  $students = 'SELECT     	
            studentid,
            dob, 
            firstname, 
            interests, 
            interests_other, 
            countryresident,
            smg_countrylist.countryname, 
            smg_religions.religionname
        FROM
            smg_students
        INNER JOIN 	
            smg_countrylist ON smg_countrylist.countryid = smg_students.countryresident
        LEFT JOIN 	
            smg_religions ON smg_religions.religionid = smg_students.religiousaffiliation
        WHERE 	   	
            active = 1 
			 AND 
            hostid = 0
        AND 
            direct_placement = 0
        AND 
            (companyID = 1 or companyid = 2 or companyid = 3 or companyid = 4 or companyid = 12)
        ORDER BY rand()
        LIMIT 5';

  $result = $db_conn->query($students);
  if ($result->num_rows >0 )
  {  
     $db_conn->close();
	}
  }

 
  
?>

<body>
<?php include '_slidingLogin.php'; ?>
<div class="container">
  <?php include '_header.php'; ?>
  <div class="clearfloat">&nbsp;</div>
  <?php include '_menu.php'; ?>
<img src="images/viewStudents_headers.jpg" width="1024" height="250" alt=" ISE student Scholarships" />

 <div class="clearfloat">&nbsp;</div>
 <div class="sidebar2">
   <div class="ltblueBorder" style="float: right;">
  <div class="boxBrdTp"><h1>Ready to Host</h1></div>
  <div class="boxBrdRt">
    <p>If you are ready to host or want to speak with an area representative. <a href="ready-host-student.php"><br>
      details&#187;</a></p>
  </div>
   <div class="boxBrdLt"><a href="ready-host-student.php"><img src="images/ready-host-exchange-student.jpg" width="109" height="111" alt="Ready to Host an exchange student"></a></div>
<!-- ltGreenBorder --></div>

  <div class="redBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Why Host?</h1></div>
       <div class="boxFlipRt"><a href="why-host-family.php"><img src="images/why-host-exchange-student.jpg" width="109" height="110" alt="Why host an exchange student"></a></div>
  <div class="boxFlipLt">
    <p>There are many benefits to hosting for your family and community. <a href="why-host-family.php"><br>
      details&#187;</a></p>
  </div>

<!-- redBorder --></div>

  <div class="greenBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Meet Our Students</h1></div>
  <div class="boxBrdRt">
    <p>We have so many wonderful students to choose from<br> <a href="meet_our_students.php">
      details&#187;</a></p>
  </div>
   <div class="boxBrdLt"><a href="meet-our-students.php"><img src="images/meet-our-students.jpg" width="109" height="110" alt="meet our students"></a></div>
<!-- greenBorder --></div>

  <div class="orangeBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Hosting Requirements</h1></div>
       <div class="boxFlipRt"><a href="hosting-requirements.php"><img src="images/hosting-requirements.jpg" width="110" height="109" alt="Hosting Requirements"></a></div>
  <div class="boxFlipLt">
    <p>If you are wondering if your family is a good fit to host, see what is required.<br> <a href="hosting-requirements.php">
        details&#187;</a></p>
  </div>
<!-- orangeBorder --></div>

  <div class="dkblueBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Start Application</h1></div>
    
  <a href="http://iseusa.com/hostApplication" target="_blank"><img src="images/host-family-app.png" alt="family resources" width="250" height="160" align="absbottom" /></a>
<!-- dk Blue Border --></div>

    <div class="clearfloat">&nbsp;</div>  
<!-- end sidebar 2 --></div>

<article class="contentLft">
<div class="dotLine">&nbsp;</div>
<h1>View Our Exchange Students</h1>
<div class="dotLine">&nbsp;</div>

<h3>Student Profiles</h3>
<p>Below are some are students that are currently in the US or on their way.</p>
<div class="blueLine">&nbsp;</div>
<a name="students">
<table width="90%" align="center">
	<Tr>
<?PHP
	while($fieldData=$result->fetch_object())
		
		{
		echo '<tr>';
		echo '<td>';
		echo '<span class="picIMG" style="float:right; margin:10px;"><img src="http://ise.exitsapplication.com/nsmg/pics/flags/'.$fieldData->countryresident.'.jpg" width="133"></span>';
		echo '<strong>Name: </strong>'.$fieldData->firstname.'<br>';
		echo '<strong>ID: </strong>'.$fieldData->studentid.'-01<br>';
		echo '<strong>Birthday: </strong> '.date("M j, Y", strtotime($fieldData->dob)).'<br />';
		echo '<strong>Home Country: </strong>'.$fieldData->countryname.'<br />';
		echo '<strong>Religion: </strong>'.$fieldData->religionname.'<br /><br />';
		echo '<strong>About '.$fieldData->firstname.': </strong>'.$fieldData->interests_other.'</p>';
		echo '</td>';
      	echo '</tr>';
		echo '<tr>';
		echo '<td>';
		echo '<div class="dotLine">&nbsp;</div>';
		echo '</td>';
      	echo '</tr>';
		
		}
	?>
</Table>

      <div class="clearfloat" style="height: 20px;">&nbsp;</div> 
<div class="blueLine">&nbsp;</div>
  <div class="clearfloat" style="height: 20px;">&nbsp;</div> 
     <tr>
     	<Td colspan=4 align="center"><h2 align="center"><a href="viewStudents.php" class="basicBlueButton">View More Students</a> &nbsp; &nbsp;<a href="http://iseusa.com/hostApplication" class="basicBlueButton" target="_blank">Start Application</a></h2></Td>
    </table>
    
          </cfif>



<div class="clearfloat" style="height: 20px;">&nbsp;</div>
<div class="clearfloat">&nbsp;</div>
 <div class="dotLine">&nbsp;</div>
   <div class="blueBtn"><img src="images/img-buttons/faqBtn-test.png" width="31" height="30" alt="ISE Student Trips" /><a href="host-family-faq.php" class="whiteLink">&nbsp; Questions?</a></div>
       <div class="redBtn"><a href="host-family-resources.php" class="whiteLink"><img src="images/img-buttons/redBtn-test.png" width="31" height="30" alt="ISE Testimonial" /> &nbsp;Resources</a></div>
   <div class="clearfloat">&nbsp;</div>
</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>