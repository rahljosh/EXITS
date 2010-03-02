<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>Login &#8212; <mango:Blog title /></title>
		
	<meta http-equiv="Content-Type" content="text/html; charset=<mango:Blog charset />" />
	<link rel="stylesheet" href="<mango:Blog skinurl />assets/styles/style.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="<mango:Blog skinurl />assets/styles/custom.css" type="text/css" media="screen" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />
	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />
	
	<meta name="generator" content="Mango <mango:Blog version />" />
	<meta name="robots" content="index, follow" />
	<mango:Event name="beforeHtmlHeadEnd" />
</head>
<body>
<mango:Event name="beforeHtmlBodyStart" />
<!-- wrap starts here -->
<div id="wrap-out"><div id="wrap">

	<!--header -->
	<div id="header">			
				
		<h1 id="logo-text"><a href="<mango:Blog url />"><mango:Blog title /></a></h1>		
		<p id="intro">
		<mango:Blog tagline /> 
		</p>		
		
	<!--header ends-->					
	</div>
	
	<!-- content-wrap starts -->
	<div id="content-wrap">
				
		<div id="main">
			<h2>Login</h2>
            <mango:RequestVar ifExists="errormsg">
				<p><mango:RequestVar name="errormsg" /></p>
			</mango:RequestVar>
            <cfoutput><form action="<mangox:Environment selfUrl />" method="post" id="login_form"></cfoutput>
			<p>
				<label for="username">Username:</label>
				<input name="username" id="username" value="" size="22" type="text">
				<label for="password">Password:</label>
				<input name="password" id="password" value="" size="22" type="password">
			</p>
			<p>
				<input name="login" class="button" type="submit" id="submit" value="Login" />
			</p>
			</form>
			
			
		<!-- main ends -->	
		</div>
	<!-- content-wrap ends-->	
	</div>
		
	<!-- footer starts here -->	
	<div id="footer">
		<mango:Event name="afterFooterStart" />
		<p class="float-right">Copyright <mango:Blog date dateformat="yyyy" /> <mango:Blog title /></p>
		<p><a href="http://www.mangoblog.org" title="Mango Blog - A free ColdFusion blog engine">Powered by Mango Blog</a> &mdash; <a href="http://www.styleshout.com/">Fresh Media Theme</a> ported by <a href="http://www.cftips.net">John Gagliardi</a></p>
		<mango:Event name="beforeFooterEnd" />
	</div><!--end footer-->
<!-- wrap ends here -->
</div></div>
<mango:Event name="beforeHtmlBodyEnd" />
</body>
</html>
