<cfcomponent>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getInstance" output="false" description="Returns an object of this class" 
					access="public" returntype="any">
						
		<cfset var newinstance = "" />
		<cfif NOT structkeyexists(application,"_mainFileExplorer")> 
			<cfset newinstance = createObject("component", "MainFileExplorer").init() />
			<cfset application._mainFileExplorer = newinstance />
		 </cfif> 
		
		<cfreturn application._mainFileExplorer />
	</cffunction>	

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" output="false" returntype="any">
		<cfargument name="rootPath" type="string" required="false">
		<cfargument name="extensions" type="string" required="false" default="*">
		
	 	<cfif structkeyexists(arguments,"rootPath")>
			<cfset variables.settings.root = arguments.rootPath />
		</cfif>
	 	<cfset variables.settings.ext = arguments.extensions />
		<cfreturn this>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getFileManager" access="public" output="false" returntype="any">
		<cfif NOT structkeyexists(variables,"filemanager")>
			<cfset variables.fileManager = createObject("component","FileManager").init(variables.settings.root, variables.settings.ext)/>
		</cfif>
		<cfreturn variables.fileManager />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setFileManager" access="public" output="false" returntype="any">
		<cfargument name="filemanager">

		<cfset variables.fileManager = arguments.filemanager>

	</cffunction>
		
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getSettings" output="false" description="Gets the settings for this application" 
					access="private" returntype="void">
				
		<cfscript>
			variables.settings = structnew();

			variables.settings.root  = GetProfileString(variables.configfile, "default", "rootDirectory");
			variables.settings.ext = GetProfileString(variables.configfile, "default", "allowedExtensions");
		</cfscript>

	</cffunction> 
	
				
</cfcomponent>