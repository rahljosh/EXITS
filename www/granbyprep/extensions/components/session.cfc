<!--- ------------------------------------------------------------------------- ----
	
	File:		session.cfc
	Author:		Marcus Melo
	Date:		July, 01 2010
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
                    sessionInformation
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


	<!--- Set Session Variables --->
	<cffunction name="setSessionVariables" access="public" returntype="numeric" hint="Sets session variables">
	
    	<cfscript>
			SESSION.STUDENT.isSection1Completed = 0;	
			
			SESSION.STUDENT.isSection2Completed = 0;		
			
			SESSION.STUDENT.isSection3Completed = 0;		
		</cfscript>
    
    </cffunction>

</cfcomponent>