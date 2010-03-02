<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title><mango:Message title /> &#8212; Error</title>		
	<link href="skins/freshmedia/assets/styles/style.css" type="text/css" media="screen" rel="stylesheet">
	<link href="skins/freshmedia/assets/styles/custom.css" type="text/css" media="screen" rel="stylesheet">
</head>
<body>
<!-- wrap starts here -->
<div id="wrap-out"><div id="wrap">

	<!--header -->
	<div id="header">			
				
		<h1 id="logo-text">Error</h1>		
				
	<!--header ends-->					
	</div>
	
	<!-- content-wrap starts -->
	<div id="content-wrap">
				
		<div id="main">
			<h2><mango:Message title /></h2>
            <p><mango:Message text />
               <mango:Message data />
            </p>
		<!-- main ends -->	
		</div>
		
		<!-- sidebar starts -->
		<div id="sidebar">
		<!-- sidebar ends -->		
		</div>
		
	<!-- content-wrap ends-->	
	</div>
		
	<!-- footer starts here -->	
	<div id="footer-wrap"><div id="footer-content">
			
	</div></div>
	<div class="clearer"></div>

	<div id="footer">
		<p><a href="http://www.mangoblog.org" title="Mango Blog - A free ColdFusion blog engine">Powered by Mango Blog</a> &mdash; <a href="http://www.styleshout.com/">Fresh Media Theme</a> ported by <a href="http://www.cftips.net">John Gagliardi</a></p>
	</div><!--end footer-->
<!-- wrap ends here -->
</div></div>
</body>
</html>
