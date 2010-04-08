<!--- Generate Avery Standard 5160 labels for our contacts. --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>DS 2019 History</title>
</head>

<body>

<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:.5in 13.6pt 0in 13.6pt;
	}
	table {
		mso-table-layout-alt:fixed;
		mso-padding-top-alt:0in;
		mso-padding-bottom-alt:0in
	}
	td.label {
		width:110.0pt;
	}	
	p {
		margin-top:0.5in;
		margin-right:5.3pt;
		margin-bottom:0.5in;
		margin-left:5.3pt;
		mso-pagination:widow-orphan;
		font-size:11.0pt;
		font-family:"Arial";
		border:hidden;
	}
</style>

<cfif NOT IsDefined('form.datecreated')>
	You must select a date. Please go back and try again.
	<cfabort>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_history" datasource="caseusa">
	SELECT  history.companyid, history.datecreated, history.timecreated, history.csietid, history.studentid, history.hostid, history.host_lastname, history.host_address,
			history.host_city, history.host_state, history.host_zip, history.schoolid, history.school_name, history.school_address,
			history.school_city, history.school_state, history.school_zip, history.programid, history.regionid, history.placement_date,
			history.placerepid,  history.place_firstname, history.place_lastname, history.arearepid, history.area_firstname, history.area_lastname,
			s.firstname, s.familylastname, s.ds2019_no,
			p.programname
	FROM smg_csiet_history history
	LEFT JOIN smg_students s ON s.studentid = history.studentid
	LEFT JOIN smg_programs p ON s.programid = p.programid
	WHERE history.companyid = '#client.companyid#' 
		AND history.datecreated = '#form.datecreated#'
		AND s.ds2019_no LIKE 'N%'
	ORDER BY history.csietid
</cfquery>

<cfinclude template="../querys/get_company_short.cfm">

<div style="section1">

<cfoutput>
<table border=0 cellpadding="0" cellspacing="0" align="center" frame="below">
	<tr>
		<td width="50">&nbsp;</td>
		<td class="label" align="center"><font size="+3"><b>#companyshort.companyshort#</b></font></td>
		<td class="label" align="center" colspan="3"><font size="+3"><b>DS 2019 - Placement Report</b></font></td>		
	</tr>
	<cfloop query="get_history">
		<tr>
			<td align="left" width="30">#csietid#</td>
			<td class="label" align="right" width="110"><b>First Name :</b></td><td class="label">#firstname#</td>
			<td class="label" align="right" width="110"><b>Host Family :</b></td><td class="label">#host_lastname#</td>
		</tr>
		<tr>
			<td align="left">&nbsp;</td>
			<td align="right"><b>Last Name :</b></td><td>#familylastname#</td>
			<td align="right"><b>School Name :</b></td><td>#school_name#</td>			
		</tr>
		<tr>
			<td align="left">&nbsp;</td>
			<td align="right"><b>DS 2019 Number :</b></td><td>#ds2019_no#</td>
			<td align="right"><b>Address :</b></td><td>#school_address#</td>			
		</tr>
		<tr>
			<td align="left">&nbsp;</td>
			<td align="right"><b>Address :</b></td><td>#host_address#</td>
			<td align="right"><b>City :</b></td><td>#school_city#</td>			
		</tr>			
		<tr>
			<td align="left">&nbsp;</td>
			<td align="right"><b>City :</b></td><td>#host_city#</td>
			<td align="right"><b>State :</b></td><td>#school_state#</td>			
		</tr>			
		<tr>
			<td align="left">&nbsp;</td>
			<td align="right"><b>State :</b></td><td>#host_state#</td>
			<td align="right"><b>ZIP Code :</b></td><td>#school_zip#</td>			
		</tr>			
		<tr>
			<td align="left">&nbsp;</td>
			<td align="right"><b>ZIP Code :</b></td><td>#host_zip#</td>
			<td align="right"><b>Program :</b></td><td>#programname#</td>			
		</tr>
		<tr><td colspan="5"></td></tr>		
	</cfloop>
</table>

</cfoutput>
</div>

</body>
</html>

<!--- Tell the browser this is a word document --->
<cfheader 
	name="Content-Type" 
	value="application/msword">


<!--- Tell the browser this is an attachment and provide a filename. --->
<cfheader 
	name="Content-Disposition" 
	value="attachment; filename=ds2019report.doc">