<!----reject Report---->
<cflock scope="application" timeout="10">
	<cfquery name="reject_report" datasource="caseusa">
		update smg_document_tracking
			set date_rejected = #CreateODBCDate(now())#,
				date_ra_approved = null,
				date_rd_approved = null,
				note = '#form.reason#',
				rejected_by = #client.userid#
		where report_number = #url.number#
	</cfquery>
</cflock>

<cfquery name="insert_link" datasource="caseusa">
	insert into smg_links (link)
		values ('https://www.student-management.com/nsmg/index.cfm?curdoc=forms/view_progress_report&number=#url.number#')
</cfquery>

<cfquery name="find_link" datasource="caseusa">
	Select Max(id) as id
	from smg_links
</cfquery>

<cfquery name="get_user" datasource="caseusa">
	select userid from smg_prquestion_details
	where report_number = #url.number#
</cfquery>

<cfquery name="get_email" datasource="caseusa">
	select email from smg_users where userid = #get_user.userid#
</cfquery>

<cfquery name="get_rejector" datasource="caseusa">
	select rejected_by, note from smg_document_tracking
	where report_number = #url.number#
</cfquery>

<cfquery name="rejector_email" datasource="caseusa">
	select email from smg_users where userid = #get_rejector.rejected_by#
</cfquery>

<cfoutput>

<cfmail to="#get_email.email#"  from="support@case-usa.org" subject="Progress Report Rejected" >
A report you submitted has been rejected.   

To view the report and make necessary changes please visit https://www.case-usa.org/
	
Reason given for rejection:
#get_rejector.note#

====================================================
This is message was automatically generated by CASE. 
This message may contain confidential information.
If you have any concerns please immediately contact
support@case-usa.org
=====================================================
</cfmail>

<cfif client.usertype eq 4>

<cfquery name="student" datasource="caseusa">
	select stuid from smg_prquestion_details
	where report_number = #url.number#
</cfquery>

<cfquery name="rdemail" datasource="caseusa">
	SELECT smg_students.regionassigned, user_access_rights.userid, smg_users.email
	FROM smg_students
	LEFT JOIN user_access_rights ON  user_access_rights.regionid = smg_students.regionassigned
	LEFT JOIN smg_users ON smg_users.userid = user_access_rights.userid
	WHERE studentid = #student.stuid# 
		AND user_access_rights.usertype = 5
		AND smg_users.active = '1'
</cfquery>

<cfmail to="#rdemail.email#" failto="support@case-usa.org" from="support@case-usa.org" subject="Progress Report Rejected" >
A report you approved to headquarters has been rejected by the facilitator.  The report is waiting for the Area Rep to make corrections.

To view the report and reason it was rejected please visit https://www.case-usa.org/
	
*Authentication is required if you are not logged in.*

Reason given for rejection:
#get_rejector.note#

====================================================
This is message was automatically generated by CASE. 
This message may contain confidential information.
If you have any concerns please immediately contact
support@case-usa.org
=====================================================
</cfmail>

</cfif>

</cfoutput>

<cflocation url = "../index.cfm?curdoc=forms/progress_report_list" addtoken="no">
	