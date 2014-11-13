<!--- ------------------------------------------------------------------------- ----
	
	File:		session.cfc
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		This holds functions for setting up session variables

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="session"
    accessors="true"
	output="false" 
	hint="This holds functions for setting up session variables">

	<!--- Set up the properties of this component --->
	<cfproperty 
		name="My" 
		type="struct" 
		hint="A structure containing internal variables for this session controller" />
	
		
	<!--- initializes and returns a session instance --->
	<cffunction name="Init" access="public" returntype="session" output="No" hint="Returns the initialized session object">

		<!--- Param Session Variables --->
        <cfparam name="SESSION.informationID" default="0">
        <cfparam name="SESSION.HOST.ID" default="0">
        <cfparam name="SESSION.HOST.applicationStatus" default="9">
        <cfparam name="SESSION.HOST.familyName" default="">
        <cfparam name="SESSION.HOST.email" default="">
        <cfparam name="SESSION.HOST.seasonID" default="0">
        <cfparam name="SESSION.HOST.userID" default="0">
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

		<cfscript>
			// Return this initialized instance
			return(this);
		</cfscript>

	</cffunction>


	<!--- Initializes and returns a security controller instance --->
	<cffunction name="InitSession" access="public" returntype="numeric" hint="Stores Session Information">
		<cfargument name="httpReferer" type="string" default="" required="yes">
		<cfargument name="entryPage" type="string" default="" required="yes">
		<cfargument name="httpUserAgent" type="string" default="" required="yes">
		<cfargument name="queryString" type="string" default="" required="yes">
		<cfargument name="remoteAddr" type="string" default="" required="yes">
		<cfargument name="remoteHost" type="string" default="" required="yes">
		<cfargument name="httpHost" type="string" default="" required="yes">
		<cfargument name="https" type="string" default="" required="yes">
		
		<!--- 
			Insert the session data into the session table.
			Return the Unique ID
		 --->
        <cftry>
        
            <cfquery 
                result="newRecord"
                datasource="#APPLICATION.DSN.Source#">
                INSERT INTO
                    applicationSessionInformation
                (
                    httpReferer,
                    entryPage,
                    httpUserAgent,
                    queryString,
                    remoteAddr,
                    remoteHost,
                    httpHost,
                    https,
                    dateCreated		
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.httpReferer#" maxlength="500">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.entryPage#" maxlength="500">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.httpUserAgent#" maxlength="500">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.queryString#" maxlength="500">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.remoteAddr#" maxlength="250">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.remoteHost#" maxlength="250">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.httpHost#" maxlength="250">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.https#" maxlength="250">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
            </cfquery>
			
			<cfreturn newRecord.GENERATED_KEY />
            
            <!--- ERROR --->
            <cfcatch>                
                <cfreturn 0>
            </cfcatch>
        	
        </cftry>
        
	</cffunction>


	<!--- Log In --->
	<cffunction name="setHostSession" access="public" returntype="void" output="false" hint="Set Host Session Variables">
		<cfargument name="hostID" default="0" hint="Host ID">
		<cfargument name="applicationStatus" default="9" hint="applicationStatus">
        <cfargument name="familyName" default="" hint="familyName">
        <cfargument name="email" default="" hint="email">
        <cfargument name="isExitsLogin" default="false" hint="Set to true when logging in from EXITS">       
        <cfargument name="regionID" default="0" hint="Region ID">
        <cfargument name="userID" default="0" hint="User ID">
        <cfargument name="currentSection" default="login" hint="">

        <cfscript>
			// New Struct
			SESSION.HOST = StructNew();
			SESSION.HOST.PATH = StructNew();
		
			// Host Family Information
			SESSION.HOST.ID = VAL(ARGUMENTS.hostID);
			SESSION.HOST.applicationStatus = VAL(ARGUMENTS.applicationStatus);
			SESSION.HOST.familyName = ARGUMENTS.familyName;
			SESSION.HOST.email = ARGUMENTS.email;
			SESSION.HOST.seasonID = APPLICATION.selectedSeason;
			SESSION.HOST.regionID = VAL(ARGUMENTS.regionID);
			SESSION.HOST.userID = VAL(ARGUMENTS.userID);
			
			// Set tp true when logged in from EXITS
			SESSION.HOST.isExitsLogin = ARGUMENTS.isExitsLogin;	

			// Get Sections that are denied - Accessible from any page
			qGetDeniedSections = APPLICATION.CFC.HOST.getDeniedSections();
			
			// Locked section if opening a specific section from EXITS or if application has been denied
			if ( ( SESSION.HOST.isExitsLogin ) OR ( NOT SESSION.HOST.isExitsLogin AND qGetDeniedSections.recordCount ) ) {
				SESSION.HOST.isSectionLocked = true;					
			} else {				
				SESSION.HOST.isSectionLocked = false;					
			}
			
			// Set Folders
			if ( VAL(ARGUMENTS.hostID) ) {
				
				// Set Full Paths
				SESSION.HOST.PATH.albumLarge = APPLICATION.PATH.hostApp & ARGUMENTS.hostID & "/album/large/";
				SESSION.HOST.PATH.albumThumbs = APPLICATION.PATH.hostApp & ARGUMENTS.hostID & "/album/thumbs/";
				SESSION.HOST.PATH.docs = APPLICATION.PATH.hostApp & ARGUMENTS.hostID & "/docs/";

				// Make sure folders exist
				APPLICATION.CFC.DOCUMENT.createFolder(SESSION.HOST.PATH.albumLarge);
				APPLICATION.CFC.DOCUMENT.createFolder(SESSION.HOST.PATH.albumThumbs);
				APPLICATION.CFC.DOCUMENT.createFolder(SESSION.HOST.PATH.docs);

				// Set Relative Paths
				SESSION.HOST.PATH.relativeAlbumLarge = APPLICATION.PATH.relativeHostApp & ARGUMENTS.hostID & "/album/large/"; 
				SESSION.HOST.PATH.relativeAlbumThumbs = APPLICATION.PATH.relativeHostApp & ARGUMENTS.hostID & "/album/thumbs/"; 
				SESSION.HOST.PATH.relativeDocs = APPLICATION.PATH.relativeHostApp & ARGUMENTS.hostID & "/docs/";
				
			} else {
				
				// Set Path for folders
				SESSION.HOST.PATH.albumLarge = "";
				SESSION.HOST.PATH.albumThumbs = "";
				SESSION.HOST.PATH.docs = "";
				
				// Relative Path
				SESSION.HOST.PATH.relativeAlbumLarge = "";
				SESSION.HOST.PATH.relativeAlbumThumbs = "";
				SESSION.HOST.PATH.relativeDocs = "";

			}
			
			// Re-build Menu based on logged in user/host family information
			SESSION.leftMenu = APPLICATION.CFC.UDF.buildLeftMenu(currentSection=ARGUMENTS.currentSection);
		</cfscript>
		
	</cffunction>


	<cffunction name="setHostSessionApplicationStatus" access="public" returntype="void" output="false" hint="Set an specific Session Variables">
        <cfargument name="applicationStatus" default="" hint="applicationStatus">
        
        <cfscript>
			if ( listFind("7,8,9", ARGUMENTS.applicationStatus) ) {
				SESSION.HOST.applicationStatus = ARGUMENTS.applicationStatus;	
			}
		</cfscript>
		
	</cffunction>


	<cffunction name="getHostSession" access="public" returntype="struct" hint="Get HOST Session variables" output="no">

        <cfscript>
			try {
				
				// Check if HOST structure exits
				if ( StructIsEmpty(SESSION.HOST) ) {
					// Set Session
					setHostSession();
				}
				
			} catch (Any e) {
				// Set Session
				setHostSession();
			}
			
			// Make Sure Structs are not empty
			return SESSION.HOST;
		</cfscript>
        
	</cffunction>


	<!--- Log Out --->
	<cffunction name="doLogout" access="public" returntype="void" hint="Clears HOST Session Information">
		
		<cfscript>
			// Clear Session
			structClear(SESSION.HOST);	
		</cfscript>
	
    </cffunction>
    
    
	<!--- Set Company Session --->
	<cffunction name="setCompanySession" access="public" returntype="void" output="false" hint="Set Host Session Variables">
        
        <cfscript>
			if ( 
				ListFindNoCase(CGI.SERVER_NAME, "case-usa", ".") 
				OR ListFindNoCase(CGI.SERVER_NAME, "case.exitsapplication.com")
				OR ListFindNoCase(CGI.SERVER_NAME, "smg.case.local")) {
				
				// CASE
				SESSION.COMPANY.ID = 10;
				SESSION.COMPANY.exitsURL = "https://case.exitsapplication.com/";
				SESSION.COMPANY.logoImage = "logoCASE.png";
				SESSION.COMPANY.submitGreyImage = "submitGrey.png";
				SESSION.COMPANY.submitImage = "submit.png";
			
			} else if ( 
				ListFindNoCase(CGI.SERVER_NAME, "exchange-service", ".") 
				OR ListFindNoCase(CGI.SERVER_NAME, "es.exitsapplication.com") 
				OR ListFindNoCase(CGI.SERVER_NAME, "smg.esi.local")) {
				
				// ESI
				SESSION.COMPANY.ID = 14;
				SESSION.COMPANY.exitsURL = "https://es.exitsapplication.com/";
				SESSION.COMPANY.logoImage = "logoESI.png";
				SESSION.COMPANY.submitGreyImage = "submitGrey.png";
				SESSION.COMPANY.submitImage = "submit.png";
			
			} else if ( 
				ListFindNoCase(CGI.SERVER_NAME, "dash", ".") 
				OR ListFindNoCase(CGI.SERVER_NAME, "dash.exitsapplication.com") 
				OR ListFindNoCase(CGI.SERVER_NAME, "smg.esi.local")) {
				
				// ESI
				SESSION.COMPANY.ID = 15;
				SESSION.COMPANY.exitsURL = "https://dash.exitsapplication.com/";
				SESSION.COMPANY.logoImage = "logoDASH.png";
				SESSION.COMPANY.submitGreyImage = "submitGrey.png";
				SESSION.COMPANY.submitImage = "submit.png";	
			} else {
				
				// ISE
				SESSION.COMPANY.ID = 1;		
				SESSION.COMPANY.exitsURL = "https://ise.exitsapplication.com/";
				SESSION.COMPANY.logoImage = "logoISE.png";
				SESSION.COMPANY.submitGreyImage = "ISESubmitGrey.png";
				SESSION.COMPANY.submitImage = "ISESubmit.png";
				
			}
			
			// Query to Get Company Info
			qGetCompanyInformation = APPLICATION.CFC.LOOKUPTABLES.getCompany(companyID=SESSION.COMPANY.ID);
			
			SESSION.COMPANY.name = qGetCompanyInformation.companyName;
			SESSION.COMPANY.shortName = qGetCompanyInformation.companyShort_noColor;
			SESSION.COMPANY.tollFree = qGetCompanyInformation.toll_free;
			SESSION.COMPANY.siteURL = qGetCompanyInformation.url;
			SESSION.COMPANY.pageTitle = "#qGetCompanyInformation.companyName# - Host Family Application";
			
			// Images/Logos
			SESSION.COMPANY.color = "###qGetCompanyInformation.company_color#";
			SESSION.COMPANY.headerLogo = "#SESSION.COMPANY.exitsURL#nsmg/pics/logos/#SESSION.COMPANY.ID#_header_logo.png";
			SESSION.COMPANY.profileHeaderImage = "#SESSION.COMPANY.exitsURL#nsmg/pics/#SESSION.COMPANY.ID#_short_profile_header.jpg";
			SESSION.COMPANY.pxImage = "#SESSION.COMPANY.exitsURL#nsmg/pics/logos/#SESSION.COMPANY.ID#_px.png";
			
			// Emails
			SESSION.COMPANY.EMAIL.support = qGetCompanyInformation.support_email;
			SESSION.COMPANY.EMAIL.errors = "errors@student-management.com";	
		</cfscript>
		
	</cffunction>
    

	<cffunction name="getCompanySession" access="public" returntype="struct" hint="Get COMPANY Session variables" output="no">
        
        <cfscript>
			try {
				
				// Check if HOST structure exits
				if ( StructIsEmpty(SESSION.COMPANY) ) {
					// Set Session
					setCompanySession();
				}
				
			} catch (Any e) {
				// Set Session
				setCompanySession();
			}
			
			// Make Sure Structs are not empty
			return SESSION.COMPANY;
		</cfscript>
        
	</cffunction>   
    

	<cffunction name="getCompanySessionByKey" access="public" returntype="string" hint="Get COMPANY Session variables" output="no">
		<cfargument name="structKey" default="" hint="Only works for the 1st level - struct key is not required">
        
        <cfscript>
			try {
				
				// Try to get specific value
				return SESSION.COMPANY[ARGUMENTS.structKey];

			} catch (Any e) {
				// Not Found - Reset Session
				setCompanySession();
				
				// Try to get specific value
				try {
					return SESSION.COMPANY[ARGUMENTS.structKey];
				} catch (Any e) {
					return "";
				}
				
			}
		</cfscript>
        
	</cffunction>  
         

</cfcomponent>