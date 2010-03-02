<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<mango:Post>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title><mango:PostProperty title /> &#8212; <mango:Blog title /></title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=<mango:Blog charset />" />
	<link rel="stylesheet" href="<mango:Blog skinurl />assets/styles/style.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="<mango:Blog skinurl />assets/styles/custom.css" type="text/css" media="screen" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />
	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />
	
	<meta name="generator" content="Mango <mango:Blog version />" />
	<mango:PostProperty ifHasCustomField='meta-description'>
		<meta name="description" content="<mango:PostProperty customfield='meta-description' />" />
	</mango:PostProperty>
	<mango:PostProperty ifNotHasCustomField='meta-description'>
		<meta name="description" content="<mango:Blog description />" />
	</mango:PostProperty>
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
        	<h2><mango:PostProperty title /></h2>

			<p class="post-info">Posted by <mango:Author><a href="<mango:AuthorProperty link />"><mango:PostProperty author /></a></mango:Author>
			<mango:Categories ifCountGT="0" count="1"> | Tags: </mango:Categories><mango:Categories><mango:Category><a href="<mango:CategoryProperty link />" title="View all posts in  <mango:CategoryProperty title />" rel="category tag"><mango:CategoryProperty title /></a> <mango:Category ifCurrentIsNotLast>, </mango:Category></mango:Category></mango:Categories>  </p>
				
			<mango:PostProperty body />
			   		
			<div class="post-footer">
			<mango:Event name="beforePostContentEnd" template="post" mode="full" />
			</div>
			<p class="postmeta">
			<span class="date"><mango:PostProperty date dateformat="mmmm dd, yyyy" /></span>				
			</p>
                    
          <!-- comments start -->	
			<div id="comments">
				<mango:PostProperty ifcommentsallowed ifCommentCountGT="0">
				<h3 class="comments_headers"><mango:PostProperty commentCount /> response<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty><mango:PostProperty ifCommentCountLT="1">s</mango:PostProperty><mango:PostProperty ifcommentsallowed> so far &darr;</mango:PostProperty></h3>
	            </mango:PostProperty>
	            <mango:PostProperty ifcommentsallowed ifCommentCountLT="1">
				<!-- If comments are open, but there are no comments. -->
	            <div class="entry">
	                <p>There are no comments yet...Kick things off by filling out the form below.</p>
	            </div>
				</mango:PostProperty>
	            <mango:PostProperty ifNotCommentsAllowed ifCommentCountGT="0">
			<div class="comment-number">
				<h3 class="comments_headers"><mango:PostProperty commentCount /> response<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty></h3><p> (comments are now closed)	</p>
		    </div><!--end comment-number-->
		</mango:PostProperty>
	            <mango:Comments>
				<mango:Comment>
					<blockquote<mango:CommentProperty ifIsAuthor> class="author"</mango:CommentProperty>>
                    <p><strong><mango:CommentProperty ifhasurl><a href='<mango:CommentProperty url />' rel='external nofollow'></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty> </strong> - <mango:CommentProperty date dateformat="mmm d, yyyy" /> at <mango:CommentProperty time /><p>
					<mango:CommentProperty content /></blockquote>
				</mango:Comment>
				</mango:Comments>
                
				<mango:PostProperty ifcommentsallowed>
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
                        <input type="hidden" name="comment_post_id" value="<mango:PostProperty id />" />
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
                </mango:PostProperty>
                        
                </div> <!-- Close #comments container -->
<div class="clear flat"></div>
		</div>
		
		<!-- sidebar starts -->
		<div id="sidebar">
		
			<mangox:PodGroup locationId="sidebar" template="index">
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
		<mangox:PodGroup locationId="footer-post" template="post">
			<template:footer_post />
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
</mango:Post>
</body>
</html>
