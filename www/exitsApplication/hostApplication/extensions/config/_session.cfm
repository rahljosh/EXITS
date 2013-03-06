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
<cfparam name="SESSION.HOST.userID" default="0">
<cfparam name="SESSION.HOST.regionID" default="0">
<cfparam name="SESSION.HOST.isSectionLocked" default="false">
<cfparam name="SESSION.HOST.isExitsLogin" default="false">
<!--- Full Paths --->
<cfparam name="SESSION.HOST.PATH.albumLarge" default="">
<cfparam name="SESSION.HOST.PATH.albumThumbs" default="">
<cfparam name="SESSION.HOST.PATH.docs" default="">
<!--- Relative Paths --->
<cfparam name="SESSION.HOST.PATH.relativeAlbumLarge" default="">
<cfparam name="SESSION.HOST.PATH.relativeAlbumThumbs" default="">
<cfparam name="SESSION.HOST.PATH.relativeDocs" default="">

<!--- Param SESSION.COMPANY Variables --->
<cfparam name="SESSION.COMPANY.ID" default="0">
<cfparam name="SESSION.COMPANY.exitsURL" default="">
<cfparam name="SESSION.COMPANY.logoImage" default="">
<cfparam name="SESSION.COMPANY.submitGreyImage" default="">
<cfparam name="SESSION.COMPANY.submitImage" default="">

<cfparam name="SESSION.COMPANY.name" default="">
<cfparam name="SESSION.COMPANY.shortName" default="">
<cfparam name="SESSION.COMPANY.tollFree" default="">
<cfparam name="SESSION.COMPANY.siteURL" default="">
<cfparam name="SESSION.COMPANY.pageTitle" default="">

<cfparam name="SESSION.COMPANY.color" default="">
<cfparam name="SESSION.COMPANY.headerLogo" default="">
<cfparam name="SESSION.COMPANY.profileHeaderImage" default="">
<cfparam name="SESSION.COMPANY.pxImage" default="">

<cfparam name="SESSION.COMPANY.EMAIL.support" default="">
<cfparam name="SESSION.COMPANY.EMAIL.errors" default="">

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

	// SET SESSION.COMPANY structure
	APPLICATION.CFC.SESSION.setCompanySession();
	
	// Build Left Menu According to user/host family and/or status
	SESSION.leftMenu = APPLICATION.CFC.UDF.buildLeftMenu();
		
	// Page Messages
	SESSION.PageMessages = CreateCFC("pageMessages").Init();
	
	// Form Errors
	SESSION.formErrors = CreateCFC("formErrors").Init();
</cfscript>
