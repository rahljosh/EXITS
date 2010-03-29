<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<mango:Page>
	<title><mango:PageProperty title /> &#8212; <mango:Blog title /></title>
		
	 <meta http-equiv="Content-Type" content="text/html; charset=<mango:Blog charset />" />
	<link rel="stylesheet" href="<mango:Blog skinurl />assets/styles/style.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="<mango:Blog skinurl />assets/styles/custom.css" type="text/css" media="screen" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />
	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />
	
	<meta name="generator" content="Mango <mango:Blog version />" />
	<mango:PageProperty ifHasCustomField='meta-description'>
		<meta name="description" content="<mango:PageProperty customfield='meta-description' />" />
	</mango:PageProperty>
	<mango:PageProperty ifNotHasCustomField='meta-description'>
		<meta name="description" content="<mango:Blog description />" />
	</mango:PageProperty>
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
				<li><a href="<mango:Blog basePath />">Home</a></li>
				<mango:Pages parentPage=""><mango:Page>
					<li <mango:PageProperty ifiscurrentpage>id="current"</mango:PageProperty>><a <mango:PageProperty ifiscurrentpage>class="current"</mango:PageProperty> href="<mango:PageProperty link>" title="<mango:PageProperty title />">
						<mango:PageProperty title /></a></li>
				</mango:Page></mango:Pages>	
			</ul>		
		</div>	
				
	<!--header ends-->					
	</div>
	
	<!-- content-wrap starts -->
	<div id="content-wrap">
				
		<div id="main">
        	<h2><mango:PageProperty title /></h2>
            <mango:PageProperty body />
			
            <h3>By month:</h3>
            
			<ul><mango:Archives type="month"><mango:Archive>
			<li><a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /> (<mango:ArchiveProperty postcount />)</a></li>
			</mango:Archive></mango:Archives>
			</ul>
            
            <h3>By Category:</h3>
			
			<ul>
			<mango:Categories>
				<mango:Category>
				<li><a href="<mango:CategoryProperty rssurl />"><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />">
					<mango:CategoryProperty title /> (<mango:CategoryProperty postcount />)</a> </li>
				</mango:Category>
			</mango:Categories>
			</ul>
            
            <div class="post-footer">
			<mango:Event name="beforePageContentEnd" template="page" mode="full" />
			</div>
            
             <div id="comments">
				<mango:PageProperty ifcommentsallowed>
				<h3 class="comments_headers"><mango:PageProperty commentCount /> response<mango:PageProperty ifCommentCountGT="1">s</mango:PageProperty><mango:PageProperty ifCommentCountLT="1">s</mango:PageProperty><mango:PageProperty ifcommentsallowed> so far &darr;</mango:PageProperty></h3>
	            </mango:PageProperty>
	            <mango:PageProperty ifNotCommentsAllowed ifCommentCountGT="0">
			<div class="comment-number">
				<h3 class="comments_headers"><mango:PageProperty commentCount /> response<mango:PageProperty ifCommentCountGT="1">s</mango:PageProperty></h3><p> (comments are now closed)	</p>
		    </div><!--end comment-number-->
		</mango:PageProperty>
	            <mango:Comments>
				<mango:Comment>
					<blockquote<mango:CommentProperty ifIsAuthor> class="author"</mango:CommentProperty>>
                    <p><strong><mango:CommentProperty ifhasurl><a href='<mango:CommentProperty url />' rel='external nofollow'></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty> </strong> - <mango:CommentProperty date dateformat="mmm d, yyyy" /> at <mango:CommentProperty time /><p>
					<mango:CommentProperty content /></blockquote>
				</mango:Comment>
				</mango:Comments>
                
				<mango:PageProperty ifcommentsallowed>
                    <!-- Comment Form -->
                    <h3 id="respond" class="comments_headers">Leave a Comment</h3>
                    <mango:Message ifMessageExists type="comment" status="error">
                        <p class="error">There was a problem: <mango:Message text /></p>
                    </mango:Message>
                    <mango:Message ifMessageExists type="comment" status="success">
                        <p class="message"><mango:Message text /></p>
                    </mango:Message>
                    
                    <form method="post" action="#respond" id="comment_form">
						<p>
                        <input type="hidden" name="action" value="addComment" />
                        <input type="hidden" name="comment_post_id" value="<mango:PageProperty id />" />
                        <input type="hidden" name="comment_parent" value="" />
                        <mango:AuthenticatedAuthor ifIsLoggedIn>
                            You are logged in as <mango:AuthorProperty name />
                            <input type="hidden" name="comment_name" value="<mango:AuthorProperty name />" />
                            <input type="hidden" name="comment_email" value="<mango:AuthorProperty email />" />
                            <input type="hidden" name="comment_website" value="<mango:Blog url />" />
                        </mango:AuthenticatedAuthor>
                        
                        <mango:AuthenticatedAuthor ifNotIsLoggedIn>
                       	<label for="author">Name</label><input id="author" type="text" name="comment_name" value="<mango:RequestVar name='comment_name' />" />
                        <label for="email">Mail (it will not be displayed)</label><input type="text" id="email" name="comment_email" value="<mango:RequestVar name='comment_email' />" />
                        <label for="url">Website</label><input type="text" id="url" name="comment_website" size="30" value="<mango:RequestVar name='comment_website' />"  />
                        </mango:AuthenticatedAuthor>
                        <label for="comment_content">Your comments</label>
                        <textarea id="comment_content" name="comment_content" rows="7"><mango:RequestVar name="comment_content" /></textarea>
                        <label for="subscribe">Subscribe to this comment thread</label><input type="checkbox" id="subscribe" name="comment_subscribe" value="1" />
						</p>
						<p>
                       <mango:Event name="beforeCommentFormEnd" /></p>
                        <input name="submit" class="button" type="submit" id="submit" value="Submit" />
                        </form>
                </mango:PageProperty>
                        
                </div> <!-- Close #comments container -->
		<!-- main ends -->	
		</div>
		
		<!-- sidebar starts -->
		<div id="sidebar">
			<mangox:PodGroup locationId="sidebar-page" template="archives_index">
                <mango:Pages ifCountGT="0" count="1" parentPage="firstParent">
				<mangox:TemplatePod id="page-menu" title="Page Menu">
					<template:pageMenu start="parent" />
				</mangox:TemplatePod>
				</mango:Pages>
                <template:sidebar />
            </mangox:PodGroup>	
		<!-- sidebar ends -->		
		</div>
		
	<!-- content-wrap ends-->	
	</div>
		
	<!-- footer starts here -->	
	<div id="footer-wrap"><div id="footer-content">
		<mangox:PodGroup locationId="footer" template="archives_index">
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
</mango:Page>
</body>
</html>
