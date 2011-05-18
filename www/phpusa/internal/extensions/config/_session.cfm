<!--- ------------------------------------------------------------------------- ----
	
	File:		_session.cfm
	Author:		Marcus Melo
	Date:		February, 25 2011
	Desc:		This sets up the components that will be stored in the SESSION
				scope and used by a single user accross multiple pages.

----- ------------------------------------------------------------------------- --->

<cfscript>
	// CLEAR SESSION SCOPE
	StructClear(SESSION);

	// Param Session Variables
	param name="SESSION.started" default=now();	
	param name="SESSION.expires" default=DateAdd('h', 12, now());	

	// These are arrays and cannot be stored in client variables
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
</cfscript>
