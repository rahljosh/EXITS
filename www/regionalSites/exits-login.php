<?php include 'extensions/_pageHeader.php'; ?>
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

<img src="images/Login_header.jpg" width="1024" height="250" alt="Contact ISE student Exchange" style="display: block;" />
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
					<a class="smItalic" href="https://www.iseusa.com/hostApplication">&nbsp;Forgot your password?</a></div>
                    
				</form></div>
                <div class="clearfloat">&nbsp;</div>
                <div class="blueLine">&nbsp;</div>
                 <p align="center">If you would like to be a host family, but do not have an account:<br><br> <a href="become-a-host-family.php" class="basicBlueButton">Get started here</a></p>

                
<div class="dotLine">&nbsp;</div>

</article>
 <div class="clearfloat"></div>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>