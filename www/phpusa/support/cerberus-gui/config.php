<?php

// Database connection information
// Type your information in between the single quotes ('s) below

define("DB_SERVER",'192.168.1.101');   
define("DB_NAME",'cerberus');
define("DB_USER",'cerberus');
define("DB_PASS",'cerberus123');


// [JAS]: IPs that we'll allow to view upgrade.php.  
//   Add yours here at the end, or replace a 0.0.0.0
//   Partial IP masks are allowed.

$authorized_ips = array("127.0",
                                   "192.168.1",
                                   "71.38.92.214",
                                   "0.0.0.0",
                                   "0.0.0.0"
                                   );


// SMTP Authentication for outbound mail server
// Type your information in between the single quotes ('s) below
// Leave empty if you don't know what this is, or don't need it.

define('SMTP_AUTH_USERNAME','outgoingsmg');
define('SMTP_AUTH_PASSWORD','smg123QwE');

