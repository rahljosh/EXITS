<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">

	<cfscript>
		// Set up the application.
		THIS.Name = "extrav1"; // "extra" & Hash(GetCurrentTemplatePath());
		THIS.ApplicationTimeout = CreateTimeSpan( 1, 0, 0, 0 ); // Application Expires in 1 day
		THIS.SessionManagement = true;
		THIS.sessionTimeout = CreateTimeSpan( 0, 8, 0, 0 ); // Session Expires in 8 hours
		THIS.ClientManagement = true;
	</cfscript>

	<!--- Define the page request properties. --->
	<cfsetting requesttimeout="20" showdebugoutput="false" enablecfoutputonly="false" />

	<cffunction
		name="OnApplicationStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires when the application is first created.">
 			
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
		<cfargument name="TargetPage" type="string" required="true" />
		
		<!--- New Address --->
        <cflocation url="https://extra.exitsapplication.com/" addtoken="no">
        
		<cfif NOT Compare(Left(currentPage, 1), "_")>
            <cfthrow 
                message="Cannot access files that start with _" 
                type="EXCEPTION"
                />	
        </cfif>
               
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
		<cfargument name="SessionScope" type="struct" required="true" />
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
 		
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
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
		 
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
		<cfargument name="Exception" type="any" required="true" />
		<cfargument name="EventName" type="string" required="false" default=""	/>
 		
        
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
    
</cfcomponent>    