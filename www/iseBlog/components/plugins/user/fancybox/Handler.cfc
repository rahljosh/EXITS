<cfcomponent extends="BasePlugin">

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::: INITIALIZE PLUGIN ::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
		<cfset setManager(arguments.mainManager) />
		<cfset setPreferencesManager(arguments.preferences) />
		<cfset setPackage("com/visual28/mango/plugins/fancybox") />
		<cfset initSettings(
			fancyboxClass = ".thumbnails", 
			fancyboxZoomSpeedIn = "500", 
			fancyboxZoomSpeedOut = "500",
			fancyboxOverlayShow = "true"
		) />
		<cfreturn this/>
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::: SETUP ::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfreturn "<strong>Fancybox has been activated:</strong> Would you like to <a href='generic_settings.cfm?event=showFancyboxSettings&amp;owner=fancybox&amp;selected=showFancyboxSettings'>configure it</a> now?" />
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::: UNSETUP ::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn "<strong>Fancybox has been deactivated</strong>: If there were problems you had with the plugin, go to <a href='http://www.visual28.com'>www.visual28.com.com</a> for support." />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::: EVENT HANDLER ::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />		
		<cfreturn />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::: PROCESS EVENTS ::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<cfset var removeScripts = "" />
		<cfset var addMessage = "" />
		<cfset var data =  "" />
		<cfset var eventName = arguments.event.name />
		<cfif eventName EQ "beforeHtmlHeadEnd">	
			<cfsavecontent variable="removeScripts">
			<cfoutput>
	<link rel="stylesheet" type="text/css" href="#getAssetPath()#assets/fancy.css">
	<script type="text/javascript" src="#getAssetPath()#assets/jquery.fancybox-1.0.0.js"></script>
	<script type="text/javascript" src="#getAssetPath()#assets/jquery.pngFix.pack.js"></script>
	<script type="text/javascript">
		$(function(){
			$("#getSetting('fancyboxClass')#").fancybox({ 'zoomSpeedIn': #getSetting('fancyboxZoomSpeedIn')#, 'zoomSpeedOut': #getSetting('fancyboxZoomSpeedOut')#, 'overlayShow': #getSetting('fancyboxOverlayShow')# }); 	
		});
	</script>
			</cfoutput>
			</cfsavecontent>
			<cfset data = arguments.event.outputData />
			<cfset data = data & removeScripts />
			<cfset arguments.event.outputData = data />


		<!--- admin nav event --->
		<cfelseif eventName EQ "settingsNav">
			<cfset link = structnew() />
			<cfset link.owner = "fancybox">
			<cfset link.page = "settings" />
			<cfset link.title = "Fancybox" />
			<cfset link.eventName = "showFancyboxSettings" />
			<cfset arguments.event.addLink(link)>
	

		<!--- admin settings event --->
		<cfelseif eventName EQ "showFancyboxSettings" AND getManager().isCurrentUserLoggedIn()>
			<cfset data = arguments.event.data />				
			<cfif structkeyexists(data.externaldata,"apply")>
				<cfset setSettings(
					fancyboxClass = data.externaldata.fancyboxClass, 
					fancyboxZoomSpeedIn = data.externaldata.fancyboxZoomSpeedIn, 
					fancyboxZoomSpeedOut = data.externaldata.fancyboxZoomSpeedOut, 
					fancyboxOverlayShow = data.externaldata.fancyboxOverlayShow
				) />
				<cfset persistSettings() />
				<cfset data.message.setstatus("success") />
				<cfset data.message.setType("settings") />
				<cfset data.message.settext("Fancybox Setting Updated")/>
			</cfif>
			<cfsavecontent variable="page">
				<cfinclude template="admin/settingsForm.cfm">
			</cfsavecontent>
			<cfset data.message.setTitle("Fancybox Settings") />
			<cfset data.message.setData(page) />
		</cfif>
		<cfreturn arguments.event />
	</cffunction>

</cfcomponent>