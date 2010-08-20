<!--- ------------------------------------------------------------------------- ----
	
	File:		candidate.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
	Desc:		This holds the functions needed for the user

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="candidate"
	output="false" 
	hint="A collection of functions for the candidate">


	<!--- Return the initialized candidate object --->
	<cffunction name="Init" access="public" returntype="candidate" output="false" hint="Returns the initialized candidate object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getCandidateByID" access="public" returntype="query" output="false" hint="Gets a candidate by candidateID or uniqueID">
    	<cfargument name="candidateID" default="0" hint="candidateID is not required">
        <cfargument name="uniqueID" default="" hint="uniqueID is not required">
              
        <cfquery 
			name="qGetCandidateByID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					*
                FROM 
                    extra_candidates
                WHERE
                	1 = 1
					
					<cfif VAL(ARGUMENTS.candidateID)>
	                    AND
                        	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
					</cfif>
                    
					<cfif LEN(ARGUMENTS.uniqueID)>
	                    AND
                        	uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.uniqueID#">
					</cfif>
		</cfquery>
		   
		<cfreturn qGetCandidateByID>
	</cffunction>


	<cffunction name="getVerificationList" access="remote" returnFormat="json" output="false" hint="Returns verification report list in Json format">
    	<cfargument name="intRep" default="0" hint="International Representative is not required">
        <cfargument name="receivedDate" default="" hint="Filter by verification received date">

        <cfquery 
			name="qGetVerificationList" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ec.candidateID,
                    ec.firstName,
                    ec.middleName,
                    ec.lastName,
                    ec.sex,
                    DATE_FORMAT(ec.dob, '%m/%e/%Y') as dob,
                    ec.birth_city,
                    ec.birth_country,
                    ec.citizen_country,
                    ec.residence_country,
                    birth.countryName as birthCountry,
                    citizen.countryName as citizenCountry,
                    resident.countryName as residentCountry
                FROM 
                    extra_candidates ec
				INNER JOIN
                	smg_programs p ON p.programID = ec.programID
                LEFT OUTER JOIN
                	smg_countrylist birth ON birth.countryID = ec.birth_country
				LEFT OUTER JOIN
                	smg_countrylist citizen ON citizen.countryID = ec.citizen_country
				LEFT OUTER JOIN
                	smg_countrylist resident ON resident.countryID = ec.residence_country
                WHERE
                	ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				AND   
                    ec.ds2019 = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                AND
                    ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
				<cfif VAL(ARGUMENTS.intRep)>
                    AND
                        ec.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.intRep#">
                </cfif>
				<cfif IsDate(ARGUMENTS.receivedDate)>
                	AND
                    	ec.verification_received = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.receivedDate#">
				<cfelse>
                	AND
                    	ec.verification_received IS <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">
                </cfif>
			ORDER BY
            	ec.candidateID
		</cfquery>
		   
		<cfreturn qGetVerificationList>
	</cffunction>


	<cffunction name="getRemoteCandidateByID" access="remote" returnFormat="json" output="false" hint="Returns a candidate in Json format">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">

        <cfquery 
			name="qGetRemoteCandidateByID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ec.candidateID,
                    ec.firstName,
                    ec.middleName,
                    ec.lastName,
                    ec.sex,
                    DATE_FORMAT(ec.dob, '%m/%e/%Y') as dob,
                    ec.birth_city,
                    ec.birth_country,
                    ec.citizen_country,
                    ec.residence_country
                FROM 
                    extra_candidates ec
                WHERE
                    ec.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
		   
		<cfreturn qGetRemoteCandidateByID>
	</cffunction>


	<cffunction name="updateRemoteCandidateByID" access="remote" returntype="void" hint="Updates a candidate record.">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="firstName" required="yes" hint="firstName is required">
        <cfargument name="middleName" required="yes" hint="middleName is required">
        <cfargument name="lastName" required="yes" hint="lastName is required">
        <cfargument name="sex" required="yes" hint="sex is required">
        <cfargument name="dob" required="yes" hint="dob is required">
        <cfargument name="birthCity" required="yes" hint="birthCity is required">
        <cfargument name="birthCountry" required="yes" hint="birthCountry is required">
        <cfargument name="citizenCountry" required="yes" hint="citizenCountry is required">
        <cfargument name="residenceCountry" required="yes" hint="residenceCountry is required">

        <cfquery 
			datasource="#APPLICATION.DSN.Source#">
                UPDATE
					extra_candidates
				SET
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.firstName#">,
                    middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.middleName#">,
                    lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.lastName#">,
                    sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sex#">,
                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.dob#">,
                    birth_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.birthCity#">,
                    birth_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.birthCountry)#">,
                    citizen_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.citizenCountry)#">,
                    residence_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.residenceCountry)#">
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
		   
	</cffunction>


	<cffunction name="confirmVerificationReceived" access="remote" returntype="void" hint="Sets verification_received field as received.">
        <cfargument name="candidateID" required="yes" hint="candidateID is required">

        <cfquery 
			datasource="#APPLICATION.DSN.Source#">
                UPDATE
					extra_candidates
				SET
                    verification_received = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.candidateID#">
		</cfquery>
		   
	</cffunction>

</cfcomponent>