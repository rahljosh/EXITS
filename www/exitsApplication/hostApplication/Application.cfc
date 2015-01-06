<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">

	<cfscript>
		// Set up the application.
		//THIS.Name = "EXITS";
		THIS.Name = "EXITS-HostApplication"; //  & Hash(GetCurrentTemplatePath())
		THIS.applicationTimeout = CreateTimeSpan( 0, 1, 0, 0 );
		THIS.sessionManagement = true;
		THIS.sessionTimeout = CreateTimeSpan( 0, 4, 0, 0 ); // Session Expires in 4 hours
		THIS.clientManagement = true;
		THIS.selectedSeason = 0; 
		
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
		
		<!--- Param URL Variables --->
		<cfparam name="URL.init" default="0">
        <cfparam name="URL.initApp" default="0">
        <cfparam name="URL.initSession" default="0">
        <cfparam name="URL.uniqueID" default="">
        <cfparam name="URL.userID" default="0">
        <cfparam name="URL.season" default="0">
        <cfparam name="URL.section" default="login">
        
		<cfscript>
			// Reset Application and Session
			if ( URL.init EQ 1 ) {
				THIS.OnApplicationStart();
				THIS.OnSessionStart();
			}
			
			// Init Application
			if ( URL.initApp EQ 1 ) {
				THIS.OnApplicationStart();
			}
			
			// Init Session
			if ( URL.initSession EQ 1 ) {
				THIS.OnSessionStart();
			}
			
			// Set the season to the URL variable if it exists
			if (VAL(URL.season)) {
				APPLICATION.selectedSeason = URL.season;	
			}
			
			/***
				Check to see if the current path is legal. The user cannot access 
				files starting with "_" so throw error if need be. 
			***/
			currentPage = APPLICATION.CFC.UDF.GetCurrentPageFromPath(CGI.cf_template_path);
		</cfscript>
        
		<!--- uniqueID Login | Make sure the link is coming from EXITS --->  
        <cfif LEN(URL.uniqueID) AND ( FindNoCase("smg.local", CGI.HTTP_REFERER) OR FindNoCase("esi.local",CGI.HTTP_REFERER) OR FindNoCase("exitsapplication.com", CGI.HTTP_REFERER) )>
            
            <!--- Check if we have a host account --->
            <cfquery name="qLoginHostFamily" datasource="#APPLICATION.DSN.Source#">
                SELECT  
                    smg_hosts.hostID,
                    smg_hosts.familylastname,
                    smg_hosts.email,
                    smg_hosts.regionID,
                    smg_host_app_season.applicationStatusID,
                	smg_host_app_season.ID
                FROM 
                    smg_hosts
              	INNER JOIN smg_host_app_season ON smg_host_app_season.hostID = smg_hosts.hostID
                    AND smg_host_app_season.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.selectedSeason#">
                WHERE 
                    smg_hosts.uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(URL.uniqueID)#">              
            </cfquery>
    
            <cfscript>
                // Host Account found - Log them in
                if ( qLoginHostFamily.recordcount ) {
    
					// Login Host Family - Menu Available
					APPLICATION.CFC.SESSION.setHostSession(
						hostID=qLoginHostFamily.hostID,												
						applicationStatus=qLoginHostFamily.applicationStatusID,
						familyName=qLoginHostFamily.familylastname,
						email=qLoginHostFamily.email,	
						isExitsLogin=true,
						regionID=qLoginHostFamily.regionID,
						userID=URL.userID,
						currentSection=URL.section
					);
													
                } else {
					APPLICATION.CFC.SESSION.doLogout();	
				}
            </cfscript>
        
        </cfif>

        <cfscript>				
			// If not logged in go to the login page
			if ( NOT VAL(APPLICATION.CFC.SESSION.getHostSession().ID) ) {
				URL.section="login";
			}
			
			// Force SSL
			if ( NOT APPLICATION.isServerLocal AND CGI.SERVER_PORT EQ 80 ) {
				location("https://#CGI.HTTP_HOST##CGI.SCRIPT_NAME#?section=#URL.section#", "no");
			}
		</cfscript>
		
        <!--- Cannot access files that start with _ --->
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
			
            <cfscript>
				// Set Error ID
				vErrorID = "###APPLICATION.CFC.SESSION.getHostSession().ID#-#dateformat(now(),'mmddyyyy')#-#timeformat(now(),'hhmmss')#";
        	</cfscript>
			
            <!--- Production Environment - Email Error --->
            <cfmail to="#SESSION.COMPANY.EMAIL.errors#" from="#SESSION.COMPANY.EMAIL.support#" subject="host.exitsapplication.com : Error" type="HTML">
				<p>An error occurred on #DateFormat( Now(), "mmm d, yyyy" )# at #TimeFormat( Now(), "hh:mm TT" )#</p>
                        
                <p>Error ID = #vErrorID#</p>                
                
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
            
            <cflocation url="/errorMessage.cfm" addtoken="no" />
        
        <cfelse>
			
            <!--- Local Environment - Show Error --->
 			<cfdump var="#ARGUMENTS.Exception#">
                       
        </cfif>
        
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
    
</cfcomponent>    