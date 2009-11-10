<cfquery name="current_status" datasource="mysql">
SELECT max(STATUS)as status , studentid
FROM smg_student_app_status
GROUP BY studentid
</cfquery>
<cfdump var="#current_status#">


<cfloop query="current_status">
	<cfquery name="update_current_status" datasource="mysql">
	update smg_students
	set app_current_status = #status#
	where studentid = #studentid#
	</cfquery>
</cfloop>
