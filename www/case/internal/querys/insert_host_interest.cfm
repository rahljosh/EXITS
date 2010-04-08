<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_interests" datasource="caseusa">
Update smg_hosts
set interests = '#form.interest#',
    band = '#form.band#',
	orchestra = '#form.orchestra#',
	comp_sports = '#form.comp_sports#',
	interests_other = '#form.specific_interests#' 
where hostid = #client.hostid#

</cfquery>
</cftransaction>
 <cflocation url="../index.cfm?curdoc=forms/family_app_4" addtoken="No">