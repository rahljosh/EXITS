<link rel="stylesheet" href="reports.css" type="text/css">

<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.3in 0.3in 0.46in;
	}
	div.Section1 {		
		page:Section1;
	}
</style>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="MySQL">
	SELECT 	s.studentid, s.firstname, s.familylastname, s.programid, s.ds2019_no,
			p.programname,
			sch.schoolname, sch.address as schooladdress, sch.address2 as schooladdress2,
			sch.city as schoolcity, sch.state as schoolstate, sch.zip as schoolzip,
			c.countryname,
			u.firstname as repfirstname, u.lastname as replastname, u.phone as repphone,
			st.statename
	FROM smg_students s 
	INNER JOIN smg_programs p		ON 	s.programid = p.programid
	LEFT JOIN smg_schools sch ON 	s.schoolid = sch.schoolid
	LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
	LEFT JOIN smg_users u ON s.arearepid = u.userid
	LEFT JOIN smg_states st on sch.state = st.state
	WHERE 
		(s.active = '1' AND s.ds2019_no LIKE 'N%'  
			AND	( <cfloop list=#form.programid# index='prog'>
			s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
			AND grades = '12')
	OR 
		(s.active = '1' AND s.ds2019_no LIKE 'N%'  
			AND	( <cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			AND grades = '11' and (countryresident = '49' or countryresident = '237'))
	ORDER BY st.statename, s.familylastname
</cfquery>

<div class="Section1">

<cfoutput>
<table width="650" align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td width="50">&nbsp;</td>
		<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="left"></td>
		<td valign="middle" align="left"><font size="+3"><b>Graduated Students Report</b></font></td>		
	</tr>
	<tr><td colspan="3"><hr width=100% align="center"></td></tr>
</table>

<cfif get_students.recordcount mod 6 is 0>
	<cfset totalpages = get_students.recordcount \ 6>
<cfelse>	
	<cfset totalpages = get_students.recordcount \ 6>
	<cfset totalpages = totalpages + 1>
</cfif>

<cfset pagenumber = 0>

</cfoutput>

<cfoutput query="get_students">

<table width='650' cellpadding=6 cellspacing="0" align="center" frame="below" border="1">
<tr><td>
		<table>
		<tr>
			<td align="left" width="50">#get_students.currentrow#</td>
			<td align="right"><b>U.S. State :</b></td><td width="180">#statename#</td>
		</tr>
		<tr>
			<td align="left">&nbsp;</td>
			<td align="right"><b>Name of Student :</b></td><td>#firstname# #familylastname#</td>
		</tr>
		<tr>
			<td align="left">&nbsp;</td>
			<td align="right"><b>Country of Origin :</b></td><td>#countryname#</td>
		</tr>
		<tr>
			<td align="left">&nbsp;</td>
			<td align="right"><b>Local Rep :</b></b></td><td>#repfirstname# #replastname#</td>
		</tr>
		<tr>			
			<td align="left">&nbsp;</td>
			<td align="right"><b>Local Rep Number : </b></td><td>#repphone#</td>
		</tr>
		<tr>
			<td align="left">&nbsp;</td>			
			<td align="right"><b>U.S. Host School :</b></b></td><td>#schoolname#</td>
		</tr>										
		<tr>			
			<td align="left">&nbsp;</td>			
			<td align="right"><b>City of U.S. Host School :</b></b></td><td>#schoolcity#</td>
		</tr>	
		</table>
</td></tr>
</table>

<cfif (recordcount is 1) or (currentrow mod 6 is 0)> 
	<cfset pagenumber = #pagenumber#+1>
	<table width='650' align="center">
		<tr>
		<td align="left" width="200">#DateFormat(now(), 'mm/dd/yyyy')#</td>
		<td align="center">Graduated Students Report</td>
		<td align="right" width="200">Page #pagenumber#  of  #totalpages#</td></tr>
	</table>
	<div style="page-break-after:always;"></div>
	<br><br><br>
</cfif>

<cfif (recordcount mod 6 is not 0) and (recordcount is currentrow)>
	<cfset pagenumber = #pagenumber#+1>
	<table width='650' align="center">
		<tr>
		<td align="left" width="200">#DateFormat(now(), 'mm/dd/yyyy')#</td>
		<td align="center">Graduated Students Report</td>
		<td align="right" width="200">Page #pagenumber# of  #totalpages#</td></tr>
	</table>	
</cfif>

</cfoutput>
</div>