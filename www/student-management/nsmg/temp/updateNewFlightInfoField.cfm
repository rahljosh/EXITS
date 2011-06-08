<cfsetting requesttimeout="9999">

<!--- UPDATE isCompleted 06/08/2011 --->

<cfquery name="qGetNotCompleted" datasource="mysql">
	SELECT
		flightID,
        dep_date,
        dep_airCode,
        arrival_airCode,
        flight_number,
        arrival_time
    FROM
    	smg_flight_info
    WHERE	
    	isCompleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
</cfquery>


<cfloop query="qGetNotCompleted">

	<cfscript>
        isCompleted = APPLICATION.CFC.STUDENT.isFlightInformationComplete(
            depDate=qGetNotCompleted.dep_date,
            depAirCode=qGetNotCompleted.dep_airCode,
            arrivalAirCode=qGetNotCompleted.arrival_airCode,
            flightNumber=qGetNotCompleted.flight_number,
            arrivalTime=qGetNotCompleted.arrival_time
        );
    </cfscript>

    <cfquery datasource="mysql">
        UPDATE
            smg_flight_info
        SET
        	isCompleted = <cfqueryparam cfsqltype="cf_sql_integer" value="#isCompleted#">
        WHERE	
            flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetNotCompleted.flightID#">
    </cfquery>

</cfloop>

<p>
	<cfdump var="#qGetNotCompleted.recordCount#"> found - Done!
</p>

<!--- END OF UPDATE isCompleted 06/08/2011 --->


<!---

<!--- Update PreAYP --->
<cfquery name="qGetPreAYP" datasource="mysql">
	SELECT
		flightID
    FROM
    	smg_flight_info
    WHERE	
    	isPreAYP = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>

<cfloop query="qGetPreAYP">
	
    <cfquery datasource="mysql">
        UPDATE
            smg_flight_info
        SET
        	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="preAYPArrival">
        WHERE	
            flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPreAYP.flightID#">
    </cfquery>
    
</cfloop>

<p>Pre-Ayp Updated</p>

<!--- Update dateCreated --->
<cfquery name="qGetInputDate" datasource="mysql">
	SELECT
		flightID,
        input_date
    FROM
    	smg_flight_info
    WHERE	
    	input_date IS NOT NULL
	AND
    	dateCreated IS NULL
	LIMIT
    	5000        
</cfquery>

<cfloop query="qGetInputDate">
	
    <cfquery datasource="mysql">
        UPDATE
            smg_flight_info
        SET
        	dateCreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qGetInputDate.input_date#">
        WHERE	
            flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetInputDate.flightID#">
    </cfquery>
    
</cfloop>

<p>Date Created</p>

--->

