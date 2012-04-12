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
		
		REMOTE FUNCTIONS
	
	----- ------------------------------------------------------------------------- --->
    
    <!--- Start of Auto Suggest --->
    <cffunction name="lookupHostFamily" access="remote" returntype="string" output="false" hint="Remote function to get host families">
        <cfargument name="search" type="string" default="" hint="Search is not required">
        
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
		
		END OF REMOTE FUNCTIONS
	
	----- ------------------------------------------------------------------------- --->

</cfcomponent>