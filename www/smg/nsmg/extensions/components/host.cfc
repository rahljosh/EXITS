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
    	<cfargument name="hostID" default="0" hint="HostID is not required">
        
        <cfquery 
			name="qGetHosts" 
			datasource="#APPLICATION.dsn#">
                SELECT
                	hostID,
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
                    areaRepID,
                    active,
                    dateProcessed,
                    current_state,
                    approved,
                    interests,
                    interests_other,
                    band,
                    orchestra,
                    comp_sports,
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
                    special_cloths,
                    point_interest,
                    school_trans,
                    other_trans,
                    familyLetter,
                    pictures,
                    applicationSent,
                    applicationApproved,
                    previousHost,
                    home_first_call,
                    home_last_visit,
                    home_visited,
                    pert_info,
                    companyID,
                    host_start_date,
                    host_end_date,
                    studentHosting,
                    uniqueID,
                    imported         
                FROM 
                    smg_hosts
                    
                <cfif VAL(ARGUMENTS.hostID)>
                WHERE
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
                </cfif>
                    
                ORDER BY 
                    familyLastName
		</cfquery>
		   
		<cfreturn qGetHosts>
	</cffunction>


	<cffunction name="getHostMemberByID" access="public" returntype="query" output="false" hint="Gets a host member by ID">
    	<cfargument name="childID" type="numeric" hint="Child ID is required">
        <cfargument name="hostID" default="0" hint="HostID is not required">
        
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
                    cbc_form_received,
                    shared,
                    roomShareWith
                FROM 
                    smg_host_children
                WHERE
                	childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.childID#">
                    
                <cfif VAL(ARGUMENTS.hostID)>
                AND
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.hostID#">
                </cfif>

		</cfquery>
		   
		<cfreturn qGetHostMemberByID>
	</cffunction>


	<cffunction name="getHostLeads" access="public" returntype="query" output="false" hint="Gets host leads entered from ISEUSA.com">
        <cfargument name="sortBy" type="string" default="dateCreated" hint="sortBy is not required">
        <cfargument name="sortOrder" type="string" default="ASC" hint="sortOrder is not required">
        <cfargument name="isDeleted" type="string" default="0" hint="isDeleted is not required">
        
        <cfquery 
			name="qGetHostLeads" 
			datasource="#APPLICATION.dsn#">
                SELECT
					hl.id,
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
                    st.state
                FROM 
                    smg_host_lead hl
                LEFT OUTER JOIN
                	smg_states st ON st.id = hl.stateID
                WHERE
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isDeleted#">
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
    
</cfcomponent>