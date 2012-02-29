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
				// stored in the database
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
        <cfargument name="cbcfamID" default="0" hint="CBCFamID is not required">
        <cfargument name="sortBy" type="string" default="seasonID" hint="sortBy is not required">
        <cfargument name="sortOrder" type="string" default="ASC" hint="sortOrder is not required">
        <cfargument name="getOneRecord" type="numeric" default="0" hint="getOneRecord is not required">

			<cfscript>
				// Make sure we have a valid sortOrder value
                if ( NOT ListFind("ASC,DESC", ARGUMENTS.sortOrder ) ) {
                    ARGUMENTS.sortOrder = 'DESC';			  
                }
            </cfscript>

            <cfquery 
            	name="qGetCBCHostByID" 
                datasource="#APPLICATION.dsn#">
                    SELECT 
                        h.cbcfamID, 
                        h.hostID, 
                        h.familyID,
                        h.batchID,  <!--- phase out | storing cbc in the database --->
                        h.cbc_type,
                        h.notes,
                        h.date_authorized, 
                        h.date_sent, 
                        h.date_expired,
                        h.date_approved,
                        h.xml_received, 
                        h.requestID, 
                        h.isNoSSN,
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
                        h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#"> 

                    <cfif VAL(ARGUMENTS.cbcfamID)>
                        AND
                            h.cbcfamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcfamID#">                                	
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
                            
                    <cfswitch expression="#ARGUMENTS.sortBy#">
                        
                        <cfcase value="seasonID">                    
                            h.seasonID #ARGUMENTS.sortOrder#
                        </cfcase>

                        <cfcase value="familyID">                    
                            h.familyID #ARGUMENTS.sortOrder#,
                            h.seasonID #ARGUMENTS.sortOrder#
                        </cfcase>

                        <cfcase value="date_sent">
                            h.date_sent #ARGUMENTS.sortOrder#
                        </cfcase>
        
                        <cfdefaultcase>
                            h.seasonID #ARGUMENTS.sortOrder#
                        </cfdefaultcase>
        
                    </cfswitch> 
                    
                    <cfif VAL(ARGUMENTS.getOneRecord)>
                    	LIMIT 1
                    </cfif>
                                        
            </cfquery>    

		<cfreturn qGetCBCHostByID>
	</cffunction>


	<cffunction name="getEligibleHostMember" access="public" returntype="query" output="false" hint="Returns CBC for family members 17 years old and older">
		<cfargument name="hostID" required="yes" hint="HostID is required">
        <cfargument name="studentID" default="0" hint="studentID is not required, pass to get only members that will not turn 18 during the program">

			<cfscript>
                // Get Student Program End Date - Remove 5 days from program end date to compensate for leap/bissextile year
                qGetProgramInfo = APPLICATION.CFC.PROGRAM.getProgramByStudentID(studentID=ARGUMENTS.studentID);
			</cfscript>
            
            <cfquery 
            	name="qGetEligibleHostMember" 
            	datasource="#APPLICATION.dsn#">
                    SELECT 
                        childID, 
                        hostID, 
                        membertype, 
                        name, 
                        middlename, 
                        lastName,
                        sex, 
                        ssn, 
                        birthdate, 
                        FLOOR(DATEDIFF(CURRENT_DATE,birthdate)/365) AS age,
                        cbc_form_received
                    FROM 
                        smg_host_children 
                    WHERE 
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
                    AND
                    	liveAtHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">                    
                    AND
                    	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
					<cfif IsDate(qGetProgramInfo.endDate)> 
                        <!--- Get only students that are turning 18 by the end of the program --->
                        AND 
                            FLOOR(DATEDIFF("#DateFormat( DateAdd("d", -5, qGetProgramInfo.endDate), 'yyyy-mm-dd')#", birthdate)/365) >= <cfqueryparam cfsqltype="cf_sql_integer" value="18">
                    <cfelse>                    
                        AND 
                            FLOOR(DATEDIFF(CURRENT_DATE, birthdate)/365) >= <cfqueryparam cfsqltype="cf_sql_integer" value="17">
                    </cfif>
                    
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
        <cfargument name="isNoSSN" default="0" hint="isNoSSN is not required">
        <cfargument name="dateAuthorized" required="yes" hint="Date of Authorization">
        <cfargument name="isReRun" default="0" hint="isReRun is not required">

            <cfquery 
            	name="qCheckPending" 
            	datasource="#APPLICATION.dsn#">
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
            </cfquery>
            	
			<cfif NOT qCheckPending.recordCount>
            
                <cfquery 
                    datasource="#APPLICATION.dsn#">
                        INSERT INTO 
                            smg_hosts_cbc 
                        (
                            hostID, 
                            familyID, 
                            cbc_type, 
                            seasonID, 
                            companyID,
                            isNoSSN,
                            isReRun, 
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
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isReRun#">,
                            <cfif LEN(ARGUMENTS.dateAuthorized)>
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(ARGUMENTS.dateAuthorized)#">,
                            <cfelse>
                                NULL,                          
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        )
                </cfquery>	
                
			</cfif>
            
	</cffunction>


	<cffunction name="updateHostOptions" access="public" returntype="void" output="false" hint="Updates the flag and SSN field on the CBC record. It does not return a value">
		<cfargument name="cbcFamID" required="yes" hint="cbcFamID is required">
        <cfargument name="isNoSSN" default="" hint="isNoSSN is not required. Values 0 or 1">
		<cfargument name="flagCBC" default="0" hint="flagCBC is not required. Values 0 or 1">
        <cfargument name="notes" default="" hint="any notes on the CBC">
        <cfargument name="date_approved" default="" hint="date the cbc was approved">
            <cfquery 
            	name="qUpdateHostOptions" 
                datasource="#APPLICATION.dsn#">
                    UPDATE 
                        smg_hosts_cbc
                    SET 
                        isNoSSN = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.isNoSSN#">,
                        flagcbc = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.flagCBC#">,
                        notes  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.notes#">,
                        date_approved = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date_approved#">
                    WHERE 
                        cbcFamID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cbcFamID#">
            </cfquery>	

	</cffunction>

	
	<cffunction name="getPendingCBCHost" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run for a host">
        <cfargument name="companyID" type="numeric" default="0" hint="CompanyID is not required">
        <cfargument name="seasonID" type="numeric" default="0" hint="SeasonID is not required">
        <cfargument name="userType" type="string" default="" hint="UserType is not required. List of values such as mother,father">
        <cfargument name="hostID" type="numeric" default="0" hint="HostID is not required">
        <cfargument name="noSSN" type="numeric" default="0" hint="Optional - Set to 1 to send batch with no SSN">
        
        <cfquery 
        	name="qGetCBCHost" 	
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                    cbc.cbcfamID, 
                    cbc.hostID, 
                    cbc.cbc_type,
                    cbc.seasonID,
                    cbc.companyID,
                    cbc.isNoSSN,
                    cbc.date_authorized, 
                    cbc.date_sent, 
                    cbc.date_expired,
                    h.familylastName,
                    h.fatherlastName, 
                    h.fatherfirstName, 
                    h.fathermiddlename, 
                    h.fatherdob, 
                    h.fatherssn,
                    h.motherlastName, 
                    h.motherfirstName, 
                    h.mothermiddlename, 
                    h.motherdob,
                    h.motherssn,
                    c.companyShort,
                    c.gis_username,
                    c.gis_password,
                    c.gis_account                                           
                FROM 
                    smg_hosts_cbc cbc
                INNER JOIN 
                    smg_hosts h ON h.hostID = cbc.hostID
                LEFT OUTER JOIN
                	smg_companies c ON c.companyID = cbc.companyID
                WHERE 
                    cbc.date_authorized IS NOT NULL                
				AND
                	cbc.date_sent IS NULL 	
                AND 
                    requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                
                <!--- Check if we are running ISE's CBC --->
                <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                AND 
                    cbc.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
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
                
                	<!--- NO SSN --->
                	<cfif VAL(ARGUMENTS.noSSN) AND ARGUMENTS.userType EQ 'father'>
					AND 
                        h.fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                    <cfelseif VAL(ARGUMENTS.noSSN) AND ARGUMENTS.userType EQ 'mother'>
					AND 
                        h.motherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                    </cfif>
                
                </cfif>
				
            	<!--- Check if we have a valid hostID --->
				<cfif VAL(ARGUMENTS.hostID)>
                AND 
                    cbc.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
				</cfif>
                
                ORDER BY	
                	c.companyID
                
                <!--- If running batch, limit to 20 so we don't get time outs --->
                LIMIT 20
        </cfquery>
   
        <cfreturn qGetCBCHost>
    </cffunction>


	<cffunction name="getPendingCBCHostMember" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run for a host member">
        <cfargument name="companyID" type="numeric" default="0" hint="CompanyID is not required">
        <cfargument name="seasonID" type="numeric" default="0" hint="SeasonID is not required">
        <cfargument name="hostID" type="numeric" default="0" hint="HostID is not required">
        <cfargument name="noSSN" type="numeric" default="0" hint="Optional - Set to 1 to send batch with no SSN">
        
        <cfquery 
        	name="qGetCBCHostMember" 	
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                	cbc.cbcfamID, 
                    cbc.hostID, 
                    cbc.cbc_type, 
                    cbc.seasonID,
                    cbc.companyID,
                    cbc.isNoSSN,
                    cbc.date_authorized, 
                    cbc.date_sent, 
                    cbc.date_expired,
                	child.childID, 
                    child.name, 
                    child.middlename, 
                    child.lastName, 
                    child.birthdate, 
                    child.SSN, 
                    child.hostID,
					c.companyShort,
                    c.gis_username,
                    c.gis_password,
                    c.gis_account   
                FROM 
                	smg_hosts_cbc cbc
                INNER JOIN 
                	smg_host_children child ON child.childID = cbc.familyID
						AND	
                        	child.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                
                LEFT OUTER JOIN
                	smg_companies c ON c.companyID = cbc.companyID    
                WHERE 
                	cbc.date_authorized IS NOT NULL 
				AND
                	cbc.date_sent IS NULL 	               
                AND 
                    requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            	AND	
                	cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="member">
            
                <!--- Check if we are running ISE's CBC --->
                <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                AND 
                    cbc.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
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

				<!--- NO SSN --->
                <cfif VAL(ARGUMENTS.noSSN)>
                AND 
                    child.SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                </cfif>            

                ORDER BY	
                	c.companyID

                LIMIT 20
			</cfquery>

        <cfreturn qGetCBCHostMember>
    </cffunction>


	<cffunction name="updateHostCBC" access="public" returntype="void" output="false" hint="Updates CBC Information">
        <cfargument name="ReportID" type="string" required="yes">  
        <cfargument name="cbcFamID" type="numeric" required="yes">      
        <cfargument name="xmlReceived" type="string" default="">
        
        <cfquery 
        	datasource="MySql">
            UPDATE 
            	smg_hosts_cbc  
            SET 
            	date_sent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                date_expired = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('yyyy', 1, now())#">, <!--- Expires in 1 Year --->
                requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reportID#">,
                xml_received = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.xmlReceived#">
            WHERE 
            	cbcfamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcFamID#">
        </cfquery>

	</cffunction>
    

	<cffunction name="UpdateHostXMLReceived" access="public" returntype="void" output="false" hint="Updates XML Received Information">
        <cfargument name="cbcFamID" type="numeric" required="yes">      
        <cfargument name="xmlReceived" type="string" default="">
        
        <cfquery 
        	datasource="MySql">
            UPDATE 
            	smg_hosts_cbc  
            SET 
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
        <cfargument name="cbcID" default="0" hint="CBC ID is not required">
        <cfargument name="cbcType" default="" hint="CBC type is optional: user/member">
			
            <cfquery 
            	name="qGetCBCUserByID" 
                datasource="#APPLICATION.dsn#">
                    SELECT
                        u.cbcID,
                        u.userID,
                        u.familyID,
                        u.seasonID,
                        u.companyID,
                        u.batchID, <!--- phase out --->
                        u.requestID,
                        u.date_authorized,
                        u.date_sent,
                        u.date_expired,
                        u.date_approved,
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
                    
                    <cfif VAL(ARGUMENTS.cbcID)>
                    AND
                        u.cbcID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcID#">                
                	</cfif>

                    <cfif ARGUMENTS.cbcType EQ "user">
                    AND 
                        u.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    <cfelseif ARGUMENTS.cbcType EQ "member">
                    AND 
                        u.familyID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    </cfif>
                    
				ORDER BY
                	u.seasonID                    
            </cfquery>    

		<cfreturn qGetCBCUserByID>
	</cffunction>


	<cffunction name="getEligibleUserMember" access="public" returntype="query" output="false" hint="Returns CBC for family members 18 years old and older">
		<cfargument name="userID" required="yes" hint="User ID is required">

            <cfquery 
            	name="qGetEligibleUserMember" 
            	datasource="#APPLICATION.dsn#">
                    SELECT 
                    	id, 
                        firstName, 
                        middleName,
                        lastName,
                        sex,
                        relationship,
                        dob,
                        SSN,
                        drivers_license,
                        auth_received,
                        auth_received_type,
                        no_members
                    FROM 
                    	smg_user_family 
                    WHERE 
                    	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userid#">
                    AND 
                    	(DATEDIFF(now( ) , dob)/365) > <cfqueryparam cfsqltype="cf_sql_integer" value="17">
                    ORDER BY 
                    	id                
            </cfquery>
            
		<cfreturn qGetEligibleUserMember>
    </cffunction>


	<cffunction name="insertUserCBC" access="public" returntype="void" output="false" hint="Inserts CBC record. It does not return a value">
		<cfargument name="userID" required="yes" hint="User ID is required">
        <cfargument name="familyMemberID" default="0" hint="Family Member ID is not required">
        <cfargument name="seasonID" required="yes" hint="SeasonID is required">
        <cfargument name="companyID" required="yes" hint="companyID is required">
        <cfargument name="isReRun" default="0" hint="isReRun is not required">
        <cfargument name="dateAuthorized" required="yes" hint="Date of Authorization">

            <cfquery 
            	name="qCheckPending" 
            	datasource="#APPLICATION.dsn#">
					SELECT
                    	userID
                    FROM
                    	smg_users_cbc
                    WHERE
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">	
            		AND
                    	date_sent IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    AND
                    	familyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.familyMemberID#">
            </cfquery>
            	
			<cfif NOT qCheckPending.recordCount>

                <cfquery 
                    datasource="#APPLICATION.dsn#">
                        INSERT INTO 
                            smg_users_cbc 
                        (
                            userid, 
                            familyid, 
                            seasonid, 
                            companyid,
                            isReRun, 
                            date_authorized,
                            dateCreated
                        )
                        VALUES 
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.userID#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.familyMemberID#">,  
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.seasonID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isReRun#">,
                            <cfif LEN(ARGUMENTS.dateAuthorized)>
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(ARGUMENTS.dateAuthorized)#">,
                            <cfelse>
                                NULL,                           
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        )
                </cfquery>	
			
            </cfif>
            
	</cffunction>


	<cffunction name="updateUserCBCByID" access="public" returntype="void" output="false" hint="Update a CBC record">
		<cfargument name="cbcID" required="yes" hint="CBC ID is required">
        <cfargument name="companyID" required="yes" hint="companyID is required">
        <cfargument name="flagCBC" default="0" hint="flagCBC is required. Values 0 or 1">
        <cfargument name="dateAuthorized" required="yes" hint="Date of Authorization">
        <cfargument name="dateApproved" default="" required="no" hint="Date of approval, either null or date approved">
 		 <cfargument name="notes" default="" required="no" hint="notes on CBC for office to view">

            <cfquery 
            	datasource="#APPLICATION.dsn#">
                    UPDATE 
                    	smg_users_cbc 
                    SET 	
                    	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">,
                        flagcbc = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.flagCBC#">,
                        date_approved =  <cfif LEN(ARGUMENTS.dateApproved)><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.dateApproved)#"><cfelse>NULL</cfif>,
                        notes = <cfif LEN(ARGUMENTS.notes)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.notes#"><cfelse>NULL</cfif>,
                        date_authorized = <cfif LEN(ARGUMENTS.dateAuthorized)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(ARGUMENTS.dateAuthorized)#"><cfelse>NULL</cfif>
                    WHERE 
                    	cbcid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcID#">
            </cfquery>	

    
	</cffunction>

    
	<cffunction name="getPendingCBCUser" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run for a user">
        <cfargument name="companyID" type="numeric" default="0" hint="CompanyID is not required">
        <cfargument name="seasonID" type="numeric" default="0" hint="SeasonID is not required">
        <cfargument name="userID" type="numeric" default="0" hint="UserID is not required">
        <cfargument name="noSSN" type="numeric" default="0" hint="Optional - Set to 1 to send batch with no SSN">
        
        <cfquery 
        	name="qGetCBCUser" 	
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                	cbc.cbcID, 
                    cbc.userID, 
                    cbc.familyID,
                    cbc.companyID,
                    cbc.date_authorized, 
                    cbc.date_sent, 
                    cbc.date_expired,
                    u.firstName, 
                    u.lastName, 
                    u.middlename, 
                    u.dob, 
                    u.ssn,
                    c.companyShort,
                    c.gis_username,
                    c.gis_password,
                    c.gis_account                    
                FROM 
                	smg_users_cbc cbc
                INNER JOIN 
                	smg_users u ON u.userID = cbc.userID
                INNER JOIN 
                	user_access_rights uar ON uar.userID = u.userID
				LEFT OUTER JOIN
                	smg_companies c ON c.companyID = cbc.companyID                    
                WHERE 
                    cbc.date_authorized IS NOT NULL
				AND                    
                    cbc.date_sent IS NULL
                AND 
                    requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                AND 
                    cbc.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND 
                    uar.usertype <= <cfqueryparam cfsqltype="cf_sql_integer" value="7">

                <!--- Check if we are running ISE's CBC --->
                <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                    AND 
                        cbc.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
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

            	<!--- NO SSN --->
				<cfif VAL(ARGUMENTS.noSSN)>
                AND 
                    u.ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
				</cfif>
				
                ORDER BY
                	cbc.companyID
                
                <!--- If running batch, limit to 20 so we don't get time outs --->
                LIMIT 20
        </cfquery>
   
        <cfreturn qGetCBCUser>
    </cffunction>


	<cffunction name="getPendingCBCUserMember" access="public" returntype="query" output="false" hint="Returns CBC records that need to be run for a user member">
        <cfargument name="companyID" type="numeric" default="0" hint="CompanyID is not required">
        <cfargument name="seasonID" type="numeric" default="0" hint="SeasonID is not required">
        <cfargument name="userID" type="numeric" default="0" hint="UserID is not required">
        <cfargument name="noSSN" type="numeric" default="0" hint="Optional - Set to 1 to send batch with no SSN">
        
        <cfquery 
        	name="qGetPendingCBCUserMember" 	
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                	cbc.cbcID, 
                    cbc.userID, 
                    cbc.familyID, 
                    cbc.companyID,
                    cbc.date_authorized, 
                    cbc.date_sent, 
                    cbc.date_expired,
                    u.firstName, 
                    u.lastName, 
                    u.middlename, 
                    u.dob, 
                    u.ssn,
                    c.companyShort,
                    c.gis_username,
                    c.gis_password,
                    c.gis_account                    
                FROM 
                	smg_users_cbc cbc
                INNER JOIN 
                	smg_user_family u ON u.ID = cbc.familyID
				LEFT OUTER JOIN
                	smg_companies c ON c.companyID = cbc.companyID                    
                WHERE 
                	cbc.date_authorized IS NOT NULL
                AND
                    cbc.date_sent IS NULL
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
                <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, ARGUMENTS.companyID)>
                AND 
                    cbc.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelseif VAL(ARGUMENTS.companyID)>
                AND 
                    cbc.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
                </cfif>

            	<!--- NO SSN --->
				<cfif VAL(ARGUMENTS.noSSN)>
                AND 
                    u.ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
				</cfif>

                LIMIT 20
        </cfquery>
   
        <cfreturn qGetPendingCBCUserMember>
    </cffunction>


	<cffunction name="updateUserCBC" access="public" returntype="void" output="false" hint="Updates User CBC Information">
        <cfargument name="ReportID" type="string" required="yes">  
        <cfargument name="cbcID" type="numeric" required="yes">  
        <cfargument name="xmlReceived" type="string" default=""> 
        
        <cfquery 
        	datasource="MySql">
            UPDATE 
            	smg_users_cbc  
            SET 
                date_sent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                date_expired = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('yyyy', 1, now())#">, <!--- Expires in 1 Year --->
                requestID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.reportID#">,
                xml_received = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.xmlReceived#">
            WHERE 
            	cbcID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcID#">
        </cfquery>

	</cffunction>
    
    
	<cffunction name="updateUserXMLReceived" access="public" returntype="void" output="false" hint="Updates XML Received Information">
        <cfargument name="cbcID" type="numeric" required="yes">      
        <cfargument name="xmlReceived" type="string" default="">
        
        <cfquery 
        	datasource="MySql">
            UPDATE 
            	smg_users_cbc  
            SET 
                xml_received = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.xmlReceived#">
            WHERE 
            	cbcID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cbcID#">
        </cfquery>

	</cffunction>
	<!--- End of Users --->
    

	<!--- CBC Batch Functions --->
	<cffunction name="processBatch" access="public" returntype="struct" output="false" hint="Process XML Batch. Creates, submits and sends email">
        <cfargument name="companyID" type="numeric" required="yes">
        <cfargument name="userType" type="string" required="yes" hint="Father,Mother,User,Member">
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
        <cfargument name="noSSN" type="numeric" default="0" hint="Optional - Set to 1 to send batch with no SSN">
        <cfargument name="isReRun" type="numeric" default="0" hint="Set to 1 if re running batches automtically">
               
			<cfscript>
				// declare variable
				var requestXML = '';
				var responseXML = '';
				var reportID = 0;
				var decryptedSSN = '';
				
				// declare return structure
				var batchResult = StructNew();

				batchResult.message = 'Success';
				batchResult.URLResults = '';
			
				// URL is shown in the create_xml_users_gis and create_xml_hosts_gis pages.
				batchResult.BGCDirectURL = BGCDirectURL;
			
				// If we are running this local, update the user information
				if ( APPLICATION.isServerLocal ) {
					ARGUMENTS.username = BGCUser;
					ARGUMENTS.password = BGCPassword;
					ARGUMENTS.account = BGCAccount;
				}
				
				// Get Company Information
				//qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=ARGUMENTS.companyID);
			</cfscript>
        	
            <!--- Create XML --->
            <cfoutput>
                
                <!--- Check if we should include SSN --->
                <cfif NOT VAL(ARGUMENTS.noSSN)>

                    <cftry>
                        <cfscript>
                            // Decrypt SSN
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
                    
                    <cfxml variable="requestXML">
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
                                        <noSummary>YES</noSummary>			
                                        <includeDetails>YES</includeDetails>
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
                
				<!--- 
					No SNN USOneSearch Only
				--->   
				<cfelse>     
                               
                    <cfxml variable="requestXML">
                    <BGC>
                        <login>
                            <user>#ARGUMENTS.username#</user>
                            <password>#ARGUMENTS.password#</password>
                            <account>#ARGUMENTS.account#</account>
                        </login>
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
                                        <noSummary>YES</noSummary>			
                                        <includeDetails>YES</includeDetails>
                                    </options>
                                </custom>				
                            </USOneSearch>
                        </product>
                    </BGC>
                    </cfxml>
                
                </cfif> <!--- End of NO SSN --->
                
			</cfoutput>
            
            <cftry>
            
				<!--- Submit CBC --->
                <cfhttp url="#BGCDirectURL#" method="post" throwonerror="yes">
                    <cfhttpparam type="Header" name="charset" value="utf-8" />
                    <cfhttpparam type="XML" value="#requestXML#" />                    
                </cfhttp>
                
                <cfscript>	
                    // Parse XML we received back to a variable
                    responseXML = XmlParse(cfhttp.filecontent);		
					
                    // Reads XML File and Send Email CFC
                    batchResult.message = sendEmailResult(
                        companyID=ARGUMENTS.companyID,
                        responseXML=responseXML,
                        userType=ARGUMENTS.userType,
                        hostID=ARGUMENTS.hostID,
                        userID=ARGUMENTS.userID,
                        lastName=ARGUMENTS.lastName,
                        firstName=ARGUMENTS.firstName,
						isReRun=ARGUMENTS.isReRun
                    );				
    
                    // Get Report ID
                    if ( responseXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.XmlAttributes.qtyFound NEQ 0 ) {
                        ReportID = '#responseXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender.record.key.secureKey.XmlText#';
                    } else {
                        ReportID = '#responseXML.bgc.XmlAttributes.orderId#';
                    }

                    // Check if we have successfully submitted the background check
                    if (batchResult.message EQ 'success') {
                        
                        if ( VAL(ARGUMENTS.hostID) ) {
                            // Update Host CBC 
                            updateHostCBC(
                                ReportID=ReportID,
                                cbcFamID=ARGUMENTS.cbcID,
                                xmlReceived=responseXML
                            );							
							
							// Set up URL Results
							batchResult.URLResults = "view_host_cbc.cfm?hostID=#ARGUMENTS.hostID#&CBCFamID=#ARGUMENTS.cbcID#";

						} else {
                            // Update User CBC 
                            updateUserCBC(
                                ReportID=ReportID,
                                cbcID=ARGUMENTS.cbcID,
                                xmlReceived=responseXML
                            );

							// Set up URL Results
							batchResult.URLResults = "view_user_cbc.cfm?userid=#ARGUMENTS.userID#&cbcID=#ARGUMENTS.cbcID#";
                        }
                    }
                    
                    return batchResult;
                </cfscript>
                
                <cfcatch type="any">
                    
                    <!--- Store XML in a temp file --->
                    <cffile action="write" file="#APPLICATION.PATH.temp#xmlReceived.xml" output="#responseXML#" nameconflict="overwrite" charset="utf-8">
                    
                    <cfmail 
                    	from="#APPLICATION.EMAIL.support#"
                        to="#APPLICATION.EMAIL.errors#"
                        subject="CBC Error"
                        type="html">
						
                        <cfmailparam file="#APPLICATION.PATH.temp#xmlReceived.xml" type="text">
                        
                    	<p>#CLIENT.exits_url#</p>
                    
                        <p>
                        	<strong>
                            	Error Processing CBC for #ARGUMENTS.userType# #ARGUMENTS.firstName# #ARGUMENTS.lastName# 
								<cfif VAL(ARGUMENTS.userID)> #ARGUMENTS.userID# </cfif>
                                <cfif VAL (ARGUMENTS.hostID)> #ARGUMENTS.hostID# </cfif> 
                          	</strong>
                       </p>                 
                        
                        <p>Message: #cfcatch.message#</p>
                        
                        <!--- Do Not Include Sent XML - It contains SSN --->
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
                        batchResult.message = 'Error Processing CBC for #ARGUMENTS.firstName# #ARGUMENTS.lastName#. Please try again.';
						
						return batchResult;
					</cfscript>
                </cfcatch>
                
            </cftry>

	</cffunction>


	<cffunction name="sendEmailResult" access="public" returntype="string" output="false" hint="Reads XML File and Sends Email Result">
    	<cfargument name="companyID" required="yes">
        <cfargument name="responseXML" default="" hint="responseXML or XMLFilePath must be passed to this function">
        <cfargument name="XMLFilePath" default="" hint="responseXML or XMLFilePath must be passed to this function">
        <cfargument name="userType" type="string" default="" hint="Father,Mother,User,Member">
        <cfargument name="hostID" type="numeric" default="0" hint="Optional">
        <cfargument name="userID" type="numeric" default="0" hint="Optional">        
        <cfargument name="firstName" type="string" default="" hint="Optional">
		<cfargument name="lastName" type="string" default="" hint="Optional">
        <cfargument name="isReRun" type="numeric" default="0" hint="Optional - Set to 1 if re running batches automtically">
        	
            <cfscript>
				// Set return variable
				var emailResult = 'Success';
				var readXML = '';
				var setCBCType = '';
				
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

				// Get Company Information
				qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=ARGUMENTS.companyID);
				
				// These are used in the email subject to display User, User Member, Host Father, Host Mother and Host Member
				if ( VAL(ARGUMENTS.hostID) ) {
					setCBCType = 'Host';	
					setCBCID = ' (###ARGUMENTS.hostID#)';
				} else if ( VAL(ARGUMENTS.userID) AND ARGUMENTS.userType EQ 'user' ) {
					setCBCType = '';	
					setCBCID = ' (###ARGUMENTS.userID#)';
				} else if ( VAL(ARGUMENTS.userID) ) {
					setCBCType = 'User';	
					setCBCID = ' (###ARGUMENTS.userID#)';
				}

				// Set Email To
				if ( APPLICATION.isServerLocal ) {
					emailTo = 'marcus@iseusa.com';
				} else {
					emailTo = qGetCompany.gis_email;
				}

				// Set Email Subject
				if ( NOT VAL(ARGUMENTS.isReRun) ) {
	            	emailSubject = 'Background Checks Search for #qGetCompany.companyshort# - #setCBCType# #ARGUMENTS.userType# - #ARGUMENTS.firstName# #ARGUMENTS.lastName# #setCBCID#';
				} else {
	            	emailSubject = 'Scheduled Re-Run Background Checks Search for #qGetCompany.companyshort# - #setCBCType# #ARGUMENTS.userType# - #ARGUMENTS.firstName# #ARGUMENTS.lastName# #setCBCID#';
				}
			</cfscript>
        		
            <cfmail 
            	from="#qGetCompany.support_email#" 
                to="#emailTo#"
                subject="#emailSubject#" 
                failto="#qGetCompany.support_email#"
                type="html">
                
                    <cfscript>
						// Display Formatted Results
                        displayXMLResult(
                            companyID=ARGUMENTS.companyID, 
                            responseXML=ARGUMENTS.responseXML, 
                            userType=ARGUMENTS.userType,
                            hostID=ARGUMENTS.hostID,
                            userID=ARGUMENTS.userID
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
        <cfargument name="familyID" type="numeric" default="0" hint="User or Host member ID">  
			
            <cfscript>
				// Parse XML
				var readXML = XmlParse(ARGUMENTS.responseXML);
				
				// Declare First and Last Name
				setfirstName = '';
				setLastName = '';
				
				/* 
					Up to 3 Products 
				   	1. UsOneValidate
				   	2. UsOneSearch
				   	3. UsOneTrace 
				   	If run without social, there will be only one product UsOneSearch 
				*/

				// Get Total of Products
				totalProducts = ArrayLen(readXML.bgc.product);
				
				// Set USOneSearchID, if there is a social is product 2 if there is no social is product 1
				if ( totalProducts GT 1 ) {
					usOneSearchID = 2;					
				} else {
					usOneSearchID = 1;					
				}
				
				// Get USOneSearch Report ID                
				if ( readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.XmlAttributes.qtyFound NEQ 0 ) {
                    ReportID = '#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender.record.key.secureKey.XmlText#';
                } else {
                    ReportID = '#readXML.bgc.XmlAttributes.orderId#';
                }
				
				// Get Company Information
				qGetCompany = APPLICATION.CFC.COMPANY.getCompanies(companyID=ARGUMENTS.companyID);
							
				if ( VAL(ARGUMENTS.hostID) ) {
					// Set CBC Type 
					setCBCType = 'Host';
					
					// Get First Name / Last Name
					switch (ARGUMENTS.userType) {
						// Get host father first and last name
						case "father": {
							qHostFather = APPLICATION.CFC.HOST.getHosts(hostID=ARGUMENTS.hostID);
							setfirstName = qHostFather.fatherfirstName;
							setLastName = qHostFather.fatherLastName;
							break;
						}
						// Get host mother first and last name
						case "mother": {
							qHostMother = APPLICATION.CFC.HOST.getHosts(hostID=ARGUMENTS.hostID);
							setfirstName = qHostMother.motherfirstName;
							setLastName = qHostMother.motherLastName;
							break;
						}
						// Get host member first and last name
						case "member": {
							qHostMember = APPLICATION.CFC.HOST.getHostMemberByID(childID=ARGUMENTS.familyID, hostID=ARGUMENTS.hostID);
							setfirstName = qHostMember.name;
							setLastName = qHostMember.lastName;
							break;
						}
					}
				
				} else if ( VAL(ARGUMENTS.userID) ) {

					switch (ARGUMENTS.userType) {
						// Get User First and Last Name
						case "user": {
							// Set CBC Type 
							setCBCType = '';	
							qUser = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.userID);
							setfirstName = qUser.firstName;
							setLastName = qUser.lastName;
							break;
						}
						// Get Member First and Last Name
						case "member": {
							// Set CBC Type 
							setCBCType = 'User';	
							qUserMember = APPLICATION.CFC.USER.getUserMemberByID(ID=ARGUMENTS.familyID, userID=ARGUMENTS.userID);
							setfirstName = qUserMember.firstName;
							setLastName = qUserMember.lastName;
							break;
						}
					}
				}
				
				// Get total of items - USOneSearch
				totalItems = readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.XmlAttributes.qtyFound;
            </cfscript>
        
			<cfoutput>
            
                <table width="670" align="center">
					<!--- Header --->
                    <tr bgcolor="##CCCCCC"><th colspan="2"><cfif APPLICATION.isServerLocal>DEVELOPMENT SERVER - </cfif> #qGetCompany.companyName#</th></tr>
                    <tr><td colspan="2">&nbsp;</td></tr>

                    <tr bgcolor="##CCCCCC"><th colspan="2">Criminal Backgroud Check &nbsp; -  &nbsp; Date Processed: #DateFormat(now(), 'mm/dd/yyyy')#</th></tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    
                    <tr bgcolor="##CCCCCC">
                        <th colspan="2">
                            *** Search Results for #setCBCType# #ARGUMENTS.usertype# - #setfirstName# #setLastName# 
                            <cfif VAL(ARGUMENTS.hostID)>
                                (###ARGUMENTS.hostID#)
                            <cfelseif VAL(ARGUMENTS.userID)>
                                (###ARGUMENTS.userID#)
                            </cfif> 
                            ***
                        </th>
                    </tr>
                    
                    <tr><td colspan="2">&nbsp;</td></tr>
                    
                    <!--- USOneValidate --->
					<cfif totalProducts GT 1>                   
                        <tr bgcolor="##CCCCCC"><th colspan="2">US ONE VALIDATE</th></tr>
                        <tr><td colspan="2"><b>SSN Validation & Death Master Index Check for #readXML.bgc.product[1].USOneValidate.order.ssn#</b></td></tr>
                        <tr><td colspan="2">&nbsp; &nbsp; &nbsp; #readXML.bgc.product[1].USOneValidate.response.validation.textResponse#</td></tr>	
                        <tr><td colspan="2">&nbsp; &nbsp; &nbsp; The associated individual is <b> <cfif readXML.bgc.product[1].USOneValidate.response.validation.isDeceased.XmlText EQ 'no'>not</cfif> deceased.</b></td></tr>			
                        <tr><td colspan="2">&nbsp; &nbsp; &nbsp; Issued in <b>#readXML.bgc.product[1].USOneValidate.response.validation.stateIssued#</b> between <b>#readXML.bgc.product[1].USOneValidate.response.validation.yearIssued#</b></td></tr>			
                                                
                        <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                    </cfif>
                                        
                    <!--- USOneSearch --->	
                    <tr bgcolor="##CCCCCC"><th colspan="2"><b>US ONE SEARCH</b></th></tr>
                    <tr><td colspan="2"><b>You searched for:</b></td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>#readXML.bgc.product[usOneSearchID].USOneSearch.order.lastName#, #readXML.bgc.product[usOneSearchID].USOneSearch.order.firstName# #readXML.bgc.product[usOneSearchID].USOneSearch.order.middlename#</b></td></tr>
                    <cfif totalProducts GT 1>    
	                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>SSN : </b> #readXML.bgc.product[1].USOneValidate.order.ssn#</td></tr>
                    </cfif>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>DOB : </b> #readXML.bgc.product[usOneSearchID].USOneSearch.order.dob.month#/#readXML.bgc.product[usOneSearchID].USOneSearch.order.dob.day#/#readXML.bgc.product[usOneSearchID].USOneSearch.order.dob.year#</td></tr>						
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>Report ID : </b> #ReportID#</td></tr>
                    <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>Number of items: </b> #totalItems#<br></td></tr>
                    
                    <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                    
                    <cfif VAL(totalItems)>
                        
                        <!--- ITEMS - OFFENDER --->
                        <cfloop from="1" to ="#totalItems#" index="t">				
                            <cfset totalOffenses = ArrayLen(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.XmlChildren)>
                            <tr>
                                <td><b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].identity.personal.fullName#</b></td>
                                <td>ID ##: #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].record.key.offenderid#</td>
                            </tr>
                            <tr>
                                <td>DOB: #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].identity.personal.dob#</td>
                                <td>GENDER: #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].identity.personal.gender#</td>
                            </tr>
                            <tr><td colspan="2">Total of Offenses: #totalOffenses#<br></td></tr>
                           
                            <tr><td colspan="2"><hr width="100%" align="center"></td></tr>	
                            
                            <!--- OFFENSES --->
                            <cfloop from="1" to ="#totalOffenses#" index="i">
                                <tr><td colspan="2">
                                        <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].description#</b>
                                        (#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].record.provider#, #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].record.key.state#)
                                    </td>
                                </tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                
                                <!--- Disposition --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].disposition.XmlText)>
                                    <tr><td colspan="2">Disposition : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].disposition#</b></td></tr>
                                </cfif>
                                
                                <!--- Degree Of Offense --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].degreeOfOffense.XmlText)>
                                    <tr><td colspan="2">Degree Of Offense : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].degreeOfOffense#</b></td></tr>
                                </cfif>
                                
                                <!--- Sentence --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentence.XmlText)>
                                    <tr><td colspan="2">Sentence : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentence#</b></td></tr>
                                </cfif>
                                
                                <!--- Probation --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].probation.XmlText)>
                                    <tr><td colspan="2">Probation : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].probation#</b></td></tr>
                                </cfif>
                                
                                <!--- Offense --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].confinement.XmlText)>
                                    <tr><td colspan="2">Offense : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].confinement#</b></td></tr>
                                </cfif>
                                
                                <!--- Arresting Agency --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestingAgency.XmlText)>
                                    <tr><td colspan="2">Arresting Agency : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestingAgency#</b></td></tr>
                                </cfif>
                                
                                <!--- Original Agency --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].originatingAgency.XmlText)>
                                    <tr><td colspan="2">Original Agency : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].originatingAgency#</b></td></tr>
                                </cfif>
                                
                                <!--- Jurisdiction --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].jurisdiction.XmlText)>
                                <tr><td colspan="2">Jurisdiction : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].jurisdiction#</b></td></tr>
                                </cfif>
                               
                                <!--- Statute --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].statute.XmlText)>
                                <tr><td colspan="2">Statute : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].statute#</b></td></tr>
                                </cfif>
                                
                                <!--- Plea --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].plea.XmlText)>
                                    <tr><td colspan="2">Plea : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].plea#</b></td></tr>
                                </cfif>
                                
                                <!--- Court Decision --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtDecision.XmlText)>
                                    <tr><td colspan="2">Court Decision : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtDecision#</b></td></tr>
                                </cfif>
                                
                                <!--- Court Costs --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtCosts.XmlText)>
                                    <tr><td colspan="2">Court Costs : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].courtCosts#</b></td></tr>
                                </cfif>
                                
                                <!--- Fine --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fine.XmlText)>
                                    <tr><td colspan="2">Fine : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fine#</b></td></tr>
                                </cfif>
                                
                                <!--- Offense Date --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].offenseDate.XmlText)>
                                <tr><td colspan="2">Offense Date : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].offenseDate#</b></td></tr>
                                </cfif>
                                
                                <!--- Arrest Date --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestDate.XmlText)>
                                    <tr><td colspan="2">Arrest Date : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].arrestDate#</b></td></tr>
                                </cfif>
                                
                                <!--- Sentence Date --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentenceDate.XmlText)>
                                    <tr><td colspan="2">Sentence Date : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].sentenceDate#</b></td></tr>
                                </cfif>
                                
                                <!--- Disposition Date --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].dispositionDate.XmlText)>
                                    <tr><td colspan="2">Disposition Date : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].dispositionDate#</b></td></tr>
                                </cfif>
                                
                                <!--- File Date --->
                                <cfif LEN(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fileDate.XmlText)>
                                <tr><td colspan="2">File Date : <b>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].fileDate#</b></td></tr>
                                </cfif>
                                
                                <tr><td colspan="2">&nbsp;</td></tr>
                                
                                <!--- SPECIFIC INFORMATION --->				
                                <tr><td colspan="2"><i>#readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].record.provider#, #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].record.key.state# SPECIFIC INFORMATION</i></td></tr>
                                <cfset totalSpecifics = ArrayLen(readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.XmlChildren)>
                                <tr>
                                
                                <cfloop from="1" to ="#totalSpecifics#" index="s">
                                    <td>&nbsp; &nbsp; &nbsp; #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.supplement[s].displayTitle# : 
                                        <b> #readXML.bgc.product[usOneSearchID].USOneSearch.response.detail.offenders.offender[t].offenses.offense[i].recorddetails.recorddetail.supplements.supplement[s].displayValue# </b>
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
                    <cfif totalProducts GT 1> 
                    
                        <tr bgcolor="##CCCCCC"><th colspan="2"><b>US ONE TRACE</b></th></tr>
                        <tr><td colspan="2"><b>You searched for:</b></td></tr>
                        <tr><td colspan="2">&nbsp; &nbsp; &nbsp; <b>#readXML.bgc.product[3].USOneTrace.order.lastName#, #readXML.bgc.product[3].USOneTrace.order.firstName#</b></td></tr>
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
                    
                    </cfif>
                    
                    <!--- FOOTER --->
                    <tr><td colspan="2">For more information please visit <a href="www.backgroundchecks.com">www.backgroundchecks.com</a></td></tr>	
                    <tr>
                    	<td colspan="2">
                            *******************************<br>
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
                            *******************************
                    	</td>
	                </tr>
                </table>
                <br><br>
            </cfoutput>

	</cffunction>
    <!--- End of CBC Batch Functions --->

	
    
    <!--- CBC In Compliance --->
	<cffunction name="hostCBCsubmittedUnderUser" access="public" returntype="query" output="false" hint="Cross data to get host CBCs submitted under user">
        <cfargument name="firstName" type="string" hint="firstName is required">
        <cfargument name="lastName" type="string" hint="lastName is required">
        <cfargument name="dob" type="string" hint="dob is required">
        <cfargument name="ssn" type="string" hint="ssn is required">

		<!--- CROSS DATA - check if was submitted under a user --->
        <cfquery name="qHostCBCsubmittedUnderUser" datasource="#application.dsn#">
            SELECT DISTINCT 
            	u.userid, 
                u.firstName, 
                u.lastName, 
                cbc.requestid,
                cbc.date_sent, 
                cbc.date_expired
            FROM 
            	smg_users u
            INNER JOIN 
            	smg_users_cbc cbc ON cbc.userid = u.userid
            LEFT JOIN 
            	smg_seasons ON smg_seasons.seasonid = cbc.seasonid
            WHERE 
            	cbc.familyid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND
                DATE_ADD(cbc.date_sent, INTERVAL 1 Year) >= CURRENT_DATE
                                                   
            <cfif isDate(ARGUMENTS.dob)>
                AND 
                    (
                        (
                        	u.ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.ssn#"> 
                        AND 
                        	u.ssn != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                         ) 
                    OR 
                        (
                            u.firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.firstName#">
                        AND 
                            u.lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.lastName#">				
                        AND 
                            u.dob = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dob#">
                        )
                    )
			<cfelse>
                AND 
                    (
                        (
                        	u.ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.ssn#"> 
                        AND checkHostFamilyCompliance
                        	u.ssn != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                         ) 
                    OR 
                        (
                            u.firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.firstName#">
                        AND 
                            u.lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.lastName#">				
                        )
                    )
            </cfif>                
        </cfquery>
        
        <cfreturn qHostCBCsubmittedUnderUser>
    </cffunction>
    
    
	<cffunction name="checkHostFamilyCompliance" access="public" returntype="string" output="false" hint="Check if a host family CBC and school acceptance is in compliance">
        <cfargument name="hostID" type="numeric" hint="hostID is required">
        <cfargument name="studentID" type="numeric" default="0" hint="studentID is not required">
 
		<cfscript>
			var returnMessage = '';			
			var vMissingMessage = '';
			var vExpiredMessage = '';
			
			// Get School Acceptance Date - Placements can only be approved with a valid CBC and school acceptance
			var vSchoolAcceptanceDate = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=ARGUMENTS.studentID, getActiveRecord=1).doc_school_accept_date;

			// Gets Host Family Information
			qGetHost = APPLICATION.CFC.HOST.getHosts(hostID=ARGUMENTS.hostID);
			
			// Cross Data - Get CBC submitted under USER
			/*
			qGetMotherCBCUnderUser = hostCBCsubmittedUnderUser(
				firstName=qGetHost.motherFirstName,
				lastName=qGetHost.motherLastName,
				dob=qGetHost.motherDOB,
				ssn=qGetHost.motherSSN);

			// Cross Data - Get CBC submitted under USER
			qGetFatherCBCUnderUser = hostCBCsubmittedUnderUser(
				firstName=qGetHost.fatherFirstName,
				lastName=qGetHost.fatherLastName,
				dob=qGetHost.fatherDOB,
				ssn=qGetHost.fatherSSN);
			*/
			
			// Check if CBCs are missing
			qGetCBCMother = getCBCHostByID(hostID=ARGUMENTS.hostID,cbcType='mother', sortBy="date_sent", sortOrder="DESC", getOneRecord=1);
			
			if ( LEN(qGetHost.motherFirstName) AND LEN(qGetHost.motherLastName) AND NOT VAL(qGetCBCMother.recordCount) ) { //  AND NOT VAL(qGetMotherCBCUnderUser.recordCount)
				// Store Missing CBC Message
				vMissingMessage = vMissingMessage & "<p>Missing CBC for host mother</p>";				
			} else if ( LEN(qGetHost.motherFirstName) AND LEN(qGetHost.motherLastName) AND isDate(qGetCBCMother.date_expired) AND qGetCBCMother.date_expired LTE now() ) {
				// Check if CBC is expired   
				vExpiredMessage = vExpiredMessage & "<p>Host Mother - Expired on: #DateFormat(qGetCBCMother.date_expired, 'mm/dd/yyyy')#</p>";
			}
			
			qGetCBCFather = getCBCHostByID(hostID=ARGUMENTS.hostID,cbcType='father', sortBy="date_sent", sortOrder="DESC", getOneRecord=1);
			
			if ( LEN(qGetHost.fatherFirstName) AND LEN(qGetHost.fatherLastName) AND NOT VAL(qGetCBCFather.recordCount) ) { //  AND NOT VAL(qGetFatherCBCUnderUser.recordCount)
				// Store Missing CBC Message
				vMissingMessage = vMissingMessage & "<p>Missing CBC for host father</p>";
			} else if ( LEN(qGetHost.fatherFirstName) AND LEN(qGetHost.fatherLastName) AND isDate(qGetCBCFather.date_expired) AND qGetCBCFather.date_expired LTE now() ) {
				// Check if CBC is expired   
				vExpiredMessage = vExpiredMessage & "<p>Host Father - Expired on: #DateFormat(qGetCBCFather.date_expired, 'mm/dd/yyyy')#</p>";				
			}

			// Get Eligible Family Member CBC
			qGetEligibleMembers = getEligibleHostMember(hostID=ARGUMENTS.hostID, studentID=ARGUMENTS.studentID);
			
			// Loop through eligible member query
            For ( i=1; i LTE qGetEligibleMembers.recordCount; i=i+1 ) {

				// Gets Host Member CBC
				qGetCBCMember = getCBCHostByID(
					hostID=ARGUMENTS.hostID,
					familyMemberID=qGetEligibleMembers.childID[i],
					cbcType='member',
					sortBy="date_sent", 
					sortOrder="DESC",
					getOneRecord=1
				);		
				
				if ( NOT VAL(qGetCBCMember.recordCount) ) {
					// Store Missing CBC Message
					vMissingMessage = vMissingMessage & "<p>Missing CBC for host member #qGetEligibleMembers.name[i]# #qGetEligibleMembers.lastName[i]#</p>";
				} else if ( isDate(qGetCBCMember.date_expired) AND qGetCBCMember.date_expired LTE now() ) {
					// Check if CBC is expired   
					vExpiredMessage = vExpiredMessage & "<p>Host Member - Expired on: #DateFormat(qGetCBCMember.date_expired, 'mm/dd/yyyy')#</p>";
				}
				
            }
        </cfscript>

		<cfif LEN(vMissingMessage) OR LEN(vExpiredMessage)>
        
            <cfsavecontent variable="returnMessage">
                <cfoutput>
                
                    <div style="color:##F00">
                    
                        <p>You can only approve a placement when CBCs and School Acceptance are compliant. Please see below:</p>
                        
                        <!--- Display Missing CBC --->
                        #vMissingMessage#
                        
                        <!--- Display Expired CBC --->
                        #vExpiredMessage#

                        <cfif NOT IsDate(vSchoolAcceptanceDate)>
                            <p>Missing School Acceptance Form</p>
                        </cfif>
                        
                    </div>
                    
                </cfoutput>                    
            </cfsavecontent>
        
        </cfif>

		<cfreturn returnMessage>        
	</cffunction>    
    <!--- End of CBC In Compliance --->

	
    <!--- CBC Re-Run Functions --->
	<cffunction name="getExpiredUserCBC" access="public" returntype="query" output="false" hint="Return expires CBC for users">
        <cfargument name="cbcType" type="string" hint="cbcType is required. User or member">
        
		<cfscript>
			// Set Last Login
			var lastLogin = DateFormat(DateAdd('yyyy', -1, now()),'yyyy-mm-dd');
        </cfscript>
    	      
        <cfquery 
        	name="qGetExpiredUserCBC" 
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                    cbc.userID,
                    cbc.familyID,
                    cbc.companyID,
                    cbc.date_authorized,
                    cbc.date_sent,
                    DATE_ADD(cbc.date_sent, INTERVAL 11 MONTH) AS renewal_date,
                    cbc.seasonID AS seasonID,
                    u.firstName,
                    u.lastName,
                    u.lastLogin
                FROM 
                    smg_users_cbc cbc 
                INNER JOIN 
                    smg_users u ON u.userID = cbc.userID 
                    	AND u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        AND u.dateCancelled IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                        AND u.lastLogin >= <cfqueryparam cfsqltype="cf_sql_date" value="#lastLogin#">
                WHERE 
					<!--- Get Latest Record --->
                    cbc.date_sent = 
                    (
                        SELECT 
                            MAX(getMaxDate.date_sent) 
                        FROM 
                            smg_users_cbc getMaxDate
                        WHERE                                                
                            getMaxDate.userID = cbc.userID                                                                                                       
                    )  
                AND
					cbc.userID NOT IN 
                    ( 
                    	SELECT 
                        	userID 
                        FROM 
                        	smg_users_cbc 
                        WHERE 
                        	date_sent IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
						<cfif ARGUMENTS.cbcType EQ 'user'>
                            AND
                                cbc.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        <cfelseif ARGUMENTS.cbcType EQ 'member'>
                            AND
                                cbc.familyID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        </cfif>
                    )   

				<cfif ARGUMENTS.cbcType EQ 'user'>
                	AND
                    	cbc.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                <cfelseif ARGUMENTS.cbcType EQ 'member'>
                	AND
                    	cbc.familyID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfif>
                
                <!--- Copied CBCs have a comment on notes field --->
                AND 
                    cbc.notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                    
                GROUP BY         
                    cbc.userID                
                
                HAVING
                	 renewal_date <= CURRENT_DATE 
                                
                UNION
                
                <!--- Get Supervising Representative Assigned to an Active Student --->
                SELECT DISTINCT 
                    cbc.userID,
                    cbc.familyID,
                    cbc.companyID,
                    cbc.date_authorized,
                    cbc.date_sent,
                    DATE_ADD(cbc.date_sent, INTERVAL 11 MONTH) AS renewal_date,
                    cbc.seasonID AS seasonID,
                    u.firstName,
                    u.lastName,
                    u.lastLogin
                FROM 
                    smg_users_cbc cbc 
                INNER JOIN 
                    smg_users u ON u.userID = cbc.userID 
                    	AND u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        AND u.dateCancelled IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                INNER JOIN
                	smg_students s ON s.areaRepID = cbc.userID
                    	AND	
                        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                WHERE 
					<!--- Get Latest Record --->
                    cbc.date_sent = 
                    (
                        SELECT 
                            MAX(getMaxDate.date_sent) 
                        FROM 
                            smg_users_cbc getMaxDate
                        WHERE                                                
                            getMaxDate.userID = cbc.userID                                                                                                       
                    )  
				AND                                    
					cbc.userID NOT IN 
                    ( 
                    	SELECT 
                        	userID 
                        FROM 
                        	smg_users_cbc 
                        WHERE 
                        	date_sent IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
						<cfif ARGUMENTS.cbcType EQ 'user'>
                            AND
                                cbc.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        <cfelseif ARGUMENTS.cbcType EQ 'member'>
                            AND
                                cbc.familyID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        </cfif>
                    )   

				<cfif ARGUMENTS.cbcType EQ 'user'>
                	AND
                    	cbc.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                <cfelseif ARGUMENTS.cbcType EQ 'member'>
                	AND
                    	cbc.familyID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfif>
                
                <!--- Copied CBCs have a comment on notes field --->
                AND 
                    cbc.notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                    
                GROUP BY         
                    cbc.userID                
                
                HAVING
                	 renewal_date <= CURRENT_DATE 

                UNION
                
                <!--- Get Placing Representative Assigned to an Active Student --->
                SELECT DISTINCT 
                    cbc.userID,
                    cbc.familyID,
                    cbc.companyID,
                    cbc.date_authorized,
                    cbc.date_sent,
                    DATE_ADD(cbc.date_sent, INTERVAL 11 MONTH) AS renewal_date,
                    cbc.seasonID AS seasonID,
                    u.firstName,
                    u.lastName,
                    u.lastLogin
                FROM 
                    smg_users_cbc cbc 
                INNER JOIN 
                    smg_users u ON u.userID = cbc.userID 
                    	AND u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        AND u.dateCancelled IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                INNER JOIN
                	smg_students s ON s.placeRepID = cbc.userID
                    	AND	
                        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                WHERE 
					<!--- Get Latest Record --->
                    cbc.date_sent = 
                    (
                        SELECT 
                            MAX(getMaxDate.date_sent) 
                        FROM 
                            smg_users_cbc getMaxDate
                        WHERE            
                        	<cfif ARGUMENTS.cbcType EQ 'user'>                                    
                            	getMaxDate.userID = cbc.userID
                            <cfelseif ARGUMENTS.cbcType EQ 'member'>
                            	getMaxDate.familyID = cbc.familyID
                            </cfif>                                                                                                       
                    )  
				AND                                    
					cbc.userID NOT IN 
                    ( 
                    	SELECT 
                        	userID 
                        FROM 
                        	smg_users_cbc 
                        WHERE 
                        	date_sent IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
						<cfif ARGUMENTS.cbcType EQ 'user'>
                            AND
                                cbc.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        <cfelseif ARGUMENTS.cbcType EQ 'member'>
                            AND
                                cbc.familyID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        </cfif>
                    )   

				<cfif ARGUMENTS.cbcType EQ 'user'>
                	AND
                    	cbc.familyID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                <cfelseif ARGUMENTS.cbcType EQ 'member'>
                	AND
                    	cbc.familyID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfif>
                
                <!--- Copied CBCs have a comment on notes field --->
                AND 
                    cbc.notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                    
                GROUP BY         
                    cbc.userID                
                
                HAVING
                	 renewal_date <= CURRENT_DATE 
                
                ORDER BY                     
                    date_sent
        </cfquery>
		
    	<cfreturn qGetExpiredUserCBC>
    </cffunction>    
    

	<cffunction name="getExpiredHostCBC" access="public" returntype="query" output="false" hint="Return expires CBC for users">
        <cfargument name="cbcType" type="string" hint="cbcType is required. Father/Mother/Member">
        <cfargument name="isUpcomingProgram" type="numeric" default="0" hint="Set to 1 to run this query and search host families hosting upcoming students">
        <cfargument name="hostID" type="numeric" default="0" hint="Pass hostID to check if there are CBCs expired">
        <cfargument name="studentID" type="numeric" default="0" hint="Pass studentID to check if there are CBCs expired">
        
        <cfscript>
			var vUpcomingProgramList = '';
			
			// Get Upcoming Programs
			if ( VAL(ARGUMENTS.isUpcomingProgram) ) {
				qGetUpcomingPrograms = APPLICATION.CFC.PROGRAM.getPrograms(isUpcomingProgram=1);
				
				vUpcomingProgramList = ValueList(qGetUpcomingPrograms.programID);
			}
		</cfscript>
        
        <cfquery 
        	name="qGetExpiredHostCBC" 
        	datasource="#APPLICATION.dsn#">
                SELECT DISTINCT 
                    cbc.hostID,
                    cbc.familyID,
                    cbc.cbc_type,
                    h.companyID,
                    cbc.date_authorized,
                    cbc.date_sent,
                    DATE_ADD(cbc.date_sent, INTERVAL 11 MONTH) AS renewal_date,
					cbc.date_expired,
                    cbc.seasonID AS seasonID,
                    h.familylastname,
                    p.programName,
                    p.startDate,
                    p.endDate,
                    IFNULL( 
                    		(
                                SELECT 
                                    MAX(dep_date) 
                                FROM 
                                    smg_flight_info 
                                WHERE 
                                    studentID = s.studentID 
                                AND 
                                	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure"> 
                                AND
                                	programID = p.programID
                                AND 
                                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                             ), p.endDate
							) AS studentDepartureDate
                FROM 
                   	smg_hosts_cbc cbc 
                INNER JOIN 
                    smg_hosts h ON h.hostid = cbc.hostid
                INNER JOIN 
                    smg_students s ON s.hostid = cbc.hostid 
                    	AND 
                        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
                        AND 
                        	s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
						
						<cfif VAL(ARGUMENTS.studentID)>
                        	<!--- Check For a Student Before Approving a placement --->
							AND
                            	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">                     
                        <cfelse>
                            <!--- Placement Approved --->
                            AND
                                s.host_fam_Approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
						</cfif>

						<!--- Get Upcoming Students --->
						<cfif VAL(ARGUMENTS.isUpcomingProgram)>
							AND
                            	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vUpcomingProgramList#" list="yes"> )                        
                        </cfif>
                        
                INNER JOIN	
                	smg_programs p ON p.programID = s.programID 
                        AND 
                        	p.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
						AND
                        	p.endDate > CURRENT_DATE
                
                <!--- Get Only Members that live at home --->
                <cfif ARGUMENTS.cbcType EQ 'member'>
                	INNER JOIN
                    	smg_host_children shc ON shc.hostID = cbc.hostID
                        	AND
                            	shc.childID = cbc.familyID 
                			AND
                            	shc.liveAtHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                            AND	
                            	shc.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                </cfif>
                
                WHERE 
					<!--- Get Latest Record --->
                    cbc.date_sent = 
                    (
                        SELECT 
                            MAX(getMaxDate.date_sent) 
                        FROM 
                            smg_hosts_cbc getMaxDate
                        WHERE                                                
                            getMaxDate.hostID = cbc.hostID
                        AND
                        	getMaxDate.familyID = cbc.familyID                            
                        AND	
                            getMaxDate.cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cbcType#">                                                                                                      
                    )  
				AND                                
                    cbc.hostID NOT IN 
                    ( 
                    	SELECT 
                        	hostID 
                        FROM 
                        	smg_hosts_cbc 
                        WHERE 
                        	familyID = cbc.familyID 
                        AND                        
                        	date_sent IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">  
                        AND
                            cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cbcType#">
                              
                    )   
                
                <cfif VAL(ARGUMENTS.hostID)>
                	AND
                    	h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
                </cfif>
                
                <cfif ARGUMENTS.cbcType EQ 'father'>
                	AND
                    	h.fatherFirstName != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
					AND
                    	h.fatherLastName != <cfqueryparam cfsqltype="cf_sql_varchar" value="">      
                <cfelseif ARGUMENTS.cbcType EQ 'mother'>
                	AND
                    	h.motherFirstName != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
					AND
                    	h.motherLastName != <cfqueryparam cfsqltype="cf_sql_varchar" value="">      
                </cfif>
                
                <!--- Copied CBCs have a comment on notes field --->
                AND 
                    cbc.notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="">

                AND
                    cbc.cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.cbcType#">
                
                GROUP BY 
                    cbc.hostid	
                
                HAVING
                	renewal_date <= CURRENT_DATE 
				AND                
                    date_expired <= p.endDate
                AND	
					date_expired <= studentDepartureDate 
                
                ORDER BY 
                    p.endDate DESC,
                    date_sent 
        </cfquery>
		
    	<cfreturn qGetExpiredHostCBC>
    </cffunction>        
    <!--- CBC Re-Run Functions --->

                    
</cfcomponent>    