<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance List</title>
</head>

<body>

<cfif NOT IsDefined('url.type') OR NOT IsDefined('url.date')>
	An error has occurred. Please try again.
	<cfabort>
</cfif>

<cfquery name="get_candidates" datasource="MySql"> 
	SELECT h.candidateid, h.firstname, h.lastname, 
		u.businessname,
		p.programname		
	FROM extra_insurance_history h
	INNER JOIN extra_candidates c ON c.candidateid = h.candidateid
	INNER JOIN smg_users u ON u.userid = c.intrep
	INNER JOIN smg_programs p ON c.programid = p.programid
	WHERE h.transtype = <cfqueryparam value="#url.type#" cfsqltype="cf_sql_char">
		AND h.filed_date = <cfqueryparam value="#url.date#" cfsqltype="cf_sql_date">
	 ORDER BY u.businessname, h.lastname, h.firstname		
</cfquery>
					
<!--- The table consists has two columns, two labels. To identify where to place each, we need to maintain a column counter. --->

<div class="Section1">

<cfoutput>						
						
<table align="center" width="670" border="0" cellspacing="2" cellpadding="0" frame="below">	
	<tr><td colspan="3">Insurance Cards List &nbsp; - &nbsp; Insured on #DateFormat(url.date, 'mm/dd/yyyy')# &nbsp; - &nbsp; Total of #get_candidates.recordcount# candidate(s)</td></tr>
	<tr>
		<td><b>Intl. Rep.</b></td>
		<td><b>Student</b></td>
		<td><b>Program</b></td>
	</tr>
	<cfloop query="get_candidates">
		<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
			<td>#businessname#</td>
			<td>#Firstname# #lastname# (###candidateid#)</td>
			<td>#programname#</td>
		</tr>
	</cfloop>
</table>

</cfoutput>

</div>

</body>
</html>