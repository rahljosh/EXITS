<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>DS 2019 History</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.3in 0.3in 0.46in;
	}
	div.Section1 {		
		page:Section1;
	}
</style>

<cfif NOT IsDefined('form.datecreated')>
	You must select a date. Please go back and try again.
	<cfabort>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_history" datasource="MySQL">
	SELECT  history.companyid, history.datecreated, history.timecreated, history.csietid, history.studentid,	history.hostid, history.host_lastname, history.host_address,
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
	WHERE     
	<cfif CLIENT.companyID EQ 5>
        history.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
    <cfelse>
        history.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
    AND 
        history.datecreated = '#form.datecreated#'
    AND 
        s.ds2019_no LIKE 'N%'
	ORDER BY 
    	history.csietid
</cfquery>

<div style="section1">

<cfoutput>
<table width="650" align="center" border=0 bgcolor="FFFFFF">
	<tr>
		<td width="50">&nbsp;</td>
		<td><img src="../pics/logos/#client.companyid#.gif"  alt="" border="0" align="left"></td>
		<td valign="middle" align="left"><font size="+3"><b>DS 2019 Placement Report <!--- DS 2019 - History File <br> From #DateFormat(get_history.datecreated, 'mm/dd/yyyy')# - #TimeFormat(get_history.timecreated, 'hh:mm tt')#---></b></font></td>		
	</tr>
	<tr><td colspan="3"><hr width=100% align="center"></td></tr>
</table>

<cfif get_history.recordcount mod 6 is 0>
	<cfset totalpages = get_history.recordcount \ 6>
<cfelse>	
	<cfset totalpages = get_history.recordcount \ 6>
	<cfset totalpages = totalpages + 1>
</cfif>

<cfset pagenumber = 0>

<cfloop query="get_history">
	<table width='650' cellpadding=6 cellspacing="0" align="center" frame="below" border="1">
	<tr><td>
			<table>
			<tr>
				<td align="left" width="30">#csietid#</td>
				<td align="right" width="110"><b>First Name :</b></td><td width="180">#firstname#</td>
				<td align="right" width="110"><b>Host Family :</b></td><td width="220">#host_lastname# (###hostid#)</td>
			</tr>
			<tr>
				<td align="left">&nbsp;</td>
				<td align="right"><b>Last Name :</b></td><td>#familylastname# (###studentid#)</td>
				<td align="right"><b>School Name :</b></td><td>#school_name# (###schoolid#)</td>			
			</tr>
			<tr>
				<td align="left">&nbsp;</td>
				<td align="right"><b>DS 2019 Number :</b></td><td>#ds2019_no#</td>
				<td align="right"><b>Program :</b></td><td>#programname#</td>			
			</tr>
			<tr>			
				<td align="left">&nbsp;</td>			
				<td align="right"><b>Intl. Agent:</b></b></td><td colspan="3">#businessname#</td>
			</tr>							

			<tr>			
				<td align="left">&nbsp;</td>			
				<td align="right"><b>Placement Date:</b></b></td><td>#DateFormat(placement_date, 'mm/dd/yyyy')#</td>
				<td align="right"><b>Region :</b></td><td>#regionname#</td>										 				
			</tr>
			<tr>			
				<td align="left">&nbsp;</td>			
				<td align="right"><b>Placing Rep.</b></td><td>#place_firstname# #place_lastname# (###placerepid#)</td>
				<td align="right"><b>Supervising Rep.:</b></td><td>#area_firstname# #area_lastname# (###arearepid#)</td>										 				
			</tr>							
			</table>
	</td></tr>
	</table>
	
	<cfif (recordcount is 1) or (currentrow mod 6 is 0)> 
		<cfset pagenumber = #pagenumber#+1>
		<table width='650' align="center">
			<tr>
			<td align="left" width="200"><!--- #DateFormat(now(), 'mm/dd/yyyy')# --->01/15/2007</td>
			<td align="center">DS 2019 Placement Report</td>
			<td align="right" width="200">Page #pagenumber#  of  #totalpages#</td></tr>
		</table>
		<div style="page-break-after:always;"></div>
		<br><br><br>
	</cfif>
	
	<cfif (recordcount mod 6 is not 0) and (recordcount is currentrow)>
		<cfset pagenumber = #pagenumber#+1>
		<table width='650' align="center">
			<tr>
			<td align="left" width="200"><!--- #DateFormat(now(), 'mm/dd/yyyy')# --->01/15/2007</td>
			<td align="center">DS 2019 Placement Report</td>
			<td align="right" width="200">Page #pagenumber# of  #totalpages#</td></tr>
		</table>	
	</cfif>

</cfloop>

</cfoutput>
</div>

</body>
</html>
