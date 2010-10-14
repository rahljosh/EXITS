<!--- ------------------------------------------------------------------------- ----
	
	File:		_session.cfm
	Author:		Marcus Melo
	Date:		October, 14 2010
	Desc:		This sets up the components that will be stored in the SESSION
				scope and used by a single user accross multiple pages.

----- ------------------------------------------------------------------------- --->

<cfscript>
	// CLEAR SESSION SCOPE
	StructClear(SESSION);
</cfscript>

<!--- Param Session Variables --->
<cfparam name="SESSION.started" default="#now()#">
<cfparam name="SESSION.expires" default="#DateAdd('h', 2, now())#">

<!--- Candidate Information --->
<cfparam name="SESSION.CANDIDATE.companyID" default="0">
<cfparam name="SESSION.CANDIDATE.isLoggedIn" default="0">
<cfparam name="SESSION.CANDIDATE.ID" default="0">
<cfparam name="SESSION.CANDIDATE.applicationStatusID" default="0">
<cfparam name="SESSION.CANDIDATE.firstName" default="">
<cfparam name="SESSION.CANDIDATE.lastName" default="">
<cfparam name="SESSION.CANDIDATE.email" default="">
<cfparam name="SESSION.CANDIDATE.dateLastLoggedIn" default="">
<cfparam name="SESSION.CANDIDATE.isReadOnly" default="0">
<cfparam name="SESSION.CANDIDATE.isSection1Complete" default="0">
<cfparam name="SESSION.CANDIDATE.section1FieldList" default="">
<cfparam name="SESSION.CANDIDATE.isSection2Complete" default="0">
<cfparam name="SESSION.CANDIDATE.section2FieldList" default="">
<cfparam name="SESSION.CANDIDATE.isSection3Complete" default="0">
<cfparam name="SESSION.CANDIDATE.section3FieldList" default="">
<cfparam name="SESSION.CANDIDATE.intlRepID" default="0">
<cfparam name="SESSION.CANDIDATE.branchID" default="0">
<cfparam name="SESSION.CANDIDATE.intlRepName" default="">

<cfscript>
	// Page Messages
	SESSION.PageMessages = CreateCFC("pageMessages").Init();
	
	// Form Errors
	SESSION.formErrors = CreateCFC("formErrors").Init();
</cfscript>
