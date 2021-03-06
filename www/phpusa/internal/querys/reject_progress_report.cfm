<!----reject Report---->
<cflock scope="application" timeout="10">
	<cfquery name="reject_report" datasource="MySQL">
		update smg_document_tracking
			set date_rejected = #CreateODBCDate(now())#,
				date_ra_approved = null,
				date_rd_approved = null,
				note = '#form.reason#',
				rejected_by = #client.userid#
		where report_number = #url.number#
	</cfquery>
</cflock>
<!----
<cfquery name="insert_link" datasource="MySQL">
	insert into smg_links (link)
		values ('https://www.student-management.com/nsmg/index.cfm?curdoc=forms/view_progress_report&number=#url.number#')
</cfquery>

<cfquery name="find_link" datasource="MySQL">
	Select Max(id) as id
	from smg_links
</cfquery>
---->
<cfquery name="get_user" datasource="mysql">
	select distinct userid from smg_prquestion_details
	where report_number = #url.number#
</cfquery>

<cfquery name="get_email" datasource="mysql">
	select email from smg_users where userid = #get_user.userid#
</cfquery>

<cfquery name="get_rejector" datasource="mysql">
	select rejected_by, note from smg_document_tracking
	where report_number = #url.number#
</cfquery>

<cfquery name="rejector_email" datasource="MySQL">
	select email from smg_users where userid = #get_rejector.rejected_by#
</cfquery>

<cfoutput>

<cfmail to="#get_email.email#"  from="#rejector_email.email#" subject="PHP - Progress Report Rejected" >
A report you submitted has been rejected.   

To view the report and make necessary changes please visit http://www.phpusa.com/ 
	
*Authentication is required if you are not logged in.*

Reason given for rejection:
#get_rejector.note#

====================================================
This is message was automaticall generated by PHP. 
This message may contain confidential information.
If you have any concerns please immediately contact
support@student-management.com
=====================================================
</cfmail>


</cfoutput>

<cflocation url = "../index.cfm?curdoc=lists/progress_report_list" addtoken="no">
	