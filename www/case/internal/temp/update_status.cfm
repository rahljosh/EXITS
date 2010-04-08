<cfquery name="status" datasource="caseusa">
select studentid, app_current_status
from smg_students
where active = 1
</cfquery>
<cfloop query="status">
	<cfquery name="insert_current_status" datasource="caseusa">
	INSERT INTO smg_student_app_status
				(studentid, status, date, approvedby)
			values
				(#studentid#, #app_current_status#, #now()#, 1)
	</cfquery>
</cfloop>