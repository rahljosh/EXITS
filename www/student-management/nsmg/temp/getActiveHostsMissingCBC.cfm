<!--- ------------------------------------------------------------------------- ----
	
	File:		getActiveHostsMissingCBC.cfm
	Author:		Marcus Melo
	Date:		April 17, 2012
	Desc:		
	
	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Active Hosts ---->
    <cfquery name="qGetMissingFather" datasource="mysql">
        SELECT DISTINCT
            h.hostID,
            h.familyLastName,
            h.fatherFirstName,
            r.regionName
       	FROM
        	smg_hosts h
        LEFT OUTER JOIN
        	smg_hosts_cbc cbc ON cbc.hostID = h.hostID
            	AND	
                	cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="father">
        INNER JOIN
        	smg_students s ON s.hostID = h.hostID
            	AND
                	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				AND
                	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,12" list="yes"> )                     
		INNER JOIN
        	smg_programs p ON p.programID = s.programID
            	AND
                	p.endDate <= <cfqueryparam cfsqltype="cf_sql_date" value="2012-06-30">
        INNER JOIN
        	smg_regions r ON r.regionID = h.regionID
        WHERE
        	h.fatherFirstName != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        AND
        	cbc.hostID IS NULL
        <!---
		AND
			h.hostID NOT IN ( SELECT hostID FROM smg_hosts_cbc WHERE cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="father"> )  
		--->
		ORDER BY
            r.regionName 
    </cfquery>

    <cfquery name="qGetMissingMother" datasource="mysql">
        SELECT DISTINCT
            h.hostID,
            h.familyLastName,
            h.motherFirstName,
            r.regionName
       	FROM
        	smg_hosts h
        LEFT OUTER JOIN
        	smg_hosts_cbc cbc ON cbc.hostID = h.hostID
            	AND	
                	cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="mother">
        INNER JOIN
        	smg_students s ON s.hostID = h.hostID
            	AND
                	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				AND
                	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,12" list="yes"> )                     
		INNER JOIN
        	smg_programs p ON p.programID = s.programID
            	AND
                	p.endDate <= <cfqueryparam cfsqltype="cf_sql_date" value="2012-06-30">
        INNER JOIN
        	smg_regions r ON r.regionID = h.regionID
        WHERE
        	h.motherFirstName != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        AND
        	cbc.hostID IS NULL
        <!---
        AND
            h.hostID NOT IN ( SELECT hostID FROM smg_hosts_cbc WHERE cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="mother"> )  
		--->
        ORDER BY
            r.regionName 
    </cfquery>

</cfsilent>

 
<cfdump var="#qGetMissingFather.recordCount#">

<cfdump var="#qGetMissingMother.recordCount#">