<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title><mango:Message title /> &#8212; <mango:Blog title /></title>
		
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
		
		<div  id="nav">
			<ul>
				<li id="current"><a class="current" href="<mango:Blog basePath />">Home</a></li>
				<mango:Pages><mango:Page>
					<li><a href="<mango:PageProperty link>" title="<mango:PageProperty title />">
						<mango:PageProperty title /></a></li>
				</mango:Page></mango:Pages>	
			</ul>		
		</div>	
				
	<!--header ends-->					
	</div>
	
	<!-- content-wrap starts -->
	<div id="content-wrap">
				
		<div id="main">
			<h2><mango:Message title /></h2>
            <mango:Message text />
            <mango:Message data />
		<!-- main ends -->	
		</div>
		
		<!-- sidebar starts -->
		<div id="sidebar">
		
			<mangox:PodGroup locationId="sidebar" template="generic">
                <mangox:TemplatePod id="blog-description" title="About">
                <p><mango:Blog description descriptionParagraphFormat /></p>
                </mangox:TemplatePod>
                <template:sidebar />
            </mangox:PodGroup>		
						
		<!-- sidebar ends -->		
		</div>
		
	<!-- content-wrap ends-->	
	</div>
		
	<!-- footer starts here -->	
	<div id="footer-wrap"><div id="footer-content">
		<mangox:PodGroup locationId="footer" template="generic">
			<template:footer />
        </mangox:PodGroup>
	
	</div></div>
	<div class="clearer"></div>

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
