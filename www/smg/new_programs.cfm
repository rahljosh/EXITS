<cfoutput>
<cfquery name="current_programs" datasource="mysql">
SELECT smg_students.studentid, smg_students.programid as students_program, smg_students.regionassigned, smg_students.companyid as students_company, smg_programs.programname, smg_programs.type as current_type, smg_programs.companyid as program_company, smg_programs.startdate
from smg_students
left join smg_programs on smg_programs.programid = smg_students.programid
where regionassigned = #url.region#
and smg_students.active = 1

order by students_program
</cfquery>
#current_programs.recordcount#
<table border=1>
	<tr>
		<td></td><td>Student ID</td><td>Region</td><td>Students Current Company<Td>Current Program</Td><td>Program ID</td><TD>Current Programs Company</TD><td>Current Program Type</td><td>New Program</td><td>Program ID</td><td>New Programs Company</td><Td>New Program Type</Td>
	</td>
<cfloop query="current_programs">
		<cfquery name="new_program" datasource="mysql">
		select programname as new_program, type as new_type, companyid as new_program_company, programid
		from smg_programs 
		where active = 1 and type =#current_type# and companyid = #students_company# and
		
			startdate = #startdate#
		
		</cfquery>
		<cfquery name="old_program" datasource="mysql">
		select programname as new_program, type as new_type, companyid as new_program_company, programid
		from smg_programs 
		where startdate = #startdate# and programid > 190 and type =#current_type# and companyid = #students_company#		  
		</cfquery>
	<tr>
		<Td>#current_programs.currentrow#</Td><Td>#studentid#</Td><td>#regionassigned#</td><td>#students_company#</td><Td>#programname#</Td><td>#current_programs.students_program#</td><td>#program_company#</td><td>#current_type#</td>
<Cfif current_programs.startdate lt '2009-07-01'>
		<td>#old_program.new_program#</td><td>#old_program.programid#</td><td>#old_program.new_program_company#</td><td>#old_program.new_type#</td><td>Update smg_students set programid = #old_program.programid# where studentid = #studentid# Q1</td>

	<cfquery name="update_students_old" datasource="mysql">
	Update smg_students set programid = #old_program.programid# where studentid = #studentid#
	limit 1
	</cfquery>

<cfelse>
		<td>#new_program.new_program#</td><td>#new_program.programid#</td><td>#new_program.new_program_company#</td><td>#new_program.new_type#</td><td>Update smg_students set programid = #new_program.programid# where studentid = #studentid# Q2</td>

	<cfquery name="update_students_new" datasource="mysql">
	Update smg_students set programid = #new_program.programid# where studentid = #studentid#
	limit 1
	</cfquery>

</Cfif>
	</tr>
</cfloop>
</table>
</cfoutput>