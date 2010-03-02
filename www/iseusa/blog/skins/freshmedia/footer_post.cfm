<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<cfif thisTag.executionMode EQ "start">

	<!--- recent posts --->
	<mangox:TemplatePod id="posts" title="Recent Posts">
		<ul class="col-list">	
		<mango:Posts count="6">
			<mango:Post>
				<li><a href="<mango:PostProperty link />" rel="bookmark" title="Permanent link to <mango:PostProperty title />"><mango:PostProperty title /> - <span><mango:PostProperty date dateformat="m-d-yyyy" /></span></a></li>
			</mango:Post>
		</mango:Posts>
	</mangox:TemplatePod>
	
	<!--- comments --->
	<mangox:TemplatePod id="comments" title="Recent Comments">
			<ul class="col-list"><mango:Comments recent count="4">
				<mango:Comment>			
				<li><a href="<mango:CommentProperty entryLink />#comment-<mango:CommentProperty id />" title="on <mango:CommentProperty entryTitle />"><mango:CommentProperty name />: <span><mango:CommentProperty excerptChars="80" /></span></a></li>
                </mango:Comment>
				</mango:Comments>					
			</ul>
	</mangox:TemplatePod>

	<mangox:TemplatePod id="author-description">
		<mango:Author>
		<h3>About <mango:AuthorProperty name /></h3>
		<p><mangox:Gravatar class="float-left" size="40" /><mango:AuthorProperty shortdescription descriptionParagraphFormat /></p>
		</mango:Author>
	</mangox:TemplatePod>
	
	<mangox:TemplatePod id="blog-description" title="About">
		<p><mango:Blog description descriptionParagraphFormat /></p>
	</mangox:TemplatePod>
	
	<!--- categories  --->
	<mangox:TemplatePod id="categories" title="Categories">
	<ul class="col-list">
	<mango:Categories>
		<mango:Category>
		<li><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />"><mango:CategoryProperty title /> (<mango:CategoryProperty postCount />)<br /><span><mango:CategoryProperty description /></span></a></li>
		</mango:Category>
	</mango:Categories>
	</ul>
	</mangox:TemplatePod>
	
	<mangox:TemplatePod id="monthly-archives" title="Archives">
		<ul class="col-list">
		<mango:Archives type="month" count="6"><mango:Archive>
			<li><a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /> (<mango:ArchiveProperty postcount />)</a></li>
		</mango:Archive></mango:Archives>
		</ul>
	</mangox:TemplatePod>
	
	<!--- output all the pods, including the ones added by plugins --->
	<mangox:Pods count="3"><!--- output the first 3 only --->
		<mangox:Pod>
			<mangox:Pod ifCurrentIsNotLast><div class="col float-left <mangox:Pod ifCurrentIsFirst>space-sep</mangox:Pod>"></mangox:Pod>
			<mangox:Pod ifCurrentIsLast><div class="col2 float-right"></mangox:Pod>
			<mangox:PodProperty ifHasTitle>
				<h3><mangox:PodProperty title /></h3>
					<mangox:PodProperty content />
			</mangox:PodProperty>
		</mangox:Pod>
		<mangox:Pod><!--- output the content as is, good for "templatePods" --->
			<mangox:PodProperty ifNotHasTitle>
				<mangox:PodProperty content />
			</mangox:PodProperty>
		</mangox:Pod>
		</div>
	</mangox:Pods>
</cfif>