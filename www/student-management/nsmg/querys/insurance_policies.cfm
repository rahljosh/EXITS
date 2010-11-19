<cfquery name="insurance_policies" datasource="MySql">
	SELECT 
    	insutypeid, 
        type 
	FROM 
    	smg_insurance_type
    WHERE
    	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>
