<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_interests" datasource="mysql">
Update smg_hosts
set interests = '#form.interest#',
	interests_other = '#form.specific_interests#' 
where hostid = #client.hostid#

</cfquery>
</cftransaction>
 <cflocation url="../index.cfm?curdoc=forms/host_fam_pis_5" addtoken="No">