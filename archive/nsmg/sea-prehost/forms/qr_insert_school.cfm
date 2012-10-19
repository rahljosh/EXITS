<cfquery name="insert_school" datasource="mysql">
update smg_hosts set 
	schoolid = #form.school#
where hostid = #url.hostid#
</cfquery>
<cfoutput>
<Cflocation url="index.cfm?curdoc=forms/host_fam_pis_3&hostid=#url.hostid#">
</cfoutput>