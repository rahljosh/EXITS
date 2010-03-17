<cfapplication 
	name="smg" 
    clientmanagement="yes">

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
        // Check if we need to initialize Application scope
		if ( VAL(URL.init) ) {
			// Clear the Application structure	
			StructClear(APPLICATION.CFC);	
		}
		
		// Create a function that let us create CFCs from any location
		function CreateCFC(strCFCName){
            return(CreateObject("component", ("extensions.components." & ARGUMENTS.strCFCName)));
        }
		
		
		/***** Create APPLICATION.CFC structure *****/
		APPLICATION.CFC = StructNew();

		// Set a short name for the CFCs
		AppCFC = APPLICATION.CFC;

		// Store the initialized UDF Library object in the Application scope
		AppCFC.UDF = CreateCFC("udf").Init();
		
		// Store Application.IsServerLocal - This needs be declare before the other CFC components
		APPLICATION.IsServerLocal = AppCFC.UDF.IsServerLocal();

		// Store the initialized CBC object in the Application scope
		AppCFC.CBC = CreateCFC("cbc").Init();

		// Store the initialized Company object in the Application scope
		AppCFC.Company = CreateCFC("company").Init();

		// Store the initialized Host object in the Application scope
		AppCFC.Host = CreateCFC("host").Init();

		// Store the initialized Host object in the Application scope
		AppCFC.Insurance = CreateCFC("insurance").Init();

		// Store the initialized Program object in the Application scope
		AppCFC.pdfDoc = CreateCFC("pdfDoc").Init();

		// Store the initialized Program object in the Application scope
		AppCFC.Program = CreateCFC("program").Init();

		// Store the initialized Progress Report object in the Application scope
		AppCFC.ProgressReport = CreateCFC("progressReport").Init();
		
		// Store the initialized Region object in the Application scope
		AppCFC.Region = CreateCFC("region").Init();

		// Store the initialized School object in the Application scope
		AppCFC.School = CreateCFC("school").Init();

		// Store the initialized Student object in the Application scope
		AppCFC.Student = CreateCFC("student").Init();

		// Store the initialized User object in the Application scope
		AppCFC.User = CreateCFC("user").Init();


		if (APPLICATION.IsServerLocal) {
			// Store the initialized webEx object in the Application scope
			// AppCFC.WebEx = CreateCFC("webEx").Init();
		}

		/***** Create APPLICATION.EMAIL structure *****/
		APPLICATION.EMAIL = StructNew();		

		// Set a short name for the APPLICATION.EMAIL
		AppEmail = APPLICATION.EMAIL;

		AppEmail.support = 'support@student-management.com';
		AppEmail.finance = 'marcel@student-management.com';
		AppEmail.errors = 'errors@student-management.com';
		
		
		/***** Create APPLICATION.PATH structure *****/
		APPLICATION.PATH = StructNew();		
		// Set a short name for the APPLICATION.PATH
		AppPath = APPLICATION.PATH;
		
		AppPath.base = getDirectoryFromPath(getBaseTemplatePath());
		AppPath.pdfDocs = 'uploadedfiles/pdf_docs';
		
		
		/***** Set Settings based on Live or Dev Servers *****/
		
		// Check if this is Dev or Live 
		if ( APPLICATION.isServerLocal ) {
			// Development Server Settings	
			
			// Set Site URL
			APPLICATION.site_url = 'http://dev.student-management.com';
			
		} else {
			// Live Server Settings
			
			// Set Site URL
			APPLICATION.site_url = 'http://www.student-management.com';
			
		}


		/* 
			Create the constant object in the application scope - can be used to store states, countries and statuses 
			that are often used in the system so we do not need to call the database to get them
		*/
		APPLICATION.Constants = StructNew();
		
		// Set the reference to the struct
		Constants = APPLICATION.Constants;
		
		// Set up constant for project help statuses
		Constants.projectHelpStatus = ArrayNew(1);		
		Constants.projectHelpStatus[1] = "created";
		Constants.projectHelpStatus[2] = "sr_approved";
		Constants.projectHelpStatus[3] = "ra_approved";
		Constants.projectHelpStatus[4] = "ra_rejected";
		Constants.projectHelpStatus[5] = "rd_approved";
		Constants.projectHelpStatus[6] = "rd_rejected";
		Constants.projectHelpStatus[7] = "ny_approved";
		Constants.projectHelpStatus[8] = "ny_rejected";
		// ArrayAppend(Constants.projectHelpStatus, "sr_approved");
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


<!--- this enables the address lookup. 0=off, 1=simple (lookup required but user can enter any value), 2=auto (lookup required and auto fill in readonly value).
used on: forms/school_form.cfm, host_fam_form.cfm, user_form.cfm --->
<cfparam name="application.address_lookup" default="0"> 


<!--- session has expired // Go to login page. --->
<cfif NOT VAL(CLIENT.userID) OR NOT VAL(CLIENT.userType)>
    <cflocation url="http://#cgi.http_host#/" addtoken="no">
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
