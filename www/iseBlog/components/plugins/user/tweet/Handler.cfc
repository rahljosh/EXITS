<cfcomponent extends="BasePlugin">

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
		<cfset setManager(arguments.mainManager) />
		<cfset setPreferencesManager(arguments.preferences) />
		<cfset setPackage("com/witheringtree/mango/plugins/tweet") />
		<cfset initSettings(
			title = "Twitter Updates", 
			loadingtext = "loading tweets...", 
			username = "seaofclouds", 
			avatarsize = "32", 
			count = "3", 
			introtext = "", 
			outrotext = "", 
			jointext = "", 
			autojointextdefault = "i said,", 
			autojointexted = "i", 
			autojointexting = "i am", 
			autojointextreply = "i replied to", 
			autojointexturl = "i am looking at", 
			query = ""
		) />
		<cfreturn this/>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfreturn "<strong>Tweet has been activated</strong><br /> 
			Would you like to <a href='generic_settings.cfm?event=showTweetSettings&amp;owner=tweet&amp;selected=showTweetSettings'>configure it</a> now?" />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn "<strong>Tweet has been deactivated</strong><br />
			If there were problems you had with the plugin, go to <a href='http://www.witheringtree.com'>www.witheringtree.com</a> for support." />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />		
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<cfset var removeScripts = "" />
		<cfset var addMessage = "" />
		<cfset var data =  "" />
		<cfset var eventName = arguments.event.name />
		<!--- add to page when it builds --->
		<cfif eventName EQ "beforeHtmlHeadEnd">	
			<cfsavecontent variable="removeScripts">
			<cfoutput>
	<!-- Tweet -->
	<link rel="stylesheet" type="text/css" href="#getAssetPath()#assets/tweet.css">
	<script type="text/javascript" src="#getAssetPath()#assets/jquery.tweet.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			$(".tweet").tweet({
				loading_text: "#getSetting('loadingtext')#", 
				username: "#getSetting('username')#", 
				avatar_size: #getSetting('avatarsize')#, 
				count: #getSetting('count')#, 
				intro_text: "#getSetting('introtext')#", 
				outro_text: "#getSetting('outrotext')#", 
				join_text: "#getSetting('jointext')#", 
				auto_join_text_default: "#getSetting('autojointextdefault')#", 
				auto_join_text_ed: "#getSetting('autojointexted')#", 
				auto_join_text_ing: "#getSetting('autojointexting')#", 
				auto_join_text_reply: "#getSetting('autojointextreply')#", 
				auto_join_text_url: "#getSetting('autojointexturl')#", 
				query: "#getSetting('query')#"
			});
		});
	</script></cfoutput>
			</cfsavecontent>
			<cfset data = arguments.event.outputData />
			<cfset data = data & removeScripts />
			<cfset arguments.event.outputData = data />


		<!--- show in settings navigation --->
		<cfelseif eventName EQ "settingsNav">
			<cfset link = structnew() />
			<cfset link.owner = "tweet">
			<cfset link.page = "settings" />
			<cfset link.title = "Tweet" />
			<cfset link.eventName = "showTweetSettings" />
			<cfset arguments.event.addLink(link)>
	

		<!--- show/update form to edit properties --->
		<cfelseif eventName EQ "showTweetSettings" AND getManager().isCurrentUserLoggedIn()>
			<cfset data = arguments.event.data />				
			<cfif structkeyexists(data.externaldata,"apply")>
				<cfset setSettings(
					title = data.externaldata.title, 
					loadingtext = data.externaldata.loadingtext, 
					username = data.externaldata.username, 
					avatarsize = data.externaldata.avatarsize, 
					count = data.externaldata.count, 
					introtext = data.externaldata.introtext, 
					outrotext = data.externaldata.outrotext, 
					jointext = data.externaldata.jointext, 
					autojointextdefault = data.externaldata.autojointextdefault, 
					autojointexted = data.externaldata.autojointexted, 
					autojointexting = data.externaldata.autojointexting, 
					autojointextreply = data.externaldata.autojointextreply, 
					autojointexturl = data.externaldata.autojointexturl, 
					query = data.externaldata.query
				) />
				<cfset f = getAssetPath() & "assets/">
				<cfset p = GetDirectoryFromPath(ExpandPath(f)) & "tweet.css">
				<cffile action="write" file="#p#" output="#data.externaldata.style#">
				<cfset persistSettings() />
				<cfset data.message.setstatus("success") />
				<cfset data.message.setType("settings") />
				<cfset data.message.settext("Tweet Setting Updated")/>
			</cfif>
			<cfsavecontent variable="page">
				<cfinclude template="admin/settingsForm.cfm">
			</cfsavecontent>
			<cfset data.message.setTitle("Tweet Settings") />
			<cfset data.message.setData(page) />


		<!--- show in pod list in admin --->
		<cfelseif eventName EQ "getPodsList">
			<cfset pod = structnew() />
			<cfset pod.title = "Twitter" />
			<cfset pod.id = "tweet" />
			<cfset arguments.event.addPod(pod)>


		<!--- show pod in list on the page --->
		<cfelseif eventName EQ "getPods">
			<cfif event.allowedPodIds EQ "*" OR listfindnocase(event.allowedPodIds, "tweet")>
				<cfsavecontent variable="tweetPod">
					<cfoutput>
						<cfinclude template="podContent.cfm" />
					</cfoutput>
				</cfsavecontent>
				<cfset pod = structnew() />
				<cfset pod.title = getSetting('title') />
				<cfset pod.content = tweetPod />
				<cfset pod.id = "tweet" />
				<cfset arguments.event.addPod(pod)>
			</cfif>
		</cfif>
		<cfreturn arguments.event />
	</cffunction>

</cfcomponent>