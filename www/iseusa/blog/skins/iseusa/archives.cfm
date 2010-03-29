<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=<mango:Blog charset />" />
	
	<title>Archives &#8212; <mango:Blog title /></title>
	
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
			<mango:Archive pageSize="5">
            	<mango:ArchiveProperty ifIsType="category"><h1>Entries Tagged as <mango:ArchiveProperty title /></h1></mango:ArchiveProperty>
                <mango:ArchiveProperty ifIsType="month"><h2>Entries for month: <mango:ArchiveProperty title dateformat="mmmm yyyy"  /></h2></mango:ArchiveProperty>
                <mango:ArchiveProperty ifIsType="day"><h2>Entries for day: <mango:ArchiveProperty title dateformat="dd mmmm yyyy" /></h2></mango:ArchiveProperty>
                <mango:ArchiveProperty ifIsType="year"><h2>Entries for year: <mango:ArchiveProperty title dateformat="yyyy" /></h2></mango:ArchiveProperty>
                <mango:ArchiveProperty ifIsType="search"><h2>Search Results for <span class="green"><mango:ArchiveProperty title format="escapedHtml" /></h2></mango:ArchiveProperty>
                <mango:ArchiveProperty ifIsType="author"><h2>Entries by '<mango:ArchiveProperty title />'</h2></mango:ArchiveProperty>
                <mango:ArchiveProperty ifIsType="unknown"><h2>No archives</h2></mango:ArchiveProperty>
                
                <mango:Posts count="5">
				<mango:Post>
                	<h2><a href="<mango:PostProperty link />" rel="bookmark" title="Permanent Link to <mango:PostProperty title />"><mango:PostProperty title /></a></h2>
			
					<p class="post-info">Posted by <mango:Author><a href="<mango:AuthorProperty link />"><mango:PostProperty author /></a></mango:Author>
					<mango:Categories ifCountGT="0" count="1"> | Tags: </mango:Categories><mango:Categories><mango:Category><a href="<mango:CategoryProperty link />" title="View all posts in  <mango:CategoryProperty title />" rel="category tag"><mango:CategoryProperty title /></a> <mango:Category ifCurrentIsNotLast>, </mango:Category></mango:Category></mango:Categories>  </p>
				
					<mango:PostProperty ifhasExcerpt excerpt />
			   		<mango:PostProperty ifNotHasExcerpt body />
			   		
			   		<div class="post-footer">
					<mango:Event name="beforePostContentEnd" template="archives" mode="excerpt" />
					</div>
					<p class="postmeta">		
					<mango:PostProperty ifhasExcerpt><a href="<mango:PostProperty link />" class="readmore">Read more</a> |
					</mango:PostProperty>
                    <mango:PostProperty ifcommentsallowed><a href="<mango:PostProperty link />#respond" title="Comment on <mango:PostProperty title />" class="comment"><mango:PostProperty ifCommentCountGT="0"><mango:PostProperty commentCount /> Comment<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty></mango:PostProperty><mango:PostProperty ifCommentCountLT="1">No Comments</mango:PostProperty></a> |</mango:PostProperty>				
                    <span class="date"><mango:PostProperty date dateformat="mmmm dd, yyyy" /></span>	
                    </p>
			
                </mango:Post>
            </mango:Posts>
             
			<div class="page-navigation clear">
				<mango:ArchiveProperty ifHasNextPage><div class="float-left"><a href="<mango:ArchiveProperty link pageDifference="1" />">&laquo; Older Entries</a></div></mango:ArchiveProperty>
				<mango:ArchiveProperty ifHasPreviousPage><div class="float-right"><a href="<mango:ArchiveProperty link pageDifference="-1" />">Newer Entries &raquo; </a></div></mango:ArchiveProperty>
			</div>
            </mango:Archive>
		<!-- main ends -->	
		</div>
		
		<!-- sidebar starts -->
		<div id="sidebar">
		
			<mangox:PodGroup locationId="sidebar" template="archives">
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
		<mangox:PodGroup locationId="footer" template="archives">
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
