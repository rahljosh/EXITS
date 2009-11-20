<?php

// FROM php.net, mail() documentation

require_once(FILESYSTEM_PATH . "cerberus-api/mail/mimePart.php");

function sock_mail($auth, $to, $subj, $body, $head, $from, $attachments = array()) {
    $lb="\r\n";                     			//linebreak
    $body_lb="\r\n";                			//body linebreak
    $loc_host = SMTP_LOCAL;        			//localhost
    $smtp_acc = SMTP_ACCT;				    			//account
    $smtp_pass=SMTP_PASS;    							//password
    $smtp_host=SMTP_HOST;  		//server SMTP
    $hdr = explode($lb,$head);      			//headers

    // Add Message-ID to headers [JSJ]
    srand((double)microtime()*10000000);
    $message_id = sprintf('<%s.%s@%s>', base_convert(time(), 10, 36), base_convert(rand(), 10, 36), !empty($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : $_SERVER['SERVER_NAME']);
    $hdr[] = "Message-ID: " . $message_id;

    // Add MIME Header [JSJ]
    $hdr[] = "MIME-Version: 1.0";

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

    // Set MIME encoded body as new body and add required headers [JSJ]
    $mime_output = $message->encode();
    $body = $mime_output['body'];
    foreach($mime_output['headers'] as $key=>$value) {
       $hdr[] = $key . ": " . $value;
    }
    
    if($body) {$bdy = preg_replace("/^\./","..",explode($body_lb,$body));}
    
    // build the array for the SMTP dialog. Line content is array(command, success code, additonal error message)
    if($auth == 1) {// SMTP authentication methode AUTH LOGIN, use extended HELO "EHLO"
        $smtp = array(
            // call the server and tell the name of your local host
            array("EHLO ".$loc_host.$lb,"220,250","HELO error: "),
            
            // request to auth
            array("AUTH LOGIN".$lb,"334","AUTH error:"),
            
            // username
            array(base64_encode($smtp_acc).$lb,"334","AUTHENTIFICATION error : "),
            
            // password
            array(base64_encode($smtp_pass).$lb,"235","AUTHENTIFICATION error : "));
    } 
    else {// no authentication, use standard HELO    
        $smtp = array(
            // call the server and tell the name of your local host
            array("HELO ".$loc_host.$lb,"220,250","HELO error: "));
    }
    
    // envelop
    $smtp[] = array("MAIL FROM: <".$from.">".$lb,"250","MAIL FROM error: ");
    $smtp[] = array("RCPT TO: <".$to.">".$lb,"250","RCPT TO error: ");
    
    // begin data        
    $smtp[] = array("DATA".$lb,"354","DATA error: ");
    
    // header
    $smtp[] = array("Subject: ".$subj.$lb,"","");
    $smtp[] = array("To: ".$to.$lb,"","");        
    foreach($hdr as $h) {$smtp[] = array($h.$lb,"","");}
    
    // end header, begin the body
    $smtp[] = array($lb,"","");
    if($bdy) {foreach($bdy as $b) {$smtp[] = array($b.$body_lb,"","");}}
    
    // end of message
    $smtp[] = array(".".$lb,"250","DATA(end)error: ");
    $smtp[] = array("QUIT".$lb,"221","QUIT error: ");

    // open socket
    $fp = @fsockopen($smtp_host, 25);
    if (!$fp) echo "<b>Error:</b> Cannot conect to ".$smtp_host."<br>";
    
    $banner = @fgets($fp, 1024);
    // perform the SMTP dialog with all lines of the list
    foreach($smtp as $req){
        $r = $req[0];
        // send request
        @fputs($fp, $req[0]);
        // get available server messages and stop on errors
        if($req[1]){
            while($result = @fgets($fp, 1024)){if(substr($result,3,1) == " ") { break; }};
            if (!strstr($req[1],substr($result,0,3)))  /*echo"$req[2].$result<br>" */;
        }
    }
    $result = @fgets($fp, 1024);
    
    // close socket
    @fclose($fp);
    return 1;
}  
    
