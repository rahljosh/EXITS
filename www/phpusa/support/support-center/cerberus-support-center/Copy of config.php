<?php
define("DB_PLATFORM","mysql");

define("DB_SERVER","localhost");  
define("DB_NAME","cerberus");  
define("DB_USER","cerberus");
define("DB_PASS","cerberus123");   

// This is the profile ID you created in the Cerberus GUI under [Configuration]
define("PROFILE_ID",1);

define("SMTP_HOST","smtp1.dnsmadeeasy.com"); // your SMTP server
define("SMTP_LOCAL",$_SERVER['SERVER_NAME']); // your hostname

define("SMTP_AUTH",1);  // use SMTP authorization?  0 = off   1 = on
define("SMTP_ACCT","outgoingsmg"); // if authorization is used, otherwise blank
define("SMTP_PASS","smg123QwE"); // if authorization is used, otherwise blank

/* 
   Only uncomment and set the following path if auto detection doesn't work
   Path to the SupportCenter files, *MUST* include a trailing slash '/'.
   i.e.: define("FILESYSTEM_PATH","","/www/htdocs/cerberus-support-center/");
   NOTE: If you run a Windows server enter paths escaped, such as: 
		c:\\Inetpub\\wwwroot\\support-center\\cerberus-support-center\\
             or c:/Inetpub/wwwroot/support-center/cerberus-support-center/
*/
//define("FILESYSTEM_PATH","/www/htdocs/support-center/cerberus-support-center/");

// This is the URL used to access the Support Center from the web.  Be sure to include 
// whether you are using https:// or http://.  You *must* include a trailing slash at
// the end of the path.
// i.e.: define("WEB_URL","http://localhost/support-center/");
define("WEB_URL", "http://www.phpusa.com/support/support-center/");

// Change the following if you renamed the cerberus-support-center folder 
//	to something else.  Don't use leading or trailing slashes in the name.
define("DIRECTORY_NAME","cerberus-support-center");

// This reflects the base URL for the Support Center if you want to embed it in another 
// application (rather than use index.php).  If you're unsure what this setting does then 
// leave it set to the default value.
// Default:
//		define("BASE_URL", WEB_URL . "index.php?x=");
// ModernBill (embedded): 
//		define("BASE_URL", WEB_URL . "user.php?op=menu&tile=mysupport");
define("BASE_URL", WEB_URL . "index.php?x=");

//=============================================================================
// !!! [JAS]: DO NOT EDIT BELOW THIS LINE !!!
//=============================================================================

// [JSJ]: If we didn't set the filesystem path manually above, then auto-detect it
if(!defined('FILESYSTEM_PATH')) {
   define("FILESYSTEM_PATH", dirname(__FILE__) . "/");
}

define("FULL_URL", urlencode(BASE_URL . 
		((isset($_SERVER['QUERY_STRING']) && !empty($_SERVER['QUERY_STRING']))
			? "&" . $_SERVER['QUERY_STRING']
			: ""
			))
	);
	
include (FILESYSTEM_PATH . "cerberus-api/database/cer_Database.class.php");

$cerberus_db = Cer_Database::getInstance();

// Class to grab configuration values from the database
require_once(FILESYSTEM_PATH . "cerberus-api/configuration/CerConfiguration.class.php");

define("GUI_VERSION","3.0 RC2 (Build 199)");
define("CURRENT_DB_SCRIPT","24ba15259f7f28af573ca8c2b501bebd");

$cfg = CerConfiguration::getInstance();

// [JAS]: For now, keep this in English
// [TODO]: Set up translation
define("LANG_NAME","English");
define("LANG_CHARSET_CODE","iso-8859-1");
define("LANG_CHARSET_MAIL_CONTENT_TYPE","text/plain");
define("LANG_CHARSET","text/html; charset=" . LANG_CHARSET_CODE);
define("LANG_DATE_FORMAT_STANDARD", "%a %b %d %Y %I:%M%p");
