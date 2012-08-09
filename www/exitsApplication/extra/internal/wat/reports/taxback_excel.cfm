<cfquery name="get_candidates" datasource="mysql">
	select c.firstname, c.candidateid,c.lastname, c.sex, c.citizen_country, c.dob, c.email, c.home_phone, c.programid, c.status,
	p.programname, smg_countrylist.countryname
	FROM extra_candidates c
	LEFT JOIN smg_programs p on p.programid = c.programid
	LEFT JOIN smg_countrylist on smg_countrylist.countryid = c.citizen_country
	WHERE c.programid = #url.program#
	AND c.status <> 'canceled'
	ORDER BY c.firstname
</cfquery> 


<cfquery name="program_info" datasource="mysql">
	select programname
	from smg_programs
	where programid = #url.program#
</cfquery> 

<cfoutput>

<cfcontent type="application/msexcel"> 
<cfheader name="Content-Disposition" value="attachment; filename=taxback.xls"> 

<table width="960" align="center">
	<tr>
		<td colspan="6" bgcolor="##CCCCCC"><font face="arial" size="3"><b>Taxback Report</b></font></td>
	</tr>
	<tr>
		<td width="50%" colspan="3"><font face="arial" size="2"><strong>Program:</strong> #program_info.programname#</font>
	  </td>
		<td width="50%" colspan="3"><font face="arial" size="2"><strong>Total Students:</strong> #get_candidates.recordcount#</font>
		</td>
	</tr>
	<tr>
		<td colspan="6"> <img src="../../pics/black_pixel.gif" width="960" height="2"> </td>
	</tr>
	<tr>
		<Td align="left" width="280"><font face="arial" size="2"><strong>Student</strong></font></td>
		<td align="left" width="80"><font face="arial" size="2"><strong>DOB</strong></font></td>
		<td align="left" width="150"><font face="arial" size="2"><strong>Citizenship</strong></font></td>
		<td align="left" width="250"><font face="arial" size="2"><strong>Email</strong></font></td>
		<td align="left" width="200"><font face="arial" size="2"><strong>Home Phone ##</strong></font></td>
	</tr>
	<tr>
  	<td colspan=6><img src="../../pics/black_pixel.gif" width="960" height="2"></td>
  </tr>
	<cfloop query="get_candidates">
	<tr>
		<td valign="top" align="left"><font face="arial" size="2">#firstname# #lastname# (#candidateid#)</font></td>
		<td valign="top" align="left"><font face="arial" size="2">#dateformat (dob, 'mm/dd/yyyy')#</font></td>
		<td valign="top" align="left"><font face="arial" size="2">#countryname#</font></td>
		<td valign="top" align="left"><font face="arial" size="2">#email#</font></td>
		<td valign="top" align="left"><font face="arial" size="2">#home_phone# </font></td>
	</tr>
	</cfloop>
	<tr>
		<td colspan="6"><img src="../../pics/black_pixel.gif" width="960" height="2">
<Br><br>
<span class="style2">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span></td>
	</tr>
</table>
</cfoutput>
