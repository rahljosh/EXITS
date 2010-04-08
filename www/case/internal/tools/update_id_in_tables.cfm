<!----Get all id's from smg_students that CASE has registered---->
<cfquery name="corresponding_smg_id" datasource="caseusa">
select studentid, smg_id
from smg_students
</cfquery>

<cfloop query="corresponding_smg_id">
	<cfquery name="update_app_health" datasource="caseusa">
	update smg_student_app_health set studentid = #studentid#
	where smg_id = #smg_id#
	</cfquery>
	
	<cfquery name="smg_student_app_school_year" datasource="caseusa">
	update smg_student_app_school_year set studentid = #studentid#
	where smg_id = #smg_id#
	</cfquery>
	
	<cfquery name="smg_student_app_shots" datasource="caseusa">
	update smg_student_app_shots set studentid = #studentid#
	where smg_id = #smg_id#
	</cfquery>
	
	<cfquery name="smg_student_app_state_requested" datasource="caseusa">
	update smg_student_app_state_requested set studentid = #studentid#
	where smg_id = #smg_id#
	</cfquery>
	
	<cfquery name="smg_student_app_status" datasource="caseusa">
	update smg_student_app_status set studentid = #studentid#
	where smg_id = #smg_id#
	</cfquery>
</cfloop>