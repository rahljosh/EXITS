<cfquery name="hosts" datasource="mysql">
select host.familylastname, host.fatherssn, host.motherssn, stu.familylastname as stulastname, stu.firstname
from smg_hosts host
LEFT JOIN smg_students stu on stu.hostid = host.hostid
LEFT JOIN php_students_in_program on php_students_in_program.studentid = stu.studentid
where php_students_in_program.active = 1
</cfquery>

<cfloop query="hosts">
#familylastname#,#fatherssn#,#motherssn#, #stulastname#, #stu.firstname#<br>
</cfloop>