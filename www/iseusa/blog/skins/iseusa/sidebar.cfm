<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<cfif thisTag.executionMode EQ "start">

	<!--- recent posts --->
	<mangox:TemplatePod id="posts" title="Recent Posts">
		<ul class="sidemenu">
		<mango:Posts count="5" source="recent">
		<mango:Post>
			<li><a href="<mango:PostProperty link />"><mango:PostProperty title /></a></li>
		</mango:Post>
		</mango:Posts>
		</ul>
	</mangox:TemplatePod>
	
	<!--- categories  --->
	<mangox:TemplatePod id="categories" title="Categories">
	<ul class="sidemenu">
	<mango:Categories parent="root">
		<mango:Category>
		<li><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />"><mango:CategoryProperty title /> (<mango:CategoryProperty postCount />)<br /><span><mango:CategoryProperty description /></span></a></li>
		</mango:Category>
	</mango:Categories>
	</ul>
	</mangox:TemplatePod>
	
	<!--- search box --->
	<mangox:TemplatePod id="search" title="Search">
		<form  method="get" action="<mango:Blog searchUrl />" class="searchform">
            <p>
            <input name="term" class="textbox" type="text" />
            <input name="search" class="button" value="Search" type="submit" />
            </p>			
        </form>	
	</mangox:TemplatePod>

	<!--- category cloud --->
	<mangox:TemplatePod id="category-cloud" title="Tag Cloud">
		<mangox:CategoryCloud includeStyle="false" />
	</mangox:TemplatePod>
	
	<!--- archives by month --->
	<mangox:TemplatePod id="monthly-archives" title="Archives">
		<ul class="sidemenu">
		<mango:Archives type="month" count="12"><mango:Archive>
			<li><a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /> (<mango:ArchiveProperty postcount />)</a></li>
		</mango:Archive></mango:Archives>
		</ul>
	</mangox:TemplatePod>
	
	<!--- all links by category --->
	<mangox:TemplatePod id="links-by-category">
		<mangox:LinkCategories>
			<mangox:LinkCategory>
				<h3><mangox:LinkCategoryProperty name /></h3>
			</mangox:LinkCategory>
				<ul class="sidemenu">
				<mangox:Links>
				<mangox:Link>
					<li><a href="<mangox:LinkProperty address />" title="<mangox:LinkProperty title />"><mangox:LinkProperty title /><br /><span><mangox:LinkProperty description /></span></a></li>
				</mangox:Link>
				</mangox:Links>
				</ul>
		</mangox:LinkCategories>
	</mangox:TemplatePod>
	
	
	<!--- output all the pods, including the ones added by plugins --->
	<mangox:Pods>
		<mangox:Pod>
			<mangox:PodProperty ifHasTitle>
				<h3><mangox:PodProperty title /></h3>
					<mangox:PodProperty content />
			</mangox:PodProperty>
		</mangox:Pod>
		<mangox:Pod><!--- output the content as is, good for "templatePods" --->
			<mangox:PodProperty ifNotHasTitle>
			<br />
				<mangox:PodProperty content />
			</mangox:PodProperty>
		</mangox:Pod>
	</mangox:Pods>
</cfif>