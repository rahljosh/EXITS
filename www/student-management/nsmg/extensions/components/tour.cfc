<cfcomponent displayname="tour"output="false" hint="A collection of functions for MPD Tours">


	<!--- Return the initialized Tour object --->
	<cffunction name="Init" access="public" returntype="tour" output="false" hint="Returns the initialized tour object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	<!--- Get all active tours --->
	<cffunction name="getAllActiveTours" access="public" returntype="query">
		
        <cfquery name="qGetAllActiveTours" datasource="#APPLICATION.DSN#">
        	SELECT
            	*
           	FROM
            	smg_tours
           	WHERE
            	isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
           	ORDER BY
            	tour_name
        </cfquery>
        
		<cfreturn qGetAllActiveTours>
        
	</cffunction>
    
    <!--- TOUR FLIGHT INFORMATION - (return format json) --->
    
    <!--- Get Flights --->
    <cffunction name="getFlights" access="remote" returnFormat="json">
    	<cfargument name="studentID" required="yes">
        <cfargument name="tripID" required="yes">
        <cfargument name="flightType" required="yes">
        
        <cfquery name="qGetFlightInformation" datasource="#APPLICATION.DSN#">
        	SELECT
            	*
           	FROM
            	student_tours_flight_information
           	WHERE
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">
          	AND
            	tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.tripID#">
          	AND
            	flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightType#">
           	ORDER BY
            	departDate,
            	departTime
        </cfquery>
        
        <cfscript>
			if (VAL(qGetFlightInformation.recordCount)) {
				return SerializeJson(qGetFlightInformation,true);	
			} else {
				return 0;
			}
		</cfscript>
        
    </cffunction>
    
    <!--- Get flight information --->
    <cffunction name="getFlightInformationByID" access="remote" returnFormat="json">
    	<cfargument name="flightID" required="yes">
        
        <cfquery name="qGetFlightInformation" datasource="#APPLICATION.DSN#">
        	SELECT
            	*
           	FROM
            	student_tours_flight_information
           	WHERE
            	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.flightID#">
        </cfquery>
        
        <cfscript>
			if (VAL(qGetFlightInformation.recordCount)) {
				return SerializeJson(qGetFlightInformation,true);	
			} else {
				return 0;
			}
		</cfscript>
        
    </cffunction>
    
    <!--- Add flight information --->
    <cffunction name="addFlightInformation" access="remote" returnFormat="json">
    	<cfargument name="studentID" required="yes">
        <cfargument name="tripID" required="yes">
        <cfargument name="type" required="yes">
        <cfargument name="date" required="yes">
        <cfargument name="departureCity" required="yes">
        <cfargument name="departureAirportCode" required="yes">
        <cfargument name="arrivalCity" required="yes">
        <cfargument name="arrivalAirportCode" required="yes">
        <cfargument name="flightNumber" required="yes">
        <cfargument name="departureTime" required="yes">
        <cfargument name="arrivalTime" required="yes">
        <cfargument name="overnightFlight" required="yes">
        
        <cftry>
        
        	<cfquery datasource="#APPLICATION.DSN#">
            	INSERT INTO
                	student_tours_flight_information
                    (
                    	studentID,
                        tripID,
                        flightType,
                        departDate,
                        departTime,
                        departCity,
                        departAirportCode,
                        arrivalTime,
                        arrivalCity,
                        arrivalAirportCode,
                        flightNumber,
                        isOvernightFlight,
                        dateCreated
                    )
             	VALUES
                	(
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.tripID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.type#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date#">,
                        <cfqueryparam cfsqltype="cf_sql_time" value="#ARGUMENTS.departureTime#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.departureCity#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.departureAirportCode#">,
                        <cfqueryparam cfsqltype="cf_sql_time" value="#ARGUMENTS.arrivalTime#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalCity#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalAirportCode#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightNumber#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.overnightFlight#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
                    )
            </cfquery>
        
        	<cfscript>
				return 1;
			</cfscript>
            
            <cfcatch type="any">
            	<cfscript>
					return 0;
				</cfscript>
            </cfcatch>
            
     	</cftry>
        
    </cffunction>
    
    <!--- Update flight information --->
    <cffunction name="updateFlightInformation" access="remote" returnFormat="json">
    	<cfargument name="flightID" required="yes">
    	<cfargument name="studentID" required="yes">
        <cfargument name="tripID" required="yes">
        <cfargument name="type" required="yes">
        <cfargument name="date" required="yes">
        <cfargument name="departureCity" required="yes">
        <cfargument name="departureAirportCode" required="yes">
        <cfargument name="arrivalCity" required="yes">
        <cfargument name="arrivalAirportCode" required="yes">
        <cfargument name="flightNumber" required="yes">
        <cfargument name="departureTime" required="yes">
        <cfargument name="arrivalTime" required="yes">
        <cfargument name="overnightFlight" required="yes">
        
        <cftry>
        
        	<cfquery datasource="#APPLICATION.DSN#">
            	UPDATE
                	student_tours_flight_information
              	SET
           			studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">,
                    tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.tripID#">,
                    flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.type#">,
                    departDate = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.date#">,
                    departTime = <cfqueryparam cfsqltype="cf_sql_time" value="#ARGUMENTS.departureTime#">,
                    departCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.departureCity#">,
                    departAirportCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.departureAirportCode#">,
                    arrivalTime = <cfqueryparam cfsqltype="cf_sql_time" value="#ARGUMENTS.arrivalTime#">,
                    arrivalCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalCity#">,
                    arrivalAirportCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.arrivalAirportCode#">,
                    flightNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.flightNumber#">,
                    isOvernightFlight = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(ARGUMENTS.overnightFlight)#">,
                    dateCreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
              	WHERE
                	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.flightID#">
            </cfquery>
        
        	<cfscript>
				return 1;
			</cfscript>
            
            <cfcatch type="any">
            	<cfscript>
					return 0;
				</cfscript>
            </cfcatch>
            
     	</cftry>
        
    </cffunction>
    
    <!--- Delete flight information --->
    <cffunction name="deleteFlightInformation" access="remote" returntype="void">
    	<cfargument name="flightID" required="yes">
        
        <cfquery datasource="#APPLICATION.DSN#">
        	DELETE FROM
            	student_tours_flight_information
           	WHERE
            	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.flightID#">
        </cfquery>
    
    </cffunction>
    
    <!--- END TOUR FLIGHT INFORMATION --->
    
</cfcomponent>