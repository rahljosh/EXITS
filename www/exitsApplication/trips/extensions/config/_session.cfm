<!--- ------------------------------------------------------------------------- ----
	
	File:		_session.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		This sets up the components that will be stored in the SESSION
				scope and used by a single user accross multiple pages.

----- ------------------------------------------------------------------------- --->

<cfscript>
	// CLEAR SESSION VARIABLE
	StructClear(SESSION);
</cfscript>

<!--- Param Session Variables --->
<cfparam name="SESSION.started" default="#now()#">
<cfparam name="SESSION.expires" default="#DateAdd('h', 2, now())#">

<!--- Param Session Variables --->
<cfparam name="SESSION.informationID" default="0">

<!--- Param Session Variables --->
<cfparam name="SESSION.TOUR.tourID" default="0">
<cfparam name="SESSION.TOUR.isLoggedIn" default="0">
<cfparam name="SESSION.TOUR.studentID" default="0">
<cfparam name="SESSION.TOUR.hostID" default="0">    
<cfparam name="SESSION.TOUR.applicationPaymentID" default="0"> 

<!--- Param Session Variables --->
<cfparam name="SESSION.COMPANY.ID" default="0">
<cfparam name="SESSION.COMPANY.name" default="">
<cfparam name="SESSION.COMPANY.shortName" default="">
<cfparam name="SESSION.COMPANY.email" default="">
<cfparam name="SESSION.COMPANY.supportEmail" default="">
<cfparam name="SESSION.COMPANY.siteURL" default="">
<cfparam name="SESSION.COMPANY.exitsURL" default="">
<cfparam name="SESSION.COMPANY.color" default="">
<cfparam name="SESSION.COMPANY.tollFree" default="">
<cfparam name="SESSION.COMPANY.phone" default="">
<cfparam name="SESSION.COMPANY.fax" default="">

<cfscript>
	// Store session information
	SESSION.informationID = APPLICATION.CFC.SESSION.InitSession(
		httpReferer = CGI.http_referer,
		entryPage = 'http://' & CGI.server_name & '/' & CGI.script_name,
		httpUserAgent = CGI.http_user_agent,
		queryString = CGI.query_string,						 
		remoteAddr = CGI.remote_addr,
		remoteHost = CGI.remote_host,
		remoteUser = CGI.remote_user,
		httpHost = CGI.http_host,
		https = CGI.https
	);

	// Page Messages
	SESSION.PageMessages = CreateCFC("pageMessages").Init();
	
	// Form Errors
	SESSION.formErrors = CreateCFC("formErrors").Init();
</cfscript>
