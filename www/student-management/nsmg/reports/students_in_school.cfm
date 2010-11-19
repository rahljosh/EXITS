<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Students in School</title>
<link rel="stylesheet" href="../smg.css" type="text/css">
</head>

<body>

<cfoutput>

<cfif NOT IsDefined('url.schoolid')>
	<table width="95%" align="center" cellpadding=6 cellspacing="0" align="center">
		<tr><td align="center"><h3>An error has occurred. Please try again later.</h3></td></tr>
	</table>
	<cfabort>
</cfif>

<cfquery name="get_school" datasource="MySQL">
	select *
	from smg_schools
	where schoolid = #url.schoolid#
	order by Schoolname
</cfquery>

<cfif get_school.recordcount EQ 0>
	<table width="95%" align="center" cellpadding=6 cellspacing="0" align="center">
		<tr><td align="center"><h3>No school was found on the system with ID ###url.schoolid#.</h3></td></tr>
	</table>
	<cfabort>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<table width="95%" cellpadding=6 cellspacing="0" align="center">
	<tr><td><span class="application_section_header">#companyshort.companyshort# - 
			Students in #get_school.schoolname# (###get_school.schoolid#)</span></td></tr>
</table><br>

<cfquery name="get_students_school" datasource="MySql">
	SELECT s.firstname, s.familylastname, s.studentid, s.sex, s.countryresident, s.schoolid, s.programid, s.active,
		u.businessname,
		c.companyshort,
		country.countryname,
		p.programname
	FROM smg_students s
	INNER JOIN smg_users u ON s.intrep = u.userid
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	LEFT JOIN smg_programs p ON p.programid = s.programid
	LEFT JOIN smg_countrylist country ON s.countryresident = country.countryid
	WHERE s.schoolid = '#url.schoolid#'
		<!--- AND s.companyid = '#client.companyid#' --->		
	ORDER BY c.companyshort, p.programname, s.firstname
</cfquery>

<cfquery name="get_history" datasource="MySql">
	SELECT s.firstname, s.familylastname, s.studentid, s.sex, s.countryresident, s.programid, s.active,
		u.businessname,
		c.companyshort,
		country.countryname,
		p.programname,
		hist.reason
	FROM smg_students s
	INNER JOIN smg_users u ON s.intrep = u.userid
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	INNER JOIN smg_hosthistory hist ON hist.studentid = s.studentid
	LEFT JOIN smg_programs p ON p.programid = s.programid
	LEFT JOIN smg_countrylist country ON s.countryresident = country.countryid
	WHERE hist.schoolid = '#url.schoolid#'
		AND hist.reason != 'Original Placement'
		<!--- AND s.companyid = '#client.companyid#' --->		
	ORDER BY c.companyshort, p.programname, s.firstname
</cfquery>
	
<table align="center" width="95%" cellpadding=6 cellspacing="0" frame="below">

	<tr><th colspan="7"><h3>STUDENTS CURRENT ASSIGNED</h3></th></tr>
	<cfif get_students_school.recordcount>
		<tr>
			<td width="4%"><h3>Company</h3></td>
			<td width="28%"><h3>Name</h3></td>
			<td width="8%" align="center"><h3>Sex</h3></td>
			<td width="18%" align="center"><h3>Country</h3></td>
			<td width="24%"><h3>Intl. Rep.</h3></td>
			<td width="10%"><h3>Program</h3></td>
			<td width="8%"><h3>Status</h3></td>
		</tr>
		<cfloop query="get_students_school">
		<tr bgcolor="#iif(get_students_school.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#companyshort#</td>
			<td>#firstname# #familylastname# (###studentid#)</td>
			<td align="center">#sex#</td>
			<td align="center">#countryname#</td>
			<td>#businessname#</td>
			<td>#programname#</td>
			<td align="center"><cfif get_students_school.active is 0>Inactive<cfelse>Active</cfif></td>
		</tr>	
		</cfloop>
	<cfelse>
		<tr><td colspan="7" align="center"><h3>There are no current students assigned to this school.</h3></td></tr>
	</cfif>

	<tr><td colspan="7">&nbsp;</td></tr>
	<tr><th colspan="7"><h3>SCHOOL HISTORY</h3></th></tr>

	<cfif get_history.recordcount>
		<tr>
			<td width="4%"><h3>Company</h3></td>
			<td width="28%"><h3>Name</h3></td>
			<td width="8%" align="center"><h3>Sex</h3></td>
			<td width="18%" align="center"><h3>Country</h3></td>
			<td width="24%"><h3>Intl. Rep.</h3></td>
			<td width="10%"><h3>Program</h3></td>
			<td width="8%"><h3>Status</h3></td>
		</tr>
		<cfloop query="get_history">
		<tr bgcolor="#iif(get_history.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#companyshort#</td>
			<td>#firstname# #familylastname# (###studentid#)</td>
			<td align="center">#sex#</td>
			<td align="center">#countryname#</td>
			<td>#businessname#</td>
			<td>#programname#</td>
			<td align="center"><cfif get_history.active is 0>Inactive<cfelse>Active</cfif></td>
		</tr>
		<tr><td colspan="7" bgcolor="#iif(get_history.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">Reason for changing: #reason#</td></tr>	
		</cfloop>
		<tr><td colspan="7">&nbsp;</td></tr>
	<cfelse>
		<tr><td colspan="7" align="center"><h3>There are no history records for this school.</h3></td></tr>
	</cfif>
</table><br>

<table width="100%" align="center" cellpadding=6 cellspacing="0">
	<tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>
</cfoutput>

</body>
</html>