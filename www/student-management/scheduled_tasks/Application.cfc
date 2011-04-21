<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">

	<cfscript>
		// Set up the application.
		//THIS.Name = "SMG-ScheduledTasks";
		THIS.Name = "SMG-ScheduledTasks-" & Hash(GetCurrentTemplatePath());
		THIS.ApplicationTimeout = CreateTimeSpan( 0, 1, 0, 0 );
		THIS.clientManagement = true;
		THIS.SessionManagement = true;
		THIS.sessionTimeout = CreateTimeSpan( 0, 1, 0, 0 );
		

		/*
			Set up a mapping on CF Admin
			/components --> C:\Websites\www\smg\nsmg\extensions\components  
			componentsPath = '/components.';
		*/

		//componentsPath = '/components.';
		componentsPath = 'nsmg.extensions.components.';
		extensionsPath = '../nsmg/extensions/';

		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
			return(CreateObject("component", (componentsPath & ARGUMENTS.strCFCName)));
		}
	</cfscript>


	<!--- Define the page request properties. --->
	<cfsetting
		requesttimeout="20"
		showdebugoutput="false"
		enablecfoutputonly="false"
		/>
 
 
	<cffunction
		name="OnApplicationStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires when the application is first created.">
		
		<!--- Include Application Settings ---> 
        <cfinclude template="#extensionsPath#config/_app_index.cfm" />
 
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
 
	<cffunction
		name="OnSessionStart"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the session is first created.">
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="OnRequestStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires at first part of page processing.">
 
		<!--- Define arguments. --->
        <cfargument
            name="TargetPage"
            type="string"
            required="true"
            />
            
        <!--- Include Config Settings ---> 
        <cfinclude template="#extensionsPath#config/_index.cfm" />

		<cfscript>
			// Check if we need to re-init the application
			if ( VAL(URL.init) ) {
				// Clear the Application structure	
				StructClear(APPLICATION.CFC);					
				THIS.OnApplicationStart();
				THIS.OnSessionStart();
			}
		</cfscript>

		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 

	<cffunction
		name="OnRequestEnd"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after the page processing is complete.">
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="OnSessionEnd"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the session is terminated.">
 
		<!--- Define arguments. --->
		<cfargument
			name="SessionScope"
			type="struct"
			required="true"
			/>
 
		<cfargument
			name="ApplicationScope"
			type="struct"
			required="false"
			default="#StructNew()#"
			/>
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="OnApplicationEnd"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the application is terminated.">
 
		<!--- Define arguments. --->
		<cfargument
			name="ApplicationScope"
			type="struct"
			required="false"
			default="#StructNew()#"
			/>
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction
		name="OnError"
		access="public"
		returntype="void"
		output="true"
		hint="Fires when an exception occures that is not caught by a try/catch.">
 
		<!--- Define arguments. --->
		<cfargument
			name="Exception"
			type="any"
			required="true"
			/>
 
		<cfargument
			name="EventName"
			type="string"
			required="false"
			default=""
			/>
		
        <!---	
 		<cfif NOT APPLICATION.IsServerLocal()>

            <cfmail to="#APPLICATION.EMAIL.Errors#" from="#APPLICATION.EMAIL.Errors#" subject="EXITS - Scheduled Task Error" type="HTML">
                <p>
                An error occurred on
                #DateFormat( Now(), "mmm d, yyyy" )# at
                #TimeFormat( Now(), "hh:mm TT" )#
                </p>
                
                <h3>Error:</h3>
                <cfdump var="#ARGUMENTS.Exception#">
                <br><br>
                
                <h3>SESSION:</h3>
                <cfdump var="#SESSION#">
                <br><br>
                
                <h3>FORM:</h3>
                <cfdump var="#FORM#">
                <br><br>
                
                <h3>URL:</h3>
                <cfdump var="#URL#"> 
                <br><br>
                
            </cfmail>
            
            <cfset GetPageContext().GetOut().ClearBuffer() />
            
        <cfelse>
			
            <!--- Display Error --->
 			<cfdump var="#ARGUMENTS.Exception#">
                       
        </cfif>
        --->
 
		<!--- Display Error --->
        <cfdump var="#ARGUMENTS.Exception#">

		<!--- Return out. --->
		<cfreturn />
	</cffunction>
  
</cfcomponent>