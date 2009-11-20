<?php

// Path to the cerberus-support-center directory *WITH* trailing slash.
// Uncomment the define below if you need to override the automatic value.
define("CER_MB_FILESYSTEM_PATH", "/path/to//support-center/cerberus-support-center/");
define("WEB_URL", "http://www.yourwebsite.com/modernbill-instance/");
define("BASE_URL", WEB_URL . "user.php?op=menu&tile=mysupport");

if(!defined("CER_MB_FILESYSTEM_PATH")) {
  define("CER_MB_FILESYSTEM_PATH",str_replace("embed/modernbill","",dirname(__FILE__)));
}

?>
