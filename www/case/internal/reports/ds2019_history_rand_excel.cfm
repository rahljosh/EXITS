<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>DS 2019 History</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<cfif form.random EQ '' OR NOT IsDefined('form.datecreated')>
	You must enter number and/or select a date. Please go back and try again.
	<cfabort>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_history" datasource="caseusa">
	SELECT  history.companyid, history.datecreated, history.csietid, history.studentid,	history.hostid, history.host_lastname, history.host_address,
			history.host_city, history.host_state, history.host_zip, history.schoolid, history.school_name, history.school_address,
			history.school_city, history.school_state, history.school_zip, history.programid, history.regionid, history.placement_date,
			history.placerepid,  history.place_firstname, history.place_lastname, history.arearepid, history.area_firstname, history.area_lastname,
			s.firstname, s.familylastname, s.ds2019_no,
			u.businessname,
			p.programname,
			r.regionname
	FROM smg_csiet_history history
	LEFT JOIN smg_students s ON s.studentid = history.studentid
	LEFT JOIN smg_users u ON s.intrep = u.userid
	LEFT JOIN smg_programs p ON s.programid = p.programid
	LEFT JOIN smg_regions r ON r.regionid = history.regionid
	WHERE history.companyid = '#client.companyid#' 
		AND s.ds2019_no LIKE 'N%'
		AND history.datecreated = '#form.datecreated#'
		AND	( <cfloop list="#form.random#" index='randn'>
		history.csietid = '#randn#' 
		<cfif randn EQ #ListLast(form.random)#><Cfelse>or</cfif>
		</cfloop> )
	ORDER BY history.csietid
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=smg_students.xls"> 

<cfoutput>
<table border=1 cellpadding=2 cellspacing=0 class="section" width=100%>
	<tr>
		<th>CSIET Random ID</th>
		<th>Intl. Rep.</th>
		<th>Student</th>
		<th>DS 2019</th>
		<th>Program</th>
		<th>Region</th>
		<th>Placement Date</th>
		<th>Host Family</th>
		<th>School</th>
		<th>Placing Rep.</th>
		<th>Area Rep.</th>
	</tr>
	<cfloop query="get_history">
	<tr>
		<td>#csietid#</td>
		<td>#businessname#</td>
		<td>#firstname# #familylastname# (#studentid#)</td>
		<td>#ds2019_no#</td>
		<td>#programname#</td>
		<td>#regionname#</td>
		<td>#DateFormat(placement_date, 'mm/dd/yyyy')#</td>
		<td>#host_lastname# (#hostid#)</td>
		<td>#school_name# (#schoolid#)</td>
		<td>#place_firstname# #place_lastname# (#placerepid#)</td>
		<td>#area_firstname# #area_lastname# (#arearepid#)</td>
	</tr>					 				
</cfloop>
	<!--- <tr><td colspan="11">Total of #get_history.recordcount# students.</td></tr> --->
</table>
</cfoutput>

</body>
</html>