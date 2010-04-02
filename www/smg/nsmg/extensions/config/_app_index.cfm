<!--- ------------------------------------------------------------------------- ----
	
	File:		_app_index.cfm
	Author:		Marcus Melo
	Date:		March, 30 2010
	Desc:		Application Configuration index - configures the system. 
				
----- ------------------------------------------------------------------------- --->

<!--- Set up init variables --->

<!--- Stores the date of the last APPLICATION initialization --->
<cfparam 
	name="APPLICATION.DateLastInit" 
	type="string"
	default="#Now()#" 
	/>

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
		name="URL.InitApplication" 
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
		<cfset URL.InitApplication = 0 />
		<cfset URL.InitSession = 0 />
	</cfcatch>
    
</cftry>


<!--- Set up Application variables --->
<cfinclude template="_app.cfm" />


<!--- Set up Components --->
<cfinclude template="_app_components.cfm" />

