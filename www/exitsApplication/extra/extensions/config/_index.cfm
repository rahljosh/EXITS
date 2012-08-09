<!--- ------------------------------------------------------------------------- ----
	
	File:		_index.cfm
	Author:		Marcus Melo
	Date:		October, 14 2010
	Desc:		Application Configuration index - configures the system. 
				
----- ------------------------------------------------------------------------- --->

<cfscript>
	// CLEAR APPLICATION SCOPE
	StructClear(APPLICATION);
</cfscript>

<!--- Set up init variables --->

<!--- Stores the date of the last APPLICATION initialization --->
<cfparam 
	name="APPLICATION.DateLastInit" 
	type="string"
	default="#Now()#" 
	/>

<!--- 
	Stores the date of the last SESSION initialization. This is defaulted to be less than the APPLICATION initialization since we want to make 
	sure that the session will be initialize if the system reboots. 
--->
<cfparam 
	name="SESSION.DateLastInit"
	type="string"
	default="#DateAdd('d', -1, APPLICATION.DateLastInit)#" 
	/>


<!--- Param Application variables --->
<cfparam name="APPLICATION.applicationID" default="0">
<cfparam name="APPLICATION.foreignTable" default="">


<!--- Try to initialize some type-specific variables --->
<cftry>
    
    <!--- This is URL variable that signals a re-initialization of the system --->
    <cfparam 
        name="URL.Init"
        type="numeric"
        default="0"
        />

	<!--- This is a URL variable that signals a re-initialization of the APPLICATION --->
	<cfparam 
		name="URL.initApp" 
		type="numeric"
		default="0"
		/>
		
	<!--- This is a URL variable that signals a re-initialization of the SESSION --->
	<cfparam 
		name="URL.InitSession"
		type="numeric"
		default="0"
		/>

	<!--- Catch any errors --->
	<cfcatch>
		<cfset URL.Init = 0 />
		<cfset URL.initApp = 0 />
		<cfset URL.InitSession = 0 />
	</cfcatch>
    
</cftry>

<!--- Set up Application Components. This gets included first as there will be other parts of the config that rely on UDFs. --->
<cfinclude template="_app_components.cfm" />

<!--- Set up Application variables --->
<cfinclude template="_app.cfm" />
