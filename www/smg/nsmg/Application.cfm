<cfapplication 
	name="smg" 
    clientmanagement="yes">


	<!--- Added by Marcus Melo 10/13/2009 --->

    <!--- Param URL variable --->
	<cfparam name="URL.init" default="0">

	<!--- Param Client Variables --->
	<cfparam name="CLIENT.companyID" default="0">
	<cfparam name="CLIENT.userID" default="0">
    <cfparam name="CLIENT.studentID" default="0">  
    <cfparam name="CLIENT.regionID" default="0">  
	<cfparam name="CLIENT.name" default=""> 
    <cfparam name="CLIENT.userType" default="9">   
    <cfparam name="CLIENT.companyName" default="">  
    <cfparam name="CLIENT.parentCompany" default="">   
    <cfparam name="CLIENT.company_submitting" default="">  
    <cfparam name="CLIENT.lastLogin" default="">  
	<cfparam name="CLIENT.programManager" default="">
    
	<cfscript>
        // Check if we need to initialize Application scope
		if ( VAL(URL.init) ) {
			// Clear the Application structure	
			StructClear(APPLICATION);	
		}
		
		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
            return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
        }
		
		/***** Create APPLICATION.CFC structure *****/
		APPLICATION.CFC = StructNew();
		
		// Store the initialized UDF Library object in the Application scope
		APPLICATION.CFC.UDF = CreateCFC("UDF").Init();
		
		// Store Application.IsServerLocal - This needs be declare before CFC component
		APPLICATION.IsServerLocal = APPLICATION.CFC.UDF.IsServerLocal();

		// Store the initialized CBC object in the Application scope
		APPLICATION.CFC.CBC = CreateCFC("CBC").Init();

		// Store the initialized Company object in the Application scope
		APPLICATION.CFC.Company = CreateCFC("Company").Init();

		// Store the initialized Host object in the Application scope
		APPLICATION.CFC.Host = CreateCFC("Host").Init();

		// Store the initialized Program object in the Application scope
		APPLICATION.CFC.Program = CreateCFC("Program").Init();

		// Store the initialized Region object in the Application scope
		APPLICATION.CFC.Region = CreateCFC("Region").Init();

		// Store the initialized School object in the Application scope
		APPLICATION.CFC.School = CreateCFC("School").Init();

		// Store the initialized Student object in the Application scope
		APPLICATION.CFC.Student = CreateCFC("Student").Init();

		// Store the initialized User object in the Application scope
		APPLICATION.CFC.User = CreateCFC("User").Init();

		// Set a short name for the CFCs
		AppCFC = APPLICATION.CFC;


		/***** Create APPLICATION.EMAIL structure *****/
		APPLICATION.EMAIL = StructNew();		
		APPLICATION.EMAIL.support = 'support@student-management.com';
		APPLICATION.EMAIL.finance = 'marcel@student-management.com';
		// Set a short name for the CFCs
		AppEmail = APPLICATION.EMAIL;
		
		
		/***** Set Site URL	 *****/
		
		// Check if this is Dev or Live 
		if ( APPLICATION.isServerLocal ) {
			// Development Server Settings	
			APPLICATION.site_url = 'http://dev.student-management.com';
		} else {
			// Live Server Settings
			APPLICATION.site_url = 'http://www.student-management.com';
		}
	</cfscript>
	<!--- End of Added by Marcus Melo 10/13/2009 --->


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

<!----Set site variables for email and site---->
<cfif cgi.http_host is 'jan.case-usa.org' or cgi.http_host is 'www.case-usa.org'>
	<cfparam name="application.support_email" default="support@case-usa.org">
	<cfparam name="application.site_url" default="http://www.case-usa.org">
<cfelse>
    <cfparam name="application.support_email" default="support@student-management.com">
    <cfparam name="application.site_url" default="http://www.student-management.com">
</cfif>


<cfparam name="application.dsn" default="MySQL">

<!--- this enables the address lookup. 0=off, 1=simple (lookup required but user can enter any value), 2=auto (lookup required and auto fill in readonly value).
used on: forms/school_form.cfm, host_fam_form.cfm, user_form.cfm --->
<cfparam name="application.address_lookup" default="0"> 

<!--- session has expired. --->
<cfif not isDefined("client.userid")>
	<cflocation url="#cgi.http_host#" addtoken="no">
</cfif>

<!----Take Down site except for certain users
<cfif not listFind("1,13282,7178", client.userid)>
	THE SITE IS TEMPORARILY DOWN FOR MAINTENANCE
    <cfabort>
</cfif>
---->

<!--- always allow logout. --->
<cfif not findNoCase("/logout.cfm", getBaseTemplatePath())>
	<!--- force verify user information. --->
    <cfif isDefined("client.verify_info")>
		<!--- allow user only on user info and user form. --->
    	<cfif NOT (isDefined("url.curdoc") AND listFindNoCase("user_info,forms/user_form", url.curdoc))>
        	<cflocation url="/nsmg/index.cfm?curdoc=user_info&userid=#client.userid#" addtoken="no">
        </cfif>
    <!--- force change password. --->
    <cfelseif isDefined("client.change_password")>
	    <!--- allow user only on change password page. --->
    	<cfif NOT (isDefined("url.curdoc") AND url.curdoc EQ 'forms/change_password')>
        	<cflocation url="/nsmg/index.cfm?curdoc=forms/change_password" addtoken="no"><br />
		</cfif>
    </cfif>
</cfif>

<!--- if "resume login" is used login is not run.  Automatically logout if not the same day, so change password and verify info can be checked when they login again.
use isDefined because students don't have thislogin.  this is on application.cfm and nsmg/application.cfm --->
<cfif isDefined("client.thislogin") and client.thislogin NEQ dateFormat(now(), 'mm/dd/yyyy')>
	<!--- don't do a cflocation because we'll get an infinite loop. --->
	<cfinclude template="/nsmg/logout.cfm">
</cfif>

<cfinclude template="includes/trackman.cfm">
