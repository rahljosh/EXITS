<!--- ------------------------------------------------------------------------- ----
	
	File:		_session.cfm
	Author:		Marcus Melo
	Date:		February, 25 2011
	Desc:		This sets up the components that will be stored in the SESSION
				scope and used by a single user accross multiple pages.

----- ------------------------------------------------------------------------- --->

<cfquery name="qCompanyInfo" datasource="#APPLICATION.DSN#">
	SELECT
    	companyID,
        support_email,
        projectManager,
        url_ref
	FROM
    	smg_companies
	WHERE
    	url_ref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.http_host#">
</cfquery>

<cfscript>
	// CLEAR SESSION SCOPE - Use only when we switch to Application.cfc
	StructClear(SESSION);
	
	// Param SESSION Variables
	param name="SESSION.emailSupport" default='support@student-management.com';	
	param name="SESSION.started" default=now();	
	param name="SESSION.expires" default=DateAdd('h', 12, now());	

	// These are arrays and cannot be stored in CLIENT variables
	param name="SESSION.pageMessages" default='';	
	param name="SESSION.formErrors" default='';	
	
	// Check if we have a valid object
	if ( NOT IsObject(SESSION.pageMessages) ) {
		// Page Messages
		SESSION.pageMessages = CreateCFC("pageMessages").Init();
	}
	
	// Check if we have a valid object
	if ( NOT IsObject(SESSION.formErrors) ) {
		// Form Errors
		SESSION.formErrors = CreateCFC("formErrors").Init();
	}
	
	// Set User Roles
	APPLICATION.CFC.USER.setUserRoles(userID=CLIENT.userID);	

	// Set Email Support According to Company
	if ( VAL(qCompanyInfo.recordCount) ) {
		
		SESSION.emailSupport = qCompanyInfo.support_email;
		
	}
</cfscript>
