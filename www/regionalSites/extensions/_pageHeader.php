<!doctype html>
<html>
<head>
<meta charset="UTF-8">
 <meta name="robots" content="noindex, nofollow"> 
<link href="css/structure.css" rel="stylesheet" type="text/css">
<link href="css/menu.css" rel="stylesheet" type="text/css">
<link href="css/style.css" rel="stylesheet" type="text/css">
<link href="css/buttons.css" rel="stylesheet" type="text/css">
<link href="css/login.css" rel="stylesheet" type="text/css">
<?php
if ($_POST[zip]) {
	setcookie('iseLead', viewStudents, time()+3600*24*365, '/');  /* expire in 1 year */	
};

require_once 'extensions/mobileSession.php';	
//require_once 'extensions/dumpVars.php';	
?>
</head>
