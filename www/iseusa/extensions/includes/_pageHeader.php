<!doctype html>

<html>
<head>
<meta charset="UTF-8">

 <?php
 session_start();
$_SESSION['outboundEmail'] = 'tom@iseusa.com';
$_SESSION['webstoreEmail'] = 'budge@iseusa.com';
$_SESSION['infoEmail'] = 'budge@iseusa.com';
$_SESSION['programManagerEmail'] = 'spencer@iseusa.com';
$_SESSION['hostLeadEmail'] = 'budge@iseusa.com';
$_SESSION['jobEmail'] = 'robert@iseusa.com';
// @include_once('extensions/includes/dumpVars.php');
// @include_once('extensions/includes/dBug.php');

// include the Zebra_Form class
	require 'Zebra_Form/Zebra_Form.php';
	
@  $db = new mysqli('204.12.102.10', 'rahljosh', 'f8qvVpF[@v', 'smg');
 
 if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    exit();
}

  $query = 'SELECT pageTitle, pageKeywords, pageDescription FROM metadata WHERE url = "'.$_SERVER['SCRIPT_NAME'].'" AND site = "iseusa"';
  
  $result = $db->query($query);
  	
  $num_results = $result->num_rows;
 
 for($i=0; $i <$num_results; $i++){
  $row = $result->fetch_assoc();
  echo "<title>".stripslashes($row['pageTitle'])."</title>";
  echo "<META NAME='keywords' content='".stripslashes($row['pageKeywords'])."'>";
  echo "<META NAME='description' content='".stripslashes($row['pageDescription'])."'>";
}
?>
  <!---Form Errors--->
  <!-- Load jQuery and the validate plugin -->
  <script src="//code.jquery.com/jquery-1.9.1.js"></script>
  <script src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>

  
<link href="css/structure.css" rel="stylesheet" type="text/css">
<link href="css/menu.css" rel="stylesheet" type="text/css">
<link href="css/style.css" rel="stylesheet" type="text/css">
<link href="css/buttons.css" rel="stylesheet" type="text/css">
<link href="css/login.css" rel="stylesheet" type="text/css">
<link href="css/form-style.css" rel="stylesheet" type="text/css">
<!--[if lt IE 9]>
<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-880717-2']);
  _gaq.push(['_setDomainName', 'iseusa.com']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
</head>
