<!--- ------------------------------------------------------------------------- ----
	
	File:		_session.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		This sets up the components that will be stored in the SESSION
				scope and used by a single user accross multiple pages.

----- ------------------------------------------------------------------------- --->

<!--- Param Session Variables --->
<cfparam name="SESSION.started" default="#now()#">
<cfparam name="SESSION.expires" default="#DateAdd('h', 2, now())#">
<!--- Student Information --->
<cfparam name="SESSION.STUDENT.firstName" type="string" default="">
<cfparam name="SESSION.STUDENT.lastName" type="string" default="">
<cfparam name="SESSION.STUDENT.dateLastLoggedIn" type="string" default="">
<!--- Folder to upload application files multiple files --->
<cfparam name="SESSION.STUDENT.myUploadFolder" type="string" default="">

<cftry>

	<cfparam name="SESSION.STUDENT.ID" type="numeric" default="0">
	<cfparam name="SESSION.ID" type="numeric" default="0">
        
    <cfcatch type="any">
    
		<cfscript>
            // Set studentID to 0
            SESSION.STUDENT.ID = 0;
			SESSION.ID = 0;
        </cfscript>
        
    </cfcatch>
    
</cftry>    
			
<cfscript>
	// Store session information
	SESSION.ID = APPLICATION.CFC.SESSION.InitSession(
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
</cfscript>

<cfscript>
	// Page Messages
	SESSION.PageMessages = CreateCFC("pageMessages").Init();
	
	// Form Errors
	SESSION.formErrors = CreateCFC("formErrors").Init();
</cfscript>
