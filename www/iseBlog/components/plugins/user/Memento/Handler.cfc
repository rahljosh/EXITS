<cfcomponent extends="BasePlugin">

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::: INITIALIZE PLUGIN ::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
		
			<cfset setManager(arguments.mainManager) />
			<cfset setPreferencesManager(arguments.preferences) />
			<cfset setPackage("com/visual28/mango/plugins/Memento") />
			
			<cfset initSettings(
					MementoDotPathToiEdit = "assets.plugins.Memento.iEdit",
					MementoGalleryFolder = "memento",
					MementoResizeEngine = "iEdit", 
					MementoResizeMethod = "scaleToFit",
					MementoGalleryEffect = "shadowbox",
					MementoMaxThumbSize = "100",
					MementoPreviewHeight = "800",
					MementoPreviewWidth = "800",
					MementoShowTitle = "no",
					MementoThumbClass = "mementothumbs",
					MementoCSS = ".mementothumbs img {margin: 10px;}",
					MementoKeepOriginal = "yes"
				) />
		
		<cfreturn this/>
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::: SETUP ::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfset DefaultDirectory = #expandpath('..\assets\content\memento')#>
		<cfif not directoryExists("#DefaultDirectory#")>
   			<cfdirectory action="create" directory="#DefaultDirectory#">
		</cfif>	
		<cfreturn "Memento plugin activated. Would you like to <a href='generic_settings.cfm?event=showMementoSettings&amp;owner=Memento&amp;selected=showMementoSettings'>configure it now</a>?" />
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::: UNSETUP ::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn "Deactivated Plugin: Was it something I said? Have problems with it? For support go to <a href='http://www.visual28.com'>www.visual28.com</a>" />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::: EVENT HANDLER ::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />		
		<cfreturn />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::: PROCESS EVENTS ::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
			
			<!--- vars required by all plugins --->
			<cfset var data =  "" />
			<cfset var eventName = arguments.event.name />
			<cfset var link = "" />
			<cfset var page = "" />
			
			<!--- Plugin Specific vars --->
			<cfset var match = "" />
			<cfset var noMoreMatches = false />
			<cfset var fancyboxscripts = "" />
			<cfset basePath = getManager().getBlog().getURL() />
			<cfset DefaultDirectory = expandpath('assets\content\memento') />
			<cfset outputGallery = "" />
			<cfset outputcss = "" />
			<cfset albumName = "" />
			<cfset fullTag = "" />
			<cfset myImages = "" />
			<cfset myImage = "" />
			<cfset name = "" />		
			
			
			<!--- process page and post content events --->
			<cfif eventName is "pageGetContent" or eventName is "postGetContent">
			<cfset data = arguments.event.accessObject />
				
				<!--- loop over data and get all [memento:AlbumName] until it returns false --->
				<cfloop condition="noMoreMatches is false"> 
					<cfset match = refindnocase("\[memento:([-_[:alnum:]]+)\]", data.content, 1, true) />				
					<cfif match.len[1] eq 0>
						<cfset noMoreMatches = true />
					
					<cfelse>
						<cfset fullTag = mid(data.content, match.pos[1], match.len[1]) />
						<cfset albumName = mid(data.content, match.pos[2], match.len[2]) />
						<cfset imageDirectory = "#DefaultDirectory#/#albumName#">
						
						<cfdirectory directory="#imageDirectory#" name="myImages">
						
						<!--- make  a thumbs folder if one does already not exist --->
						<cfif not directoryExists("#imageDirectory#/thumbs")>
						   <cfdirectory action="create" directory="#imageDirectory#/thumbs">
						</cfif>
						
						<cfsavecontent variable="outputGallery">
							<cfloop query="myImages">
							   <!--- valid images only --->
							   <cfif isImageFile("#directory#/#name#")>
								
									<!--- CFIMAGE RESIZE FUNCTIONS --->
									<cfif getSetting("MementoResizeEngine") eq "cfimage">
										<cfset targetThumbSize = getSetting("MementoMaxThumbSize")>
										<cfset edgeTrim = 0>
										
										<!--- check for a thumbnail --->
										<cfif not fileExists("#directory#/thumbs/#name#")>
											<cfimage action="read" source="#directory#/#name#" name="newThumbImage">
												<cfif getSetting("MementoResizeMethod") eq "scaleToFit">
													<cfset imageScaleToFit(newThumbImage, getSetting("MementoMaxThumbSize"), getSetting("MementoMaxThumbSize"))>
												
												<cfelseif getSetting("MementoResizeMethod") eq "crop">
													<!--- If portriate mode, then resize for the width as it's the smaller value --->
													<cfif newThumbImage.height GT newThumbImage.width>
														<cfset ImageResize(newThumbImage,'#targetThumbSize#','')>
														<cfset edgeTrim = newThumbImage.height - targetThumbSize>
														<cfset edgeTrim = edgeTrim / 2>
														<cfset ImageCrop(newThumbImage,0,edgeTrim,targetThumbSize,targetThumbSize)>
													
													<!--- If Landscape mode, then resize for the height as it's the smaller value --->
													<cfelseif newThumbImage.width GT newThumbImage.height>
														<cfset ImageResize(newThumbImage,'','#targetThumbSize#')>
														<cfset edgeTrim = newThumbImage.width - targetThumbSize>
														<cfset edgeTrim = edgeTrim / 2>
														<cfset ImageCrop(newThumbImage,edgeTrim,0,targetThumbSize,targetThumbSize)>
													
													<cfelse>
														<cfset imageScaleToFit(newThumbImage, targetThumbSize, targetThumbSize)>
													</cfif>
												</cfif>
											<cfset imageWrite(newThumbImage, "#directory#/thumbs/#name#",true)>
										</cfif>
									
									
									<!--- IEDIT RESIZE FUNCTIONS --->
									<cfelseif getSetting("MementoResizeEngine") eq "iEdit">
										<cfset targetThumbSize = getSetting("MementoMaxThumbSize")>
										<cfset edgeTrim = 0>
										
										<cfif not fileExists("#directory#/thumbs/#name#")>
											<cfset DotPathToiEdit = getSetting("MementoDotPathToiEdit")>
											<cfobject component="#DotPathToiEdit#" name="myImage">
											<cfset myImage.SelectImage("#directory#/#name#")>
											
											<cfif getSetting("MementoResizeMethod") eq "scaleToFit">
												<cfset myImage.scaleToFit(targetThumbSize,targetThumbSize)>
											
											<cfelseif getSetting("MementoResizeMethod") eq "crop">
												
												<cfif myImage.getheight() gt myImage.getwidth()>
													<cfset myImage.scaleWidth(targetWidth)>
													<cfset edgeTrim = myImage.getheight() - targetThumbSize>
													<cfset edgeTrim = edgeTrim / 2>
													<cfset myImage.crop(targetThumbSize,targetThumbSize,0,edgeTrim)>
												
												<cfelseif myImage.getwidth() gt myImage.getheight()>
													<cfset myImage.scaleHeight(targetThumbSize)>
													<cfset edgeTrim = myImage.getwidth() - targetThumbSize>
													<cfset edgeTrim = edgeTrim / 2>
													<cfset myImage.crop(targetHeight,targetThumbSize,edgeTrim,0)>
												
												<cfelse>
													<cfset myImage.scaleToFit(targetThumbSize,targetThumbSize)>
													
												</cfif>
											</cfif>
											<!--- Output the image ---->
											<cfset myImage.output("#directory#/thumbs/#name#", "jpg",100)>
										</cfif>
										
									</cfif>
									<!--- END ALL RESIZE FUNCTIONS --->
								 
								 <cfif getSetting("MementoGalleryEffect") eq "shadowbox">
								 	<cfoutput><a href="#basePath#assets/content/memento/#albumName#/#name#"<cfif getSetting("MementoShowTitle") eq "yes"> title="#name#"</cfif> class="#getSetting("MementoThumbClass")#" rel="shadowbox[group]"><img src="#basePath#assets/content/memento/#albumName#/thumbs/#name#" alt="#name#" /></a></cfoutput>
								 
								 <cfelseif getSetting("MementoGalleryEffect") eq "lightbox">
								 	<cfoutput><a href="#basePath#assets/content/memento/#albumName#/#name#"<cfif getSetting("MementoShowTitle") eq "yes"> title="#name#"</cfif> class="#getSetting("MementoThumbClass")#" rel="lightbox[group]"><img src="#basePath#assets/content/memento/#albumName#/thumbs/#name#" alt="#name#" /></a></cfoutput>
								 
								 <cfelseif getSetting("MementoGalleryEffect") eq "fancybox">
								 	<cfoutput><a href="#basePath#assets/content/memento/#albumName#/#name#"<cfif getSetting("MementoShowTitle") eq "yes"> title="#name#"</cfif> class="#getSetting("MementoThumbClass")#"><img src="#basePath#assets/content/memento/#albumName#/thumbs/#name#" alt="#name#" /></a></cfoutput>
								 
								 <cfelse>
								 	<cfoutput><a href="#basePath#assets/content/memento/#albumName#/#name#"<cfif getSetting("MementoShowTitle") eq "yes"> title="#name#"</cfif> class="#getSetting("MementoThumbClass")#"><img src="#basePath#assets/content/memento/#albumName#/thumbs/#name#" alt="#name#" /></a></cfoutput>
								 </cfif>
								  
								  
							   </cfif>
							</cfloop>
						</cfsavecontent>
						
						<cfset data.content = replace(data.content, fullTag, outputGallery, "all") />	
					</cfif>
				</cfloop>
					
			<cfelseif eventName EQ "beforeHtmlHeadEnd">
				<cfif getSetting("MementoCSS") neq "">
					<cfsavecontent variable="outputcss"><cfoutput>
					<style type="text/css">
						<!--
							#getSetting("MementoCSS")#
						-->
					</style>
					</cfoutput></cfsavecontent>
					
					<cfset data = arguments.event.outputData />
					<cfset data = data & outputcss />
					<cfset arguments.event.outputData = data />
				</cfif>	
			
			<!--- admin nav event --->
			<cfelseif eventName EQ "settingsNav">
				<cfset link = structnew() />
				<cfset link.owner = "Memento">
				<cfset link.page = "settings" />
				<cfset link.title = "Memento" />
				<cfset link.eventName = "showMementoSettings" />
				<cfset arguments.event.addLink(link)>
			
			
			<!--- admin event --->
			<cfelseif eventName EQ "showMementoSettings" AND getManager().isCurrentUserLoggedIn()>
				<cfset data = arguments.event.data />				
				<cfif structkeyexists(data.externaldata,"apply")>
					
					<!--- save plugin settings --->
					<cfset setSettings(
							MementoGalleryEffect = data.externaldata.MementoGalleryEffect,
							MementoResizeEngine = data.externaldata.MementoResizeEngine, 
							MementoResizeMethod = data.externaldata.MementoResizeMethod,
							MementoMaxThumbSize = data.externaldata.MementoMaxThumbSize,
							MementoShowTitle = data.externaldata.MementoShowTitle,
							MementoThumbClass = data.externaldata.MementoThumbClass,
							MementoCSS = data.externaldata.MementoCSS,
							MementoDotPathToiEdit = data.externaldata.MementoDotPathToiEdit
						) />
					
					<cfset persistSettings() />
					<cfset data.message.setstatus("success") />
					<cfset data.message.setType("settings") />
					<cfset data.message.settext("Memento Settings Updated") />
				</cfif>
				
				<cfsavecontent variable="page">
					<cfinclude template="admin/settingsForm.cfm">
				</cfsavecontent>
					
					<!--- change h2 page title message --->
					<cfset data.message.setTitle("Memento Photo Gallery Settings") />
					<cfset data.message.setData(page) />			
			</cfif>
			
		<cfreturn arguments.event />
			
	</cffunction>

</cfcomponent>