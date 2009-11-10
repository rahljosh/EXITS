<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfquery name="process_host_app" datasource="MySQL">
update smg_hosts
set dateprocessed = #now()#,
	current_state = "Review"
where hostid = #client.hostid#
</cfquery>
</cftransaction>

<cflocation url="../forms/application_processing.cfm" addtoken="no">

