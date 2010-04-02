<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">


    <cfscript>
		// Set up the application.
		THIS.Name = "smg";
		THIS.ApplicationTimeout = CreateTimeSpan(1,0,0,0);			
		THIS.clientManagement = true;
		
		//THIS.clientStorage = 'MySql';
		//THIS.SessionManagement = true;
		//THIS.sessionTimeout = CreateTimeSpan(0,2,0,0);
		
		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
			return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
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
	 		<cfinclude template="extensions/config/_app_index.cfm" />
 
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
        <cfinclude template="extensions/config/_index.cfm" />

		<cfscript>
			// Check if we need to re-init the application
			if ( VAL(URL.init) ) {
				// Clear the Application structure	
				StructClear(APPLICATION.CFC);					
				THIS.OnApplicationStart();
				THIS.OnSessionStart();
			}
			
			// Set up Application Shot Names
			AppCFC = APPLICATION.CFC;
			AppEmail = APPLICATION.EMAIL;
			AppPath = APPLICATION.PATH;
			Constants = APPLICATION.Constants;
		</cfscript>
	
		<!--- session has expired // Go to login page. --->
        <cfif NOT VAL(CLIENT.userID) OR NOT VAL(CLIENT.userType)>
        
            <cflocation url="http://#cgi.http_host#/" addtoken="no">
        
        </cfif>
 
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
 
 	<!---
		MAINTENANCE PAGE
		ACTIVATE THIS WHILE PROCESSING DATA STEPS 3 TO 6		
	--->
    <!---
	<cffunction
		name="OnRequest"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after pre page processing is complete.">

		<!--- Define arguments. --->
		<cfargument
			name="TargetPage"
			type="string"
			required="true"
			/>

		<!--- Include the requested page. --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />

		<!--- Maintenance Page
			<cfinclude template="">
		--->
	
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	--->
    
 
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
 		<cfif NOT APPLICATION.isServerLocal>

            <cfmail to="#APPLICATION.EMAIL.Errors#" from="#APPLICATION.EMAIL.Errors#" subject="EXITS: Error On Page" type="HTML">
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
            
			<!--- Redirect to error page
            <cflocation url="" addtoken="no" />
            --->
            
        <cfelse>

 			<cfdump var="#ARGUMENTS.Exception#">
                       
        </cfif>
 		--->
        
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
</cfcomponent>