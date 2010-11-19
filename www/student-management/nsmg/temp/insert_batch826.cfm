<cfquery name="batch826" datasource="Mysql">
select smg_students.studentid , smg_students.hostid, smg_schools.schoolname
from smg_students
LEFT JOIN smg_schools on smg_schools.schoolid = smg_students.schoolid
where smg_students.sevis_batchid = 808
</cfquery>

<cfloop query="batch826">
<cfif schoolname is ''><cfset schoolnm = 'International Student Exhange' ><cfelse><cfset schoolnm = '#schoolname#'></cfif>
	<cfquery name="insertbatch826" datasource="MySQL">
		insert into smg_sevis_history (batchid, studentid, hostid, school_name, start_date, end_date)
					values ( 808, #studentid#, #hostid#, '#schoolnm#', '2008-07-20', '2009-06-30')
	</cfquery>
</cfloop>