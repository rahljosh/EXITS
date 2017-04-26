<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInformation.cfc
	Author:		Marcus Melo
	Date:		October, 20 2010
	Desc:		This holds the functions needed for the flight information

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="flightInformation"
	output="false" 
	hint="A collection of functions for the flight information">


	<!--- Return the initialized candidate object --->
	<cffunction name="Init" access="public" returntype="flightInformation" output="false" hint="Returns the initialized flight Information object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>


	<cffunction name="getFlightInformationByCandidateID" access="public" returntype="query" output="false" hint="Returns flight information for a candidate">
    	<cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="flightType" required="yes" hint="arrival/departure">
        <cfargument name="getLastLeg" default="0" hint="set to 1 to get the last leg only">

        <cfquery 
			name="qGetFlightInformationByCandidateID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ID,
                    candidateID,
                    programID,
                    flightType,
                    DATE_FORMAT(departDate, '%c/%e/%Y') AS departDate,
                    departCity,
                    departAirportCode,
                    TIME_FORMAT(departTime, '%h:%i %p') AS departTime,       
                    flightNumber,
                    arriveCity,
                    arriveAirportCode,                    
                    TIME_FORMAT(arriveTime, '%h:%i %p') AS arriveTime,                    
                    IF(isOvernightFlight,' Yes ',' No ') AS isOvernightFlight,
                    dateCreated,
                    dateUpdated
                FROM 
                    extra_flight_information	
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.candidateID)#">
                AND
                    flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.flightType)#">

				<cfif ARGUMENTS.getLastLeg>
                    ORDER BY	
                        ID DESC      
					LIMIT 1
				<cfelse>
                    ORDER BY	
                        ID ASC           
                </cfif> 
                                          		
		</cfquery>

        <cfscript>
			return qGetFlightInformationByCandidateID;
		</cfscript>
	</cffunction>


	<cffunction name="getDailyFlightReport" access="public" returntype="query" output="false" hint="Emails flight information report updated/entered in the last 25 hours">
        <cfargument name="flightType" required="yes" hint="arrival/departure">
		<cfargument name="companyID" required="no" default="0">

        <cfquery 
			name="qGetDailyFlightReport" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
                    ec.candidateID,
                    ec.firstName,
                    ec.lastName,
                    eh.name as hostCompanyName,
                    u.businessName,
					efi.ID,
                    ec.programID,
                    efi.flightType,
                    ec.startDate,
                    DATE_FORMAT(efi.departDate, '%c/%e/%Y') AS departDate,
                    efi.departCity,
                    efi.departAirportCode,
                    TIME_FORMAT(efi.departTime, '%h:%i %p') AS departTime,       
                    efi.flightNumber,
                    efi.arriveCity,
                    efi.arriveAirportCode,                    
                    TIME_FORMAT(efi.arriveTime, '%h:%i %p') AS arriveTime,                    
                    IF(efi.isOvernightFlight,' Yes ',' No ') AS isOvernightFlight,
                    efi.dateCreated,
                    efi.dateUpdated
                FROM 
                    extra_candidates ec
                INNER JOIN
                	extra_flight_information efi ON ec.candidateID = efi.candidateID
                    	AND
                        	efi.dateUpdated >= DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL -1450 MINUTE)    
				INNER JOIN
                	smg_users u ON u.userID = ec.intRep
				LEFT JOIN                 
                    extra_hostcompany eh ON ec.hostcompanyID = eh.hostcompanyID
                	Left JOIN 
                	smg_programs p on p.programid = ec.programid
                WHERE
                    flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.flightType)#">
				<cfif VAL(ARGUMENTS.companyID)>
					AND ec.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">
				</cfif>
                ORDER BY
                	u.businessName,
                    ec.candidateID,	
                	efi.departDate,
                    efi.departTime                    
		</cfquery>

        <cfscript>
			return qGetDailyFlightReport;
		</cfscript>
        
	</cffunction>

		
     
    <!--- Remote Functions --->    
	<cffunction name="getFlightInformation" access="remote" returnFormat="json" output="false" hint="Returns flight information for a candidate in Json format">
    	<cfargument name="candidateID" required="yes" hint="candidateID is required">
        <cfargument name="flightType" required="yes" hint="arrival/departure">

        <cfquery 
			name="qGetFlightInformation" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ID,
                    candidateID,
                    programID,
                    flightType,
                    DATE_FORMAT(departDate, '%c/%e/%Y') AS departDate,
                    departCity,
                    departAirportCode,
                    TIME_FORMAT(departTime, '%h:%i %p') AS departTime,       
                    flightNumber,
                    arriveCity,
                    arriveAirportCode,                    
                    TIME_FORMAT(arriveTime, '%h:%i %p') AS arriveTime,                    
                    IF(isOvernightFlight,' Yes ',' No ') AS isOvernightFlight,
                    dateCreated,
                    dateUpdated
                FROM 
                    extra_flight_information	
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.candidateID)#">
                AND
                    flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.flightType)#">
				ORDER BY	
                	ID ASC                 
		</cfquery>

        <cfscript>
			// Declare a struct
			var resStruct = StructNew();
			// Store the flightType
			resStruct.flightType = ARGUMENTS.flightType;
			// Store the query to a struct
			resStruct.query = qGetFlightInformation;
			
			return resStruct;
		</cfscript>
	</cffunction>


	<cffunction name="getFlightInformationByID" access="remote" returnFormat="json" output="false" hint="Returns flight information in Json format">
    	<cfargument name="ID" required="yes" hint="ID is required">

        <cfquery 
			name="qGetFlightInformationByID" 
			datasource="#APPLICATION.DSN.Source#">
                SELECT
					ID,
                    candidateID,
                    programID,
                    flightType,
                    DATE_FORMAT(departDate, '%c/%e/%Y') AS departDate,
                    departCity,
                    departAirportCode,
                    TIME_FORMAT(departTime, '%h:%i %p') AS departTime,       
                    flightNumber,
                    arriveCity,
                    arriveAirportCode,                    
                    TIME_FORMAT(arriveTime, '%h:%i %p') AS arriveTime,                    
                    IF(isOvernightFlight,1,0) AS isOvernightFlight,
                    dateCreated,
                    dateUpdated
                FROM 
                    extra_flight_information	
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.ID)#">
		</cfquery>
            		   
		<cfreturn qGetFlightInformationByID>
	</cffunction>


	<cffunction name="deleteFlightInformationByID" access="remote" returnFormat="json" output="false" hint="Returns flight information in Json format">
    	<cfargument name="ID" required="yes" hint="ID is required">
		<cfargument name="candidateID" required="yes" hint="candidateID is required">
        
        <cfquery 
			datasource="#APPLICATION.DSN.Source#">
                DELETE  FROM 
                    extra_flight_information	
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.ID)#">
				AND
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.candidateID)#">
		</cfquery>
            		   
	</cffunction>


	<cffunction name="insertUpdateFlightInformation" access="remote" returntype="void" output="false" hint="Inserts/Updates a flight information">
    	<cfargument name="ID" required="yes" hint="ID is required">
    	<cfargument name="candidateID" type="numeric" hint="candidateID is required">
        <cfargument name="programID" default="0" type="numeric" hint="programID is not required">
        <cfargument name="flightType" type="string" hint="arrival/departure">
        <cfargument name="departDate" type="string" hint="departDate is required">
        <cfargument name="departCity" type="string" hint="departCity is required">
        <cfargument name="departAirportCode" type="string" hint="departAirportCode is required">
        <cfargument name="arriveCity" type="string" hint="arriveCity is required">
        <cfargument name="arriveAirportCode" type="string" hint="arriveAirportCode is required">
        <cfargument name="flightNumber" type="string" hint="flightNumber is required">
        <cfargument name="departTime" type="string" hint="departTime is required">
        <cfargument name="arriveTime" type="string" hint="arriveTime is required">
        <cfargument name="isOvernightFlight" default="0" hint="isOvernightFlight is not required">
        
        <cfif VAL(ARGUMENTS.ID)>
        	
			<!--- UPDATE --->
            <cfquery 
                datasource="#APPLICATION.DSN.Source#">
                    UPDATE
                        extra_flight_information
                    SET                    
                        programID=<cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.programID)#">,
                        flightType=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.flightType)#">,
                        <cfif IsDate(ARGUMENTS.departDate)>
                            departDate=<cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.departDate)#">,                    
                        <cfelse>
                            departDate=<cfqueryparam cfsqltype="cf_sql_date" null="yes">,   
                        </cfif>
                        departCity=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.departCity)#">,
                        departAirportCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(UCASE(ARGUMENTS.departAirportCode))#">,
                        <cfif IsDate(ARGUMENTS.departTime)>
                            departTime=<cfqueryparam cfsqltype="cf_sql_time" value="#TRIM(ARGUMENTS.departTime)#">,                    
                        <cfelse>
                            departTime=<cfqueryparam cfsqltype="cf_sql_time" null="yes">,   
                        </cfif>
                        flightNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(UCASE(ARGUMENTS.flightNumber))#">,
                        arriveCity=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.arriveCity)#">,
                        arriveAirportCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(UCASE(ARGUMENTS.arriveAirportCode))#">,
                        <cfif IsDate(ARGUMENTS.arriveTime)>
                            arriveTime=<cfqueryparam cfsqltype="cf_sql_time" value="#TRIM(ARGUMENTS.arriveTime)#">,                    
                        <cfelse>
                            arriveTime=<cfqueryparam cfsqltype="cf_sql_time" null="yes">,   
                        </cfif>                    
                        isOvernightFlight=<cfqueryparam cfsqltype="cf_sql_bit" value="#TRIM(ARGUMENTS.isOvernightFlight)#">
					WHERE
                        ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.ID)#">
                    AND
                        candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.candidateID)#">
            </cfquery>
            
        <cfelse>

        	<!--- INSERT --->
            <cfquery 
                datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO 
                        extra_flight_information
                    (                    
                        candidateID,
                        programID,
                        flightType,
                        departDate,
                        departCity,
                        departAirportCode,
                        departTime,
                        flightNumber,
                        arriveCity,
                        arriveAirportCode,
                        arriveTime,
                        isOvernightFlight,
                        dateCreated
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.candidateID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(ARGUMENTS.programID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.flightType)#">,                    
                        <cfif IsDate(ARGUMENTS.departDate)>
                            <cfqueryparam cfsqltype="cf_sql_date" value="#TRIM(ARGUMENTS.departDate)#">,                    
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_date" null="yes">,   
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.departCity)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(UCASE(ARGUMENTS.departAirportCode))#">,
                        <cfif IsDate(ARGUMENTS.departTime)>
                            <cfqueryparam cfsqltype="cf_sql_time" value="#TRIM(ARGUMENTS.departTime)#">,                    
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_time" null="yes">,   
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.flightNumber)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(ARGUMENTS.arriveCity)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(UCASE(ARGUMENTS.arriveAirportCode))#">,
                        <cfif IsDate(ARGUMENTS.arriveTime)>
                            <cfqueryparam cfsqltype="cf_sql_time" value="#TRIM(ARGUMENTS.arriveTime)#">,                    
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_time" null="yes">,   
                        </cfif>                    
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#TRIM(ARGUMENTS.isOvernightFlight)#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
            </cfquery>
		
        </cfif>
        		   
	</cffunction>

</cfcomponent>
