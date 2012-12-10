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
<cfparam name="SESSION.timeStarted" default="#now()#">
<cfparam name="SESSION.timeExpires" default="#DateAdd('h', 4, now())#">

<!--- Param Session Variables --->
<cfparam name="SESSION.informationID" default="0">

<!--- Param Session Variables --->
<cfparam name="SESSION.HOST.ID" default="0">
<cfparam name="SESSION.HOST.applicationStatus" default="9">
<cfparam name="SESSION.HOST.familyName" default="">
<cfparam name="SESSION.HOST.email" default="">
<cfparam name="SESSION.HOST.seasonID" default="0">
<!--- Full Paths --->
<cfparam name="SESSION.HOST.PATH.albumLarge" default="">
<cfparam name="SESSION.HOST.PATH.albumThumbs" default="">
<cfparam name="SESSION.HOST.PATH.docs" default="">
<!--- Relative Paths --->
<cfparam name="SESSION.HOST.PATH.relativeAlbumLarge" default="">
<cfparam name="SESSION.HOST.PATH.relativeAlbumThumbs" default="">
<cfparam name="SESSION.HOST.PATH.relativeDocs" default="">


<!--- Param Session Variables --->
<cfparam name="SESSION.COMPANY.ID" default="0">
<cfparam name="SESSION.COMPANY.name" default="">
<cfparam name="SESSION.COMPANY.shortName" default="">
<cfparam name="SESSION.COMPANY.siteURL" default="">
<cfparam name="SESSION.COMPANY.exitsURL" default="">
<cfparam name="SESSION.COMPANY.pageTitle" default="">
<cfparam name="SESSION.COMPANY.logoImage" default="">
<cfparam name="SESSION.COMPANY.color" default="">
<cfparam name="SESSION.COMPANY.EMAIL.support" default="">
<cfparam name="SESSION.COMPANY.EMAIL.errors" default="">
<cfparam name="SESSION.COMPANY.EMAIL.hostApp" default="">


<cfscript>
	// Store session information
	/* No need to insert session information
	SESSION.informationID = APPLICATION.CFC.SESSION.InitSession(
		httpReferer = CGI.http_referer,
		entryPage = 'https://' & CGI.server_name & CGI.script_name,
		httpUserAgent = CGI.http_user_agent,
		queryString = CGI.query_string,						 
		remoteAddr = CGI.remote_addr,
		remoteHost = CGI.remote_host,
		remoteUser = CGI.remote_user,
		httpHost = CGI.http_host,
		https = CGI.https
	);
	*/

	/*******************************************
		Create SESSION.EMAIL structure
	*******************************************/
	
	if ( ListFindNoCase(CGI.SERVER_NAME, "case-usa", ".") ) {
		
		// CASE
		SESSION.COMPANY.ID = 10;
		// Query to Get Company Info
		//
		SESSION.COMPANY.name = "Cultural Academic Student Exchange";
		SESSION.COMPANY.shortName = "CASE";
		SESSION.COMPANY.siteURL = "http://www.case-usa.org/";
		SESSION.COMPANY.exitsURL = "https://case.exitsapplication.com/";
		SESSION.COMPANY.pageTitle = "(CASE) Cultural Academic Student Exchange - Host Family Application";
		SESSION.COMPANY.logoImage = "logoCASE.png";
		SESSION.COMPANY.submitGreyImage = "submitGrey.png";
		SESSION.COMPANY.submitImage = "submit.png";
		SESSION.COMPANY.color = "##98012E";
		SESSION.COMPANY.EMAIL.support = "support@case-usa.org";
		SESSION.COMPANY.EMAIL.errors = "errors@student-management.com";
		SESSION.COMPANY.EMAIL.hostApp = "hostApp@case-usa.org";		
	
	} else {
		
		// ISE
		SESSION.COMPANY.ID = 1;		
		// Query to Get Company Info
		//
		SESSION.COMPANY.name = "International Student Exchange";
		SESSION.COMPANY.shortName = "ISE";
		SESSION.COMPANY.siteURL = "https://www.iseusa.com/";
		SESSION.COMPANY.exitsURL = "https://ise.exitsapplication.com/";
		SESSION.COMPANY.pageTitle = "(ISE) International Student Exchange - Host Family Application";
		SESSION.COMPANY.logoImage = "logoISE.png";
		SESSION.COMPANY.submitGreyImage = "ISESubmitGrey.png";
		SESSION.COMPANY.submitImage = "ISESubmit.png";
		SESSION.COMPANY.color = "##0054A0";
		SESSION.COMPANY.EMAIL.support = "support@iseusa.com";
		SESSION.COMPANY.EMAIL.errors = "errors@student-management.com";
		SESSION.COMPANY.EMAIL.hostApp = "hostApp@iseusa.com";
		
	}
	
	// Page Messages
	SESSION.PageMessages = CreateCFC("pageMessages").Init();
	
	// Form Errors
	SESSION.formErrors = CreateCFC("formErrors").Init();
</cfscript>
