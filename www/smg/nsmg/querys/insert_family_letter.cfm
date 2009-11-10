<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfquery name="insert_family_letter" datasource="MySQL">
update smg_hosts
	set familyletter = "#form.letter#"
where hostid = #client.hostid#
</cfquery>
</cftransaction>
<cflocation url="../index.cfm?curdoc=forms/family_app_12" addtoken="no">
