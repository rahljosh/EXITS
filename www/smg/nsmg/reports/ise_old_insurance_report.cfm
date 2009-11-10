

<cfquery name="students" datasource="MySQL">
select stu.studentid, stu.firstname, stu.familylastname, pro.programname,
smg_insurance.insuranceid, smg_insurance.studentid, smg_insurance.firstname, smg_insurance.lastname, smg_insurance.sex,
smg_insurance.dob, smg_insurance.country_code, smg_insurance.new_date, smg_insurance.end_date, smg_insurance.sent_to_caremed, 
smg_insurance.org_code, smg_insurance.policy_code, smg_insurance.transtype, pro.programname,
smg_users.businessname
from smg_students stu
left join smg_programs pro on stu.programid = pro.programid
left join smg_insurance on smg_insurance.studentid = stu.studentid
left join smg_users on smg_users.userid = stu.intrep
where stu.programid = 167

order by smg_users.businessname, simpsonsmg_insurance.policy_code, stu.familylastname
</cfquery>

<cfoutput>
	1
<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><!--- <td><b>Previous Date</b> ---></td>
	<td>Agent</td>
	<td>Student ID</td>
		<td><strong>Last Name</strong></td>
		<td><strong>First Name</strong></td>
		<td><b>Transaction</b></td>
		<td><b>Sex</b></td>
		<td><b>DOB</b></td>
		<td><b>Country</b></td>
		<td><b>Start Date</b></td>
		<td><b>End Date</b></td>
		<td><b>Org. Code</b></td>		
		<td><b>Policy Code</b></td>		
		<td><b>Program Name</b></td>		
		<td><b>Sent on</b></td>
	</tr>
<cfloop query="students">

	

	
				<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
<!--- 		<td><cfif previous_date is ''>1<sup>st</sup> File<cfelse>#DateFormat(previous_date, 'mm/dd/yyyy')#</cfif></td> --->	
				<td>#studentid#</td>
				<td>#businessname#</td>
				<td>#familylastname#</td>
				<td>#firstname#</td>
				<td>#transtype#</td>
				<td>#sex#</td>
				<td>#DateFormat(dob, 'mm/dd/yyyy')#</td>
				<td>#country_code#</td>
				<td>#DateFormat(new_date, 'mm/dd/yyyy')#</td>
				<td>#DateFormat(end_date, 'mm/dd/yyyy')#</td>				
				<td>#org_code#</td>		
				<td>#policy_code#</td>		
				<td>#programname#</td>
				<td><cfif sent_to_caremed EQ ''>File has not been sent<cfelse></cfif>#DateFormat(sent_to_caremed, 'mm/dd/yyyy')#</td>
			</tr>
	
		
</cfloop>
</table>
</cfoutput>
done.....