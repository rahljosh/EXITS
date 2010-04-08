<cfquery name="get_students_host" datasource="caseusa">
select smg_students.studentid, smg_students.hostid, smg_hosts.*
from smg_students inner join smg_hosts
where (smg_students.studentid = #client.studentid#) and (smg_students.hostid = smg_hosts.hostid)
</cfquery>

