<?PHP 

require_once 'lib/swift_required.php';
	// Create the Transport
	$transport = Swift_SmtpTransport::newInstance('smtp1.dnsmadeeasy.com', 25)
	  ->setUsername('isemail')
	  ->setPassword('Ise!2q')
	  ;
	// Create the Mailer using your created Transport
	$mailer = Swift_Mailer::newInstance($transport);
	
	// Create a message
	
	$message = Swift_Message::newInstance($emailSubject)
	  ->setTo(array($emailToAddress => $emailToName))
	  ->setFrom(array($emailFromAddress => $emailFromName));
	 $imgLogo = $message->embed(Swift_Image::fromPath('http://www.iseusa.com/images/ISE_logo.png'));
	 $bgImg = $message->embed(Swift_Image::fromPath('http://www.iseusa.com/images/background.jpg'));
	   
	 $message ->setBody(
'<html>'.
'<head>'.
'<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />'.
'<title>Email Message</title>'.
'<body style="font-family: Gotham, \'elvetica Neue\', Helvetica, Arial, sans-serif;">'.
'<table width="100%" border="0" cellpadding="20" background="'.$bgImg.'" align="center" >'.
' <tr>'.
    '<td height="73">'.
    '<table width="80%" border="0" cellpadding="0" bgcolor="#FFFFFF" align="center">'.
  '<tr>'.
  '<td width="25%" rowspan="3"><img src="'.$imgLogo.'" alt="" width="150" height="104" align="right"/></td>'.
  '<td width="75%" height="29">&nbsp;</td>'.
  '</tr>'.
  '<tr>'.
    '<td height="47" bgcolor="#17468E"><h2 style="font-family: Gotham, \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: #fff; padding-left: 10px;">International Student Exchange</h2></td>'.
  '</tr>'.
  '<tr>'.
   '<td><div style="font-size: 10px; float: right; margin: 5px; width: 120px; color: #666;">'.date("d M o").'</div></td>'.
  '</tr>'.
  '<tr>'.
    '<td colspan="2">'.
    '<div style="margin: 20px 0;">'.
    '<table width="90%" border="0" cellpadding="8" align="center">'.
  '<tr>'.
   '<td bgcolor="#EFEFEF"><h2>'.$emailSubject.'</h2></td>'.
   '</tr>'.
  '<tr>'.
    '<td>&nbsp;</td>'.
  '</tr>'.
  '<tr>'.
    '<td><h3>Just wanted to let you know...</h3>'.
		'<p>'.$emailBody.'</p>'.
    '</td>'.
  '</tr>'.
  '<tr>'.
    '<td>&nbsp;</td>'.
  '</tr>'.
  '<tr>'.
  '<td bgcolor="#EFEFEF"><p><strong>This is a system generated email, a response to this email may or may not be received.</strong></p></td>'.
  '</tr>'.
'</table>'.
  '</div>'.  
	'</td>'.
  '</tr>'.
  '<tr>'.
    '<td colspan="2" bgcolor="#EFEFEF"><div style="font-size: 10px; color: #666; padding: 5px; width: 60%; margin: 10px auto; text-align: center;"><p>International Student Exchange 119 Cooper St. Babylon NY 11702</p></div></td>'.
  '</tr>'.
'</table>'.
    '</td>'.
  '</tr>'.
'</table>'.
'</body>'.
'</html>', 
'text/html'
	  
	  );
	
	// Send the message
	$result = $mailer->send($message);
	 
		
?>

