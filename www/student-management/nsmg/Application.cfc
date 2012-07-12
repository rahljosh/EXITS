<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">

    <cfscript>
		// Set up the application.
		THIS.Name = "EXITS";
		THIS.ApplicationTimeout = CreateTimeSpan(1,0,0,0);			
		THIS.clientManagement = true;
		
		THIS.SessionManagement = true;
		THIS.sessionTimeout = CreateTimeSpan(0,10,0,0);
		
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
			
            <cfscript>
				// Include Application Settings
				include "extensions/config/_app_index.cfm";				
			</cfscript>
 
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

		<cfparam name="URL.init" default="0">
        <cfparam name="URL.initApp" default="0">
        <cfparam name="URL.initSession" default="0">
        <cfparam name="URL.curdoc" default="">
        
		<cfscript>
			// Restart Application and Session Scopes
			if ( VAL(URL.init) ) {
				// StructClear(APPLICATION.CFC);		
				THIS.OnApplicationStart();
				THIS.OnSessionStart();
			}
			
			// Restart Application Scopes
			if ( VAL(URL.initApp) ) {
				THIS.OnApplicationStart();
			}
			
			// Restart Session Scopes
			if ( VAL(URL.initSession) ) {
				THIS.OnSessionStart();
			}


			// Set up Application Shot Names
			AppCFC = APPLICATION.CFC;
			AppEmail = APPLICATION.EMAIL;
			AppPath = APPLICATION.PATH;
			Constants = APPLICATION.Constants;


			// Include Config Settings 
			include "extensions/config/_index.cfm";				
			
			
			// Session has Expired - Go to login page
			if ( NOT VAL(CLIENT.userType) AND ( NOT VAL(CLIENT.userID) OR NOT VAL(CLIENT.studentID) ) ) {
				Location("http://#cgi.http_host#/", "no");
			}

			
			// Always allow logout.
			if ( NOT findNoCase("/logout.cfm", getBaseTemplatePath()) ) {
				
				// Force verify user information.
				if ( isDefined("CLIENT.verify_info") ) {
					
					// allow user only on user info and user form.
					if ( NOT ( LEN(URL.curdoc) AND listFindNoCase("user_info,forms/user_form", URL.curdoc)) ) {
						Location("/nsmg/index.cfm?curdoc=user_info&userid=#CLIENT.userid#", "no");
					}
				
				// Force change password
				} else if ( isDefined("CLIENT.change_password") ) {
					
					// allow user only on change password page.
					if ( NOT ( LEN(URL.curdoc) AND  URL.curdoc EQ 'forms/change_password' OR  listFindNoCase("logout", URL.curdoc)) ) {
						Location("/nsmg/index.cfm?curdoc=forms/change_password", "no");
					}
				
				// Force agreement on PRODUCTION.
				} else if ( isDefined("CLIENT.agreement_needed") AND NOT APPLICATION.IsServerLocal ) {
					
					// allow user only on yearly agreement page. 
					if ( NOT ( LEN(URL.curdoc) AND listFindNoCase("forms/yearly_agreement,repRefs,displayRepAgreement,cbcAuthorization,employmentHistory,logout", URL.curdoc)) ) {
						Location("/nsmg/index.cfm?curdoc=forms/yearly_agreement&userid=#CLIENT.userid#", "no");
					}
				
				// Force SSN on PRODUCTION.
				} else if ( isDefined('CLIENT.needsSSN') AND NOT APPLICATION.IsServerLocal ) {
					
					if ( NOT ( LEN(URL.curdoc) AND listFindNoCase("forms/verifyInfo, forms/verifyInfo2, logout", URL.curdoc)) ) {
						Location("/nsmg/index.cfm?curdoc=forms/verifyInfo", "no");
					}
					
				}
				
			}

			
			/************************************************************************************************************************
				if "resume login" is used login is not run.  Automatically logout if not the same day, so change password and verify info can be checked when they login again.
				use isDefined because students don't have thislogin.  this is on application.cfm and nsmg/application.cfm
			************************************************************************************************************************/
			if ( isDefined("CLIENT.thislogin") AND CLIENT.thislogin NEQ dateFormat(now(), 'mm/dd/yyyy') ) {
				// don't do a cflocation because we'll get an infinite loop.
				include "/nsmg/logout.cfm";
			}

			
			// Insert Track
			include "includes/trackman.cfm";
		</cfscript>


		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
 
	<cffunction
		name="OnRequest"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after pre page processing is complete.">

		<!--- Define arguments. --->
		<cfargument name="TargetPage" type="string" required="true" />

		<!--- Include the requested page. --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />
		
		<!--- Return out. --->
		<cfreturn />
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
		<cfargument name="EventName" type="string" required="false" default="" />

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
        
        <cfdump var="#ARGUMENTS.Exception#">
        
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
</cfcomponent>