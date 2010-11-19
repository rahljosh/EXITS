


<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		<td width="57%" valign="middle" bgcolor="#E4E4E4" class="title1">&nbsp;Report Viewer </td>
		<td width="42%" align="right" valign="top" bgcolor="#E4E4E4" class="style1"></td>
		<td width="1%"></td>
	</tr>
</table>


<cfquery name="hostcompanies" datasource="mysql">
	select hostcompanyid, name
	from extra_hostcompany
	order by name
</cfquery>
<cfquery name="Programs" datasource="mysql">
	select programid, programname
	from smg_programs
	where companyid = #client.companyid#
</cfquery>

<form name="host" action="reports/students_hired_per_company.cfm" method="post" target="_blank" onsubmit="window.open('', 'foo', 'width=450,height=300,status=yes,resizable=yes,scrollbars=yes')">
<table width=95% align="center">
<cfoutput>
	<tr>
		<td>Company: </td><td>
		<select name=hostcompany >

<cfloop query="hostcompanies">
<option value=#hostcompanyid#>#name#</option>
</cfloop>
</select>
		</td>
	</tr>
	<tr>
		<td>Program:</td><td>
<select name=program>
<cfloop query="programs">
<option value="#programid#">#programname#</option>
</cfloop>
</select>
	</cfoutput>
	
	</td>
</td>
<tr>
<td colspan=2><Input type="submit" value="Generate Report" />
	</td>
</tr>
	<tr>
	<td colspan=2>
		Report will open in a new window.  Close that window any time to generate a new report.<br />
		The window that will open will show the report in FlashPaper Format.  You can print and search using the flashpaper interface.

 </td>
 </tr>
</table>
</form>
