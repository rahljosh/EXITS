<!----Approve Report---->
<cflock timeout="10" throwontimeout="no" type="exclusive" scope="session">
<cfquery name="approve_report" datasource="caseusa">
update smg_document_tracking
	<Cfif client.usertype is 6>
	set date_ra_approved = #now()#
	</Cfif>
	<Cfif client.usertype is 5>
	set date_rd_approved = #now()#
	</Cfif>
	<Cfif client.usertype LTE 4>
	set ny_accepted = #now()#,
		note = 'Report approved by #client.name#'
	</Cfif>
	  ,date_rejected = null
where report_number = #url.number#
</cfquery>
</cflock>
<cfif client.usertype lt 7>
	<cfif IsDefined('url.regionid')>
		
			<cflocation url = "index.cfm?curdoc=forms/progress_report_list&regionid=#url.regionid#" addtoken="no">
		
	<cfelse>
		
			<cflocation url = "index.cfm?curdoc=forms/progress_report_list" addtoken="no">
		
	</cfif>
<cfelse>
	<cflocation url = "index.cfm">
</cfif>