<cfquery name="ins_report" datasource="mysql">
SELECT distinct ins.studentid,  ins.submitted, 
stu.studentid as sid, stu.firstname, stu.familylastname, stu.intrep,
smg_users.businessname, smg_programs.programname as prog_name
FROM  smg_insurance_batch ins
Right outer join smg_students stu on stu.studentid = ins.studentid
left join smg_users on smg_users.userid = stu.intrep
left join smg_programs on smg_programs.programid = stu.programid
where stu.active = 1
and stu.companyid = #client.companyid#
order by prog_name, submitted, familylastname
</cfquery>
<cfoutput>

<table align="center">
	<tr>
		<td colspan=5 align="center">#ins_report.recordcount# students in included in report.</td>
	</tr>
	<tr>
		<Td>Student ID</Td><td>Student Name</td><Td>Programs</Td><td>Int. Rep</td><td>Insurance Submitted</td>
	</tr>

	<cfloop query="ins_report">
	<tr   bgcolor="#iif(ins_report.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" >
		<td>#sid#</td><td>#familylastname#, #firstname#</td><td>#prog_name#<td>#businessname#</td><td><cfif submitted is ''>No Record Found<cfelse>#DateFormat(submitted, 'mm/dd/yyyy')#</cfif></td>
	</tr>
	</cfloop>
</table>
</cfoutput>