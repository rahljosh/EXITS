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
<img src="images/contact-ise.jpg" width="1024" height="250" alt="Contact ISE student Exchange" />

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
Fax: 631.893.4550</p>
<div align="center"><a href="mailto:contact@iseusa.com" class="basicBlueButton">Send Email</a></div><br>
<div class="dotLine">&nbsp;</div>

<h2>Host a Student</h2>
      <p>If you are interested in hosting a student please contact us at
        <br>
      <strong>1-877-850-3043</strong></p>

<div class="dotLine">&nbsp;</div>

<h2>China Office</h2>
      <p>Brian Feng<br />
Chief Representative<br />
FLS CHINA OFFICE<br />
office:86-10-6271 2322<br />
fax:86-10-6271 6511<br />
E-mail: flschinabrian@gmail.com</p>
  </aside>
  </div>

<article class="content">
<div class="dotLine">&nbsp;</div>
<h2>Contact ISE Student Exchange</h2>
<p><strong>Questions? Comments?</strong> ISE is happy to respond to any inquiries you may have. If you have questions regarding hosting, working as an area representative, or anything related to student exchange, we would be more than happy to answer your question!</p>


<div class="fltlt" style="width: 40%; margin-left: 30px;">
<?php 
include_once ('formTemplates/_contact-ISE.php');
?></div>
<div class="dotLine">&nbsp;</div>
<h2>Where We Are</h2>
<p><iframe width="650" height="300" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="http://maps.google.com/maps?f=q&amp;source=s_q&amp;hl=en&amp;geocode=&amp;q=119+Cooper+Street,+Babylon,+NY+11702&amp;aq=0&amp;oq=119+Cooper+Street+Babylon+NY,+11702&amp;sll=55.345325,-131.661137&amp;sspn=0.10913,0.159988&amp;ie=UTF8&amp;hq=&amp;hnear=119+Cooper+St,+Babylon,+New+York+11702&amp;t=m&amp;z=14&amp;ll=40.70116,-73.319111&amp;output=embed"></iframe><br /><small><a href="http://maps.google.com/maps?f=q&amp;source=embed&amp;hl=en&amp;geocode=&amp;q=119+Cooper+Street,+Babylon,+NY+11702&amp;aq=0&amp;oq=119+Cooper+Street+Babylon+NY,+11702&amp;sll=55.345325,-131.661137&amp;sspn=0.10913,0.159988&amp;ie=UTF8&amp;hq=&amp;hnear=119+Cooper+St,+Babylon,+New+York+11702&amp;t=m&amp;z=14&amp;ll=40.70116,-73.319111" style="color:#0000FF;text-align:left">View Larger Map</a></small></p>
<div class="dotLine">&nbsp;</div>
</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>