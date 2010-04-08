<!----Update Family Album---->
<cfquery name="studentid" datasource="caseusa">
select smg_id 
from smg_student_app_family_album
where studentid = 0
</cfquery>

<cfloop query="studentid">
	<cfquery name="get_cor_id" datasource="caseusa">
	select studentid
	from smg_students
	where smg_id = #smg_id#
	</cfquery>

	<cfquery name="update_studentid" datasource="caseusa">
	update smg_student_app_family_album
		set studentid = #get_cor_id.studentid#
		where smg_id = #smg_id#
	</cfquery>

</cfloop>

<!----Update ID for siblings---->

<cfquery name="studentid1" datasource="caseusa">
select smg_id 
from smg_student_siblings
where studentid = 0
</cfquery>

<cfloop query="studentid1">

	<cfquery name="get_cor_id1" datasource="caseusa">
	select studentid
	from smg_students
	where smg_id = #smg_id#
	</cfquery>

	<cfquery name="update_studentid1" datasource="caseusa">
	update smg_student_siblings
		set studentid = #get_cor_id1.studentid#
		where smg_id = #smg_id#
	</cfquery>

</cfloop>

