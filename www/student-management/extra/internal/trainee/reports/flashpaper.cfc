<cfcomponent>
 
 	<cffunction access="private" name="write" output="false" returntype="void" hint="Writes input contents to a flashpaper file.">
		<cfargument name="contents" type="string" required="yes" hint="The content to write to the flashpaper file.">
 		<cfargument name="filename" type="string" required="no" default="temp.swf" hint="The file name of the flashpaper we are creating.">
 		<cfargument name="orientation" type="string" required="no" default="portrait" hint="Portrait or Landscape">
 		<cfargument name="cachedirectory" type="string" required="yes" hint="The cache directory for the swf file.">
 		
 		<cfdocument filename="#arguments.cachedirectory#\#arguments.filename#" format="FlashPaper" 
 					orientation="#arguments.orientation#" backgroundvisible="yes" overwrite="yes" fontembed="yes">
 			<cfoutput>
 			#arguments.contents#
 			</cfoutput>
 		</cfdocument>
 	
 	</cffunction>

 	<cffunction access="private" name="embed" output="true" returntype="void" hint="Embeds a flashpaper swf in the middle of a page.">
 		<cfargument name="filename" type="string" required="no" default="temp.swf" hint="The file name of the flashpaper we are embedding.">
 		<cfargument name="width" type="numeric" required="no" default="300" hint="The width of the embedded flashpaper object.">
 		<cfargument name="height" type="numeric" required="no" default="300" hint="The height of the embedded flashpaper object.">
 		<cfargument name="cachedirectoryUrl" type="string" required="yes" hint="The url path to the cached directory.">
 	
 		<cfoutput>
 		<object type="application/x-shockwave-flash" data="#arguments.cachedirectoryUrl#/#arguments.filename#" width="#arguments.width#" height="#arguments.height#">
 				<param name="movie" value="#arguments.cachedirectoryUrl#/#arguments.filename#" />
 				<img src="http://www.numtopia.com/terry/images/style/no_flash.gif" width="200" height="300" alt="No Flash" /> 
 		</object>
 		</cfoutput>
 		
 	</cffunction>
 	
 	<cffunction access="public" name="display" output="true" returntype="boolean" hint="Will create and embed a flashpaper entry for input contents">
 		<cfargument name="contents" type="string" required="yes" hint="The content to write to the flashpaper file.">
 		<cfargument name="filename" type="string" required="no" default="temp.swf" hint="The file name of the flashpaper we are creating.">
 		<cfargument name="orientation" type="string" required="no" default="portrait" hint="Portrait or Landscape">
 		<cfargument name="width" type="numeric" required="no" default="300" hint="The width of the embedded flashpaper object.">
 		<cfargument name="height" type="numeric" required="no" default="300" hint="The height of the embedded flashpaper object.">
 		<cfargument name="overwrite" type="boolean" required="no" default="FALSE" hint="Whether or not to force file overwriting.">
 		<cfargument name="cachedirectory" type="string" required="yes" hint="The cache directory for the swf file.">
 		<cfargument name="cachedirectoryUrl" type="string" required="yes" hint="The url path to the cached directory.">
 				
 		<cfif overwrite or not fileExists("#arguments.cachedirectory#/#arguments.filename#")>
 			<cfinvoke method="write">
 				<cfinvokeargument name="filename" value="#arguments.filename#">
 				<cfinvokeargument name="contents" value="#arguments.contents#">
 				<cfinvokeargument name="orientation" value="#arguments.orientation#">
 				<cfinvokeargument name="cachedirectory" value="#arguments.cachedirectory#">
 			</cfinvoke>
 		</cfif>
 				
 		<cfinvoke method="embed">
 			<cfinvokeargument name="filename" value="#arguments.filename#">
 			<cfinvokeargument name="width" value="#arguments.width#">
 			<cfinvokeargument name="height" value="#arguments.height#">
 			<cfinvokeargument name="cachedirectoryurl" value="#arguments.cachedirectoryurl#">
 		</cfinvoke>
 		
 		<cfreturn TRUE>
 	</cffunction>
 
 
 
 </cfcomponent>

<!----
<cfcomponent>
	

	
	<cffunction access="public" name="display" output="true" returntype="boolean" hint="Will create and embed a flashpaper entry for input contents">
		<cfargument name="contents" type="string" required="yes" hint="The content to write to the flashpaper file.">
		<cfargument name="filename" type="string" required="no" default="temp.swf" hint="The file name of the flashpaper we are creating.">
		<cfargument name="orientation" type="string" required="no" default="portrait" hint="Portrait or Landscape">
		<cfargument name="width" type="numeric" required="no" default="300" hint="The width of the embedded flashpaper object.">
		<cfargument name="height" type="numeric" required="no" default="300" hint="The height of the embedded flashpaper object.">
		<cfargument name="overwrite" type="boolean" required="no" default="FALSE" hint="Whether or not to force file overwriting.">
		<cfargument name="cachedirectory" type="string" required="yes" hint="The cache directory for the swf file.">
		<cfargument name="cachedirectoryUrl" type="string" required="yes" hint="The url path to the cached directory.">
				
				<!-----
		<cfif overwrite or not fileExists("#arguments.cachedirectory#/#arguments.filename#")>
			<cfinvoke method="write">
				<cfinvokeargument name="filename" value="#arguments.filename#">
				<cfinvokeargument name="contents" value="#arguments.contents#">
				<cfinvokeargument name="orientation" value="#arguments.orientation#">
				<cfinvokeargument name="cachedirectory" value="#arguments.cachedirectory#">
			</cfinvoke>
		</cfif>
			---->	
		<cfinvoke method="embed">
			<cfinvokeargument name="filename" value="reports/students_hired_per_company">
			<cfinvokeargument name="width" value="600">
			<cfinvokeargument name="height" value="800">
		<cfargument name="cachedirectory" type="string" required="yes" hint="The cache directory for the swf file." value="">
		<cfargument name="cachedirectoryUrl" type="string" required="yes" hint="The url path to the cached directory." value="C:\websites\extra\internal\h2b\reports\cache""http://dev.student-management.com/extra/internal/h2b/reports/cache">
		</cfinvoke>
		
		<cfreturn TRUE>
	</cffunction>



</cfcomponent>
---->