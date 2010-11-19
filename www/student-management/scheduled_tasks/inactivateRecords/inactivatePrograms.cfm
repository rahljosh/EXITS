<!--- Kill Extra Output --->
<cfsilent>

	<!--- Set Programs to Inactive if Program End Date is > 120 days --->
    <cfquery name="qGetExpiredPrograms" datasource="MySql">
        UPDATE
            smg_programs 
        SET 
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        WHERE
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes">)
        AND        
            DATE_ADD(endDAte, INTERVAL 90 DAY) < now()
    </cfquery>

</cfsilent>