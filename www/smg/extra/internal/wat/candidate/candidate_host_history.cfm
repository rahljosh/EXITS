<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../../style.css">
	<title>Program Assigment History</title>
</head>
<body>

<cfif not IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
</cfif>

<cfquery name="get_candidate_info" datasource="MySql">
	SELECT candidateid, firstname, lastname
	FROM extra_candidates
	LEFT JOIN smg_companies ON smg_companies.companyid = extra_candidates.companyid
	WHERE uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
</cfquery>

<cfquery name="host_history" datasource="MySql">
	SELECT  candcompid, candidateid, extra_candidate_place_company.hostcompanyid, placement_date, startdate,
					enddate, confirmation_received, reason_host, status, extra_hostcompany.name
	FROM extra_candidate_place_company 
	LEFT JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidate_place_company.hostcompanyid
	WHERE extra_candidate_place_company.candidateid = '#get_candidate_info.candidateid#'
	ORDER BY candcompid ASC
</cfquery>


<cfoutput query="get_candidate_info">

<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
	<tr>
		<td bordercolor="FFFFFF">

			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td align="right" class="title1">Host Company History for <u>#firstname# #lastname#</u> (#candidateid#)</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
			
			<table width="100%" border=0 cellpadding=5 cellspacing=0>
				<tr>
					<td class="style2" bgcolor="8FB6C9">Assigned On</td>
					<td class="style2" bgcolor="8FB6C9">Company Name</td>
					<td class="style2" bgcolor="8FB6C9">Reason</td>
					<td class="style2" bgcolor="8FB6C9">Start Date</td>
					<td class="style2" bgcolor="8FB6C9">End Date</td>
					<td class="style2" bgcolor="8FB6C9">Status</td>
				</tr>
				<cfif host_history.recordcount EQ '0'>
				<tr><td colspan="6" align="center" class="style1">There is no Host Company History for this student.</td></tr>
				<cfelse>
					<cfloop query="host_history">
						<tr bgcolor="#iif(host_history.currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
							<td align="left" class="style5">#DateFormat(placement_date, 'mm/dd/yyyy')#</td>
							<td align="left" class="style5"><cfif hostcompanyid EQ ''>Unassigned<cfelse>#name# (###hostcompanyid#)</cfif></td>
							<td align="left" class="style5">#reason_host#</td>
							<td align="left" class="style5">#DateFormat(startdate, 'mm/dd/yyyy')#</td>
							<td align="left" class="style5">#DateFormat(enddate, 'mm/dd/yyyy')#</td>
							<td align="left" class="style5"><CFif status EQ 1>Acitve<CFelse>Inactive</CFif></td>
						</tr>
					</cfloop>
				</cfif>
			</table>
			<br>
			<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
				<tr><td align="center" width="50%">&nbsp;<input type="image" value="close window" src="../../pics/close.gif" onClick="javascript:window.close()"></td></tr>
			</table>
			
			</td>
		</tr>
	</table>
	
</cfoutput>

</body>
</html>