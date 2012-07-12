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
		
        <!--- Production - Email Error Message - Display HTML Error --->
 		<cfif NOT APPLICATION.isServerLocal>
			
            <cfscript>
				// Set Error ID
				vErrorID = "#CLIENT.userID#-#dateformat(now(),'mmddyyyy')#-#timeformat(now(),'hhmmss')#";
			</cfscript>
            
            <!--- Email Error Message | Send out emails using Gmail --->
            <cfmail 
            	to="#APPLICATION.EMAIL.Errors#"
                from="#APPLICATION.EMAIL.Errors# (EXITS - Error Notification)" 
                subject="EXITS - Error Notification - ID: #vErrorID#" 
                type="HTML" 
                port="587"
                useTLS="yes"
                server="smtp.gmail.com"
                username="errors@student-management.com"
                password="errors123">
                    <p>An error occurred on #DateFormat( Now(), "mmm d, yyyy" )# at #TimeFormat( Now(), "hh:mm TT" )#</p>
                    
                    <p>Error ID = #vErrorID#</p>
                    
                    <p>User: #CLIENT.firstName# #CLIENT.lastName# (###CLIENT.userID#)</p>
    
                    <p>Error Event: #ARGUMENTS.EventName#</p>
                    
                    <h3>Error details:</h3>
                    <p><cfdump var="#ARGUMENTS.Exception#"></p>
                    
                    <h3>SESSION:</h3>
                    <p><cfdump var="#SESSION#"></p>
                    
                    <h3>FORM:</h3>
                    <p><cfdump var="#FORM#"></p>
                    
                    <h3>URL:</h3>
                    <p><cfdump var="#URL#"></p>
                    
                    <!---
					<h3>CGI:</h3>
					<p><cfdump var="#CGI#"></p>
					--->
            </cfmail>
            
            <cfscript>
				GetPageContext().GetOut().ClearBuffer();
			
				// Current Path to root errorMessage.cfm file
				vPath = "";
				
				// Set List Path (C:\Websites\www\student-management\nsmg\student_app\index.cfm)
				vListPath = CF_TEMPLATE_PATH;
				
				// Get Root Position
				vListRootAt = ListFindNoCase(vListPath, "nsmg", "\");
				
				// Calculate How Many levels we are far from the root | last element is the page itself, do not count it.
				vTotalExtraLevels = (ListLen(vListPath, "\") - 1) - vListRootAt;
				
				// Add Extra Root levels
				For ( i=1;i LTE vTotalExtraLevels; i=i+1) {
					vPath = vPath & "../";	
				}
				
				// Redirect to error page
				location ("#vPath#errorMessage.cfm", "no");
			</cfscript>
            
        <cfelse>
			
            <!--- Development - Display Error Message --->
 			<cfdump var="#ARGUMENTS.Exception#">
                       
        </cfif>

		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
</cfcomponent>