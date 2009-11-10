<cfquery name="get_students_area_rep_follow" datasource="MySQL">
select smg_students.studentid, smg_students.arearepid, smg_users.*
from smg_students inner join smg_users
where (smg_students.studentid = #client.studentid#) and (smg_students.arearepid = smg_users.userid)
</cfquery>
