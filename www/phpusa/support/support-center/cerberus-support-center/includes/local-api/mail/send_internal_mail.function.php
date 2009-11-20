<?php
require_once(FILESYSTEM_PATH . "cerberus-api/mail/mimePart.php");

function send_internal_mail($to,$subject,$body,$from,$attachments=array()) {

	// Build MIME body including file attachments [JSJ]
	$message =& new Mail_mimePart('', array('content_type'=>'multipart/mixed'));
	
	$message->addSubpart($body, array('content_type'=>'text/plain'));
	
	foreach($attachments as $attachment) {
		$params['content_type'] = (isset($attachment['content_type']) && !empty($attachment['content_type'])) ? $attachment['content_type'] : 'application/octet-stream';
		$params['encoding']     = 'base64';
		$params['disposition']  = 'attachment';
		$params['dfilename']    = $attachment['file_name'];
		$message->addSubpart($attachment["data"], $params);
	}
	
	$headers = 
		"To: " . $to . "\r\n".
		"From: $from\r\n".
		"Subject: $subject\r\n".
		"Reply-to: $from\r\n".
		"Date: " . date("r");
	
	$hdr = explode("\r\n",$headers);
	
	$smtp = array();
	
   // Add Message-ID to headers [JSJ]
   srand((double)microtime()*10000000);
   $message_id = sprintf('<%s.%s@%s>', base_convert(time(), 10, 36), base_convert(rand(), 10, 36), !empty($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : $_SERVER['SERVER_NAME']);
   $hdr[] = "Message-ID: " . $message_id;
	
   // Add MIME Header [JSJ]
   $hdr[] = "MIME-Version: 1.0";
	
	// Set MIME encoded body as new body and add required headers [JSJ]
	$mime_output = $message->encode();
	$body = $mime_output['body'];
	foreach($mime_output['headers'] as $key=>$value) {
		$hdr[] = $key . ": " . $value;
	}

   foreach($hdr as $h) {$smtp[] = $h."\r\n";}

   $smtp[] = "\r\n"; // break headers
   
	if($body) {$bdy = preg_replace("/^\./","..",explode("\r\n",$body));}
	if($bdy) {foreach($bdy as $b) {$smtp[] = $b."\r\n";}}

	require_once(FILESYSTEM_PATH . "cerberus-api/parser/CerPop3RawEmail.class.php");
	require_once(FILESYSTEM_PATH . "cerberus-api/parser/CerProcessEmail.class.php");
	$process = new CerProcessEmail();

	$email = implode("", $smtp);
	
	if(!empty($email)) {
		$pop3email = new CerPop3RawEmail($email);
		$result = $process->process($pop3email);
		if(!$result) { // re-fail...
			$failed = $process->last_error_msg;
		} else {
			// success!
			$failed = FALSE;
		}
		
		return $result;
	}

}
?>