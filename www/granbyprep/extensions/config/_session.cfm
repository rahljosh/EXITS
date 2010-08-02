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

<!--- Student Information --->
<cfparam name="SESSION.STUDENT.firstName" type="string" default="">
<cfparam name="SESSION.STUDENT.lastName" type="string" default="">
<cfparam name="SESSION.STUDENT.dateLastLoggedIn" type="string" default="">

<!--- Folder to upload application files multiple files --->
<cfparam name="SESSION.STUDENT.myUploadFolder" type="string" default="">

<cfparam name="SESSION.STUDENT.isApplicationSubmitted" type="numeric" default="0">

<!--- These are used on the checklist --->
<cfparam name="SESSION.STUDENT.isSection1Complete" type="numeric" default="0">
<cfparam name="SESSION.STUDENT.section1FieldList" type="string" default="">

<cfparam name="SESSION.STUDENT.isSection2Complete" type="numeric" default="0">
<cfparam name="SESSION.STUDENT.section2FieldList" type="string" default="">

<cfparam name="SESSION.STUDENT.isSection3Complete" type="numeric" default="0">
<cfparam name="SESSION.STUDENT.section3FieldList" type="string" default="">

<cfparam name="SESSION.STUDENT.isSection4Complete" type="numeric" default="0">
<cfparam name="SESSION.STUDENT.section4FieldList" type="string" default="">

<cfparam name="SESSION.STUDENT.isSection5Complete" type="numeric" default="0">
<cfparam name="SESSION.STUDENT.section5FieldList" type="string" default="">

<cftry>

	<cfparam name="SESSION.STUDENT.ID" type="numeric" default="0">
    <cfparam name="SESSION.STUDENT.hasAddFamInfo" type="numeric" default="0">
	<cfparam name="SESSION.informationID" type="numeric" default="0">

    <cfcatch type="any">
    
		<cfscript>
            // Set studentID to 0
            SESSION.STUDENT.ID = 0;
			SESSION.STUDENT.hasAddFamInfo = 0;
			SESSION.informationID = 0;
        </cfscript>
        
    </cfcatch>
    
</cftry>    
			
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
