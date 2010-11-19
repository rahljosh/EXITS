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
<Cfquery name="get_history" datasource="MySQL">
	SELECT  history.companyid, history.datecreated, history.csietid, history.studentid,	history.hostid, history.host_lastname, history.host_address,
			history.host_city, history.host_state, history.host_zip, history.schoolid, history.school_name, history.school_address,
			history.school_city, history.school_state, history.school_zip, history.programid, history.regionid, history.placement_date,
			history.placerepid,  history.place_firstname, history.place_lastname, history.arearepid, history.area_firstname, history.area_lastname,
			s.firstname, s.familylastname, s.ds2019_no,
			u.businessname,
			p.programname,
			r.regionname,
			h.motherfirstname, h.fatherfirstname,
			sch.principal
	FROM smg_csiet_history history
	LEFT JOIN smg_students s ON s.studentid = history.studentid
	LEFT JOIN smg_users u ON s.intrep = u.userid
	LEFT JOIN smg_programs p ON s.programid = p.programid
	LEFT JOIN smg_regions r ON r.regionid = history.regionid
	LEFT JOIN smg_hosts h ON h.hostid = history.hostid
	LEFT JOIN smg_schools sch ON sch.schoolid = history.schoolid
	WHERE 
    <cfif CLIENT.companyID EQ 5>
        history.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.listISE#" list="yes"> )
    <cfelse>
        history.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
    AND 
    	s.ds2019_no LIKE 'N%'
    AND 
    	history.datecreated = '#form.datecreated#'
    AND	
    	history.csietid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.random#" list="yes"> )
	ORDER BY 
    	history.csietid
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=smg_students.xls"> 

<cfoutput>
<table border=1 cellpadding=2 cellspacing=0 class="section" width=100%>
	<tr><th colspan="4">Long-Term References</th></tr>
	<tr><td colspan="4"><b>Name of Organization: #companyshort.companyname#</b></td></tr>
	<tr>
		<th>Student Name, Mailing Address during exchange, City, State, Zip, Country if outside U.S.</th>
		<th>For Inbound Students Only:<br> Name of U.S. Host Parent(s)</th>
		<th>For Inbound Students Only:<br> Name of U.S. School, School Mailing Address, City, State, Zip</th>
		<th>For Inbound Students Only:<br> Contact Person at U.S. School</th>
	</tr>
	<cfloop query="get_history">
	<tr>
		<td>#firstname# #familylastname#, #host_address#, #host_city#, #host_state# #host_zip#</td>
		<td>#fatherfirstname# <cfif fatherfirstname NEQ '' AND motherfirstname NEQ ''>and</cfif> #motherfirstname# #host_lastname#</td>
		<td>#school_name#, #school_address#, #school_city#, #school_state# #school_zip#</td>
		<td>#principal#</td>
	</tr>					 				
</cfloop>
</table>
</cfoutput>

</body>
</html>