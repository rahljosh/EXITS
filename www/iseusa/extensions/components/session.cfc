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
	
    <!--- SESSION VARIABLES --->
	<cfproperty
    	name="isSection1Completed"
        type="numeric"
        hint="Set to 1 if section 1 is completed"
        default="0" />

	<cfproperty
    	name="isSection2Completed"
        type="numeric"
        hint="Set to 1 if section 2 is completed"
        default="0" />

	<cfproperty
    	name="isSection3Completed"
        type="numeric"
        hint="Set to 1 if section 3 is completed"
        default="0" />

		
	<!--- initializes and returns a session instance --->
	<cffunction name="Init" access="public" returntype="session" output="No" hint="Returns the initialized session object">

		<!--- Param Session Variables --->
        <cfparam name="SESSION.informationID" default="0">
        <cfparam name="SESSION.TOUR.tourID" default="0">
        <cfparam name="SESSION.TOUR.isLoggedIn" default="0">
        <cfparam name="SESSION.TOUR.studentID" default="0">
        <cfparam name="SESSION.TOUR.hostID" default="0">    
        <cfparam name="SESSION.TOUR.applicationPaymentID" default="0">  

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
                VALUES(
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


	<!--- Set SESSION Variables --->
	<cffunction name="setTripSessionVariables" access="public" returntype="void" hint="Sets Trip Variables">
		<cfargument name="tourID" default="" hint="tourID is not required">
		<cfargument name="isLoggedIn" default="" hint="isLoggedIn is not required">
		<cfargument name="studentID" default="" hint="studentID is not required">
		<cfargument name="hostID" default="" hint="hostID is not required">
		<cfargument name="applicationPaymentID" default="" hint="applicationPaymentID is not required">

		<cfscript>
			// Set Variables
			if ( LEN(ARGUMENTS.tourID) ) {
				SESSION.TOUR.tourID = VAL(ARGUMENTS.tourID);
			}
			
			if ( LEN(ARGUMENTS.isLoggedIn) ) {
				SESSION.TOUR.isLoggedIn = VAL(ARGUMENTS.isLoggedIn);
			}

			if ( LEN(ARGUMENTS.studentID) ) {
				SESSION.TOUR.studentID = VAL(ARGUMENTS.studentID);
			}
			
			if ( LEN(ARGUMENTS.hostID) ) {
				SESSION.TOUR.hostID = VAL(ARGUMENTS.hostID);
			}
			
			if ( LEN(ARGUMENTS.applicationPaymentID) ) {
				SESSION.TOUR.applicationPaymentID = VAL(ARGUMENTS.applicationPaymentID);
			}
		</cfscript>
	
    </cffunction>


	<!--- Clear Trip Session --->
	<cffunction name="tripSectionLogout" access="public" returntype="void" hint="Clears TRIP Session Information">
		
		<cfscript>
			// Clear Session
			//structClear(SESSION.TOUR);	
			SESSION.TOUR.tourID = 0;
			SESSION.TOUR.isLoggedIn = 0;
			SESSION.TOUR.studentID = 0;
			SESSION.TOUR.hostID = 0;
			SESSION.TOUR.applicationPaymentID = 0;
		</cfscript>
	
    </cffunction>
    
</cfcomponent>