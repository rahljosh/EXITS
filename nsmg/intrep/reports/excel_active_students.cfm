<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Excel List - Active Students</title>
</head>

<body>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get Students  --->
<Cfquery name="get_students" datasource="MySQL">
	SELECT s.studentid, s.firstname, s.familylastname, s.branchid,
		u.businessname,
		branch.businessname as branchname
	FROM smg_students s 
	INNER JOIN smg_users u ON s.intrep = u.userid
	LEFT JOIN smg_users branch ON branch.userid = s.branchid
	WHERE s.active = '1' 
		AND s.intrep = '19'
		AND (s.app_current_status = '2' OR app_current_status = '3' OR app_current_status = '4' )
	ORDER BY s.familylastname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=students_list.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<td><b>ID</b></td>
		<td><b>First Name</b></td>
		<td><b>Last Name</b></td>
		<td><b>Branch</b></td>						
	</tr>
	<cfloop query="get_students">	
		<tr>
			<td>#studentid#</td>
			<td>#firstname#</td>
			<td>#familylastname#</td>
			<td><cfif branchid EQ 0>Main Office<cfelse>#branchname#</cfif></td>
		</tr>		
	</cfloop>
</table>
</cfoutput>


<!---

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get Students  --->
<Cfquery name="get_students" datasource="MySQL">
	SELECT s.studentid, s.firstname, s.familylastname, s.branchid,
		p.programname,
		u.businessname,
		branch.businessname as branchname,
		c.companyshort
	FROM smg_students s 
	INNER JOIN smg_programs p		ON 	s.programid = p.programid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	INNER JOIN smg_users u ON s.intrep = u.userid
	LEFT JOIN smg_users branch ON branch.userid = s.branchid
	WHERE s.active = '1' 
		AND s.intrep = '19'
	ORDER BY s.familylastname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=students_list.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<td><b>Company</b></td>
		<td><b>ID</b></td>
		<td><b>First Name</b></td>
		<td><b>Last Name</b></td>
		<td><b>Program</b></td>
		<td><b>Branch</b></td>						
	</tr>
	<cfloop query="get_students">	
		<tr>
			<td>#companyshort#</td>
			<td>#studentid#</td>
			<td>#firstname#</td>
			<td>#familylastname#</td>
			<td>#programname#</td>
			<td><cfif branchid EQ 0>Main Office<cfelse>#branchname#</cfif></td>
		</tr>		
	</cfloop>
</table>
</cfoutput>

--->

</body>
</html>