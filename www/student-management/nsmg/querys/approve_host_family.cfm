<!----Update Status of Host Fam Approved---->
<cfquery name="get_current_status" datasource="MySQL">
select host_fam_approved from smg_students
where studentid = #cookie.review_student#
</cfquery>


<cfif client.usertype is 4>
<cfset currentstatus = 1>
<Cfelse>
<cfset currentstatus = #client.usertype# - 1>
</cfif>
<cfoutput>
#client.usertype# #get_Current_Status.host_fam_approved#
</cfoutput>
<cfif client.usertype lte #get_Current_status.host_fam_approved# or #get_Current_status.host_fam_approved# is 99>
	<cfquery name="update_report" datasource="MySQL">
	update smg_students
	set host_fam_approved = #currentstatus#
	where studentid =#cookie.review_student#
	</cfquery>
</cfif>

	<cfcookie name="review_host"  value=0 expires="now">
	<cfcookie name="review_student"  value=0 expires="now">
	
	
<cflocation url="../index.cfm?curdoc=pendingPlacementList">

