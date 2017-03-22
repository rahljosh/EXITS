<!--- ------------------------------------------------------------------------- ----
	
	File:		_session.cfm
	Author:		Marcus Melo
	Date:		February, 25 2011
	Desc:		This sets up the components that will be stored in the SESSION
				scope and used by a single user accross multiple pages.

----- ------------------------------------------------------------------------- --->

<cfscript>
	// CLEAR SESSION SCOPE - Use only when we switch to Application.cfc
	StructClear(SESSION);
	
	// Param SESSION Variables
	param name="SESSION.started" default=now();	
	param name="SESSION.expires" default=DateAdd('n', 20, now());	

	// Param SESSION Struct Variables
	param name="SESSION.EMAIL" default="struct";	
	param name="SESSION.USER.ROLES" default="struct";	

	// Param SESSION Array Variables
	param name="SESSION.pageMessages" default="array";	
	param name="SESSION.formErrors" default="array";	
	
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

	// Set USER SESSION Variables
	APPLICATION.CFC.USER.setUserSession();

	// Set USER SESSION Roles
	APPLICATION.CFC.USER.setUserSessionRoles();	
	
	// Set USER SESSION Paperwork
	APPLICATION.CFC.USER.setUserSessionPaperwork();
	
	// Set Email Variables
	APPLICATION.CFC.UDF.setSessionEmailVariables();
</cfscript>
