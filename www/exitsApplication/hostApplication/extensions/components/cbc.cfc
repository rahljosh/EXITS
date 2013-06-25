<!--- ------------------------------------------------------------------------- ----
	
	COPIED FROM EXITS ON 6/14/2013 by James Griffiths
	- Removed functions that are not needed on the host app.
	
	File:		cbc.cfc
	Author:		Marcus Melo
	Date:		October, 09 2009
	Desc:		This holds the functions needed to run CBCs

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="cbc"
	output="false" 
	hint="A collection of functions for the CBC">

	
    <!--- Return the initialized CBC object --->
	<cffunction name="Init" access="public" returntype="cbc" output="false" hint="Returns the initialized CBC object">
	
		<cfscript>	
			// Declare local variables
			decryptKey = 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR';
			decryptAlgorithm = 'desede';
			decryptEncoding = 'hex';

			// Server is Local - Set Up URL	
			if ( APPLICATION.isServerLocal ) {
				// DEVELOPMENT URL				
				BGCDirectURL = 'https://model.backgroundchecks.com/integration/bgcdirectpost.aspx';	
				BGCUser = 'smg1';
				BGCPassword = 'R3d3x##';
				BGCAccount = '10005542';
			// Server is Live - Set Up URL						
			} else {
				// PRODUCTION URL
				BGCDirectURL = 'https://direct.backgroundchecks.com/integration/bgcdirectpost.aspx';
				// stored in the database
				BGCUser = '';
				BGCPassword = '';
				BGCAccount = '';
			}
			
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
		
	</cffunction>            
    
	<cffunction name="insertHostCBC" access="public" returntype="void" output="false" hint="Inserts CBC record. It does not return a value">
		<cfargument name="hostID" required="yes" hint="Host ID is required">
        <cfargument name="familyMemberID" default="0" hint="Family Member ID is not required">
        <cfargument name="cbcType" required="yes" hint="cbcType is required (mother, father or member)">
        <cfargument name="seasonID" required="yes" hint="SeasonID is required">
        <cfargument name="companyID" required="yes" hint="companyID is required">
        <cfargument name="isNoSSN" default="0" hint="isNoSSN is not required">
        <cfargument name="dateAuthorized" required="yes" hint="Date of Authorization">
        <cfargument name="isRerun" default="0" hint="isRerun is not required">

            <cfquery 
            	name="qCheckPending" 
            	datasource="#APPLICATION.DSN.Source#">
					SELECT
                    	hostID
                    FROM
                    	smg_hosts_cbc
                    WHERE
                    	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">	
            		AND
                    	date_sent IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    AND
                    	cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cbcType#">
                   	AND
                    	cbcfamid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.familyMemberID)#">
            </cfquery>
            	
			<cfif NOT qCheckPending.recordCount>
            
                <cfquery 
                    datasource="#APPLICATION.DSN.Source#">
                        INSERT INTO 
                            smg_hosts_cbc 
                        (
                            hostID, 
                            familyID, 
                            cbc_type, 
                            seasonID, 
                            companyID,
                            isNoSSN,
                            isRerun, 
                            date_authorized,
                            dateCreated
                        )
                        VALUES 
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.familyMemberID#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cbcType#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isNoSSN#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isRerun#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.dateAuthorized#" null="#NOT IsDate(ARGUMENTS.dateAuthorized)#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        )
                </cfquery>	
                
			</cfif>
            
	</cffunction>
       
</cfcomponent>    