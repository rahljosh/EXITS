<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">

	<cfscript>
		// Set up the application.
		THIS.Name = "MPDToursV1-" & Hash(GetCurrentTemplatePath()); // "MPDToursV1-" & Hash(GetCurrentTemplatePath());
		THIS.ApplicationTimeout = CreateTimeSpan( 0, 1, 0, 0 );
		THIS.SessionManagement = true;
		THIS.sessionTimeout = CreateTimeSpan( 0, 2, 0, 0 ); // Session Expires in 2 hours

		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
			return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
		}
	</cfscript>


	<!--- Define the page request properties. --->
	<cfsetting requesttimeout="20" showdebugoutput="false" enablecfoutputonly="false" />
 

	<cffunction
		name="OnApplicationStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires when the application is first created.">
 			
            <!--- Configure Application --->
 			<cfinclude template="extensions/config/_index.cfm" />
 
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>

    
	<cffunction
		name="OnSessionStart"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the session is first created.">
			
			<!--- Set up Session variables --->
            <cfinclude template="extensions/config/_session.cfm" />
			
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
		
		<cfparam name="URL.init" default="0">
        <cfparam name="URL.initApp" default="0">
        <cfparam name="URL.initSession" default="0">

        <!--- Param Session Variables --->
        <cfparam name="SESSION.TOUR.tourID" default="0">
        <cfparam name="SESSION.TOUR.isLoggedIn" default="0">
        <cfparam name="SESSION.TOUR.studentID" default="0">
        <cfparam name="SESSION.TOUR.hostID" default="0">    
        <cfparam name="SESSION.TOUR.applicationPaymentID" default="0"> 
        
        <!--- Param Session Variables --->
        <cfparam name="SESSION.COMPANY.ID" default="0">
        <cfparam name="SESSION.COMPANY.name" default="">
        <cfparam name="SESSION.COMPANY.shortName" default="">
        <cfparam name="SESSION.COMPANY.email" default="">
        <cfparam name="SESSION.COMPANY.supportEmail" default="">
        <cfparam name="SESSION.COMPANY.siteURL" default="">
        <cfparam name="SESSION.COMPANY.exitsURL" default="">
        <cfparam name="SESSION.COMPANY.color" default="">
        <cfparam name="SESSION.COMPANY.tollFree" default="">
        <cfparam name="SESSION.COMPANY.phone" default="">
        <cfparam name="SESSION.COMPANY.fax" default="">
        
		<cfscript>
			// Reset Application and Session
			if ( URL.init EQ 1 ) {
				THIS.OnApplicationStart();
				THIS.OnSessionStart();
			}

			if ( URL.initApp EQ 1 ) {
				THIS.OnApplicationStart();
			}
			
			if ( URL.initSession EQ 1 ) {
				THIS.OnSessionStart();
			}
		</cfscript>
        
		<!--- 
			Check to see if the current path is legal. The user cannot access 
			files starting with "_" so throw error if need be. 
		--->
        <cfset currentPage = APPLICATION.CFC.UDF.GetCurrentPageFromPath(CGI.cf_template_path)>        
		
		<cfif NOT Compare(Left(currentPage, 1), "_")>
            <cfthrow 
                message="Cannot access files that start with _" 
                type="EXCEPTION"
                />	
        </cfif>
               
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
 
 	<!---
		MAINTENANCE PAGE
	--->
    <!---
	<cffunction
		name="OnRequest"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after pre page processing is complete.">
		
			<!--- Include Maintenance Page Here --->
				
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
 		
 		<cfif NOT APPLICATION.IsServerLocal>
			
            <!--- Production Environment - Email Error --->
            <cfmail to="#APPLICATION.EMAIL.errors#" from="#APPLICATION.EMAIL.support#" subject="trips.exitsapplication.com : Error" type="HTML">
                <p>
                An error occurred on
                #DateFormat( Now(), "mmm d, yyyy" )# at
                #TimeFormat( Now(), "hh:mm TT" )#
                </p>
                
                <h3>Error:</h3>
                <cfdump var="#ARGUMENTS.Exception#">
                <br /><br />
                
                <h3>SESSION:</h3>
                <cfdump var="#SESSION#">
                <br /><br />
                
                <h3>FORM:</h3>
                <cfdump var="#FORM#">
                <br /><br />
                
                <h3>URL:</h3>
                <cfdump var="#URL#"> 
                
            </cfmail>
            
            <cfset GetPageContext().GetOut().ClearBuffer() />
            
            <cflocation url="/error-message.cfm" addtoken="no" />
        
        <cfelse>
			
            <!--- Local Environment - Show Error --->
 			<cfdump var="#ARGUMENTS.Exception#">
                       
        </cfif>
        
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
    
</cfcomponent>    