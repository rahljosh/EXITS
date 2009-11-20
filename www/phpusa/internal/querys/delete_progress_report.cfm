<cfif not isDefined('url.approve')>
<span class="application_section_header">Confirm Delete</span><br>
<cfoutput>
<br />
<div align="center">Are you sure that you want to delete this report?<br><a href="index.cfm?curdoc=querys/delete_progress_report&report_number=#url.number#&approve">Yes</a> :: 
	<cfif IsDefined('url.regionid')>
		<a href=index.cfm?curdoc=forms/view_progress_report&number=#url.number#&regionid=#url.regionid#>No</a>
	<cfelse>
		<a href=index.cfm?curdoc=forms/view_progress_report&number=#url.number#>No</a>
	</cfif>
</div>
<br />
</cfoutput>
<cfelse>
<cfquery name="delete_progress_report" datasource="MySQL">
	delete from smg_document_tracking
	where report_number = #url.report_number#
</cfquery>
<cfquery name="delete_pr" datasource="MySQL">
	delete from smg_prquestion_details
	where report_number = #url.report_number#
</cfquery>
<cflocation url = "index.cfm">
</cfif>