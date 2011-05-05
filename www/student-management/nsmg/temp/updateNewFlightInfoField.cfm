<cfsetting requesttimeout="9999">

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

