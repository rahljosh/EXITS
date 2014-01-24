<?php include 'extensions/includes/_pageHeader.php'; ?>
<?php

// If the form was submitted, scrub the input (server-side validation)
// see below in the html for the client-side validation using jQuery

$name = '';
$email = '';
$question = '';
$output = '';

if($_POST) {
  // collect all input and trim to remove leading and trailing whitespaces
  $name = trim($_POST['name']);
  $email = trim($_POST['email']);
  $question = trim($_POST['question']);
  
  $errors = array();
  
  // Validate the input
  if (strlen($name) == 0)
    array_push($errors, "Please enter your name");
    
  if (!filter_var($email, FILTER_VALIDATE_EMAIL))
    array_push($errors, "Please specify a valid email address");
    
  if (strlen($question) == 0)
    array_push($errors, "Please enter a question or comment");
    

    
  // If no errors were found, proceed with storing the user input
  if (count($errors) == 0) {
    array_push($errors, "No errors were found. Thanks!");
  }
  
  //Prepare errors for output
  $output = '';
  foreach($errors as $val) {
    $output .= "<p class='output'>$val</p>";
  }
  
}

?>


<body>
<?php include '_slidingLogin.php'; ?>
<div class="container">
  <?php include '_header.php'; ?>
  <div class="clearfloat">&nbsp;</div>
  <?php include '_menu.php'; ?>
<img src="images/Login_header.jpg" width="1024" height="250" alt="Contact ISE student Exchange" />

 <div class="clearfloat">&nbsp;</div>

  <div class="sidebar1">
 <aside>
    <h2>Contact Us</h2>
<p><strong>Mailing Address:</strong><br />
International Student Exchange<br />
119 Cooper Street<br />
Babylon NY, 11702<br />
<br />
<strong>Phone:</strong><br />
Toll free: 800.766.4656<br />
Local: 631.893.4540<br />
Fax: 631.893.4550</p><br><br>
<div class="dotLine">&nbsp;</div>
  </aside>
  </div>

<article class="content">
    <!-- Staff Form -->
<div class="fltrt" style="width: 45%; margin-right: 30px;">				
<form class="clearfix" action="https://ise.exitsapplication.com/login.cfm" method="post">
                <input type="hidden" name="login_submitted" value=1>
					<h1>Students & Field Staff</h1>
					<label class="grey" for="log">Username:</label>
					<input class="field" type="text" name="username" id="log" value="" size="23" /><br><br>
					<label class="grey" for="pwd">Password:&nbsp;</label>
					<input class="field" type="password" name="password" id="pwd" size="23" />
	            	<br><br>
					<div align="right"><input type="submit" name="submit" value="Login" class="bt_login" />
					<a class="smItalic" href="https://ise.exitsapplication.com/login.cfm?forgot=1">&nbsp;Forgot your password?</a></div>
				</form>	</div>
 <div class="fltlt" style="width: 40%; margin-left: 40px;">	
				<!-- Register Form -->
<form class="clearfix" action="https://www.iseusa.com/hostApplication/index.cfm?section=login" method="post">
                <input type="hidden" name="submitted" value=1>
					<h1>Host Families</h1>
					<label class="grey" for="log">Email:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<input class="field" type="text" name="username" id="log" value="" size="23" /><br><br>
					<label class="grey" for="pwd">Password:</label>
					<input class="field" type="password" name="password" id="pwd" size="23" /><br><br>
	            	
		<div align="right"><input type="submit" name="submit" value="Login" class="bt_login" />
					<a class="smItalic" href="https://www.iseusa.com/hostApp">&nbsp;Forgot your password?</a></div>
                    
				</form></div>
                <div class="clearfloat">&nbsp;</div>
                <div class="blueLine">&nbsp;</div>
                 <p align="center">If you would like to be a host family, but do not have an account:<br><br> <a href="ready-host-student.cfm" class="basicBlueButton">Get started here</a></p>
                <!----
                <p class="grey">Students, please contact an agent in your home country to get started on the path to becoming an exchange student. <Br />
                <a href="">Find an organization in your country</a></p>---->
                <p align="center">Looking to travel abroad? Visit our Outbound site for more information<br><br> <a href="study-abroad-outbound.cfm" class="basicBlueButton" >Outbound Programs</a></p>
                
<div class="dotLine">&nbsp;</div>

</article>
 <div class="clearfloat"></div>
<div class="bannerCallout" style="padding-left: 30px;">
 <div class="fltrt" style="width: 200px; padding: 35px;"><a href="mailto:contact@iseusa.com" class="basicBlueButton">Send Email</a></div>
   <h1>ISE Representative Login</h1>
   <p><strong>Questions? Comments? </strong>ISE is happy to respond to any inquiries you may have. You may email us at <a href="mailto:contact@iseusa.com">contact@iseusa.com</a>.  If you have questions regarding hosting, working as an area  representative, or anything related to student exchange, we would be  more than happy to answer your question!</p>
    <div class="clearfloat">&nbsp;</div>
<!--end bannerCallout --></div>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>