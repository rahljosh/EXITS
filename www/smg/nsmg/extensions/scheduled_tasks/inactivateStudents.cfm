<!--- Kill Extra Output --->
<cfsilent>

	<!--- Set Students to Inactive if assigned to an inactive program --->
    <cfquery datasource="MySql">
        UPDATE
            smg_students 
        SET 
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        WHERE
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12" list="yes">)
		AND
        	programID IN (
            	SELECT 
                	programID
				FROM
                	smg_programs
                WHERE
                	active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            )            
    </cfquery>

</cfsilent>