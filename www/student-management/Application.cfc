
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
			return(CreateObject("component", ("nsmg.extensions.components." & ARGUMENTS.strCFCName)));
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
				include "nsmg/extensions/config/_app_index.cfm";				
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
 		
        <cfscript>
			// Include Config Settings 
			include "nsmg/extensions/config/_client.cfm";				
		
			// Include Session Settings 
			include "nsmg/extensions/config/_session.cfm";				
		</cfscript>	
        
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
        <cfparam name="URL.userType" default="">
        <cfparam name="URL.s" default="">
        
        <cfparam name="CLIENT.userID" default="0">
        <cfparam name="CLIENT.studentID" default="0">
        <cfparam name="CLIENT.userType" default="0">
        <!--- Online Application - Activation Link - https://ise.exitsapplication.com/nsmg/student_app/index.cfm?s=7DC5F7FE-5056-A020-CC9555F332BD80F3 --->
        
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
			include "nsmg/extensions/config/_client.cfm";				

			// If referer is PHP - login student to view the online application
			if( FindNoCase("phpusa.com", CGI.HTTP_REFERER) OR FindNoCase("php.local", CGI.HTTP_REFERER) ) {
				// Login as Student
				CLIENT.userType = 10; // Student
			}
			
			// Online Application - Student Activation
			if ( LEN(URL.s) AND findNoCase("student_app", getBaseTemplatePath()) ) {				
				CLIENT.userType = 10;
				CLIENT.studentID = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=URL.s).studentID;			
			}
			
			// Not Logged IN | Session has Expired | Go to login page
			if ( ( findNoCase("nsmg", getBaseTemplatePath()) AND NOT VAL(CLIENT.userType) AND ( NOT VAL(CLIENT.userID) OR NOT VAL(CLIENT.studentID) ) )	) {
				
				Location("http://#cgi.http_host#/", "no");
			
			// User Logged In 
			} else {
				
				// Allow access to these pages when forcing verify info / change password / Missing SSN / Paperwork
				vListOfForcedPages = "logout,user_info,forms/user_form,forms/change_password,forms/verifyInfo,user/index,calendar/index";
				
				// Always allow login/logout and access to cfcs
				if ( CGI.SCRIPT_NAME NEQ "/login.cfm" AND Right(CGI.SCRIPT_NAME, 3) NEQ 'cfc' AND NOT listFindNoCase(vListOfForcedPages, URL.curdoc) AND CGI.SCRIPT_NAME NEQ '/nsmg/user/index.cfm' ) { 
					
					// Force verify user information | allow userInfo, user_form
					if ( isDefined("CLIENT.verify_info") AND NOT APPLICATION.IsServerLocal ) { // AND NOT APPLICATION.IsServerLocal
					
						Location("index.cfm?curdoc=user_info&userid=#CLIENT.userid#", "no");
	
					// Force SSN | Except Canada | Allow access to verifyInfo
					} else if ( isDefined('CLIENT.needsSSN') AND CGI.SERVER_NAME NEQ "canada.exitsapplication.com" AND NOT APPLICATION.IsServerLocal ) { // AND NOT APPLICATION.IsServerLocal
						
						Location("index.cfm?curdoc=forms/verifyInfo", "no");
	
					// Force change password | allow access to change password page
					} else if ( isDefined("CLIENT.change_password") AND NOT APPLICATION.IsServerLocal ) { // AND NOT APPLICATION.IsServerLocal
						
						Location("index.cfm?curdoc=forms/change_password", "no");
				
					// Force New Paperwork Section - Not for Canada or DASH
					} else if ( listFind("5,6,7,15", CLIENT.userType) 
							AND 
								CGI.SERVER_NAME NEQ "canada.exitsapplication.com"
							AND
								CGI.SERVER_NAME NEQ "dash.exitsapplication.com"
							AND 
								VAL(APPLICATION.CFC.USER.getUserSession().ID) 
							AND 
								NOT APPLICATION.CFC.USER.getUserSessionPaperwork().isAccountCompliant 
							AND 
								NOT APPLICATION.CFC.USER.getUserSession().paperworkSkipAllowed ) {
								
								// paperwork page
								Location("index.cfm?curdoc=user/index", "no"); 
								
					}
					
				}
			
			}
			
			/************************************************************************************************************************
				if "resume login" is used login is not run.  Automatically logout if not the same day, so change password and verify info can be checked when they login again.
				use isDefined because students don't have thislogin.  this is on application.cfm and nsmg/application.cfm
			************************************************************************************************************************/
			if ( isDefined("CLIENT.thislogin") AND CLIENT.thislogin NEQ dateFormat(now(), 'mm/dd/yyyy') ) {
				// don't do a cflocation because we'll get an infinite loop.
				include "nsmg/logout.cfm";
			}
			
			// Insert Track
			include "nsmg/includes/trackman.cfm";
		</cfscript>
		
        <!---
		<!--- Check to see if the current path is legal. Users cannot access files starting with "_" so throw error if need be. --->
		<cfif NOT Compare(Left(APPLICATION.CFC.UDF.GetCurrentPageFromPath(CGI.cf_template_path), 1), "_")>
            <cfthrow 
                message="Cannot access files that start with _" 
                type="EXCEPTION"
                />	
        </cfif>
		--->
        
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

        <cfparam name="CLIENT.userID" default="0">
        <cfparam name="CLIENT.studentID" default="0">
        <cfparam name="CLIENT.name" default="">

        <!--- Production - Email Error Message - Display HTML Error --->
 		<cfif NOT APPLICATION.isServerLocal AND NOT ListFind('1,20,28,6584,115,109,628,9106,15310,21,15330,21517,15130,19268',CLIENT.userID)> <!--- Fred from INTO needs to see the errors, josh wants to see the errors --->
            
			<cfscript>
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

            <cftry>
            
				<!--- Email Error Message | Send out emails using Gmail --->
                <cfmail 
                    to="#APPLICATION.EMAIL.Errors#"
                    from="#APPLICATION.EMAIL.Errors# (EXITS Errors)" 
                    subject="Error Notification - ID: #vErrorID#" 
                    type="HTML" 
                    port="587"
                    useTLS="yes"
                    server="#APPLICATION.SETTINGS.EMAIL.ERRORS.server#"
                    username="#APPLICATION.SETTINGS.EMAIL.ERRORS.username#"
                    password="#APPLICATION.SETTINGS.EMAIL.ERRORS.password#">
                        <p>An error occurred on #DateFormat( Now(), "mmm d, yyyy" )# at #TimeFormat( Now(), "hh:mm TT" )#</p>
                        
                        <p>Error ID = #vErrorID#</p>
                        
                        #vLoggedInName#
        
                        <p>Error Event: #ARGUMENTS.EventName#</p>
                        
                        <h3>Error details:</h3>
                        <p><cfdump var="#ARGUMENTS.Exception#"></p>
                        
                        <h3>SESSION:</h3>
                        <p><cfdump var="#SESSION#"></p>

                        <h3>CLIENT:</h3>
                        <p><cfdump var="#CLIENT#"></p>
	                        
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
                
                    // Redirect to error page
                    location ("#vPath#errorMessage.cfm", "no");
                </cfscript>
				
                <!--- Could not send email for any reason or errorMessage.cfm could not be found - redirect user to login page --->
                <cfcatch type="any">
                
                    <cfscript>
    	                // Redirect to error page
	                    Location("http://#cgi.http_host#/", "no");
                    </cfscript>
                    
                </cfcatch>

			</cftry>            
            
        <cfelse>
			
            <!--- Development - Display Error Message --->
 			<cfdump var="#ARGUMENTS.Exception#">
                       
        </cfif>

		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
</cfcomponent>