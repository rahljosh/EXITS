<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">

	<cfscript>
		// Set up the application.
		THIS.Name = "extra"; // "extra" & Hash(GetCurrentTemplatePath());
		THIS.ApplicationTimeout = CreateTimeSpan( 1, 0, 0, 0 ); // Application Expires in 1 day
		THIS.SessionManagement = true;
		THIS.sessionTimeout = CreateTimeSpan( 0, 8, 0, 0 ); // Session Expires in 8 hours
		THIS.ClientManagement = true;
		
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
     
        <!--- Param CLIENT variables --->
        <cfparam name="CLIENT.isLoggedIn" default="">
        <cfparam name="CLIENT.loginType" default="">
        
        <!--- User Specific --->
        <cfparam name="CLIENT.companyID" default="0">    
        <cfparam name="CLIENT.userType" default="">
        <cfparam name="CLIENT.userID" default=""> 
        <cfparam name="CLIENT.firstName" default="">  
        <cfparam name="CLIENT.lastname" default="">  
        <cfparam name="CLIENT.lastLogin" default="">  
        <cfparam name="CLIENT.email" default="">     
        
		<cfscript>
			// Reset Application and Session
			if ( URL.init EQ 1 ) {
				THIS.OnApplicationStart();
				THIS.OnSessionStart();
			}
			// Reset Application
			if ( URL.initApp EQ 1 ) {
				THIS.OnApplicationStart();
			}
			// Reset Session
			if ( URL.initSession EQ 1 ) {
				THIS.OnSessionStart();
			}
			
			// Check if user is NOT logged in
			if ( CLIENT.loginType EQ 'user' AND ListFind(CGI.SCRIPT_NAME, "internal", "/") AND
				(
					NOT VAL(CLIENT.userType)
				 OR 
					NOT VAL(CLIENT.userID)
				 OR
					NOT VAL(CLIENT.companyID)
				) ) { 
					
					// Delete Client Variables
					For (i=1;i LTE ListLen(GetClientVariablesList()); i=i+1)
					  DeleteClientVariable(ListGetAt(GetClientVariablesList(), i));
					
					// Redirect to login
					Location(APPLICATION.SITE.URL.main, "no");
			}
			
			/*** 
				Set APPLICATION.applicationID based on the path.
				This is set when users log in			
			***/
			if ( NOT VAL(APPLICATION.applicationID) ) {
				
				if ( ListFind(CGI.SCRIPT_NAME, "wat", "/" ) ) {
					// WAT Application
					APPLICATION.applicationID = 4;
				} else if ( ListFind(CGI.SCRIPT_NAME, "trainee", "/") ) {
					// Trainee Application
					APPLICATION.applicationID = 5;
				}

			}
			
			/*** 
				Set APPLICATION.foreignTable
				This is set when users log in			
			***/
			if ( NOT LEN(APPLICATION.foreignTable) ) {
				APPLICATION.foreignTable = 'extra_candidates';
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
        
        	<cfparam name="CLIENT.userID" default="0">
            <cfparam name="CLIENT.studentID" default="0">
            <cfparam name="CLIENT.name" default="">
        
        	<cfscript>
                // Current Path to root errorMessage.cfm file
                vPath = "";
                
                // Set List Path (C:\Websites\www\exitsApplication\extra\index.cfm)
                vListPath = CF_TEMPLATE_PATH;
                
                // Get Root Position
                vListRootAt = ListFindNoCase(vListPath, "extra", "\");
                
                // Calculate How Many levels we are far from the root | last element is the page itself, do not count it.
                vTotalExtraLevels = (ListLen(vListPath, "\") - 1) - vListRootAt;
                
                // Add Extra Root levels
                For ( i=1;i LTE vTotalExtraLevels; i=i+1) {
                    vPath = vPath & "../";	
                }
				

				// Set Error ID
				if ( VAL(CLIENT.userID) ) {
					vErrorID = "#CLIENT.userID#-#dateformat(now(),'mm-dd-yyyy')#-#timeformat(now(),'hh-mm-ss')#";
					vLoggedInName = "<p>User: #CLIENT.name# (###CLIENT.userID#)</p>";
				} else if ( VAL(CLIENT.studentID) ) {
					vErrorID = "#CLIENT.studentID#-#dateformat(now(),'mm-dd-yyyy')#-#timeformat(now(),'hh-mm-ss')#";
					vLoggedInName = "<p>Student: #CLIENT.name# (###CLIENT.studentID#)</p>";
				} else {
					vErrorID = "00-#dateformat(now(),'mm-dd-yyyy')#-#timeformat(now(),'hh-mm-ss')#";
					vLoggedInName = "<p>unknown</p>";
				}
            </cfscript>
			
            <!--- Production Environment - Email Error --->
            <cfmail to="#APPLICATION.EMAIL.errors#" from="#APPLICATION.EMAIL.support#" subject="EXTRA : Error" type="HTML">
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
                
                <h3>CLIENT:</h3>
                <cfdump var="#CLIENT#">
                <br /><br />
                
                <h3>FORM:</h3>
                <cfdump var="#FORM#">
                <br /><br />
                
                <h3>URL:</h3>
                <cfdump var="#URL#"> 
                
            </cfmail>
            
            <cfscript>
				GetPageContext().GetOut().ClearBuffer();
			
				// Redirect to error page
				location ("#vPath#errorMessage.cfm", "no");
			</cfscript>
        
        <cfelse>
			
            <!--- Local Environment - Show Error --->
 			<cfdump var="#ARGUMENTS.Exception#">
                       
        </cfif>
        
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
    
</cfcomponent>    