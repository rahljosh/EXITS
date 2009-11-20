<!----Approve Report---->

<cflock timeout="10" throwontimeout="no" type="exclusive" scope="session">
<cfquery name="approve_report" datasource="MySQL">
update smg_document_tracking
	<Cfif client.usertype is 7>
	set date_ra_approved = #now()#
	</Cfif>
	<Cfif client.usertype is 5>
	set date_rd_approved = #now()#
	</Cfif>
	<Cfif client.usertype LTE 4>
	set ny_accepted = #now()#,
		note = 'Report approved by #client.firstname# #client.lastname#'
	</Cfif>
	  ,date_rejected = null
where report_number = #url.number#
</cfquery>
<cfif client.usertype lte 4>
<cfquery name="update_evaluations" datasource="mysql">
update php_students_in_program
set
<cfif url.month eq 9>
doc_evaluation1 = #now()#
<cfelseif url.month eq 12>
doc_evaluation2 = #now()#
<cfelseif url.month eq 2>
doc_evaluation3 = #now()#
<cfelseif url.month eq 4>
doc_evaluation4 = #now()#
<cfelseif url.month eq 6>
doc_evaluation5 = #now()#
</cfif>
where studentid = #url.stu#
</cfquery>

</cfif>
</cflock>
<cfif client.usertype lt 7>
	<cfif IsDefined('url.regionid')>
		<cflocation url = "index.cfm?curdoc=lists/progress_report_list&regionid=#url.regionid#" addtoken="no">
	<cfelse>
		<cflocation url = "index.cfm?curdoc=lists/progress_report_list" addtoken="no">
	</cfif>
<cfelse>
	<cflocation url = "index.cfm">
</cfif>