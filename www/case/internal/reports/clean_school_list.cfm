<!--- http://web/newsmg/index.cfm?curdoc=reports/clean_school_list --->
<cfquery name="list_schools" datasource="caseusa">
SELECT * 
FROM smg_schools
Order by schoolname
</cfquery>

<table width="100%" align="center" cellpadding="6" cellspacing="0">
<tr>
	<td width="40">School<td>
	<td width="20%">City<td>
	<td width="10%">State<td>
	<td width="10%">Student</td>
	<td width="10%">HF</td>
	<td width="10%">Company</td>
</tr>

<cfloop query="list_schools">
	<cfoutput>
	<cfquery name="duplicates" datasource="caseusa">
	SELECT *
	from smg_schools
	WHERE schoolname like '%#list_schools.schoolname#%' and city like '%#list_schools.city#%'
	ORDER BY schoolname, state, city
	</cfquery>
	</cfoutput>
	
	<cfif duplicates.recordcount GT 1>

		<cfloop query="duplicates">
		<cfoutput>
			<cfquery name="check_link_student" datasource="caseusa">
			Select studentid
			FROM smg_students
			where schoolid = #duplicates.schoolid#
			</cfquery>	
			<cfquery name="check_link_host" datasource="caseusa">
			Select hostid
			FROM smg_hosts
			where schoolid = #duplicates.schoolid#
			</cfquery>
		
			<cfif (check_link_student.recordcount is 0) and (check_link_host.recordcount is 0)>
 				<tr>
					<td width="40%"><font color="FF0000">#duplicates.schoolid# - #duplicates.schoolname#</font><td>
					<td width="20%"><font color="FF0000">#duplicates.city#</font><td>
					<td width="10%"><font color="FF0000">#duplicates.state#</font><td>
					<td width="10%"><font color="FF0000">#check_link_student.studentid#</font></td>
					<td width="10%"><font color="FF0000">#check_link_host.hostid#</font></td>
					<td width="10%"><font color="FF0000">#duplicates.companyid#</font></td>
				</tr>
			<cfelse>
				<tr bgcolor="">
					<td width="40%"><font color="0000FF">#duplicates.schoolid# - #duplicates.schoolname#</font><td>
					<td width="20%"><font color="0000FF">#duplicates.city#</font><td>
					<td width="10%"><font color="0000FF">#duplicates.state#</font><td>
					<td width="15%"><font color="0000FF">#check_link_student.studentid#</font></td>
					<td width="15%"><font color="0000FF">#check_link_host.hostid#</font></td>
					<td width="10%"><font color="0000FF">#duplicates.companyid#</font></td>
				</tr> 
			</cfif>
		</cfoutput>		
		</cfloop>
	<cfelse>
	</cfif>	
</cfloop>		
</table><br>