<cftransaction action="BEGIN" isolation="SERIALIZABLE">

<Cfquery name="update_transportation" datasource="caseusa">
update smg_hosts
	set schooltransportation = "#form.transportation#",
		school_trans = "#form.other_desc#"
where hostid = #client.hostid#
</cfquery>
</cftransaction>
<cflocation url="../index.cfm?curdoc=forms/host_fam_pis_6" addtoken="no">