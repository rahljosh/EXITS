<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInformation.cfc
	Author:		Marcus Melo
	Date:		August, 05 2010
	Desc:		This holds the functions needed for the flightInformation

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="flightInformation"
	output="false" 
	hint="A collection of functions for the flightInformation">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="flightInformation" output="false" hint="Returns the initialized flightInformation object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="setAssignedID" access="public" returntype="void" output="false" hint="Sets the programID for flight information that are missing it">
        <cfargument name="studentID" type="numeric" hint="studentID is required">
        <cfargument name="assignedID" type="numeric" hint="assignedID is required">
        <cfargument name="programID" type="numeric" hint="programID is required">
        <cfargument name="depDate" hint="depDate is required">
              
        <cfquery datasource="#APPLICATION.dsn#">
            UPDATE
            	smg_flight_info
            SET
                assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.assignedID#">,
                programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">
			WHERE
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">  
			AND
            	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			<!--- Get all legs for this flight information - use a 20 day window --->                
			AND 
                dep_date >= DATE_ADD(<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.depDate#">, INTERVAL -20 DAY)
			AND 
                dep_date <= DATE_ADD(<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.depDate#">, INTERVAL 20 DAY)
        </cfquery>
           
	</cffunction>   


	<cffunction name="getFlightInfoByStudentID" access="public" returntype="query" output="false" hint="Gets flight information by student and assigned ID (program based).">
        <cfargument name="studentID" type="numeric" hint="studentID is required">
        <cfargument name="companyID" type="numeric" hint="companyID is required">
        <cfargument name="assignedID" default="0" type="numeric" hint="assignedID is not required">
        <cfargument name="flightType" type="string" hint="Arrival or Departure">
              
        <cfquery 
			name="qGetFlightInfoByStudentID"
        	datasource="#APPLICATION.dsn#">
            SELECT
				flightID, 
                studentID, 
                dep_date, 
                dep_city, 
                dep_aircode, 
                dep_time, 
                flight_number, 
                arrival_city, 
                arrival_aircode, 
                arrival_time, 
                overnight, 
                flight_type
			FROM
	           	smg_flight_info
			WHERE	
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">  
			AND
            	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">
			AND 
            	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#"> 
			<cfif VAL(ARGUMENTS.assignedID)>
            AND
            	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.assignedID#">
            </cfif>
        </cfquery>
		
        <cfreturn qGetFlightInfoByStudentID />          
	</cffunction>   


	<cffunction name="insertFlightInfo" access="public" returntype="void" output="false" hint="Inserts Flight Information">
        <cfargument name="studentID" type="numeric" hint="studentID is required">
        <cfargument name="assignedID" type="numeric" hint="assignedID is required">
        <cfargument name="programID" type="numeric" hint="programID is required">
        <cfargument name="companyID" type="numeric" hint="companyID is required">
        <cfargument name="depDate" type="string" hint="dep_date is required">
        <cfargument name="depCity" type="string" hint="dep_city is required">
        <cfargument name="depAirCode" type="string" hint="dep_aircode is required">
        <cfargument name="arrivalCity" type="string" hint="arrival_city is required">
        <cfargument name="arrivalAirCode" type="string" hint="arrival_aircode is required">
        <cfargument name="flightNumber" type="string" hint="flight_number is required">
        <cfargument name="depTime" type="string" hint="dep_time is required">
        <cfargument name="arrivalTime" type="string" hint="arrival_time is required">
        <cfargument name="overnight" type="string" hint="overnight is required">
        <cfargument name="flightType" type="string" hint="flight_type is required">
        
        <cfquery datasource="#APPLICATION.dsn#">
            INSERT INTO 
            	smg_flight_info
            (
            	studentID,
                assignedID, 
                programID,
                companyID, 
                dep_date, 
                dep_city, 
                dep_aircode, 
                arrival_city, 
                arrival_aircode, 
                flight_number, 
                dep_time, 
                arrival_time,
            	overnight, 
                flight_type
			)
            VALUES 
            (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">  
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.assignedID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.programID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.companyID#">, 
				<cfif IsDate(ARGUMENTS.depDate)>
                    <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.depDate)#">,
				<cfelse>
                    <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">,
				</cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.depCity#">,  
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.depAirCode#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalCity#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalAirCode#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightNumber#">,
				<cfif LEN(ARGUMENTS.depTime)>
                    <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCTime(ARGUMENTS.depTime)#">,
				<cfelse>
                    <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">,
				</cfif>
				<cfif LEN(ARGUMENTS.arrivalTime)>
                    <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCTime(ARGUMENTS.arrivalTime)#">,
				<cfelse>
                    <cfqueryparam cfsqltype="cf_sql_date" value="" null="yes">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.overnight#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">
			)
        </cfquery>
           
	</cffunction>   


</cfcomponent>