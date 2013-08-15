<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<CFQUERY name="selectdb" datasource="#APPLICATION.DSN#">
USE smg
</CFQUERY>
<cfquery name="process_host_app" datasource="#APPLICATION.DSN#">
	UPDATE smg_hosts
	SET dateprocessed = #now()#,
		current_state = "Review",
        dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
	WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.hostID)#">
</cfquery>
</cftransaction>

<cflocation url="../forms/application_processing.cfm" addtoken="no">

