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
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="host" output="false" hint="Returns the initialized Host object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getHosts" access="public" returntype="query" output="false" hint="Gets a list with hosts, if HostID is passed gets a Host by ID">
    	<cfargument name="hostID" default="" hint="HostID is not required">
        <cfargument name="regionID" default="" hint="regionID is not required">
        
        <cfquery 
			name="qGetHosts" 
			datasource="#APPLICATION.dsn#">
                SELECT
                	hostID,
                    uniqueID,
                    familyLastName,
                    fatherLastName,
                    fatherFirstName,
                    fatherMiddleName,
                    fatherBirth,
                    fatherDOB,
                    fatherSSN,
                    father_cell,
                    fatherCBC_form,
                    fatherDriver,
                    fatherCompany,
                    fatherWorkPhone,
                    fatherWorkPosition,
                    fatherfullpart,
                    fatherWorkType,
                    motherLastName,
                    motherFirstName,
                    motherMiddleName,
                    motherBirth,
                    motherDOB,
                    motherSSN,
                    mother_cell,
                    motherCBC_form,
                    motherDriver,
                    motherCompany,
                    motherWorkPhone,
                    motherWorkPosition,
                    motherfullpart,
                    motherWorkType,
                    address,
                    address2,
                    city,
                    state,
                    zip,
                    datesOfResidence,
                    mailAddress,
                    mailCity,
                    mailState,
                    mailZip,
                    phone,
                    fax,
                    email,
                    emergency_contact_name,
                    emergency_phone,
                    yrsAtAddress,
                    regionID,
                    schoolID,
                    schoolCosts,
                    schoolDistance,
                    schoolTransportation,
                    schoolTransportationOther,
                    schoolWorks,
                    schoolWorksExpl,
                    schoolCoach,
                    schoolCoachExpl,
                    cityPopulation,
                    communityType,
                    nearBigCity,
                    bigCityDistance,
                    local_air_code,
                    major_air_code,
                    airport_city,
                    airport_state,
                    sexPref,
                    hostSmokes,
                    acceptSmoking,
                    smokeConditions,
                    famDietRest,
                    famDietRestDesc,
                    stuDietRest,
                    stuDietRestDesc,
                    threesquares,
                    areaRepID,
                    active,
                    dateProcessed,
                    current_state,
                    approved,
                    interests,
                    interests_other,
                    band,
                    playBand,
                    bandInstrument,
                    orchestra,
                    playOrchestra,
                    OrcInstrument,
                    playCompSports,
                    comp_sports,
                    sportDesc,
                    pet_allergies,
                    religion,
                    churchID,
                    religious_participation,
                    churchFam,
                    churchTrans,
                    attendChurch,
                    houserules_smoke,
                    houserules_curfewWeekNights,
                    houserules_curfewWeekends,
                    houserules_chores,
                    houserules_church,
                    houserules_other,
                    population,
                    near_city,
                    near_city_dist,
                    near_pop,
                    neighborhood,
                    community,
                    terrain1,
                    terrain2,
                    terrain3,
                    terrain3_desc,
                    winterTemp,
                    summerTemp,
                    snowy_winter,
                    rainy_winter,
                    hot_summer,
                    mild_summer,
                    high_hummidity,
                    dry_air,
                    special_cloths,
                    point_interest,
                    income,
                    publicAssitance,
                    crime,
                    crimeExpl,
                    cps,
                    cpsexpl,
                    school_trans,
                    other_trans,
                    familyLetter,
                    pictures,
                    applicationSent,
                    applicationApproved,
                    applicationStarted,
                    previousHost,
                    home_first_call,
                    home_last_visit,
                    home_visited,
                    pert_info,
                    companyID,
                    host_start_date,
                    host_end_date,
                    studentHosting,
                    imported         
                FROM 
                    smg_hosts
                WHERE
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                 
                <cfif LEN(ARGUMENTS.hostID)>
                    AND
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">
                </cfif>

                <cfif LEN(ARGUMENTS.regionID)>
                    AND
                        regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                </cfif>
                    
                ORDER BY 
                    familyLastName
		</cfquery>
		   
		<cfreturn qGetHosts>
	</cffunction>


	<!--- Start of Auto Suggest --->
    <cffunction name="lookupHostFamily" access="remote" returntype="string" output="false" hint="Remote function to get host families">
        <cfargument name="search" type="string" default="" hint="Search is not required">
        <cfargument name="regionID" default="" hint="regionID is not required">
        
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

                <cfif LEN(ARGUMENTS.regionID)>
                    AND
                        regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                </cfif>
				
                AND                    
                    familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.search#%">
                
                ORDER BY 
                    familyLastName
        </cfquery>
        
        <cfscript>
			return ValueList(qLookupHostFamily.displayHostFamily);		
        </cfscript>

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
		
		PLACEMENT PAPERWORK
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="updateHostPlacementPaperwork" access="public" returntype="void" output="false" hint="Update Placement Paperwork">
        <cfargument name="hostID" default="0" hint="hostID is not required">
        <cfargument name="fathercbc_form" default="" hint="fathercbc_form is not required">
        <cfargument name="mothercbc_form" default="" hint="mothercbc_form is not required">

        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE
	                smg_hosts
                SET 
                    fathercbc_form = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.fathercbc_form#" null="#NOT IsDate(ARGUMENTS.fathercbc_form)#">,
                    mothercbc_form = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.mothercbc_form#" null="#NOT IsDate(ARGUMENTS.mothercbc_form)#">
                WHERE 
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">                    	
		</cfquery>

	</cffunction>
    
    
	<cffunction name="updateMemberPlacementPaperwork" access="public" returntype="void" output="false" hint="Update Placement Paperwork">
        <cfargument name="childID" default="0" hint="hostID is not required">
        <cfargument name="hostID" default="0" hint="hostID is not required">
        <cfargument name="memberID" default="0" hint="memberID is not required">
        <cfargument name="cbc_form_received" default="" hint="cbc_form_received is not required">

        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE
	                smg_host_children
                SET 
                    cbc_form_received = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.cbc_form_received#" null="#NOT IsDate(ARGUMENTS.cbc_form_received)#">
                WHERE 
                    childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.childID)#">  
                AND
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.hostID)#">                    	
		</cfquery>

	</cffunction>
    
	<!--- ------------------------------------------------------------------------- ----
		
		END OF PLACEMENT PAPERWORK
	
	----- ------------------------------------------------------------------------- --->


	<cffunction name="getHostStateListByRegionID" access="public" returntype="string" output="false" hint="Returns a list of host family states assigned to a region">
    	<cfargument name="regionID" type="numeric" hint="userID is required">

        <cfquery 
			name="qGetHostStateListByRegionID" 
			datasource="#APPLICATION.DSN#">
                SELECT
					state
                FROM 
                    smg_hosts
                WHERE	
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">
                AND
                	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                GROUP BY
                	state
                ORDER BY
                	state
		</cfquery>
		
        <cfscript>
			var vReturnState = ValueList(qGetHostStateListByRegionID.state);			
			
			// Return List
			return vReturnState;
		</cfscript>
           
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
                    cbc_form_received,
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
		
		HOST LEADS
	
	----- ------------------------------------------------------------------------- --->

	<cffunction name="getHostLeads" access="public" returntype="query" output="false" hint="Gets host leads entered from ISEUSA.com">
        <cfargument name="sortBy" type="string" default="dateCreated" hint="sortBy is not required">
        <cfargument name="sortOrder" type="string" default="ASC" hint="sortOrder is not required">
        <cfargument name="isDeleted" type="string" default="0" hint="isDeleted is not required">
        
        <cfquery 
			name="qGetHostLeads" 
			datasource="#APPLICATION.dsn#">
                SELECT
					hl.ID,
                    hl.regionID,
                    hl.areaRepID,
                    hl.statusID,
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.stateID,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    hl.dateCreated,
                    hl.dateUpdated,
                    r.regionName AS regionAssigned,
                    CONCAT(u.firstName, ' ', u.lastName) AS areaRepAssigned,
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
						AND
                        	alk.applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CONSTANTS.type.hostFamilyLead#">
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.isDeleted#">

                ORDER BY
                
                <cfswitch expression="#ARGUMENTS.sortBy#">
                    
                    <cfcase value="firstName">                    
                        hl.firstName,
                        hl.lastName
                    </cfcase>
                
                    <cfcase value="lastName">
                        hl.lastName,
                        hl.firstName
                    </cfcase>
    
                    <cfcase value="city">
                        hl.city
                    </cfcase>
    
                    <cfcase value="state">
                        st.state
                    </cfcase>
    
                    <cfcase value="dateCreated">
                        hl.dateCreated,
                        hl.lastName
                    </cfcase>
    
                    <cfdefaultcase>
                        hl.dateCreated DESC,
                        hl.lastName
                    </cfdefaultcase>
    
                </cfswitch>   
            
		</cfquery>
		   
		<cfreturn qGetHostLeads>
	</cffunction>


	<cffunction name="getPendingHostLeads" access="public" returntype="query" output="false" hint="Gets a list of pending leads assigned to a region or user">
        <cfargument name="userType" type="numeric" hint="userType is required">
        <cfargument name="regionID" type="numeric" hint="regionID is required">
        <cfargument name="areaRepID" type="numeric" default="0" hint="areaRepID is not required">
        <cfargument name="lastLogin" default="" hint="lastLogin is not required">
        <cfargument name="setClientVariable" type="numeric" default="0" hint="Set to 1 to display popUp on initial welcome">
        
        <cfscript>
			// If there is no last login date, use now() instead
			if ( NOT IsDate(ARGUMENTS.lastLogin) ) {
				ARGUMENTS.lastLogin = now();
			}		
		</cfscript>
        
        <cfquery 
			name="qGetPendingHostLeads" 
			datasource="#APPLICATION.dsn#">
                SELECT
					hl.ID,
                    hl.hashID,
                    hl.regionID,
                    hl.areaRepID,
                    hl.statusID,
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.stateID,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    hl.dateCreated,
                    hl.dateUpdated,
                    st.stateName,
                    r.regionName AS regionAssigned,
                    CONCAT(u.firstName, ' ', u.lastName) AS areaRepAssigned,
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
						AND
                        	alk.applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CONSTANTS.type.hostFamilyLead#">
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	hl.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				
                AND
                    hl.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">

				<cfif ARGUMENTS.userType NEQ 5 AND VAL(ARGUMENTS.areaRepID)>
                    <!--- Advisors / Area Representatives --->
                    AND
                        hl.areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.areaRepID#">
                </cfif>
                
                AND
                    (
                    	<!--- Get New Host Leads | 3 = Not Interested | 8 = Committed to Host | 9 - Interested in Hosting in the Future --->
                    	hl.dateUpdated >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.lastLogin#">
					 AND
                     	hl.statusID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="3,8,9" list="yes"> )

                     OR
                     	<!--- Get Host Leads That do not have a final disposition --->
                     	hl.ID NOT IN (
                        	SELECT
                            	ID
                            FROM
                            	smg_host_lead
                            WHERE	
                            	statusID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="3,8" list="yes"> )
                        )
                     
                     )
                ORDER BY
                    hl.dateCreated,
                    hl.lastName
		</cfquery>

        <cfscript>
			// Set CLIENT.isTherePendingHostLeads
			if ( VAL(ARGUMENTS.setClientVariable) AND qGetPendingHostLeads.recordcount ) {
				CLIENT.displayHostLeadPopUp = 1;	
			}
			
			return qGetPendingHostLeads;
		</cfscript>
		   
	</cffunction>


	<cffunction name="getHostLeadByID" access="public" returntype="query" output="false" hint="Gets host leads entered from ISEUSA.com">
        <cfargument name="ID" type="numeric" required="yes" hint="ID is required">
        
        <cfquery 
			name="qGetHostLeadByID" 
			datasource="#APPLICATION.dsn#">
                SELECT
					hl.ID,
                    hl.hashID,
                    hl.statusID,
                    hl.followUpID,	
                    hl.regionID,
                    hl.areaRepID,                    				
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.stateID,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.password,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    hl.dateLastLoggedIn,
                    hl.dateCreated,
                    hl.dateUpdated,
                    <!--- Follow Up Representative --->
                    CONCAT(fu.firstName, ' ', fu.lastName) AS followUpAssigned,
					<!--- State --->
                    st.state,
                    <!--- Region --->
                    r.regionName AS regionAssigned,
                    <!--- Company --->
                    c.companyID,
                    c.companyShort,
                    <!--- Area Representative --->
                    CAST(CONCAT(u.firstName, ' ', u.lastName,  ' ##', u.userID) AS CHAR) AS areaRepAssigned,
                    <!--- Status --->
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_users fu ON fu.userID = hl.followUpID    
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_companies c ON c.companyID = r.company
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
						AND
                        	alk.applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CONSTANTS.type.hostFamilyLead#">
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND	
                	hl.ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">

				ORDER BY	
                   hl.dateUpdated DESC                 
		</cfquery>
		   
		<cfreturn qGetHostLeadByID>
	</cffunction>
    
    
	<cffunction name="setHostLeadDataIntegrity" access="public" returntype="void" output="false" hint="This makes sure that all records have a hashID and a history">
        
		<!--- Insert HashID --->
        <cfquery 
			name="qGetHostNoHashID" 
			datasource="#APPLICATION.dsn#">
                SELECT
                    ID
                FROM
                    smg_host_lead
                WHERE
                    hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        </cfquery>
        
        <cfloop query="qGetHostNoHashID">
            <cfquery datasource="MySQL">
                UPDATE
                    smg_host_lead
                SET
                    hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.hashID(qGetHostNoHashID.ID)#">
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostNoHashID.ID#">
            </cfquery>
        </cfloop>
        
        <!--- Insert Initial Comment --->
        <cfquery 
			name="qGetHostNoHistory" 
			datasource="#APPLICATION.dsn#">
            SELECT
                ID,
                dateCreated,
                dateUpdated
            FROM
                smg_host_lead
            WHERE
                ID NOT IN 
                    (
                        SELECT
                            foreignID
                        FROM
                            applicationHistory
                        WHERE
                            foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_host_lead">
                    ) 
        </cfquery>

		<cfscript>
			// Loop through query
            For ( i=1; i LTE qGetHostNoHistory.recordCount; i=i+1 ) {
				
				// Insert Initial Comment
                APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
                    applicationID=APPLICATION.CONSTANTS.TYPE.hostFamilyLead,
                    foreignTable='smg_host_lead',
                    foreignID=qGetHostNoHistory.ID[i],
                    actions='Status: Initial - Host Lead Received',
                    dateCreated=qGetHostNoHistory.dateCreated[i],
                    dateUpdated=qGetHostNoHistory.dateUpdated[i]
                );
				
            }
        </cfscript>

	</cffunction>
       
    
	<cffunction name="updateHostLead" access="public" returntype="void" output="false" hint="Updates host lead JN">
        <cfargument name="ID" type="numeric" required="yes" hint="ID is required">
        <cfargument name="followUpID" type="numeric" required="yes" hint="followUpID is required">
        <cfargument name="regionID" type="numeric" required="yes" hint="regionID is required">        
        <cfargument name="areaRepID" type="numeric" required="yes" hint="areaRepID is required">
        <cfargument name="statusID" type="numeric" required="yes" hint="statusID is required">
        <cfargument name="enteredByID" type="numeric" required="yes" hint="enteredByID is required">
        <cfargument name="comments" type="string" default="" hint="comments is not required">
        
        <cfscript>
			// Set actions
			var vActions = '';
			
			// Get current host lead information
			qGetHostLead = getHostLeadByID(ID=ARGUMENTS.ID);				

			// Get User Information
			qGetFollowUpUser = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.followUpID);

			// Get User Information
			qGetUser = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.areaRepID);

			// Get Entered By Information
			qGetEnterBy = APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.enteredByID);
			
			// Get Status
			qGetStatus = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(
				applicationID=APPLICATION.CONSTANTS.type.hostFamilyLead,
				fieldKey='hostLeadStatus',
				fieldID=ARGUMENTS.statusID
			);
		</cfscript>
        
        <cfsavecontent variable="emailNewHostLead">
            <cfoutput>
                <p>Dear #qGetUser.firstName# #qGetUser.lastName#,</p>
                
                <p>A new host family lead has been assigned to you. Please see the details below:</p>
                
                Name: #qGetHostLead.firstName# #qGetHostLead.lastName# <br />
                Location: #qGetHostLead.city#, #qGetHostLead.state# <br />
                Phone Number: #qGetHostLead.phone# <br />
                Email Address: #qGetHostLead.email# <br />
                
                <cfif LEN(ARGUMENTS.comments)>
                    Comments: #ARGUMENTS.comments# <br />
                </cfif>
                
                <p>Please visit <a href="#CLIENT.exits_url#">#CLIENT.exits_url#</a> to view the complete host lead information.</p>
                
                Regards, <Br />
                #CLIENT.companyName#
			</cfoutput>
        </cfsavecontent>

        <cfsavecontent variable="emailFinalDecision">
            <cfoutput>
                <p>NY Office-</p>
                
                <p>The host lead below has received a final decision.</p>
                
                Name: #qGetHostLead.firstName# #qGetHostLead.lastName# <br />
                Location: #qGetHostLead.city#, #qGetHostLead.state# <br />
                Phone Number: #qGetHostLead.phone# <br />
                Email Address: #qGetHostLead.email# <br />                
                Decision: #qGetStatus.name# <br />     
                Comments: #ARGUMENTS.comments# <br />
                Updated By: #qGetEnterBy.firstName# #qGetEnterBy.lastName# ###qGetEnterBy.userID# <br />
                
                <p>Please visit <a href="#CLIENT.exits_url#">#CLIENT.exits_url#</a> to view the complete host lead information.</p>
                
                Regards, <Br />
                #CLIENT.companyName#
			</cfoutput>
        </cfsavecontent>
    
        <cfscript>	
			// Follow Up User
			if ( ARGUMENTS.followUpID NEQ qGetHostLead.followUpID ) {
				// Assign new area rep 
				vActions = vActions & "Follow Up Representative: #qGetFollowUpUser.firstName# #qGetFollowUpUser.lastName# ###qGetFollowUpUser.userID# <br /> #CHR(13)#";
				
			}
		
			// Region
			if ( ARGUMENTS.regionID NEQ qGetHostLead.regionID ) {
				// Get Region Information
				qGetRegion = APPLICATION.CFC.REGION.getRegions(regionID=ARGUMENTS.regionID);
				// Assign new region
				vActions = vActions & "Region: #qGetRegion.regionName# ###qGetRegion.regionID# <br /> #CHR(13)#";
			}

			// Area Representative
			if ( ARGUMENTS.areaRepID NEQ qGetHostLead.areaRepID ) {
				// Assign new area rep 
				vActions = vActions & "Area Representative: #qGetUser.firstName# #qGetUser.lastName# ###qGetUser.userID# <br /> #CHR(13)#";
				
				// Email Area Representative / Production Only
				if ( NOT APPLICATION.isServerLocal AND isvalid("email", qGetUser.Email) ) { 
					
					// Create Object
					oEmail = createObject("component","nsmg.cfc.email");
					
					// Send Out Email
					oEmail.send_mail(
						email_to=qGetUser.email,
						email_from='#companyshort#-support@exitsapplication.com',
						email_subject='New Host Family Lead Assigned To You',
						email_message=emailNewHostLead
					);
					
				}
				
			}
			
			// Status
			if ( ARGUMENTS.statusID NEQ qGetHostLead.statusID ) {
				// Get Status Information
				qGetStatus = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(
					applicationID=APPLICATION.CONSTANTS.type.hostFamilyLead,
					fieldKey='hostLeadStatus',
					fieldID=ARGUMENTS.statusID
				);				
				// Assign new statusID
				vActions = vActions & "Status: #qGetStatus.name# <br /> #CHR(13)#";
			}
			
			// Comments
			if ( LEN(ARGUMENTS.comments) ) {
				vActions = vActions & "Comment added <br /> #CHR(13)#";
			}
			
			// Check if information has been updated
			if ( LEN(vActions) ) {
				
				// Add User and TimeStamp Information
				vActions = vActions & "Assigned by: #qGetEnterBy.firstName# #qGetEnterBy.lastName# ###qGetEnterBy.userID# <br /> #CHR(13)#";

				// Insert New History
				APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
					applicationID=APPLICATION.CONSTANTS.TYPE.hostFamilyLead,
					foreignTable='smg_host_lead',
					foreignID=ARGUMENTS.ID,
					enteredByID=ARGUMENTS.enteredByID,
					actions=vActions,
					comments=ARGUMENTS.comments
				);
				
				// Final Decisions (Not Interested / Committed to Host) - Email Budge/Bob
				if ( ListFind("3,8", ARGUMENTS.statusID) ) {
					
					// Create Object
					oEmail = createObject("component","nsmg.cfc.email");
					
					// Send Out Email
					oEmail.send_mail(
						email_to=APPLICATION.EMAIL.hostLeadNotifications,
						email_from='#companyshort#-support@exitsapplication.com',
						email_subject='Host Lead - #qGetHostLead.lastName# from #qGetHostLead.city#, #qGetHostLead.state# - final decision',
						email_message=emailFinalDecision
					);
					
				}

			}
		</cfscript>
			
		<!--- Update Host Lead --->
        <cfquery 
            datasource="#APPLICATION.dsn#">
                UPDATE
                    smg_host_lead
                SET
                    statusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.statusID)#">,
                    followUpID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.followUpID)#">,
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.regionID)#">,
                    areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.areaRepID)#">
                WHERE	                        
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">
        </cfquery>
            
    </cffunction>


	<cffunction name="exportHostLeads" access="public" returntype="query" output="false" hint="Export Leads to Excel">
		<cfargument name="dateExported" default="" hint="Gets new leads if no date is passed">
        
        <cfquery 
			name="qExportHostLeads" 
			datasource="#APPLICATION.dsn#">
                SELECT
                	ID,
                    firstName,
                    lastName,
                    email,
					dateExported
                FROM 
                    smg_host_lead
                WHERE
 					isListSubscriber = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND	
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        
                <cfif isDate(ARGUMENTS.dateExported)>
                    AND	                    
                        dateExported = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.dateExported#">             
				<cfelse>
                	AND
                    	dateExported IS NULL				
				</cfif>
                
                ORDER BY
                	dateCreated DESC
		</cfquery>
		
        <cfscript>
			// Add IDs to a list
			vIDList = ValueList(qExportHostLeads.ID);
		</cfscript>
        
        <!--- Record date leads were exported --->
        <cfif LEN(vIDList)>
       
            <cfquery 
                datasource="#APPLICATION.dsn#">
                    UPDATE
                        smg_host_lead
                    SET	
                    	dateExported = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE
                        ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vIDList#" list="yes"> )
            </cfquery>
        
        </cfif>
           
		<cfreturn qExportHostLeads>
	</cffunction>


	<cffunction name="getHostLeadExportHistory" access="public" returntype="query" output="false" hint="Lists export history">

        <cfquery 
			name="qGetHostLeadExportHistory" 
			datasource="#APPLICATION.dsn#">
                SELECT
                	count(ID) AS totalLeads,
					dateExported
                FROM 
                    smg_host_lead
				WHERE
                	dateExported IS NOT NULL                    
                GROUP BY            
                    dateExported                  
                ORDER BY            
                    dateExported DESC
                LIMIT
                	30
		</cfquery>
		   
		<cfreturn qGetHostLeadExportHistory>
	</cffunction>

    
    
    <!--- 
		Start of Remote Functions 
	--->
	<cffunction name="getHostLeadsRemote" access="remote" returnFormat="json" output="false" hint="Returns host leads in Json format">
        <cfargument name="pageNumber" type="numeric" default="1" hint="Page number is not required">
        <cfargument name="keyword" type="string" default="" hint="keyword is not required">
        <cfargument name="followUpID" type="numeric" default="0" hint="followUpID is not required">
        <cfargument name="regionID" type="string" default="0" hint="regionID is not required">
        <cfargument name="stateID" type="string" default="0" hint="keyword is not required">
        <cfargument name="statusID" type="string" default="" hint="statusID is not required">
        <cfargument name="sortBy" type="string" default="dateCreated" hint="sortBy is not required">
        <cfargument name="sortOrder" type="string" default="DESC" hint="sortOrder is not required">
        <cfargument name="numberOfRecordsOnPage" type="numeric" default="30" hint="Page number is not required">
        <cfargument name="isDeleted" type="numeric" default="0" hint="isDeleted is not required">
        <cfargument name="hasLoggedIn" type="numeric" default="0" hint="hasLoggedIn is not required">
		
        <cfscript>
			if ( NOT ListFind("ASC,DESC", ARGUMENTS.sortOrder ) ) {
				ARGUMENTS.sortOrder = 'DESC';			  
			}
		</cfscript>
              
        <cfquery 
			name="qGetHostLeadsRemote" 
			datasource="#APPLICATION.dsn#">
                SELECT
					hl.ID,
                    <!--- 17E0 was being displayed as 17 or 17.0 --->
					<!--- CAST(hl.hashID AS CHAR) AS hashID, --->
                    <!--- CONVERT(hl.hashID USING utf8) AS hashID, --->                    
                    CONCAT(hl.hashID, '&') AS hashID,
                    hl.statusID,
                    hl.followUpID,
                    hl.regionID,
                    hl.areaRepID,
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    DATE_FORMAT(hl.dateCreated, '%m/%e/%Y') as dateCreated,
                    DATE_FORMAT(hl.dateLastLoggedIn, '%m/%e/%Y') as dateLastLoggedIn,
                    <!--- Follow Up Representative --->
                    CONCAT(fu.firstName, ' ', fu.lastName) AS followUpAssigned,
                    <!--- State --->
                    st.state,
                    <!--- Region --->
                    r.regionName AS regionAssigned,
                    <!--- Area Representative --->
                    CONCAT(u.firstName, ' ', u.lastName) AS areaRepAssigned,
                    <!--- Status --->
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_users fu ON fu.userID = hl.followUpID    
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
						AND
                        	alk.applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CONSTANTS.type.hostFamilyLead#">
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	hl.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.isDeleted#">
				
                <!--- Get Only Leads Entered as of 04/01/2011 --->
                AND
                	(
                    	hl.dateCreated >= <cfqueryparam cfsqltype="cf_sql_date" value="2011/04/01">
                	OR
                    	hl.dateLastLoggedIn IS NOT NULL	
                	)
                    
                <cfif VAL(ARGUMENTS.hasLoggedIn)>
                    AND	
                        hl.dateLastLoggedIn IS NOT NULL
				</cfif>                    

				<cfif CLIENT.companyID NEQ 5>
                    AND
                        r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                </cfif>

                <!--- Screnner --->
                <cfif CLIENT.userType EQ 26>
                	AND
                    	hl.followUpID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                </cfif>
                
                <!--- RA and AR can only see leads assigned to them --->
                <cfif ListFind("6,7,9", CLIENT.userType)>
                	AND
                    	hl.areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                </cfif>

				<cfif VAL(ARGUMENTS.followUpID)>
                    AND
                        hl.followUpID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.followUpID#">
                </cfif>
				
				<cfif VAL(ARGUMENTS.regionID)>
                    AND
                        hl.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                </cfif>

                <cfif VAL(ARGUMENTS.statusID)>
                    AND
                        hl.statusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.statusID#">
                <cfelseif ARGUMENTS.statusID NEQ 'All'>
                	<!--- Do not display final dispositions: 3=Not Interested / 8=Converted to Host Family --->
                    AND
						hl.statusID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="3,8" list="yes"> )
				</cfif>
                
                <cfif LEN(ARGUMENTS.keyword)>
                	AND
                    	(
                        	hl.firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	hl.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	hl.address LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	hl.city LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	st.state LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
	                	OR
                        	hl.zipCode LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ARGUMENTS.keyword#%">
                        )
                </cfif>

                <cfif VAL(ARGUMENTS.stateID)>
                	AND
                        hl.stateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.stateID#">
                </cfif>
                
                ORDER BY
                
                <cfswitch expression="#ARGUMENTS.sortBy#">
                    
                    <cfcase value="firstName">                    
                        hl.firstName #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>
                
                    <cfcase value="lastName">
                        hl.lastName #ARGUMENTS.sortOrder#,
                        hl.firstName
                    </cfcase>
    
                    <cfcase value="city">
                        hl.city #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>
    
                    <cfcase value="state">
                        st.state #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>

                    <cfcase value="zipCode">
                        hl.zipCode #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>
    
                    <cfcase value="phone">
                        hl.phone #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>

                    <cfcase value="email">
                        hl.email #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>
    
                    <cfcase value="dateCreated">
                        hl.dateCreated #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>

                    <cfcase value="dateLastLoggedIn">
                        hl.dateLastLoggedIn #ARGUMENTS.sortOrder#,
                        hl.lastName
                    </cfcase>
    
                    <cfcase value="statusAssigned">
						statusAssigned,
                        hl.lastName
                    </cfcase>

                    <cfcase value="regionAssigned">
						regionAssigned,
                        hl.lastName
                    </cfcase>

                    <cfcase value="areaRepAssigned">
						areaRepAssigned,
                        hl.lastName
                    </cfcase>
    
                    <cfdefaultcase>
                        hl.dateCreated DESC,
                        hl.lastName
                    </cfdefaultcase>
    
                </cfswitch>   
            
		</cfquery>

        <cfscript>
			// Set return structure that will store query + pagination information
			stResult = StructNew();
			
			// Populate structure with pagination information
			stResult.pageNumber = ARGUMENTS.pageNumber;
			stResult.numberOfRecordsOnPage = ARGUMENTS.numberOfRecordsOnPage;
			stResult.numberOfPages = Ceiling( qGetHostLeadsRemote.recordCount / stResult.numberOfRecordsOnPage );
			stResult.numberOfRecords = qGetHostLeadsRemote.recordCount;
			stResult.sortBy = ARGUMENTS.sortBy;
			stResult.sortOrder = ARGUMENTS.sortOrder;
			
			// Here using url.pagenumber to work out what records to display on current page
			stResult.recordFrom = ( (ARGUMENTS.pageNumber * stResult.numberOfRecordsOnPage) - stResult.numberOfRecordsOnPage) + 1;
			stResult.recordTo = ( ARGUMENTS.pageNumber * stResult.numberOfRecordsOnPage );
			
			/* 
				if on last page display the actual number of records in record set as the last to 'figure'. Otherwise it gives 
				a false reading and gives the pagenumber * numberOfRecordsOnPage which is always a multiple of 10
			*/
			if ( stResult.recordTo EQ (stResult.numberOfPages * 10) ) {
				stResult.recordTo = qGetHostLeadsRemote.recordCount;
			}

			// Populate structure with query
			resultQuery = QueryNew("ID, hashID, firstName, lastName, city, state, zipCode, phone, email, dateCreated, dateLastLoggedIn, statusAssigned, regionAssigned, areaRepAssigned");
			
			if ( qGetHostLeadsRemote.recordCount < stResult.recordTo ) {
				stResult.recordTo = qGetHostLeadsRemote.recordCount;
			}
			
			// Populate query below
			if ( qGetHostLeadsRemote.recordCount ) {
				
				For ( i=stResult.recordFrom; i LTE stResult.recordTo; i=i+1 ) {
					QueryAddRow(resultQuery);
					QuerySetCell(resultQuery, "ID", qGetHostLeadsRemote.ID[i]);
					QuerySetCell(resultQuery, "HASHID", qGetHostLeadsRemote.hashID[i]);
					QuerySetCell(resultQuery, "firstName", qGetHostLeadsRemote.firstName[i]);
					QuerySetCell(resultQuery, "lastName", qGetHostLeadsRemote.lastName[i]);
					QuerySetCell(resultQuery, "city", qGetHostLeadsRemote.city[i]);
					QuerySetCell(resultQuery, "state", qGetHostLeadsRemote.state[i]);
					QuerySetCell(resultQuery, "zipCode", qGetHostLeadsRemote.zipCode[i]);
					QuerySetCell(resultQuery, "phone", qGetHostLeadsRemote.phone[i]);
					QuerySetCell(resultQuery, "email", qGetHostLeadsRemote.email[i]);
					QuerySetCell(resultQuery, "dateCreated", qGetHostLeadsRemote.dateCreated[i]);
					QuerySetCell(resultQuery, "dateLastLoggedIn", qGetHostLeadsRemote.dateLastLoggedIn[i]);
					QuerySetCell(resultQuery, "statusAssigned", qGetHostLeadsRemote.statusAssigned[i]);
					QuerySetCell(resultQuery, "regionAssigned", qGetHostLeadsRemote.regionAssigned[i]);
					QuerySetCell(resultQuery, "areaRepAssigned", qGetHostLeadsRemote.areaRepAssigned[i]);
				}
			
			}
			
			// Add query to structure
			stResult.query = resultQuery;
			
			// return structure
			return stResult;			
		</cfscript>
        
	</cffunction>
    

	<cffunction name="deleteHostLeadRemote" access="remote" returntype="void" output="false" hint="Deletes a host lead">
        <cfargument name="ID" type="numeric" hint="ID is not required">
		
        <cfquery 
			datasource="#APPLICATION.dsn#">
                UPDATE
                	smg_host_lead
				SET
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
				WHERE
                	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.ID#">                                         
		</cfquery>
        
	</cffunction>            
    
    <!--- 
		End of Remote Functions 
	--->
    
    
    <!--- 
		Host Lead Reports 
	--->
	<cffunction name="getHostLeadFollowUpReport" access="public" returntype="query" output="false" hint="Gets host leads report">
        <cfargument name="followUpID" type="numeric" default="0" hint="followUpID is not required">
        <cfargument name="regionID" type="string" default="0" hint="regionID is not required">
        <cfargument name="statusID" type="string" default="" hint="statusID is not required">
        <cfargument name="dateFrom" type="string" default="" hint="dateFrom is not required">
        <cfargument name="dateTo" type="string" default="" hint="dateTo is not required">
        
        <cfquery 
			name="qGetHostLeadFollowUpReport" 
			datasource="#APPLICATION.dsn#">
                SELECT
					hl.ID,
                    hl.hashID,
                    hl.statusID,
                    hl.followUpID,
                    hl.regionID,
                    hl.areaRepID,
                    hl.firstName,
                    hl.lastName,
                    hl.address,
                    hl.address2,
                    hl.city,
                    hl.zipCode,
                    hl.phone,
                    hl.email,
                    hl.hearAboutUs,
                    hl.hearAboutUsDetail,
                    hl.isListSubscriber,
                    DATE_FORMAT(hl.dateCreated, '%m/%e/%Y') as dateCreated,
                    DATE_FORMAT(hl.dateLastLoggedIn, '%m/%e/%Y') as dateLastLoggedIn,
                    <!--- Follow Up Representative --->
                    CONCAT(fu.firstName, ' ', fu.lastName) AS followUpAssigned,
                    <!--- State --->
                    st.state,
                    <!--- Region --->
                    r.regionName AS regionAssigned,
                    <!--- Area Representative --->
                    CONCAT(u.firstName, ' ', u.lastName) AS areaRepAssigned,
                    <!--- Status --->
                    alk.name AS statusAssigned
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_users fu ON fu.userID = hl.followUpID    
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                LEFT OUTER JOIN
                	smg_regions r ON r.regionID = hl.regionID
                LEFT OUTER JOIN
                	smg_users u ON u.userID = hl.areaRepID    
                LEFT OUTER JOIN
                	applicationLookUp alk ON alk.fieldID = hl.statusID 
						AND
                        	alk.applicationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CONSTANTS.type.hostFamilyLead#">
                    	AND 
                            alk.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="hostLeadStatus">
                WHERE
                	hl.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">

                <cfif isDate(ARGUMENTS.dateFrom) AND isDate(ARGUMENTS.dateTo)>
                	AND 
                    (
                        hl.dateCreated 
                        BETWEEN 
                        	<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dateFrom#"> 
	                    AND 
    	                    <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', 1, ARGUMENTS.dateTo)#">
                    )                 	
                <cfelse>
                	<!--- Get Only Leads Entered as of 04/01/2011 --->
                    AND
                        (
                            hl.dateCreated >= <cfqueryparam cfsqltype="cf_sql_date" value="2011/04/01">
                        OR
                            hl.dateLastLoggedIn IS NOT NULL	
                        )
                </cfif>

				<cfif CLIENT.companyID NEQ 5>
                    AND
                        r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                </cfif>

				<cfif VAL(ARGUMENTS.followUpID)>
                    AND
                        hl.followUpID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.followUpID#">
                </cfif>
				
				<cfif VAL(ARGUMENTS.regionID)>
                    AND
                        hl.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
                </cfif>

                <cfif VAL(ARGUMENTS.statusID)>
                    AND
                        hl.statusID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.statusID#">
				</cfif>
                
                ORDER BY
                    hl.dateCreated DESC,
                    hl.lastName
		</cfquery>
		   
		<cfreturn qGetHostLeadFollowUpReport>
	</cffunction>    

	<!--- ------------------------------------------------------------------------- ----
		
		END OF HOST LEADS
	
	----- ------------------------------------------------------------------------- --->
    
</cfcomponent>