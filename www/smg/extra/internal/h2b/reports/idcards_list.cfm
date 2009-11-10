<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>ID Cards List</title>
</head>

<body>

<!---<cfif NOT IsDefined('form.programid') OR form.verification_received EQ 0>
	Please select at least one program and/or DS 2019 verification received date.
	<cfabort>
</cfif> --->

<cfinclude template="../querys/get_company.cfm">

<cfquery name="get_candidates" datasource="MySql"> 
	SELECT DISTINCT	c.candidateid, c.lastname, c.firstname, c.verification_received, c.active, c.cancel_date, c.startdate, c.enddate,
		u.businessname,
		p.programname, p.programid
	FROM extra_candidates c 
	INNER JOIN smg_users u ON c.intrep = u.userid
	INNER JOIN smg_programs p ON c.programid = p.programid
	INNER JOIN smg_companies comp ON c.companyid = comp.companyid
	LEFT JOIN extra_candidate_place_company place ON c.candidateid = place.candidateid
	LEFT JOIN extra_hostcompany hcompany ON place.hostcompanyid = hcompany.hostcompanyid
	LEFT JOIN smg_states states ON states.id = hcompany.state
	WHERE c.status = '1'
		<!--- AND c.verification_received = #CreateODBCDate(form.verification_received)# --->
		<cfif form.intrep NEQ 0>
			AND c.intrep = '#form.intrep#'
		</cfif>
		AND ( <cfloop list="#form.programid#" index="prog">
			 c.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )  		
	GROUP BY c.candidateid
	ORDER BY u.businessname, c.candidateid
</cfquery>
					
<!--- The table consists has two columns, two labels. To identify where to place each, we need to maintain a column counter. --->

<cfoutput>						
						
<table align="center" width="700" border="1" cellspacing="2" cellpadding="0" frame="box">	
	<tr>
		<td>		
			<table align="center" width="100%" border="0" cellspacing="2" cellpadding="0">	
				<tr><th>#get_company.companyname# &nbsp; - &nbsp; ID Cards List</th></tr>
				<tr><td>Program #get_candidates.programname# &nbsp; - &nbsp; Total of #get_candidates.recordcount# candidate(s)</td></tr>
				<!--- <tr><td>DS Verification Received on #DateFormat(verification_received, 'mm/dd/yyyy')#</td></tr> --->
			</table>
		</td>
	</tr>
</table><br />

<table align="center" width="700" border="0" cellspacing="2" cellpadding="0" frame="below">	
	<tr>
		<td><b>Intl. Agent</b></td>
		<td><b>Student</b></td>
		<th>Start Date</th>
		<th>End Date</th>
		<th>Duration</th>
	</tr>
	<cfloop query="get_candidates">
		<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
			<td>#businessname#</td>
			<td>#Firstname# #lastname# (###candidateid#)</td>
			<td align="center">#DateFormat(startdate, 'mm/dd/yyyy')#</td>
			<td align="center">#DateFormat(enddate, 'mm/dd/yyyy')#</td>
			<td align="center">#Ceiling(DateDiff('d',startdate, enddate) / 7)# weeks</td>
		</tr>
	</cfloop>
</table>

</cfoutput>

</body>
</html>