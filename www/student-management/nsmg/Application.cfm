<cfapplication 
	name="smg" 
    clientmanagement="yes"
    sessionmanagement="yes"
    sessiontimeout="#CreateTimeSpan( 0, 12, 0, 0 )#">

	<cfparam name="APPLICATION.DSN" default="MySQL">

	<!--- Added by Marcus Melo 10/13/2009 --->

    <!--- Param URL variable --->
	<cfparam name="URL.init" default="0">
    <cfparam name="URL.init2" default="0">
	
	<!--- Param Client Variables --->
	<cfparam name="CLIENT.companyID" default="0">
	<cfparam name="CLIENT.userID" default="0">
    <cfparam name="CLIENT.studentID" default="0">  
    <cfparam name="CLIENT.regionID" default="0">  
	<cfparam name="CLIENT.name" default=""> 
    <cfparam name="CLIENT.userType" default="0">   
    <cfparam name="CLIENT.companyName" default=""> 
    <cfparam name="CLIENT.companyShort" default=""> 
    <cfparam name="CLIENT.parentCompany" default="">   
    <cfparam name="CLIENT.company_submitting" default="">  
    <cfparam name="CLIENT.lastLogin" default="">  
	<cfparam name="CLIENT.programManager" default="">
    <cfparam name="CLIENT.levels" default="0">
    <cfparam name="CLIENT.accesslevelname" default="">
    <cfparam name="CLIENT.invoice_access" default="0">

	<cfscript>
        // Create a function that let us create CFCs from any location
        function CreateCFC(strCFCName){
            return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
        }

		// Check if we need to initialize Application scope
		if ( VAL(URL.init) ) {
			// Clear the Application structure	
			StructClear(APPLICATION);	
		}
	</cfscript>
    
	<!--- Include Application Config Files --->
	<cfinclude template="extensions/config/_app_index.cfm" />    
    
	<!--- Include Config Files --->
	<cfinclude template="extensions/config/_index.cfm" />    


	<!--- Redirect if not using www.student-management.com or not using SSL. 
    <cfif CGI.SERVER_NAME NEQ 'dev.exitgroup.org'>
        <cfif cgi.QUERY_STRING NEQ ''>
            <cflocation url="http://dev.exitgroup.org#cgi.script_name#?#cgi.QUERY_STRING#" addtoken="no">
        <cfelse>
            <cflocation url="http://dev.exitgroup.org#cgi.script_name#" addtoken="no">
        </cfif>
    </cfif>
    <cfoutput>
    cgi.SERVER_PORT=#cgi.SERVER_PORT#
    </cfoutput>--->


	<!--- this enables the address lookup. 0=off, 1=simple (lookup required but user can enter any value), 2=auto (lookup required and auto fill in readonly value).
    used on: forms/school_form.cfm, host_fam_form.cfm, user_form.cfm --->
    <cfparam name="application.address_lookup" default="0"> 
    

	<!--- session has expired // Go to login page. --->
    <cfif NOT VAL(CLIENT.userID) OR NOT VAL(CLIENT.userType)>
        <cflocation url="http://#cgi.http_host#/" addtoken="no">
    </cfif>
    

	<!----Take Down site except for certain users
    <cfif not listFind("1,13282,7178", CLIENT.userid)>
        THE SITE IS TEMPORARILY DOWN FOR MAINTENANCE
        <cfabort>
    </cfif>
    ---->


	<!--- always allow logout. --->
    <cfif NOT findNoCase("/logout.cfm", getBaseTemplatePath())>
    
        <!--- force verify user information. --->
        <cfif isDefined("CLIENT.verify_info")>
        
            <!--- allow user only on user info and user form. --->
            <cfif NOT (isDefined("URL.curdoc") AND listFindNoCase("user_info,forms/user_form", URL.curdoc))>
                <cflocation url="/nsmg/index.cfm?curdoc=user_info&userid=#CLIENT.userid#" addtoken="no">
            </cfif>
            
        <!--- force change password. --->
        <cfelseif isDefined("CLIENT.change_password")>
        
            <!--- allow user only on change password page. --->
            <cfif NOT (isDefined("URL.curdoc") AND  URL.curdoc EQ 'forms/change_password' OR  listFindNoCase("logout", URL.curdoc))>
                <cflocation url="/nsmg/index.cfm?curdoc=forms/change_password" addtoken="no"><br />
            </cfif>
        
        <!--- force agreement. --->
        <cfelseif isDefined("CLIENT.agreement_needed") AND NOT APPLICATION.IsServerLocal>
        
            <!--- allow user only on yearly agreement page. --->
            <cfif NOT (isDefined("URL.curdoc") AND listFindNoCase("forms/yearly_agreement,repRefs,displayRepAgreement,cbcAuthorization,employmentHistory,logout", URL.curdoc))>
                <cflocation url="/nsmg/index.cfm?curdoc=forms/yearly_agreement&userid=#CLIENT.userid#" addtoken="no"><br />
            </cfif>
            
        </cfif>
        
    </cfif>


	<!--- if "resume login" is used login is not run.  Automatically logout if not the same day, so change password and verify info can be checked when they login again.
    use isDefined because students don't have thislogin.  this is on application.cfm and nsmg/application.cfm --->
    <cfif isDefined("CLIENT.thislogin") and CLIENT.thislogin NEQ dateFormat(now(), 'mm/dd/yyyy')>
        <!--- don't do a cflocation because we'll get an infinite loop. --->
        <cfinclude template="/nsmg/logout.cfm">
    </cfif>

    <cfinclude template="includes/trackman.cfm">
