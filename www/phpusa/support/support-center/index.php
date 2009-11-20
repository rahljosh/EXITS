<?php
// [JAS]: COPY: This needs to be at the top of the page where you're embedding the public tool.
require_once ("cerberus-support-center/session.php");
?>

<html>
<head>
	<title>DMD Private High School :: Support Center</title>
	
	<!-- [JAS]: COPY: Make sure you copy the stylesheets to your site, preferrably in <head>...</head> -->
	<!-- If you have your own stylesheet for HTML elements, you can remove the cerberus-html.css link -->
	<link rel="stylesheet" href="cerberus-support-center/themes/green/cerberus-theme.css" type="text/css">
</head>

<body topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<div align="center">

<!-- START SAMPLE HEADER -->
		<!-- Your logo here -->
		<img src="../../internal/pics/dmd-logo.jpg">
		<br>
<!-- END SAMPLE HEADER -->		

<?php
/*
 * [JAS]: COPY: Cerberus Public GUI Embed
 *
 * This is the include that needs to be moved into the templates of
 * your website to embed the Cerberus Support Center in your current
 * look and feel.  Ideally, you'd have a standard corporate header, 
 * the include and a footer below it.
 *
 */

require_once ("cerberus-support-center/main.php");
?>

<!-- START SAMPLE FOOTER -->

<p>
<!-- END SAMPLE FOOTER -->

</div>
</body>
</html>
