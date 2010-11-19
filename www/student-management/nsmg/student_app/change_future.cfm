<cfquery name="current_status" datasource="mysql">
select app_current_status 
from smg_students 
where studentid = #url.studentid#
</cfquery>

<cfquery name="update_status" datasource="mysql">
insert into smg_student_app_status (studentid, status, date, approvedby)
			values(#url.studentid#, <cfif current_status.app_current_status eq 2>25<cfelse>2</cfif>, #now()#,#client.userid#)
</cfquery>
<cfquery name="update_student" datasource="mysql">
update smg_students
	set app_current_status = <cfif current_status.app_current_status eq 2>25<cfelse>2</cfif>
where studentid = #url.studentid#
</cfquery>
<cflocation url="../index.cfm?curdoc=student_app/student_app_list&status=#url.status#">