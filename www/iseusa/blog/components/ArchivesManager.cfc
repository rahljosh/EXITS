<cfcomponent name="ArchivesManager">

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="applicationManager" required="true" type="any">
		<cfargument name="accessObject" required="true" type="any">
		
			<cfset variables.accessObject = arguments.accessObject>
			<cfset variables.appManager = arguments.applicationManager>
			<cfset variables.blogid = arguments.applicationManager.getBlog().getId() />
			
		<cfreturn this />
	</cffunction>


	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getMonthlyArchives" access="public" output="false" returntype="array">	
		<cfargument name="year" required="false" default="0" type="numeric" hint="Year" />
		
		<cfset var archives = variables.accessObject.getPostsGateway().getActiveMonths(arguments.year,variables.blogid)  />		
		<cfreturn packageObjects(archives,"date") />
		
	</cffunction>	

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getArchive" access="public" output="false" returntype="any">	
		<cfargument name="type" required="true" type="any">
		<cfargument name="data" required="true" type="any">
		
		<cfset var archive =  createObject("component","model.Archive")  />
		<cfset var category = "" />
		<cfset var urlString = "" />
		<cfset var author = ""/>
		<cfset var year = 0 />
		<cfset var month = 0 />
		<cfset var day = 0 />
		<cfset var blog = variables.appManager.getBlog() />
		<cfset var friendlyUrls = blog.getSetting("useFriendlyUrls") />
		
		<cfswitch expression="#arguments.type#">
			<cfcase value="category">
				<cfset archive = createObject("component","model.CategoryArchive") />
				<cfset category = variables.appManager.getCategoriesManager().getCategoryByName(arguments.data.name) />
				<cfset archive.category = category />
				<cfset archive.postCount = category.getPostCount() />
				<cfset archive.title = category.getTitle() />
				<cfset archive.urlString = replacenocase(blog.getSetting("categoryUrl"),"{categoryName}",archive.category.getName(),"all") />
			</cfcase>
			<cfcase value="date">
				<cfset archive = createObject("component","model.DateArchive") />
				<cfset archive.setYear(arguments.data.year) />
				<cfset year = arguments.data.year />
				<cfif structkeyexists(arguments.data,"month")>
					<cfset archive.setMonth(arguments.data.month) />
					<cfset month = arguments.data.month />
				</cfif>
				<cfif structkeyexists(arguments.data,"day")>
					<cfset archive.setDay(arguments.data.day) />
					<cfset day = arguments.data.day />
				</cfif>
								
				<cfset archive.postCount = variables.appManager.getPostsManager().getPostCountByDate(year, month, day) />
				<cfif friendlyUrls>
					<cfset archive.urlString = blog.getSetting("archivesUrl") & "date/" & archive.getUrl() />
				<cfelse>
					<cfset archive.urlString = blog.getSetting("archivesUrl") & archive.getUrl() />
				</cfif>
				<cfset archive.urlString = replacenocase(archive.urlString, "{archiveType}", "date","all") />
			</cfcase>				
			<cfcase value="author">
				<cfset archive = createObject("component","model.AuthorArchive") />
				<cfset author = variables.appManager.getAuthorsManager().getAuthorByAlias(arguments.data.id) />
				<cfset archive.setAuthor(author) />
				<cfset archive.setPostCount(variables.appManager.getPostsManager().getPostCountByAuthor(author.getId())) />
				<cfset archive.urlString = author.getArchivesUrl() />
			</cfcase>
			
			<cfcase value="search">
				<cfset archive = createObject("component","model.SearchArchive") />
				<cfset archive.keyword = data.keyword />
				<cfset archive.title = data.keyword />
				<cfset archive.postCount = variables.appManager.getPostsManager().getPostCountByKeyword(data.keyword) />
				<cfset urlString = blog.getSetting("searchUrl") />
				
				<cfset archive.urlString = urlString />
				
				<cfif friendlyUrls>
					<!--- this is a friendly url --->
					<cfset archive.urlString = archive.urlString & URLEncodedFormat(archive.keyword) />
				<cfelse>
					<cfset archive.urlString = archive.urlString & "&term=" & URLEncodedFormat(archive.keyword) />
				</cfif>
			</cfcase>
			<cfcase value="multicategory">
				<cfset archive = createObject("component","model.CategoryArchive") />
				<cfset archive.category = arguments.data.name />
				<cfset archive.urlString = replacenocase(blog.getSetting("categoryUrl"),"{categoryName}",archive.category,"all") />
				<cfset archive.type = "multicategory">
			</cfcase>
			<cfdefaultcase>
				<cfset archive.type = "recent" />
				<cfset archive.postCount = variables.appManager.getPostsManager().getPostCount() />
				<cfset archive.setUrl(replacenocase(blog.getSetting("archivesUrl") & archive.getUrl(),"{archiveType}", "recent","all")) />
			</cfdefaultcase>
			
		</cfswitch>

		<cfreturn archive />
	</cffunction>	
	
	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="packageObjects" access="private" output="false" returntype="array">
		<cfargument name="objectsQuery" required="true" type="query">
		<cfargument name="type" required="true" type="any">
		
		<cfset var archives = arraynew(1) />
		<cfset var thisObject = "" />
		<cfset var blog = variables.appManager.getBlog() />
		<cfset var friendlyUrls = blog.getSetting("useFriendlyUrls") />
		<cfset var archivesUrl = blog.getSetting("archivesUrl")/>
		
		<cfif arguments.type EQ "category">
				<!--- <cfset archive = createObject("component","CategoryArchive") />
				<cfset category = variables.appManager.getCategoriesManager().getCategoryByName(arguments.data.name) />
				<cfset archive.setCategory(category) />
				<cfset archive.setPostCount(category.getPostCount()) />
				<cfset archive.setTitle(category.getTitle()) /> --->
		<cfelseif arguments.type EQ "date">
			<cfoutput query="arguments.objectsQuery">
				<cfset thisObject = createObject("component","model.DateArchive") />
				<cfset thisObject.setPostCount(post_count) />
				<cfset thisObject.setYear(year) />
				<cfif listfindnocase(arguments.objectsQuery.columnList,"month")>
					<cfset thisObject.setMonth(month) />
				</cfif>
				<cfif listfindnocase(arguments.objectsQuery.columnList,"day")>
					<cfset thisObject.setDay(day) />
				</cfif>
				<cfset archivesUrl = replacenocase(archivesUrl,"{archiveType}", "date", "all") />
				<cfif friendlyUrls>
					<cfset thisObject.setUrl(archivesUrl & "date/" & thisObject.getUrl()) />
				<cfelse>
					<cfset thisObject.setUrl(archivesUrl & thisObject.getUrl()) />
				</cfif>
				<cfset arrayappend(archives,thisObject) />
			</cfoutput>

		</cfif>
		
		<cfreturn archives />
	</cffunction>
	

</cfcomponent>