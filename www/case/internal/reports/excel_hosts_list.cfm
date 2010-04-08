<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfif NOT IsDefined('form.date') OR NOT IsDefined('form.programid')>
	You must select a program and/or enter a date to run this report.
	<cfabort>
</cfif>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="caseusa">
	SELECT DISTINCT s.date_host_fam_approved,
		h.hostid, h.familylastname as hostfamily, h.address as hostaddress, h.address2 as hostaddress2, 
		h.city as hostcity, h.state as hoststate, h.zip as hostzip,
		r.regionname,
		c.companyshort
	FROM smg_students s 
	INNER JOIN smg_programs p		ON 	s.programid = p.programid
	INNER JOIN smg_hosts h 	ON 	s.hostid = h.hostid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	INNER JOIN smg_regions r ON r.regionid = s.regionassigned 
	WHERE s.active = '1'
		AND s.date_host_fam_approved >= '#DateFormat(form.date, 'yyyy-mm-dd')#'
		AND	( <cfloop list=#form.programid# index='prog'>
		s.programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
		<!--- and s.email <> '' --->
		GROUP BY h.hostid
		ORDER BY s.familylastname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=smg_students.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
<table border="1" cellpadding="3" cellspacing="0">
<tr>
	<td>Company</td>
	<td>Host ID</td>
	<td>Host Family</td>
	<td>Address</td>	
	<td>City</td>	
	<td>State</td>	
	<td>Zip</td>	
	<td>Region</td>	
	<td>Date Placement</td>					
</tr>
</cfoutput>
<cfoutput query="get_students">	
<tr>
	<td>#companyshort#</td>
	<td>#hostid#</td>
	<td>#hostfamily#</td>
	<td><cfif hostaddress is ''>#hostaddress2#<cfelse>#hostaddress#</cfif></td>
	<td>#hostcity#</td>
	<td>#hoststate#</td>
	<td>#hostzip#</td>
	<td>#regionname#</td>
	<td>#DateFormat(date_host_fam_approved, 'mm/dd/yyyy')#</td>
</tr>		
</cfoutput>
</table>

</body>
</html>