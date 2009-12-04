<!--- ------------------------------------------------------------------------- ----
	
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
				BGCUser = '';
				BGCPassword = '';
				BGCAccount = '';
			}

			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>

	</cffunction>


	<cffunction name="getAvailableSeasons" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run">
        <cfargument name="currentSeasonIDs" default="" hint="Current Season ID's will not be returned, only available seasons are returend">
        
        <cfquery 
        	name="qGetAvailableSeasons" 
        	datasource="#APPLICATION.dsn#">
                SELECT 
                    seasonID, 
                    season, 
                    active
                FROM 
                    smg_seasons
                WHERE 
                    active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                
                <cfif LEN(ARGUMENTS.currentSeasonIDs)>
                    AND  
                        seasonID NOT IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.currentSeasonIDs#" list="yes"> )    
                </cfif>
    
                ORDER BY 
                    season
        </cfquery>
    
		<cfreturn qGetAvailableSeasons>
	</cffunction>
    
    
    <!--- Begin of Hosts --->
	<cffunction name="getCBCHostByID" access="public" returntype="query" output="false" hint="Returns CBC records for a mother, father or family member">
		<cfargument name="hostID" required="yes" hint="Host ID is required">
        <cfargument name="familyMemberID" default="0" hint="Family Member ID is not required">
        <cfargument name="cbcType" default="" hint="cbcType is required (mother, father or member)">
        <cfargument name="batchID" default="0" hint="Batch ID is not required">

            <cfquery 
            	name="qGetCBCHostByID" 
                datasource="#APPLICATION.dsn#">
                    SELECT 
                        h.cbcfamID, 
                        h.hostID, 
                        h.batchID,
                        h.date_authorized, 
                        h.date_sent, 
                        h.date_received,
                        h.xml_received, 
                        h.requestID, 
                        h.flagcbc,
                        h.seasonID, 
                        s.season,
                        c.companyID,
                        c.companyshort
                    FROM 
                        smg_hosts_cbc h
                    LEFT OUTER JOIN 
                        smg_seasons s ON s.seasonID = h.seasonID
                    LEFT OUTER JOIN 
                        smg_companies c ON c.companyID = h.companyID
                    WHERE 
                        h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#"> 

                    <cfif VAL(ARGUMENTS.batchID)>
                    AND
                        h.batchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.batchID#">                                	
                    </cfif>
	                    
                    <cfif LEN(ARGUMENTS.cbcType)>
                    AND 
                        h.cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cbcType#">
                    </cfif>
                    
                    <cfif VAL(ARGUMENTS.familyMemberID)>
                    AND 
                        h.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.familyMemberID#">
                    </cfif>
                    
                    ORDER BY 
                        s.season
            </cfquery>    

		<cfreturn qGetCBCHostByID>
	</cffunction>


	<cffunction name="getEligibleHostMember" access="public" returntype="query" output="false" hint="Returns CBC for family members">
		<cfargument name="hostID" required="yes" hint="Host ID is required">

            <cfquery 
            	name="qGetEligibleHostMember" 
            	datasource="#APPLICATION.dsn#">
                    SELECT 
                        childID, 
                        hostID, 
                        membertype, 
                        name, 
                        middlename, 
                        lastname, 
                        ssn, 
                        birthdate, 
                        (DATEDIFF(now( ) , birthdate)/365)
                    FROM 
                        smg_host_children 
                    WHERE 
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
                    AND 
                        (DATEDIFF(now( ) , birthdate)/365) > 17
                    ORDER BY 
                        childID
            </cfquery>

		<cfreturn qGetEligibleHostMember>
    </cffunction>


	<cffunction name="insertHostCBC" access="public" returntype="void" output="false" hint="Inserts CBC record. It does not return a value">
		<cfargument name="hostID" required="yes" hint="Host ID is required">
        <cfargument name="familyMemberID" default="0" hint="Family Member ID is not required">
        <cfargument name="cbcType" required="yes" hint="cbcType is required (mother, father or member)">
        <cfargument name="seasonID" required="yes" hint="SeasonID is required">
        <cfargument name="companyID" required="yes" hint="companyID is required">
        <cfargument name="dateAuthorized" required="yes" hint="Date of Authorization">

            <cfquery 
            	name="qInsertHostCBC" 
            	datasource="#APPLICATION.dsn#">
                    INSERT INTO 
                        smg_hosts_cbc 
                    (
                        hostID, 
                        familyID, 
                        cbc_type, 
                        seasonID, 
                        companyID, 
                        date_authorized
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.familyMemberID#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cbcType#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                        <cfif LEN(ARGUMENTS.dateAuthorized)>
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(ARGUMENTS.dateAuthorized)#">
                        <cfelse>
                            NULL                            
                        </cfif>
                    )
            </cfquery>	

	</cffunction>


	<cffunction name="updateHostFlagCBC" access="public" returntype="void" output="false" hint="Updates the flag field on the CBC record. It does not return a value">
		<cfargument name="cbcFamID" required="yes" hint="cbcFamID is required">
		<cfargument name="flagCBC" required="yes" hint="flagCBC is required. Values 0 or 1">
        
            <cfquery 
            	name="qUpdateHostFlagCBC" 
                datasource="#APPLICATION.dsn#">
                    UPDATE 
                        smg_hosts_cbc
                    SET 
                        flagcbc = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.flagCBC#">
                    WHERE 
                        cbcFamID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cbcFamID#">
            </cfquery>	

	</cffunction>

	
	<cffunction name="getCBCHost" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run for a host">
        <cfargument name="companyID" type="numeric" default="0" hint="CompanyID is not required">
        <cfargument name="seasonID" type="numeric" default="0" hint="SeasonID is not required">
        <cfargument name="userType" type="string" default="" hint="UserType is not required. List (mother,father or only one value)">
        <cfargument name="hostID" type="numeric" default="0" hint="HostID is not required">
        
        <cfquery 
        	name="qGetCBCHost" 	
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                    cbc.cbcfamID, 
                    cbc.hostID, 
                    cbc.cbc_type,
                    cbc.seasonID,
                    cbc.companyID,
                    cbc.batchID,
                    cbc.date_authorized, 
                    cbc.date_sent, 
                    cbc.date_received,
                    h.familylastname,
                    h.fatherlastname, 
                    h.fatherfirstname, 
                    h.fathermiddlename, 
                    fatherdob, 
                    fatherssn,
                    h.motherlastname, 
                    h.motherfirstname, 
                    h.mothermiddlename, 
                    motherdob,
                    motherssn
                FROM 
                    smg_hosts_cbc cbc
                INNER JOIN 
                    smg_hosts h ON h.hostID = cbc.hostID
                WHERE 
                    cbc.date_sent IS NULL 
                AND 
                    requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                
                <!--- Check if we are running ISE's CBC --->
                <cfif VAL(ARGUMENTS.companyID) LTE 4>
                AND 
                    cbc.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                AND 
                    cbc.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>

            	<!--- Check if we have a valid SeasonID --->
				<cfif VAL(ARGUMENTS.seasonID)>
                AND 
                    cbc.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">
				</cfif>
                
                <!--- Check if userType was passed --->
                <cfif LEN(ARGUMENTS.userType)>
                AND 
                    cbc.cbc_type IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.userType#" list="yes">)
                </cfif>
				
            	<!--- Check if we have a valid hostID --->
				<cfif VAL(ARGUMENTS.hostID)>
                AND 
                    cbc.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
				</cfif>
                
                <!--- If running batch, limit to 20 so we don't get time outs --->
                LIMIT 20
        </cfquery>
   
        <cfreturn qGetCBCHost>
    </cffunction>


	<cffunction name="getCBCHostMember" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run for a host member">
        <cfargument name="companyID" type="numeric" default="0" hint="CompanyID is not required">
        <cfargument name="seasonID" type="numeric" default="0" hint="SeasonID is not required">
        <cfargument name="hostID" type="numeric" default="0" hint="HostID is not required">
        
        <cfquery 
        	name="qGetCBCHostMember" 	
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                	cbc.cbcfamID, 
                    cbc.hostID, 
                    cbc.cbc_type, 
                    cbc.seasonID,
                    cbc.companyID,
                    cbc.batchID,                    
                    cbc.date_authorized, 
                    cbc.date_sent, 
                    cbc.date_received,
                	child.childID, 
                    child.name, 
                    child.middlename, 
                    child.lastname, 
                    child.birthdate, 
                    child.ssn, 
                    child.hostID
                FROM 
                	smg_hosts_cbc cbc
                INNER JOIN 
                	smg_host_children child ON child.childID = cbc.familyID
                WHERE 
                	cbc.date_sent IS NULL 
                AND 
                    requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
			
                <!--- Check if we are running ISE's CBC --->
                <cfif VAL(ARGUMENTS.companyID) LTE 4>
                AND 
                    cbc.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                AND 
                    cbc.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>

            	<!--- Check if we have a valid SeasonID --->
				<cfif VAL(ARGUMENTS.seasonID)>
                AND 
                	cbc.seasonID =  <cfqueryparam value="#ARGUMENTS.seasonID#" cfsqltype="cf_sql_integer">
				</cfif>
                    
            	<!--- Check if we have a valid hostID --->
				<cfif VAL(ARGUMENTS.hostID)>
                AND 
                    cbc.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
				</cfif>

                LIMIT 20
			</cfquery>

        <cfreturn qGetCBCHostMember>
    </cffunction>


	<cffunction name="updateHostCBC" access="public" returntype="void" output="false" hint="Updates CBC Information">
    	<cfargument name="batchID" type="numeric" required="yes">
        <cfargument name="ReportID" type="string" required="yes">  
        <cfargument name="cbcFamID" type="numeric" required="yes">      
        <cfargument name="xmlReceived" type="string" default="">
        
        <cfquery 
        	datasource="MySql">
            UPDATE 
            	smg_hosts_cbc  
            SET 
            	date_sent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                date_received = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                batchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.batchID#">,
                requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reportID#">,
                xml_received = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.xmlReceived#">
            WHERE 
            	cbcfamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcFamID#">
        </cfquery>

	</cffunction>
	<!--- End of Hosts --->
    

	<!--- Begin of Users --->
	<cffunction name="getCBCUserByID" access="public" returntype="query" output="false" hint="Returns CBC records for a user">
        <cfargument name="userID" required="yes" hint="userID is required">
        <cfargument name="familyID" default="0" hint="Family Member ID is not required">
        <cfargument name="batchID" default="0" hint="BatchID is not required">

            <cfquery 
            	name="qGetCBCUserByID" 
                datasource="#APPLICATION.dsn#">
                    SELECT
                        u.cbcID,
                        u.userID,
                        u.familyID,
                        u.seasonID,
                        u.companyID,
                        u.batchID,
                        u.requestID,
                        u.date_authorized,
                        u.date_sent,
                        u.date_received,
                        u.xml_received,
                        u.notes,
                        u.flagCBC,
                        s.season,
                        c.companyshort                        
                    FROM
                        smg_users_cbc u
                    LEFT OUTER JOIN 
                        smg_seasons s ON s.seasonID = u.seasonID
                    LEFT OUTER JOIN 
                        smg_companies c ON c.companyID = u.companyID
                    WHERE 
                        u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#"> 
                    
                    <cfif VAL(ARGUMENTS.familyID)>
                    AND
                        u.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.familyID#">                
                	</cfif>
                    
                    <cfif VAL(ARGUMENTS.batchID)>
                    AND
                        u.batchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.batchID#">                
                	</cfif>
            </cfquery>    

		<cfreturn qGetCBCUserByID>
	</cffunction>

    
	<cffunction name="getCBCUser" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run for a user">
        <cfargument name="companyID" type="numeric" default="0" hint="CompanyID is not required">
        <cfargument name="seasonID" type="numeric" default="0" hint="SeasonID is not required">
        <cfargument name="userID" type="numeric" default="0" hint="UserID is not required">
        
        <cfquery 
        	name="qGetCBCUser" 	
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                	cbc.cbcID, 
                    cbc.userID, 
                    cbc.familyID, 
                    cbc.date_authorized, 
                    cbc.date_sent, 
                    cbc.date_received,
                    u.firstname, 
                    u.lastname, 
                    u.middlename, 
                    u.dob, 
                    u.ssn
                FROM 
                	smg_users_cbc cbc
                INNER JOIN 
                	smg_users u ON u.userID = cbc.userID
                INNER JOIN 
                	user_access_rights uar ON uar.userID = u.userID
                WHERE 
                    cbc.date_sent IS <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">
                AND 
                    requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                AND 
                    cbc.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND 
                    uar.usertype <= <cfqueryparam cfsqltype="cf_sql_integer" value="7">

                <!--- Check if we are running ISE's CBC --->
                <cfif VAL(ARGUMENTS.companyID) LTE 4>
                AND 
                    cbc.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                AND 
                    cbc.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>

            	<!--- Check if we have a valid SeasonID --->
				<cfif VAL(ARGUMENTS.seasonID)>
                AND 
                    cbc.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">
				</cfif>

            	<!--- Check if we have a valid userID --->
				<cfif VAL(ARGUMENTS.userID)>
                AND 
                    cbc.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">
				</cfif>

                <!--- If running batch, limit to 20 so we don't get time outs --->
                LIMIT 20
        </cfquery>
   
        <cfreturn qGetCBCUser>
    </cffunction>


	<cffunction name="getCBCUserMember" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run for a user member">
        <cfargument name="companyID" type="numeric" default="0" hint="CompanyID is not required">
        <cfargument name="seasonID" type="numeric" default="0" hint="SeasonID is not required">
        <cfargument name="userID" type="numeric" default="0" hint="UserID is not required">
        
        <cfquery 
        	name="qGetCBCUserMember" 	
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                	cbc.cbcID, 
                    cbc.userID, 
                    cbc.familyID, 
                    cbc.date_authorized, 
                    cbc.date_sent, 
                    cbc.date_received,
                    u.firstname, 
                    u.lastname, 
                    u.middlename, 
                    u.dob, 
                    u.ssn
                FROM 
                	smg_users_cbc cbc
                INNER JOIN 
                	smg_user_family u ON u.ID = cbc.familyID
                WHERE 
                    cbc.date_sent IS <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">
                AND 
                    requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                AND 
                    cbc.familyID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
					
            	<!--- Check if we have a valid SeasonID --->
				<cfif VAL(ARGUMENTS.seasonID)>
                AND 
                    cbc.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">
				</cfif>

                <!--- Check if we are running ISE's CBC --->
                <cfif VAL(ARGUMENTS.companyID) LTE 4>
                AND 
                    cbc.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                AND 
                    cbc.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>

                LIMIT 20
        </cfquery>
   
        <cfreturn qGetCBCUserMember>
    </cffunction>


	<cffunction name="updateUserCBC" access="public" returntype="void" output="false" hint="Updates User CBC Information">
    	<cfargument name="batchID" type="numeric" required="yes">
        <cfargument name="ReportID" type="string" required="yes">  
        <cfargument name="cbcID" type="numeric" required="yes">  
        <cfargument name="xmlReceived" type="string" default=""> 
        
        <cfquery 
        	datasource="MySql">
            UPDATE 
            	smg_users_cbc  
            SET 
                date_sent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                date_received = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                batchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.batchID#">,
                requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reportID#">,
                xml_received = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.xmlReceived#">
            WHERE 
            	cbcID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcID#">
        </cfquery>

	</cffunction>
	<!--- End of Users --->
    

	<!--- CBC Batch Functions --->
	<cffunction name="createBatchID" access="public" returntype="numeric" output="false" hint="Returns the inserted batch ID">
    	<cfargument name="companyID" required="yes">
        <cfargument name="userID" required="yes">        
        <cfargument name="cbcTotal" required="yes">
	    <cfargument name="batchType" required="yes">
    
        <cfquery 
        	name="qCreateBatchID" 
            datasource="#APPLICATION.dsn#">
                INSERT INTO 
                	smg_users_cbc_batch  
                (
                    companyID, 
                    createdby, 
                    datecreated, 
                    total, 
                    type
                )
				VALUES 
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcTotal#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.batchType#">
                )
        </cfquery>
        
        <cfquery 
        	name="qGetBatchID" 
        	datasource="#APPLICATION.dsn#">
                SELECT 
                	MAX(cbcID) as cbcID
                FROM 
                	smg_users_cbc_batch
        </cfquery>
	
    	<cfreturn qGetBatchID.cbcID>
    </cffunction>    
	

	<cffunction name="processBatch" access="public" returntype="struct" output="false" hint="Process XML Batch. Creates, submits and sends email">
        <cfargument name="companyID" type="numeric" required="yes">
        <cfargument name="batchID" type="numeric" required="yes">
        <cfargument name="userType" type="string" required="yes">
        <cfargument name="hostID" type="numeric" default="0">
        <cfargument name="cbcID" type="string" default="0" hint="ID of smg_users_cbc or smg_hosts_cbc so we know which record we need to update">
        <cfargument name="userID" type="numeric" default="0">
        <cfargument name="username" type="string" required="yes">
        <cfargument name="password" type="string" required="yes">
        <cfargument name="account" type="string" required="yes">
        <cfargument name="SSN" type="string" required="yes">
        <cfargument name="lastName" type="string" required="yes">
        <cfargument name="firstName" type="string" required="yes">
        <cfargument name="middleName" type="string" required="yes">
        <cfargument name="DOBYear" type="numeric" required="yes">
        <cfargument name="DOBMonth" type="numeric" required="yes">
        <cfargument name="DOBDay" type="numeric" required="yes">
        <cfargument name="noSummary" type="string" required="yes">
        <cfargument name="includeDetails" type="string" required="yes">
               
			<cfscript>
				// declare variable
				var requestXML = '';
				var responseXML = '';
				var reportID = 0;
				var decryptedSSN = '';
				
				// declare return structure
				var batchResult = StructNew();

				batchResult.message = 'Success';
				batchResult.fullPathsentFile = '';
				batchResult.sentFile = '';
				batchResult.fullPathreceivedFile = '';				
				batchResult.receivedFile = '';
			
				// URL is shown in the create_xml_users_gis and create_xml_hosts_gis pages.
				batchResult.BGCDirectURL = BGCDirectURL;
			
				// If we are running this local, update the user information
				if ( APPLICATION.isServerLocal ) {
					ARGUMENTS.username = BGCUser;
					ARGUMENTS.password = BGCPassword;
					ARGUMENTS.account = BGCAccount;
				}
				
				// Get Company Information
				qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=ARGUMENTS.companyID);
			</cfscript>

            <cftry>
                <cfscript>
					// Decrypt SSN
					//decryptedSSN = Replace(Decrypt(ARGUMENTS.SSN, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', 'desede', 'hex'),"-","","All");
					decryptedSSN = Replace(Decrypt(ARGUMENTS.SSN, decryptKey, decryptAlgorithm, decryptEncoding),"-","","All");
					decryptedSSN = Replace(decryptedSSN, " ", "", "All");
				</cfscript>
       
                <cfcatch type="any">
                    
					<cfscript>
                        // Set up message
                        if ( VAL(ARGUMENTS.hostID) ) {
							batchResult.message = 'Please check SSN for host #ARGUMENTS.usertype# family #ARGUMENTS.lastName# (###ARGUMENTS.hostID#)';
						} else {
							batchResult.message = 'Please check SSN for user #ARGUMENTS.lastName# (###ARGUMENTS.userID#)';
						}
						
						return batchResult;
					</cfscript>
                    
                </cfcatch>
            </cftry>
        	
            <!--- Create XML --->
            <cfoutput>
                <cfxml variable='requestXML'>
                <BGC>
                    <login>
                        <user>#ARGUMENTS.username#</user>
                        <password>#ARGUMENTS.password#</password>
                        <account>#ARGUMENTS.account#</account>
                    </login>
                    <product>
                        <USOneValidate version="1">
                            <order>
                                <SSN>#decryptedSSN#</SSN>
                            </order>
                        </USOneValidate>
                    </product>
                    <product>
                        <USOneSearch version='1'>
                            <order>
                                <lastName>#ARGUMENTS.lastName#</lastName>				
                                <firstName>#ARGUMENTS.firstName#</firstName>
                                <middleName>#ARGUMENTS.middleName#</middleName>
                                <DOB>
                                    <year>#ARGUMENTS.DOBYear#</year>
                                    <month>#ARGUMENTS.DOBMonth#</month>
                                    <day>#ARGUMENTS.DOBDay#</day>
                                </DOB>
                            </order>
                            <custom>
                                <options>
                                    <noSummary>#ARGUMENTS.noSummary#</noSummary>			
                                    <includeDetails>#ARGUMENTS.includeDetails#</includeDetails>
                                </options>
                            </custom>				
                        </USOneSearch>
                    </product>
                    <product>	
                        <USOneTrace version="1">
                            <order>
                                <SSN>#decryptedSSN#</SSN>
                                <lastName>#ARGUMENTS.lastName#</lastName>
                                <firstName>#ARGUMENTS.firstName#</firstName>
                            </order>
                        </USOneTrace>
                    </product>	
                </BGC>
                </cfxml>
			</cfoutput>
            
            <cftry>
            
				<!--- Submit CBC --->
                <cfhttp url="#BGCDirectURL#" method="POST" throwonerror="yes">
                    <cfhttpparam type="XML" value="#requestXML#" />
                    <cfhttpparam type="Header" name="charset" value="utf-8" />
                </cfhttp>
				
                <cfscript>	
                    // Parse XML we received back to a variable
                    responseXML = XmlParse(cfhttp.filecontent);		
					
                    // Reads XML File and Send Email CFC
                    batchResult.message = sendEmailResult(
                        companyID=ARGUMENTS.companyID,
                        responseXML=responseXML,
                        //XMLFilePath=batchResult.fullPathreceivedFile,
                        userType=ARGUMENTS.userType,
                        hostID=ARGUMENTS.hostID,
                        userID=ARGUMENTS.userID,
                        lastName=ARGUMENTS.lastName,
                        firstName=ARGUMENTS.firstName
                    );				
    
                    // Get Report ID
                    if ( responseXML.bgc.product[2].USOneSearch.response.detail.offenders.XmlAttributes.qtyFound NEQ 0 ) {
                        ReportID = '#responseXML.bgc.product[2].USOneSearch.response.detail.offenders.offender.record.key.secureKey.XmlText#';
                    } else {
                        ReportID = '#responseXML.bgc.XmlAttributes.orderId#';
                    }
                    
                    // Check if we have successfully submitted the background check
                    if (batchResult.message EQ 'success') {
                        
                        if ( VAL(ARGUMENTS.hostID) ) {
                            // Update Host CBC 
                            APPLICATION.CFC.CBC.updateHostCBC(
                                batchID=ARGUMENTS.BatchID,
                                ReportID=ReportID,
                                cbcFamID=ARGUMENTS.cbcID,
                                xmlReceived=responseXML
                            );							
                        } else {
                            // Update User CBC 
                            APPLICATION.CFC.CBC.updateUserCBC(
                                batchID=ARGUMENTS.BatchID,
                                ReportID=ReportID,
                                cbcID=ARGUMENTS.cbcID,
                                xmlReceived=responseXML
                            );
                        }
                    }
                    
                    return batchResult;
                </cfscript>
                
                <cfcatch type="any">
                    <cfmail 
                    	from="support@student-management.com"
                        to="marcus@student-management.com"
                        subject="CBC Error"
                        type="html">
					
                        <p><b>Error Processing CBC for #ARGUMENTS.firstName# #ARGUMENTS.lastName#</b></p>                 
                        
                        <p>Message: #cfcatch.message#</p>
                        
                        <!---
                        <p>XML Sent:<br>
                        <cfdump var="#requestXML#"> </p>
						--->
                        
                        <!---
                        <p>XML Received: <br>
                        <cfdump var="#responseXML#"> </p>
                        --->
                        
                        <p>Error: <br>
                        <cfdump var="#cfcatch#"> </p>
                        
                     </cfmail>

					<cfscript>
                        // Set up message
                        batchResult.message = 'Error Processing CBC for #ARGUMENTS.firstName# #ARGUMENTS.lastName#. <br> Please try again.';
						
						return batchResult;
					</cfscript>
                </cfcatch>
                
            </cftry>

	</cffunction>


	<cffunction name="sendEmailResult" access="public" returntype="string" output="false" hint="Reads XML File and Sends Email Result">
    	<cfargument name="companyID" required="yes">
        <cfargument name="responseXML" default="" hint="responseXML or XMLFilePath must be passed to this function">
        <cfargument name="XMLFilePath" default="" hint="responseXML or XMLFilePath must be passed to this function">
        <cfargument name="userType" type="string" default="" hint="Optional: Member, Host Father, Host Mother, User">
        <cfargument name="hostID" type="numeric" default="0" hint="Optional">
        <cfargument name="userID" type="numeric" default="0" hint="Optional">        
        <cfargument name="firstName" type="string" default="" hint="Optional">
		<cfargument name="lastName" type="string" default="" hint="Optional">
        	
            <cfscript>
				// Set return variable
				var emailResult = 'Success';
				var readXML = '';
				var setUserType = '';
				
				// check if we have at least one of the required arguments
				if ( NOT LEN(ARGUMENTS.responseXML) AND NOT LEN(ARGUMENTS.XMLFilePath) ) {										
					emailResult = 'Error - responseXML or XMLFilePath must be passed to this function';
					return emailResult;
				}
				
				// check if we have a valid XML
				if ( LEN(ARGUMENTS.responseXML) AND NOT IsXML(ARGUMENTS.responseXML) ) {
					emailResult = 'Error - Not a valid XML';
					return emailResult;
				}				
			</cfscript>
            
            <!--- Check if we have a file Path, if we do read the XML and store it in ARGUMENTS.responseXML --->
			<cfif LEN(ARGUMENTS.XMLFilePath)>
				             
				<cftry>               
                    
                    <cffile 
                        action="read" 
                        variable="ARGUMENTS.responseXML"
                        file="#ARGUMENTS.XMLFilePath#">		
				
                    <cfcatch type="any">
                        <cfscript>
							emailResult = 'Error - Could not find XML file #ARGUMENTS.XMLFilePath#';
							
							return emailResult;
						</cfscript>
                    </cfcatch>
                    
                </cftry>
                            
            </cfif>
			
            <cfscript>
				// Parse XML
				readXML = XmlParse(ARGUMENTS.responseXML);
			
				// Get Report ID
                if ( readXML.bgc.product[2].USOneSearch.response.detail.offenders.XmlAttributes.qtyFound NEQ 0 ) {
                    ReportID = '#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender.record.key.secureKey.XmlText#';
                } else {
                    ReportID = '#readXML.bgc.XmlAttributes.orderId#';
                }
				
				// Get Company Information
				qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=ARGUMENTS.companyID);
				
				if ( VAL(ARGUMENTS.hostID) ) {
					setUserType = 'Host';	
				} else if ( VAL(ARGUMENTS.userID) ) {
					setUserType = 'User';	
				}
            </cfscript>
        
            <cfmail 
            	from="#qGetCompany.support_email#" 
                to="#qGetCompany.gis_email#"  <!--- marcus@student-management.com | #qGetCompany.gis_email# ---->
                subject="GIS Search for #qGetCompany.companyshort# #setUserType# #ARGUMENTS.userType# - #ARGUMENTS.firstName# #ARGUMENTS.lastName# (###ARGUMENTS.hostID#)" 
                failto="#qGetCompany.support_email#"
                type="html">
                
                    <cfscript>
						// Display Formatted Results
                        displayXMLResult(
                            companyID=ARGUMENTS.companyID, 
                            responseXML=ARGUMENTS.responseXML, 
                            userType=ARGUMENTS.userType,
                            hostID=ARGUMENTS.hostID,
                            userID=ARGUMENTS.userID,
                            firstName=ARGUMENTS.firstName,
                            lastName=ARGUMENTS.lastName
                        );
                    </cfscript>
                    
            </cfmail>

		<cfreturn emailResult>
	</cffunction>


	<cffunction name="displayXMLResult" access="public" returntype="void" output="true" hint="Reads and Display XML Result">
    	<cfargument name="companyID" required="yes">
        <cfargument name="responseXML" default="" hint="responseXML or XMLFilePath must be passed to this function">
        <cfargument name="userType" type="string" default="" hint="Father,Mother,User,Member">
        <cfargument name="hostID" type="numeric" default="0" hint="Optional">
        <cfargument name="userID" type="numeric" default="0" hint="Optional"> 
        <cfargument name="familyID" type="numeric" default="0" hint="Optional">  
        <cfargument name="firstName" type="string" default="" hint="Optional">
        <cfargument name="lastName" type="string" default="" hint="Optional">        
			
            <cfscript>
				// Parse XML
				var readXML = XmlParse(ARGUMENTS.responseXML);
			
				var setFirstName = '';
				var setLastName = '';
			
				// Get Report ID
                if ( readXML.bgc.product[2].USOneSearch.response.detail.offenders.XmlAttributes.qtyFound NEQ 0 ) {
                    ReportID = '#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender.record.key.secureKey.XmlText#';
                } else {
                    ReportID = '#readXML.bgc.XmlAttributes.orderId#';
                }
				
				// Get Company Information
				qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=ARGUMENTS.companyID);
				
				if ( VAL(ARGUMENTS.hostID) ) {
					setUserType = 'Host';						
				} else if ( VAL(ARGUMENTS.userID) ) {					
					setUserType = 'User';	
					ARGUMENTS.firstName = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.userID).firstName;
					ARGUMENTS.lastName = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.userID).lastName;
				}
				
				// Get total of items
				totalItems = readXML.bgc.product[2].USOneSearch.response.detail.offenders.XmlAttributes.qtyFound;
            </cfscript>
        
			<cfoutput>
                <table width="670" align="center">
                	<!--- Header --->
                    <tr bgcolor="##CCCCCC"><th colspan="2">Criminal Backgroud Check - Date Processed: #DateFormat(now(), 'mm/dd/yyyy')#</th></tr>
                    
                    <tr><td colspan="2">&nbsp;</td></tr>
                    
                    <tr bgcolor="##CCCCCC">
                        <th colspan="2">
                            * Search Results for : #qGetCompany.companyshort# #setUserType# #ARGUMENTS.usertype# - #ARGUMENTS.firstName# #ARGUMENTS.lastName# 
                            <cfif VAL(ARGUMENTS.hostID)>
                                (###ARGUMENTS.hostID#)
                            <cfelseif VAL(ARGUMENTS.userID)>
                                (###ARGUMENTS.userID#)
                            </cfif> 
                            *
                        </th>
                    </tr>
                    
                    <tr><td colspan="2">&nbsp;</td></tr>
                    
                    <!--- USOneValidate --->
                    <tr bgcolor="##CCCCCC"><th colspan="2">US ONE VALIDATE</th></tr>
                    <tr><td colspan="2"><b>SSN Validation & Death Master Index Check for #readXML.bgc.product[1].USOneValidate.order.ssn#</b></td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; #readXML.bgc.product[1].USOneValidate.response.validation.textResponse#</td></tr>	
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; The associated individual is <b> <cfif readXML.bgc.product[1].USOneValidate.response.validation.isDeceased.XmlText EQ 'no'>not</cfif> deceased.</b></td></tr>			
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; Issued in <b>#readXML.bgc.product[1].USOneValidate.response.validation.stateIssued#</b> between <b>#readXML.bgc.product[1].USOneValidate.response.validation.yearIssued#</b></td></tr>			
                                            
                    <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                    
                    <!--- USOneSearch --->	
                    <tr bgcolor="##CCCCCC"><th colspan="2"><b>US ONE SEARCH</b></th></tr>
                    <tr><td colspan="2"><b>You searched for:</b></td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>#readXML.bgc.product[2].USOneSearch.order.lastname#, #readXML.bgc.product[2].USOneSearch.order.firstname# #readXML.bgc.product[2].USOneSearch.order.middlename#</b></td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>SSN : </b> #readXML.bgc.product[1].USOneValidate.order.ssn#</td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>DOB : </b> #readXML.bgc.product[2].USOneSearch.order.dob.month#/#readXML.bgc.product[2].USOneSearch.order.dob.day#/#readXML.bgc.product[2].USOneSearch.order.dob.year#</td></tr>						
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>Report ID : </b> #ReportID#</td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>Number of items: </b> #totalItems#<br></td></tr>
                    
                    <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                    
                    <cfif VAL(totalItems)>
                        
                        <!--- ITEMS - OFFENDER --->
                        <cfloop from="1" to ="#totalItems#" index="t">				
                            <cfset totalOffenses = (ArrayLen(readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.XmlChildren))>
                            <tr>
                                <td><b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].identity.personal.fullName#</b></td>
                                <td>ID ##: #readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].record.key.offenderid#</td>
                            </tr>
                            <tr>
                                <td>DOB: #readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].identity.personal.dob#</td>
                                <td>GENDER: #readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].identity.personal.gender#</td>
                            </tr>
                            <tr><td colspan="2">Total of Offenses: #totalOffenses#<br></td></tr>
                           
                            <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                            
                            <!--- OFFENSES --->
                            <cfloop from="1" to ="#totalOffenses#" index="i">
                                <tr><td colspan="2">
                                        <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].description#</b>
                                        (#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].record.provider#, #readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].record.key.state#)
                                    </td>
                                </tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                
                                <!--- Disposition --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].disposition.XmlText NEQ ''>
                                    <tr><td colspan="2">Disposition : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].disposition#</b></td></tr>
                                </cfif>
                                
                                <!--- Degree Of Offense --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].degreeOfOffense.XmlText NEQ ''>
                                    <tr><td colspan="2">Degree Of Offense : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].degreeOfOffense#</b></td></tr>
                                </cfif>
                                
                                <!--- Sentence --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentence.XmlText NEQ ''>
                                    <tr><td colspan="2">Sentence : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentence#</b></td></tr>
                                </cfif>
                                
                                <!--- Probation --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].probation.XmlText NEQ ''>
                                    <tr><td colspan="2">Probation : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].probation#</b></td></tr>
                                </cfif>
                                
                                <!--- Offense --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].confinement.XmlText NEQ ''>
                                    <tr><td colspan="2">Offense : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].confinement#</b></td></tr>
                                </cfif>
                                
                                <!--- Arresting Agency --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestingAgency.XmlText NEQ ''>
                                    <tr><td colspan="2">Arresting Agency : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestingAgency#</b></td></tr>
                                </cfif>
                                
                                <!--- Original Agency --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].originatingAgency.XmlText NEQ ''>
                                    <tr><td colspan="2">Original Agency : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].originatingAgency#</b></td></tr>
                                </cfif>
                                
                                <!--- Jurisdiction --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].jurisdiction.XmlText NEQ ''>
                                <tr><td colspan="2">Jurisdiction : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].jurisdiction#</b></td></tr>
                                </cfif>
                               
                                <!--- Statute --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].statute.XmlText NEQ ''>
                                <tr><td colspan="2">Statute : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].statute#</b></td></tr>
                                </cfif>
                                
                                <!--- Plea --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].plea.XmlText NEQ ''>
                                    <tr><td colspan="2">Plea : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].plea#</b></td></tr>
                                </cfif>
                                
                                <!--- Court Decision --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtDecision.XmlText NEQ ''>
                                    <tr><td colspan="2">Court Decision : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtDecision#</b></td></tr>
                                </cfif>
                                
                                <!--- Court Costs --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtCosts.XmlText NEQ ''>
                                    <tr><td colspan="2">Court Costs : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtCosts#</b></td></tr>
                                </cfif>
                                
                                <!--- Fine --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fine.XmlText NEQ ''>
                                    <tr><td colspan="2">Fine : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fine#</b></td></tr>
                                </cfif>
                                
                                <!--- Offense Date --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].offenseDate.XmlText NEQ ''>
                                <tr><td colspan="2">Offense Date : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].offenseDate#</b></td></tr>
                                </cfif>
                                
                                <!--- Arrest Date --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestDate.XmlText NEQ ''>
                                    <tr><td colspan="2">Arrest Date : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestDate#</b></td></tr>
                                </cfif>
                                
                                <!--- Sentence Date --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentenceDate.XmlText NEQ ''>
                                    <tr><td colspan="2">Sentence Date : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentenceDate#</b></td></tr>
                                </cfif>
                                
                                <!--- Disposition Date --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].dispositionDate.XmlText NEQ ''>
                                    <tr><td colspan="2">Disposition Date : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].dispositionDate#</b></td></tr>
                                </cfif>
                                
                                <!--- File Date --->
                                <cfif readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fileDate.XmlText NEQ ''>
                                <tr><td colspan="2">File Date : <b>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fileDate#</b></td></tr>
                                </cfif>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                
                                <!--- SPECIFIC INFORMATION --->				
                                <tr><td colspan="2"><i>#readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].record.provider#, #readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].record.key.state# SPECIFIC INFORMATION</i></td></tr>
                                <cfset totalSpecifics = (ArrayLen(readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.XmlChildren))>
                                <tr>
                                
                                <cfloop from="1" to ="#totalSpecifics#" index="s">
                                    <td>&nbsp; &nbsp; &nbsp; #readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.supplement[s].displayTitle# : 
                                        <b> #readXML.bgc.product[2].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.supplement[s].displayValue# </b>
                                    </td>
                                    <cfif s MOD 2></tr><tr></tr></cfif>
                                </cfloop>
                                
                                <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                                                        
                            </cfloop>
                            
                        </cfloop>	
                        
                    <cfelse>
                        <tr><td colspan="2">No data found.</td></tr>
                        <tr><td colspan="2"><hr width="100%" align="center"></td></tr>
                    </cfif>
                    
                    <!--- US ONE TRACE --->
                    <tr bgcolor="##CCCCCC"><th colspan="2"><b>US ONE TRACE</b></th></tr>
                    <tr><td colspan="2"><b>You searched for:</b></td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>#readXML.bgc.product[3].USOneTrace.order.lastname#, #readXML.bgc.product[3].USOneTrace.order.firstname#</b></td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>SSN : </b> #readXML.bgc.product[3].USOneTrace.order.ssn#</td></tr>
                    
                    <tr><td colspan="2"><hr width="100%" align="center"></td></tr>			
                    
                    <cfset traceRecords = (ArrayLen(readXML.bgc.product[3].USOneTrace.response.records.XmlChildren))>
                    <cfif traceRecords GT 0>			
                        <cfloop index="tr" from="1" to ="#traceRecords#">
                            <tr>
                                <td width="50%">First Name : <b>#readXML.bgc.product[3].USOneTrace.response.records.record[tr].firstName# 
                                    #readXML.bgc.product[3].USOneTrace.response.records.record[tr].middleName# 
                                    #readXML.bgc.product[3].USOneTrace.response.records.record[tr].lastName# </b>
                                </td>
                                <td width="50%">Phone Info : <b>#readXML.bgc.product[3].USOneTrace.response.records.record[tr].phoneInfo#</b></td>
                            </tr>
                            <tr>
                                <td>Address : <b>#readXML.bgc.product[3].USOneTrace.response.records.record[tr].streetNumber# 
                                    #readXML.bgc.product[3].USOneTrace.response.records.record[tr].streetName# </b>
                                </td>		
                                <td>
                                    <b>
                                        #readXML.bgc.product[3].USOneTrace.response.records.record[tr].city#, 
                                        #readXML.bgc.product[3].USOneTrace.response.records.record[tr].state# 
                                        #readXML.bgc.product[3].USOneTrace.response.records.record[tr].postalCode#-
                                        #readXML.bgc.product[3].USOneTrace.response.records.record[tr].postalCode4# 
                                    </b>
                                </td>
                            </tr>	
                            <tr>
                                <td>County : <b>#readXML.bgc.product[3].USOneTrace.response.records.record[tr].county#</b></td>
                                <td>Verified : <b>#readXML.bgc.product[3].USOneTrace.response.records.record[tr].verified#</b></td>
                            </tr>	
                            <tr><td colspan="2"><hr width="100%" align="center"></td></tr>
                        </cfloop>
                    <cfelse>
                        <tr><td colspan="2">No data found.</td></tr>
                        <tr><td colspan="2"><hr width="100%" align="center"></td></tr>
                    </cfif>
                    
                    <tr><td colspan="2">&nbsp;</td></tr>
                    
                    <!--- FOOTER --->
                    <tr><td colspan="2">For more information please visit <a href="www.backgroundchecks.com">www.backgroundchecks.com</a></td></tr>	
                    <tr><td colspan="2">
                            ***********************<br>
                            CONFIDENTIALITY NOTICE:<br>
                            This is a transmission from 
                            <cfif ARGUMENTS.companyID EQ 10>
                                #qGetCompany.companyName#
                            <cfelse>
                                International Student Exchange 
                            </cfif> 
                            and may contain information that is confidential and proprietary.
                            If you are not the addressee, any disclosure, copying or distribution or use of the contents of this message is expressly prohibited.
                            If you have received this transmission in error, please destroy it and notify us immediately at #qGetCompany.phone#.<br>
                            Thank you.<br>
                            ***********************
                    </td>
                </tr>
                </table>
                <br><br>
            </cfoutput>

	</cffunction>
    
                    
</cfcomponent>    