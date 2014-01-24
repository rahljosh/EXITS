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
<img src="images/Promo/payitForward-header.jpg" width="1024" height="250" alt="Contact ISE student Exchange" />

 <div class="clearfloat">&nbsp;</div>
    <div class="sidebar1">
 <aside>
   <div class="dotLine">&nbsp;</div>
    <img src="images/Promo/payitForwardicon.jpg" width="240" height="300" alt=""/>
    <div class="dotLine">&nbsp;</div>
     </aside>
  </div>

<article class="content">
<div class="dotLine">&nbsp;</div>
<h2>Pay It Forward</h2>
<div class="blueLine">&nbsp;</div>
<p>In  1916, Lily Hardy Hammond coined the concept &ldquo;Pay It Forward&rdquo;.  It is an  expression for describing the beneficiary of a good deed and repaying  it to others instead of the original benefactor. Essentially, if a  person helps you out, you repay that person by helping somebody else  out.  It&rsquo;s a great way to <strong><u>Help Out</u></strong> society as a whole.</p>
<p>This weekend is &ldquo;Pay it  Forward&rdquo; weekend.   We want you to send us your stories on how you paid  it forward.  If we like it, you might just win something from our Bag of  Swag!</p>
<p>You can <a href="https://www.facebook.com/iseusa?ref=sgm" target="_blank" class="orangeLink">Facebook us</a>, send it on our <a href="http://blog.iseusa.com/" target="_blank" class="orangeLink">blog</a> or <a href="https://twitter.com/ISE_USA" target="_blank" class="orangeLink">Twitter</a>!</p>
<p>It doesn’t have to be something big, just something good.</p>


<div class="dotLine">&nbsp;</div>
</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>