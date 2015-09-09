<!--- ------------------------------------------------------------------------- ----
	
	File:		host.cfc
	Author:		Marcus Melo
	Date:		October, 09 2009
	Desc:		This holds the functions needed for the host families
	
	Update: 
	
----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="host"
	output="false" 
	hint="A collection of functions for the host family">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="host" output="false" hint="Returns the initialized Host object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getHosts" access="public" returntype="query" output="false" hint="Gets a list with hosts, if HostID is passed gets a Host by ID">
    	<cfargument name="hostID" default="" hint="HostID is not required">
        
        <cfquery 
			name="qGetHosts" 
			datasource="#APPLICATION.dsn#">
                SELECT
                	*       
                FROM 
                    smg_hosts
                WHERE
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                 
                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>

                ORDER BY 
                    familyLastName
		</cfquery>
		   
		<cfreturn qGetHosts>
	</cffunction>


	<cffunction name="getHostMemberByID" access="public" returntype="query" output="false" hint="Gets a host member by ID">
    	<cfargument name="childID" default="" hint="Child ID is not required">
        <cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="liveAtHome" default="" hint="liveAtHome is not required">
        <cfargument name="getAllMembers" default="0" hint="Returns all family members including deleted">
        
        <cfquery 
			name="qGetHostMemberByID" 
			datasource="#APPLICATION.dsn#">
                SELECT
					childID,
                    hostID,
                    memberType,
                    birthDate,
                    sex,
                    liveAtHome,
                    name,
                    middleName,
                    lastName,
                    SSN,
                    school,
                    shared,
                    roomShareWith
                FROM 
                    smg_host_children
                WHERE
                	1 = 1
                
                <cfif NOT VAL(ARGUMENTS.getAllMembers)>    
                    AND
	                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">    
                </cfif>
                
                <cfif LEN(ARGUMENTS.childID)>
                    AND
                        childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.childID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>

                <cfif LEN(ARGUMENTS.liveAtHome)>
                    AND
                        liveAtHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.liveAtHome#">
                </cfif>
				
		</cfquery>
		   
		<cfreturn qGetHostMemberByID>
	</cffunction>


	<cffunction name="getHostPets" access="public" returntype="query" output="false" hint="Gets a host pets by ID">
    	<cfargument name="animalID" default="" hint="Child ID is not required">
        <cfargument name="hostID" default="" hint="HostID is not required">
        
        <cfquery 
			name="qGetHostPets" 
			datasource="#APPLICATION.dsn#">
                SELECT
					animalID,
                    hostID,
                    animalType,
                    number,
                    indoor
                FROM 
                    smg_host_animals
                WHERE
                	1 = 1
                
                <cfif LEN(ARGUMENTS.animalID)>
                    AND
                        animalID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.animalID)#">
                </cfif>
                
                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>

		</cfquery>
		   
		<cfreturn qGetHostPets>
	</cffunction>


	<cffunction name="displayHostFamilyName" access="public" returntype="string" output="false" hint="Displays Host Family Information (father/mother)">
        <cfargument name="hostID" default="0" hint="hostID">
    	<cfargument name="fatherFirstName" default="" hint="fatherFirstName">
        <cfargument name="fatherLastName" default="" hint="fatherLastName">
        <cfargument name="motherFirstName" default="" hint="motherFirstName">
        <cfargument name="motherLastName" default="" hint="motherLastName">
        <cfargument name="familyLastName" default="" hint="familyLastName">

		<cfscript>
			// Declare Variables		
			vReturnName = '';
			
			if ( LEN(ARGUMENTS.fatherFirstName) ) {
				
				vReturnName = vReturnName & ' ' & ARGUMENTS.fatherFirstName;
				
				if ( ARGUMENTS.fatherLastName NEQ ARGUMENTS.familyLastName ) {
					vReturnName = vReturnName & ' ' & ARGUMENTS.fatherLastName;
				}
				
			}
			
			if ( LEN(ARGUMENTS.fatherFirstName) AND LEN(ARGUMENTS.motherFirstName) ) {
				vReturnName = vReturnName & ' and ';
			}
            
			if ( LEN(ARGUMENTS.motherFirstName) ) {
				
				vReturnName = vReturnName & ' ' & ARGUMENTS.motherFirstName;
				
				if ( ARGUMENTS.motherLastName NEQ ARGUMENTS.familyLastName ) {
					vReturnName = vReturnName & ' ' & ARGUMENTS.motherLastName;
				}
				
			}

			if ( ARGUMENTS.motherLastName EQ ARGUMENTS.familyLastName OR  ARGUMENTS.fatherLastName EQ ARGUMENTS.familyLastName ) {
				vReturnName = vReturnName & ' ' & ARGUMENTS.familyLastName;
			}

            if ( VAL(ARGUMENTS.hostID) ) {
				vReturnName = vReturnName & ' (##' & ARGUMENTS.hostID & ')';
			}
			
			// Return Encrypted Variable
			return(vReturnName);
        </cfscript>
		   
	</cffunction>
    
    <!--- ------------------------------------------------------------------------- ----
		
		CBC FUNCTIONS
	
	----- ------------------------------------------------------------------------- --->
    
    <cffunction name="getHostChildrenForCBC" access="public" returntype="query" output="no" hint="Gets the given host family's children">
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
                        FLOOR(DATEDIFF(CURRENT_DATE,birthdate)/365) AS age
                    FROM 
                        smg_host_children 
                    WHERE 
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                    AND
                    	liveAtHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">                    
                    AND
                    	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
					<cfif IsDate(qGetProgramInfo.endDate)> 
                        <!--- Get only students that are turning 18 by the end of the program --->
                        AND 
                            FLOOR(DATEDIFF("#DateFormat( DateAdd("d", 0, qGetProgramInfo.endDate), 'yyyy-mm-dd')#", birthdate)/365.25) >= <cfqueryparam cfsqltype="cf_sql_integer" value="18">
                    <cfelse>                    
                        AND 
                            FLOOR(DATEDIFF(CURRENT_DATE, birthdate)/365) >= <cfqueryparam cfsqltype="cf_sql_integer" value="17">
                    </cfif>
                    
                    ORDER BY 
                        childID
            </cfquery>
        <cfreturn qGetEligibleHostMember>
    </cffunction>
    
    <cffunction name="getCBC" access="public" returntype="query" output="no" hint="Gets the cbc records associated with the given host and member">
    	<cfargument name="hostID" type="numeric" hint="hostID is required">
        <cfargument name="memberType" type="string" hint="memberType is required, valid values are: 'father','mother','member'">
        <cfargument name="childID" type="numeric" default="0" hint="childID is not required, though it is neccessary when the memberType is 'member'">
        <cfargument name="isNotExpired" type="boolean" default="false" hint="isNotExpired is not required (if set to true it will only return records that have not yet expired AND are approved)">
        <cfargument name="studentID" default="0" hint="studentID is not required, pass to get only members that will not turn 18 during the program">
        
        <cfscript>
                // Get Student Program End Date - Remove 5 days from program end date to compensate for leap/bissextile year
                qGetProgramInfo = APPLICATION.CFC.PROGRAM.getProgramByStudentID(studentID=ARGUMENTS.studentID);
			</cfscript>
        <cfif memberType NEQ "member">
        	<cfquery name="qGetCBC" datasource="#APPLICATION.DSN#">
            	SELECT
                    h.hostID,
                    h.familyLastName,
                    h.fatherFirstName,
                    h.fatherMiddleName,               
                    h.fatherSSN,               
                    h.fatherDOB,
                  	h.motherFirstName,
                	h.motherMiddleName,               
                	h.motherSSN,               
                	h.motherDOB,
                    cbc.*
          		FROM smg_hosts h
            	INNER JOIN php_hosts_cbc cbc ON cbc.hostID = h.hostID
            		AND cbc.cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.memberType#">
             	WHERE h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                <cfif ARGUMENTS.isNotExpired>
                	AND cbc.date_expired > NOW()
                    AND cbc.date_approved IS NOT NULL
                </cfif>
                ORDER BY date_sent DESC
            </cfquery>
            <cfreturn qGetCBC>
        <cfelse>
        	<cfquery name="qGetChildCBC" datasource="#APPLICATION.DSN#">
            	SELECT
                	c.*,
                    cbc.*
              	FROM smg_host_children c
                INNER JOIN php_hosts_cbc cbc ON cbc.hostID = c.hostID
                    AND cbc.cbc_type = "member"
                    AND cbc.familyid = c.childID
               	WHERE c.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                AND c.childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.childID)#">
                <cfif IsDate(qGetProgramInfo.endDate)> 
                        <!--- Get only students that are turning 18 by the end of the program --->
                        AND 
                            FLOOR(DATEDIFF("#DateFormat( DateAdd("d", 0, qGetProgramInfo.endDate), 'yyyy-mm-dd')#", birthdate)/365.25) >= <cfqueryparam cfsqltype="cf_sql_integer" value="18">
                    <cfelse>                    
                        AND 
                            FLOOR(DATEDIFF(CURRENT_DATE, birthdate)/365) >= <cfqueryparam cfsqltype="cf_sql_integer" value="17">
                    </cfif>
                <cfif ARGUMENTS.isNotExpired>
                	AND cbc.date_expired > NOW()
                    AND cbc.date_approved IS NOT NULL
                </cfif>
                ORDER BY date_sent DESC
            </cfquery>
            <cfreturn qGetChildCBC>
        </cfif>
    </cffunction>
    
    <cffunction name="setCBC" access="public" returntype="void" output="no" hint="inserts or updates a host cbc record">
    	<cfargument name="date_submitted" type="string" hint="date_submitted is required">
        <cfargument name="hostID" type="numeric" default="0" hint="hostID is not required (but it is neccessary when adding)">
        <cfargument name="memberType" type="string" default="" hint="memberType is not required (but it is neccessary when adding)">
        <cfargument name="childID" type="numeric" default="0" hint="childID is not required (but is neccessary if adding memberType 'member')">
        <cfargument name="date_authorization" type="string" default="" hint="date_authorization is not required">
        <cfargument name="date_approved" type="string" default="" hint="date_approved is not required">
        <cfargument name="notes" type="string" default="" hint="notes is not required">
        <cfargument name="id" type="numeric" default="0" hint="id is not required (if this equals 0 it will insert, otherwise it will attempt to update that record)">
        
        <cfif VAL(ARGUMENTS.id)>
       		<cfquery datasource="#APPLICATION.DSN#">
            	UPDATE 
                	php_hosts_cbc
                SET
                    notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.notes#">,
                   
                    date_approved = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date_approved#" null="#NOT IsDate(ARGUMENTS.date_approved)#">
              	WHERE
                	cbcfamid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.id)#">
            </cfquery>
         </cfif>
    </cffunction>
    
    <cffunction name="isCBCValid" access="public" returntype="boolean" output="no" hint="Checks if all family members who need a CBC have a valid CBC (returns true if they do, false otherwise)">
    	<cfargument name="hostID" type="numeric" hint="hostID is required">

        <cfquery name="qGetFather" datasource="#APPLICATION.DSN#">
        	SELECT *
            FROM smg_hosts
            WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
            AND (fatherFirstName IS NOT NULL OR fatherLastName IS NOT NULL OR fatherSSN IS NOT NULL)
            AND fatherLastName != 'deceased'
        </cfquery>
        <cfquery name="qGetMother" datasource="#APPLICATION.DSN#">
        	SELECT *
            FROM smg_hosts
            WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
            AND (motherFirstName IS NOT NULL OR motherLastName IS NOT NULL OR motherSSN IS NOT NULL)
            AND motherLastName != 'deceased'
        </cfquery>
        
        <cfset valid = true>
        <cfscript>
			qGetChildren = getHostChildrenForCBC(hostID = #ARGUMENTS.hostID#);
			if (VAL(qGetFather.recordCount)) {
				if (NOT VAL(getCBC(hostID = #ARGUMENTS.hostID#, memberType = "father", isNotExpired = true).recordCount)) {
					valid = false;	
				}
			}
			if (VAL(qGetMother.recordCount)) {
				if (NOT VAL(getCBC(hostID = #ARGUMENTS.hostID#, memberType = "mother", isNotExpired = true).recordCount)) {
					valid = false;	
				}
			}
		</cfscript>
        <cfloop query="qGetChildren">
        	<cfscript>
				if (NOT VAL(getCBC(hostID = #ARGUMENTS.hostID#, memberType = "member", childID = #qGetChildren.childID#, isNotExpired = true).recordCount)) {
					valid = false;	
				}
			</cfscript>
        </cfloop>
        <cfreturn valid>
    </cffunction>
    
    <!--- ------------------------------------------------------------------------- ----
		
		END CBC FUNCTIONS
	
	----- ------------------------------------------------------------------------- --->


	<!--- ------------------------------------------------------------------------- ----
		
		REMOTE FUNCTIONS
	
	----- ------------------------------------------------------------------------- --->
    
    <!--- Start of Auto Suggest --->
    <cffunction name="lookupHostFamily" access="remote" returntype="string" output="false" hint="Remote function to get host families">
        <cfargument name="search" type="string" default="" hint="Search is not required">
        <cfargument name="validCBC" type="boolean" default="false" hint="validCBC is not required (if set to true will only return hosts who meet the CBC requirements)">
        
        <!--- Do search --->
        <cfquery 
			name="qLookupHostFamily" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	hostID,
					CAST( 
                    	CONCAT(                      
                            familyLastName,
                            ' - ', 
                            IFNULL(fatherFirstName, ''),                                                  
                            IF (fatherFirstName != '', IF (motherFirstName != '', ' and ', ''), ''),
                            IFNULL(motherFirstName, ''),
                            ' (##',
                            hostID,
                            ')'                    
						) 
					AS CHAR) AS displayHostFamily
                FROM 
                	smg_hosts
                WHERE 
                	 active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
              	AND                    
                    familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.search#%">
                ORDER BY 
                    familyLastName
        </cfquery>
        
        <cfif ARGUMENTS.validCBC>
        	<cfset list = "">
        	<cfloop query="qLookupHostFamily">
            	<cfscript>
					if (isCBCValid(hostID = #hostID#)) {
						list = list & #displayHostFamily# & ",";
					}
				</cfscript>
            </cfloop>
            <cfreturn list>
        <cfelse>
			<cfscript>
                return ValueList(qLookupHostFamily.displayHostFamily);		
            </cfscript>
      	</cfif>
        
    </cffunction>


	<cffunction name="getHostByName" access="remote" returntype="string">
        <cfargument name="search" type="string" default="" hint="Search is not required">
        
        <cfscript>
			var vhostID = 0;
		</cfscript>
        
        <cfif LEN(ARGUMENTS.search)>
        
            <cfquery 
                name="qGetHostByName" 
                datasource="#APPLICATION.dsn#">
                    SELECT
                        hostID
                    FROM
                        smg_hosts		
                    WHERE 
                        active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    AND 
                        CAST( 
                            CONCAT(                      
                                familyLastName,
                                ' - ', 
                                IFNULL(fatherFirstName, ''),                                                  
                                IF (fatherFirstName != '', IF (motherFirstName != '', ' and ', ''), ''),
                                IFNULL(motherFirstName, ''),
                                ' (##',
                                hostID,
                                ')'                    
                            ) 
                        AS CHAR) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.search)#">
                    ORDER BY
                        familyLastName
                    LIMIT
                    	1
            </cfquery>

			<cfscript>
                vhostID = ValueList(qGetHostByName.hostID);
            </cfscript>

        </cfif>

		<cfscript>
            return vhostID;
        </cfscript>
        
	</cffunction>
	<!--- End of Auto Suggest --->
    

	<!--- ------------------------------------------------------------------------- ----
		
		END OF REMOTE FUNCTIONS
	
	----- ------------------------------------------------------------------------- --->

</cfcomponent>