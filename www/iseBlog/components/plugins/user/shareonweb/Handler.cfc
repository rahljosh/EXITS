<cfcomponent extends="BasePlugin">
	<cfset variables.name = "Open Search Plugin">
	<cfset variables.id = "com.thecfguy.mango.plugins.shareonweb">
	<cfset variables.package = "com/thecfguy/mango/plugins/shareonweb"/>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
			<cfset var blogid = arguments.mainManager.getBlog().getId() />
			<cfset var path = blogid & "/" & variables.package />
			<cfset setManager(arguments.mainManager) />
			<cfset setPreferencesManager(arguments.preferences) />
			<cfset setPackage(variables.package) />           
			<cfset variables.manager = arguments.mainManager />
			<cfset variables.shareOnWebSettingsFile = variables.preferencesManager.get(path,"shareOnWebSettingsFile","shareOnWeb.xml") />
			<cfset loadshareOnWebSettings()>
		<cfreturn this/>
	</cffunction>
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfreturn "ShareOnWeb plugin activated. <br />You can now <a href='generic_settings.cfm?event=showshareOnWebSettings&amp;owner=thecfguy&amp;selected=showshareOnWebSettings'>Configure it</a>" />
	</cffunction>

	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
			<cfset var eventName = arguments.event.name />
			<cfset var pagesearchxml="">
			<!--- admin nav event --->
			<cfset path = variables.manager.getBlog().getId() & "/" & variables.package />
			<cfif eventName EQ "postGetContent" OR eventName EQ "pageGetContent">
				<cfset data = arguments.event.accessObject />
				<cfif val(variables.shareLink)>
					<cfset data.content = data.content & variables.shareOnWebCode />
				</cfif>
				<cfif val(variables.rssFeed)>
					<cfset data.content = data.content & variables.rsscode />
				</cfif>
			<cfelseif eventName EQ "beforeHtmlBodyEnd">
				<cfif variables.addThisSharebar eq 1>
					<cfset data = arguments.event />
					<cfset data.outputdata = data.outputdata & '<script src="http://sharebar.addthiscdn.com/v1/sharebar.js" type="text/javascript"></script>'>
					<cfset data.outputdata = data.outputdata  & variables.sidebarDiv>
				</cfif>
			<cfelseif eventName EQ "settingsNav">
				<cfset link = structnew() />
				<cfset link.owner = "thecfguy">
				<cfset link.page = "settings" />
				<cfset link.title = "ShareOnWeb" />
				<cfset link.eventName = "showshareOnWebSettings" />
				<cfset arguments.event.addLink(link)>
			<!--- admin event --->
			<cfelseif eventName EQ "showshareOnWebSettings" AND variables.manager.isCurrentUserLoggedIn()>
				<cfset data = arguments.event.getData() />
				<cfset errorMsg = "">
				<cfif structkeyexists(data.externaldata,"apply")>
					<cfset path = variables.manager.getBlog().getId() & "/" & variables.package />
					<cfset blogid = variables.manager.getBlog().getId() />
					<cfset data = arguments.event.getData() />
					<cfif trim(data.externaldata.username) eq "">
						<cfset username="xa-4b5354282d4fbfdf">
					<cfelse>
						<cfset username=data.externaldata.username>
					</cfif>
					<cfif structKeyExists(data.externaldata,"sharelink") and data.externaldata.sharelink EQ 1>
						<cfif data.externaldata.buttonstyle EQ 5 and not len(trim(data.externaldata.shareonwebcode))>
							<cfset errorMsg="Enter custom code from addThis.com">
						</cfif>
						<cfswitch expression="#data.externaldata.buttonstyle#">
							<cfcase value="1">
								<cfset code='<a class="addthis_button" href="http://www.addthis.com/bookmark.php?v=250&amp;username=[username]"><img src="http://s7.addthis.com/static/btn/v2/lg-share-en.gif" width="125" height="16" alt="Bookmark and Share" style="border:0"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##username=xa-4b5354282d4fbfdf"></script>'>
							</cfcase>
							<cfcase value="2">
								<cfset code='<a class="addthis_button" href="http://www.addthis.com/bookmark.php?v=250&amp;username=[username]"><img src="http://s7.addthis.com/static/btn/sm-share-en.gif" width="83" height="16" alt="Bookmark and Share" style="border:0"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##username=xa-4b5354f13cd6d9dd"></script>'>
							</cfcase>
							<cfcase value="3">
								<cfset code='<div class="addthis_toolbox addthis_default_style"><a href="http://www.addthis.com/bookmark.php?v=250&amp;username=[username]" class="addthis_button_compact">Share</a><span class="addthis_separator">|</span><a class="addthis_button_facebook"></a><a class="addthis_button_myspace"></a><a class="addthis_button_google"></a><a class="addthis_button_twitter"></a></div><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##username=xa-4b53552355eca066"></script>'>
							</cfcase>
							<cfcase value="4">
								<cfset code='<div class="addthis_toolbox addthis_default_style"><a href="http://www.addthis.com/bookmark.php?v=250&amp;username=[username]" class="addthis_button_compact">Share</a></div><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##username=xa-4b535557255b1016"></script>'>
							</cfcase>
							<cfcase value="5">
								<cfset code=data.externaldata.shareonwebcode>
							</cfcase>
						</cfswitch>
						<cfset code = replace(code,"[username]",username)>						
					<cfelse>
						<cfset data.externaldata.sharelink = 0>
						<cfset code = "">
					</cfif>
					<cfif structKeyExists(data.externaldata,"rssFeed") and data.externaldata.rssFeed EQ 1>
						<cfif not len(trim(data.externaldata.feedurl))>
							<cfset errorMsg="Enter your feed url">
						</cfif>
						<cfswitch expression="#data.externaldata.rssbuttonstyle#">
							<cfcase value="1">
								<cfset rsscode='<a href="http://www.addthis.com/feed.php?username=[username]&amp;h1=%5Burl%5D&amp;t1=" onclick="return addthis_open(this, ''feed'', ''[url]'')" alt="Subscribe using any feed reader!" target="_blank"><img src="http://s7.addthis.com/static/btn/lg-rss-2-en.gif" width="125" height="16" alt="Subscribe" style="border:0"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##username=xa-4b5c1b2b6ec5fd7d"></script>'>
							</cfcase>
							<cfcase value="2">
								<cfset rsscode='<a href="http://www.addthis.com/feed.php?username=[username]&amp;h1=%5Burl%5D&amp;t1=" onclick="return addthis_open(this, ''feed'', ''[url]'')" alt="Subscribe using any feed reader!" target="_blank"><img src="http://s7.addthis.com/static/btn/lg-feed-2-en.gif" width="125" height="16" alt="Subscribe" style="border:0"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##username=xa-4b5c1b9877032aa8"></script>'>
							</cfcase>
							<cfcase value="3">
								<cfset rsscode='<a href="http://www.addthis.com/feed.php?username=[username]&amp;h1=%5Burl%5D&amp;t1=" onclick="return addthis_open(this, ''feed'', ''[url]'')" alt="Subscribe using any feed reader!" target="_blank"><img src="http://s7.addthis.com/static/btn/sm-rss-en.gif" width="83" height="16" alt="Subscribe" style="border:0"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##username=xa-4b5c1c210dc58328"></script>'>
							</cfcase>
							<cfcase value="4">
								<cfset rsscode='<a href="http://www.addthis.com/feed.php?username=[username]&amp;h1=%5Burl%5D&amp;t1=" onclick="return addthis_open(this, ''feed'', ''[url]'')" alt="Subscribe using any feed reader!" target="_blank"><img src="http://s7.addthis.com/static/btn/sm-feed-en.gif" width="83" height="16" alt="Subscribe" style="border:0"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js##username=xa-4b5c1c8747b68987"></script>'>
							</cfcase>
						</cfswitch>
						<cfset rsscode = replace(rsscode,"[username]",username)>
						<cfset rsscode = replace(rsscode,"[url]",data.externaldata.feedurl)>
					<cfelse>
						<cfset data.externaldata.rssFeed = 0>
						<cfset rsscode="">
					</cfif>
					<cfif not structKeyExists(data.externalData,"addthissharebar")>
						<cfset data.externalData.addthissharebar = 0>
					</cfif>
					<cfsavecontent  variable="pagesearchxml"><cfoutput><?xml version="1.0"?>
<shareonweb>
<username>#data.externaldata.username#</username>
<sharelink>#data.externaldata.sharelink#</sharelink>
<buttonstyle>#data.externaldata.buttonstyle#</buttonstyle>
<code><![CDATA[#code#]]></code>
<rssFeed>#data.externaldata.rssFeed#</rssFeed>
<rssbuttonstyle>#data.externaldata.rssbuttonstyle#</rssbuttonstyle>
<rsscode><![CDATA[#rsscode#]]></rsscode>
<feedurl><![CDATA[#data.externaldata.feedurl#]]></feedurl>
<addThisSharebar>#data.externaldata.addThisSharebar#</addThisSharebar>
<sidebarDiv><![CDATA[#data.externaldata.sidebarDiv#]]></sidebarDiv>
</shareonweb>
</cfoutput></cfsavecontent>
					<cfif NOT len(variables.shareOnWebSettingsFile)>
						<cfset variables.shareOnWebSettingsFile = "shareOnWeb.xml" />
						<cfset variables.preferencesManager.put(path,"shareOnWebSettingsFile", variables.shareOnWebSettingsFile) />
					</cfif>

					<cffile action="write" file="#GetDirectoryFromPath(GetCurrentTemplatePath())#assets/#variables.shareOnWebSettingsFile#"
							output="#pagesearchxml#">
					<cfif not len(errorMsg)>
						<cfset data.message.setstatus("success") />
						<cfset data.message.setType("settings") />
						<cfset data.message.settext("Settings updated")/>
					<cfelse>
						<cfset data.message.setstatus("error") />
						<cfset data.message.setType("settings") />
						<cfset data.message.settext(errorMsg)/>
					</cfif>
				</cfif>
				<cfset loadshareOnWebSettings()>
				<cfsavecontent variable="page">
					<cfinclude template="admin/settingsForm.cfm">
				</cfsavecontent>
				<!--- change message --->
				<cfset data.message.setTitle("ShareOnWeb settings") />
				<cfset data.message.setData(page) />
			<cfelseif eventName EQ "beforeHtmlHeadEnd">

			</cfif>
		<cfreturn arguments.event />
	</cffunction>

	<cffunction name="loadshareOnWebSettings" access="private" output="false">
		<cfset var xmlcontent="">
		<cfset var arr="">
		<cfset var openxml="">
		<cfif len(variables.shareOnWebSettingsFile) AND fileexists(GetDirectoryFromPath(GetCurrentTemplatePath()) & "assets\" & variables.shareOnWebSettingsFile)>
			<cfsavecontent variable="xmlcontent"><cfinclude template="assets/#variables.shareOnWebSettingsFile#"></cfsavecontent>
			<cfset openxml = xmlParse(xmlcontent)>
			<cfset variables.shareLink = openxml.shareonweb.shareLink.XmlText>
			<cfset variables.buttonstyle = openxml.shareonweb.buttonstyle.XmlText>
			<cfset variables.shareonwebcode = openxml.shareonweb.code.XmlText>
			<cfset variables.rssFeed = openxml.shareonweb.rssFeed.XmlText>
			<cfset variables.rssbuttonstyle = openxml.shareonweb.rssbuttonstyle.XmlText>
			<cfset variables.feedurl = openxml.shareonweb.feedurl.XmlText>
			<cfset variables.rsscode = openxml.shareonweb.rsscode.XmlText>
			<cfset variables.addThisSharebar = openxml.shareonweb.addThisSharebar.XmlText>
			<cfset variables.sidebarDiv =openxml.shareonweb.sidebarDiv.XmlText>
			<cfset variables.username =openxml.shareonweb.username.XmlText>
		<cfelse>
			<cfset variables.shareLink = 1>
			<cfset variables.buttonstyle = 1>
			<cfset variables.shareonwebcode = "">
			<cfset variables.rssFeed = "0">
			<cfset variables.rssbuttonstyle = "0">
			<cfset variables.feedurl = "">
			<cfset variables.addThisSharebar = "0">
			<cfset variables.sidebarDiv ="">
			<cfset variables.username ="">
			<cfset variables.rsscode = "">
		</cfif>
	</cffunction>
</cfcomponent>