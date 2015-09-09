<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>DMD Private High School Program</title>

<link href="_css/structure.css" rel="stylesheet" type="text/css">
<!--[if lt IE 9]>
<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
<![endif]--></head>
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
<div class="wrapper">
  <?php include '_header.php'; ?>
  <div class="menu">
  <?php include '_menu.php'; ?>
  </div>
  <?php include '_loginButton.php'; ?>
  <div class="container">
  <div class="indexSlide"><img src="images/login-php-header.png" width="1045" height="317" alt=""/></div>

  <article class="contentFull">
  <!---<div class="ribbondkBlue" style="width: 900px;">
    <h1 style="color: #fff;">Login</h1>
    </div> --->

    <section>
    <?PHP if (isset($_GET['loginError'])) {
     echo '<div id="alert" align="center"><font color="red">There was a problem with your username or password.  Please try again.</font></div>';
	}
	?>
    <div class="clearfloat" style="height: 20px;"></div>
    <table width="80%" border="0" align="center" cellspacing="8">
  
  <tr>
    <td colspan="2"><h2>Local Representative / Office User Login</h2></td>
    </tr>
  <tr>
    <td align="center" valign="top"><!-- Staff Form -->
<form class="clearfix" action="../loginprocess.cfm" method="post">
                <input type="hidden" name="submitted" value=1>
					
                   
				
					<input class="field" type="text" name="username" id="log" value="" size="23"  placeholder="Username" /><br><br>
					<input class="field" type="password" name="password" id="pwd" size="23"  placeholder="Password" /><br><br>
	            	
		<div align="center"><a class="smItalic" href="http://www.phpusa.com/hostApp">Forgot your password?&nbsp;&nbsp;</a><input type="submit" name="submit" value="Login" class="blueButton" />
					</div>
                    
				</form></td>
    <td align="center" valign="top"></td>
  </tr>
  <tr>
    <td colspan="2"><hr style="margin: 20px; color: #ccc;"></td>
    </tr>
  <?PHP if (isset($_GET['loginError'])) {
	  echo '<tr><td colspan=2>';
     echo '<div id="alert" align="center"><font color="red">There was a problem with your username or password.  Please try again.</font></div>';
	echo '</td></tr>';
	}
	?>
  <tr>
    <td colspan="2"><h2>International Agent Login</h2></td>
    </tr>
    
  <tr>
    <td align="center" valign="top">			<!-- Register Form -->
<form class="clearfix" action="../loginprocess.cfm" method="post">
                <input type="hidden" name="submitted" value=1>
					
                    <h4>Flight Info / Progress Report - AXIS</h4>
					
					<input class="field" type="text" name="username" id="log" value="" size="23" placeholder="Username"/><br><br>
					
					<input class="field" type="password" name="password" id="pwd" size="23"  placeholder="Password"/><br><br>
	            	
		<div align="center"><a class="smItalic" href="https://www.phpusa.com/hostApp">Forgot your password?&nbsp;&nbsp;</a><input type="submit" name="submit" value="Login" class="blueButton" />
					</div>
                    
				</form></td>
    <td align="center" valign="top"><h4>Manage Student Applications – EXITS</h4>
<a href="https://php.exitsapplication.com/login.cfm" class="blueButton">log in here</a></td>
  </tr>
</table>

    </section>
    
  <!-- end .content --></article>
  <footer>
    <?php include '_footerInfo.php'; ?>
</footer>
<?php include '_copyright.php'; ?>
  <!-- end .container --></div>
 <div class="containerBottom"></div>
   <!-- end .wrapper --></div>
</body>
</html>