<cfquery name="check_insurance" datasource="MySQL">
select stu.studentid, stu.familylastname, stu.firstname, stu.programid
from smg_students stu
where active = 1
and companyid = #client.companyid#
</cfquery>
<cfdump var="#check_insurance#">