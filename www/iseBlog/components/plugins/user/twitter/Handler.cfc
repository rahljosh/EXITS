<cfcomponent extends="BasePlugin">

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
		
			<cfset setManager(arguments.mainManager) />
			<cfset setPreferencesManager(arguments.preferences) />
			<cfset setPackage("com/visual28/mango/plugins/twitter") />
			
			<cfset initSettings(
					twitterName = "TWITTER_USERNAME",
					twitterCount = "3",
					showFollow = "nofollow",
					twitterTitle = "Twitter Updates"
				) />
		
		<cfreturn this/>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		
		<cfreturn "Twitter plugin activated. Would you like to <a href='generic_settings.cfm?event=showTwitterSettings&amp;owner=twitter&amp;selected=showTwitterSettings'>configure it now</a>?" />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn "Deactivated Twitter Plugin: Was it something I said? Have problems with it? For support go to <a href='http://www.visual28.com'>www.visual28.com</a>" />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />		
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />

			<cfset var twitterDIV = "" />
			<cfset var twitterJS = "" />
			<cfset var data =  "" />
			<cfset var eventName = arguments.event.name />
			<cfset var pod = "" />
			<cfset var link = "" />
			<cfset var page = "" />
			
			<cfif eventName EQ "getPods">
				
				<!--- make sure we can add this to the pods list --->
				<cfif event.allowedPodIds EQ "*" OR listfindnocase(event.allowedPodIds, "twitter")>
						
					<cfsavecontent variable="twitterDIV"><cfoutput>
						<div id="twitter_div">
						<cfif getSetting("showFollow") eq "above"><div id="followMe"><a href="http://twitter.com/#getSetting("twitterName")#">Follow Me</a></div></cfif>
						<ul id="twitter_update_list"></ul>
						<cfif getSetting("showFollow") eq "below"><div id="followMe"><a href="http://twitter.com/#getSetting("twitterName")#">Follow Me</a></div></cfif></div>
					</cfoutput></cfsavecontent>
					
					<cfset pod = structnew() />
					<cfset pod.title = getSetting("twitterTitle") />
					<cfset pod.content = twitterDIV />
					<cfset pod.id = "twitter" />
					<cfset arguments.event.addPod(pod)>
				</cfif>
			
			<cfelseif eventName EQ "beforeHtmlBodyEnd">	
				<cfsavecontent variable="twitterJS"><cfoutput><script type="text/javascript" src="#getAssetPath()#twitterLinker.js"></script>
				<script type="text/javascript" src="http://twitter.com/statuses/user_timeline/#getSetting("twitterName")#.json?callback=twitterCallback2&amp;count=#getSetting("twitterCount")#"></script>
				</cfoutput></cfsavecontent>
				
				<cfset data = arguments.event.outputData />
				<cfset data = data & twitterJS />
				<cfset arguments.event.outputData = data />
					
					
			
			<!--- admin nav event --->
			<cfelseif eventName EQ "settingsNav">
				<cfset link = structnew() />
				<cfset link.owner = "twitter">
				<cfset link.page = "settings" />
				<cfset link.title = "Twitter" />
				<cfset link.eventName = "showTwitterSettings" />
				
				<cfset arguments.event.addLink(link)>
			
			
			<!--- admin event --->
			<cfelseif eventName EQ "showTwitterSettings" AND getManager().isCurrentUserLoggedIn()>
				<cfset data = arguments.event.data />				
				<cfif structkeyexists(data.externaldata,"apply")>
					
					<cfset setSettings(
							twitterName = data.externaldata.twitterName,
							twitterCount = data.externaldata.twitterCount,
							showFollow = data.externaldata.showFollow,
							twitterTitle = data.externaldata.twitterTitle
						) />
					<cfset persistSettings() />
					
					<cfset data.message.setstatus("success") />
					<cfset data.message.setType("settings") />
					<cfset data.message.settext("twitter info updated")/>
				</cfif>
				
				<cfsavecontent variable="page">
					<cfinclude template="admin/settingsForm.cfm">
				</cfsavecontent>
					
					<!--- change message --->
					<cfset data.message.setTitle("twitter settings") />
					<cfset data.message.setData(page) />
			
			<cfelseif eventName EQ "getPodsList"><!--- no content, just title and id --->
				<cfset pod = structnew() />
				<cfset pod.title = "Twitter" />
				<cfset pod.id = "twitter" />
				<cfset arguments.event.addPod(pod)>
			</cfif>
		
		<cfreturn arguments.event />
	</cffunction>

</cfcomponent>