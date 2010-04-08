<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<CFQUERY name="selectdb" datasource="caseusa">
USE smg
</CFQUERY>
<cfquery name="process_host_app" datasource="caseusa">
update smg_hosts
set dateprocessed = #now()#,
	current_state = "Review"
where hostid = #client.hostid#
</cfquery>
</cftransaction>

<cflocation url="../forms/application_processing.cfm" addtoken="no">

