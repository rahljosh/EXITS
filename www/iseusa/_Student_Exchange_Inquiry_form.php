<?php
if(isset($_POST['footerEmail'])) {
     
    // EDIT THE 2 LINES BELOW AS REQUIRED
    $email_to = "josh@iseusa.com";
    $email_subject = "Email Inquiry";
     
     
    function died($error) {
        // your error code can go here
        echo "We are very sorry, but there were error(s) found with the form you submitted. ";
        echo "These errors appear below.<br /><br />";
        echo $error."<br /><br />";
        echo "Please go back and fix these errors.<br /><br />";
        die();
    }
     
    // validation expected data exists
    if(!isset($_POST['name']) ||
        !isset($_POST['footerEmail']) ||
        !isset($_POST['comments'])) {
        died('We are sorry, but there appears to be a problem with the form you submitted.');      
    }
     
    $first_name = $_POST['name']; // required
    $email_from = $_POST['footerEmail']; // required
    $comments = $_POST['comments']; // required
     
    $error_message = "";
    $email_exp = '/^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/';
  if(!preg_match($email_exp,$email_from)) {
    $error_message .= 'The Email Address you entered does not appear to be valid.<br />';
  }
  
  if(strlen($comments) < 2) {
    $error_message .= 'The Comments you entered do not appear to be valid.<br />';
  }
  if(strlen($error_message) > 0) {
    died($error_message);
  }
    $email_message = "Form details below.\n\n";
     
    function clean_string($string) {
      $bad = array("content-type","bcc:","to:","cc:","href");
      return str_replace($bad,"",$string);
    }
     
    $email_message .= "Name: ".clean_string($name)."\n";
    $email_message .= "Email: ".clean_string($email_from)."\n";
    $email_message .= "Comments: ".clean_string($comments)."\n";
     
     
// create email headers
$headers = 'From: International Student Exchange'.$email_from."\r\n".
'Reply-To: '.$email_from."\r\n" .
'X-Mailer: PHP/' . phpversion();
@mail($email_to, $email_subject, $email_message, $headers); 
?>
 
<!-- include your own success html here -->
 
<p class="whiteFont">Thank you for contacting International Student Exchange. We will be in touch with you very soon.</p>
 
<?php
}
?>

<form name="Student_Exchange_Inquiry_form" method="post" action="<?PHP $_SERVER[SCRIPT_NAME]?>">
<table width="100px">
<tr>
 <td valign="top">
  <input  type="text" name="name" maxlength="50" size="20" placeholder="Full Name">
 </td>
</tr>
<tr>
 <td valign="top">
  <input  type="text" name="footerEmail" maxlength="80" size="20" placeholder="Email">
 </td>
</tr>
<tr>
 <td valign="top">
  <textarea  name="comments" maxlength="500" cols="19" rows="3" placeholder="Comments"></textarea>
 </td>
</tr>
<tr>
 <td colspan="2" style="text-align:center">
  <input type="submit" value="Submit" class="smOrangeButton">
 </td>
</tr>
</table>
</form>