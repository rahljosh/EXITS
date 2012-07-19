<cfquery name="family_info" datasource="MySQL">
	SELECT
    	*
	FROM
    	smg_hosts
	WHERE
    	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.hostid)#">
</cfquery>