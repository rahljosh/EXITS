<cfdocument format="pdf" orientation="portrait" backgroundvisible="yes" overwrite="no" fontembed="yes">
<cfquery name="students_hired" datasource="mysql">
select c.firstname, c.lastname, c.sex, c.home_country,c.email, c.earliestarrival, c.programid, c.intrep,
p.programname, 
u.businessname,
smg_countrylist.countryname
from extra_candidates c

LEFT JOIN smg_programs p on p.programid = c.programid
LEFT JOIN smg_users u on u.userid = c.intrep
LEFT JOIN smg_countrylist on smg_countrylist.countryid = c.home_country

where c.hostcompanyid = #form.hostcompany#
and c.programid = #form.program#
</cfquery> 

<cfoutput>
<!----
<cfdocument format="FlashPaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
---->
<cfif students_hired.recordcount eq 0>
<div align = "center">
	Based on your criteria, no results were returned.
</div>
<cfelse>
<Table width=100%>
	<tr>
		<td>
		Report: Students hired per company<br />
		Company: #students_hired.businessname#<br>
		Program: #students_hired.programname#<br>
		<font size=-2> #DateFormat(now(), 'mmm. d, yyyy')# at #TimeFormat(now(), 'h:mm t')# MST</font>
		
		</td>
		<td align="right">
		<img src="http://dev.student-management.com/extra/images/extra-logo.jpg" width=50 height=65>		
		</td>
</Table>
<br><br>
<table width=100% cellpadding="4" cellspacing=0> 
	<tr>
	<Th align="left">Student</Th><th align="left">Sex</th><th align="left">Country</th><th align="left">Email</th><th align="left">Earliest Arrival</th><th align="left">Program / Length</th><th align="left">International Agent</th>
	</tr>
<cfloop query="students_hired">
	<tr <cfif students_hired.currentrow mod 2>bgcolor="##cccccc"</cfif>>
		<td>#firstname# #lastname#</td><td>#sex#</td><td>#countryname#</td><td>#email#</td><td>#DateFormat(earliestarrival, 'mm/dd/yyyy')#</td><td>#programname#</td><td>#businessname#</td>
	</tr>
</cfloop>
	</table>
</cfif>
<!----
</cfdocument>
---->
</cfoutput>
</cfdocument>