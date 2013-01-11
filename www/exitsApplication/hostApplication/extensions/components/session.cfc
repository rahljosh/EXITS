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
        <cfparam name="SESSION.HOST.isMenuBlocked" default="false">
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
        <cfargument name="isMenuBlocked" default="false" hint="Set to true to block menu after HF submits application">
        <cfargument name="isExitsLogin" default="false" hint="Set to true when logging in from EXITS">       
        
        <cfscript>
			// New Struct
			SESSION.HOST = StructNew();
			SESSION.HOST.PATH = StructNew();
		
			// Host Family Information
			SESSION.HOST.ID = VAL(ARGUMENTS.hostID);
			SESSION.HOST.applicationStatus = VAL(ARGUMENTS.applicationStatus);
			SESSION.HOST.familyName = ARGUMENTS.familyName;
			SESSION.HOST.email = ARGUMENTS.email;
			SESSION.HOST.seasonID = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
			
			// Set to true after HF submits app
			SESSION.HOST.isMenuBlocked = ARGUMENTS.isMenuBlocked;	

			// Set tp true when logged in from EXITS
			SESSION.HOST.isExitsLogin = ARGUMENTS.isExitsLogin;	

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


	<!--- Set Host Session Menu As Blocked --->
	<cffunction name="setHostSessionisMenuBlocked" access="public" returntype="void" output="false" hint="Set an specific Session Variables">
        <cfargument name="isMenuBlocked" default="false" hint="isMenuBlocked">
        
        <cfscript>
			// Disable Menu
			SESSION.HOST.isMenuBlocked = ARGUMENTS.isMenuBlocked;	
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


</cfcomponent>