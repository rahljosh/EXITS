<!--- ------------------------------------------------------------------------- ----
	
	File:		updateFlightInfoProgramID.cfm
	Author:		Marcus Melo
	Date:		May 19, 2011
	Desc:		Updates programID for flight information records without a program
	
	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<cfquery name="qGetISEArrival" datasource="mySQL">
    	SELECT
        	f.flightID,
            f.studentID,
            f.companyID,
            f.dep_date,            
            s.programID,            
            p.startDate,
            p.endDate
        FROM
        	smg_flight_info f
		INNER JOIN
        	smg_students s ON s.studentID = f.studentID
		INNER JOIN
        	smg_programs p ON p.programID = s.programID            
        WHERE	
        	f.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
		AND
        	f.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">            
		AND
        	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )  
        AND
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		LIMIT 
        	10000                      
    </cfquery>

	<cfquery name="qGetISEDeparture" datasource="mySQL">
    	SELECT
        	f.flightID,
            f.studentID,
            f.companyID,
            f.dep_date,            
            s.programID,            
            p.startDate,
            p.endDate
        FROM
        	smg_flight_info f
		INNER JOIN
        	smg_students s ON s.studentID = f.studentID
		INNER JOIN
        	smg_programs p ON p.programID = s.programID            
        WHERE	
        	f.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
		AND
        	f.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">            
		AND
        	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes"> )   
        AND
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		LIMIT 
        	10000                                           
    </cfquery>

	<cfquery name="qGetPHPArrival" datasource="mySQL">
    	SELECT
        	f.flightID,
            f.studentID,
            f.companyID,
            f.dep_date,            
            s.programID,            
            p.startDate,
            p.endDate
        FROM
        	smg_flight_info f
		INNER JOIN
        	php_students_in_program s ON s.studentID = f.studentID
		INNER JOIN
        	smg_programs p ON p.programID = s.programID            
        WHERE	
        	f.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
		AND	
	        f.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">               
		AND
        	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="6"> 
        AND
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		LIMIT 
        	10000                      
    </cfquery>

	<cfquery name="qGetPHPDeparture" datasource="mySQL">
    	SELECT
        	f.flightID,
            f.studentID,
            f.companyID,
            f.dep_date,            
            s.programID,            
            p.startDate,
            p.endDate
        FROM
        	smg_flight_info f
		INNER JOIN
        	php_students_in_program s ON s.studentID = f.studentID
		INNER JOIN
        	smg_programs p ON p.programID = s.programID            
        WHERE	
        	f.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
		AND	
	        f.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">               
		AND
        	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="6">   
        AND
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        LIMIT 
        	10000                      
    </cfquery>
    
</cfsilent>    

<cfoutput>

	<!--- ISE Arrival --->
    <cfloop query="qGetISEArrival">
        
        <cfif qGetISEArrival.dep_date GT DateAdd("d", -60, qGetISEArrival.startDate) AND qGetISEArrival.dep_date LT DateAdd("d", 60, qGetISEArrival.endDate)>
        
            <cfquery datasource="mySQL">
                UPDATE
                    smg_flight_info
                SET
                    programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetISEArrival.programID#">
                WHERE	
                    flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetISEArrival.flightID#">
            </cfquery>
            
        <cfelse>
            
            <p>
                ISE | StudentID: #qGetISEArrival.studentID# | Arrival: #qGetISEArrival.dep_date# | Program Start: #DateAdd("d", -60, qGetISEArrival.startDate)# | Program End: #DateAdd("d", 60, qGetISEArrival.endDate)#
            </p>
            
        </cfif>
        
    </cfloop>
    
    <!--- ISE Departure --->
    <cfloop query="qGetISEDeparture">
        
        <cfif qGetISEDeparture.dep_date GT DateAdd("d", -60, qGetISEDeparture.startDate) AND qGetISEDeparture.dep_date LT DateAdd("d", 60, qGetISEDeparture.endDate)>
        
            <cfquery datasource="mySQL">
                UPDATE
                    smg_flight_info
                SET
                    programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetISEDeparture.programID#">
                WHERE	
                    flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetISEDeparture.flightID#">
            </cfquery>
            
        <cfelse>
            
            <p>
                ISE | StudentID: #qGetISEDeparture.studentID# | Departure: #qGetISEDeparture.dep_date# | Program Start: #DateAdd("d", -60, qGetISEDeparture.startDate)# | Program End: #DateAdd("d", 60, qGetISEDeparture.endDate)#
            </p>
            
        </cfif>
        
    </cfloop>


	<!--- PHP Arrival --->
    <cfloop query="qGetPHPArrival">
        
        <cfif qGetPHPArrival.dep_date GT DateAdd("d", -60, qGetPHPArrival.startDate) AND qGetPHPArrival.dep_date LT DateAdd("d", 60, qGetPHPArrival.endDate)>
        
            <cfquery datasource="mySQL">
                UPDATE
                    smg_flight_info
                SET
                    programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPHPArrival.programID#">
                WHERE	
                    flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPHPArrival.flightID#">
            </cfquery>
            
        <cfelse>
            
            <p>
                PHP | StudentID: #qGetPHPArrival.studentID# | Arrival: #qGetPHPArrival.dep_date# | Program Start: #DateAdd("d", -60, qGetPHPArrival.startDate)# | Program End: #DateAdd("d", 60, qGetPHPArrival.endDate)#
            </p>
            
        </cfif>
        
    </cfloop>
    
    <!--- PHP Departure --->
    <cfloop query="qGetPHPDeparture">
        
        <cfif qGetPHPDeparture.dep_date GT DateAdd("d", -60, qGetPHPDeparture.startDate) AND qGetPHPDeparture.dep_date LT DateAdd("d", 60, qGetPHPDeparture.endDate)>
        
            <cfquery datasource="mySQL">
                UPDATE
                    smg_flight_info
                SET
                    programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPHPDeparture.programID#">
                WHERE	
                    flightID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPHPDeparture.flightID#">
            </cfquery>
            
        <cfelse>
            
            <p>
                PHP | StudentID: #qGetPHPDeparture.studentID# | Departure: #qGetPHPDeparture.dep_date# | Program Start: #DateAdd("d", -60, qGetPHPDeparture.startDate)# | Program End: #DateAdd("d", 60, qGetPHPDeparture.endDate)#
            </p>
            
        </cfif>
        
    </cfloop>

</cfoutput>    

Done!!!
    
