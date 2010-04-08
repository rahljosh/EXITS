<link rel="stylesheet" href="../smg.css" type="text/css">

<cfquery name="list_programs" datasource="caseusa">
SELECT 	programname, companyshort
FROM	smg_programs
INNER JOIN smg_companies ON smg_programs.companyid = smg_companies.companyid
WHERE <cfloop list=#form.programid# index='prog'>
		programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	</cfloop> 
ORDER BY programname
</cfquery>

<cfquery name="list_users" datasource="caseusa">
	SELECT count(s.studentid) as total, s.placerepid, u.firstname, u.lastname, u.companyid, u.regions
	FROM smg_students s
	INNER JOIN smg_users u ON s.placerepid = u.userid
	WHERE s.canceldate is null
		AND	( <cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
	GROUP BY s.placerepid
	ORDER BY u.firstname
</cfquery>

<span class="application_section_header">Placement Report</span><br>

<table width='100%' cellpadding=2 cellspacing="0" align="center" frame="box">	
<tr><td colspan="2"><div align="justify">
	Program(s): &nbsp; &nbsp;
	<cfoutput query="list_programs"><i><u>&nbsp; #companyshort# &nbsp; - &nbsp; #programname# &nbsp; &nbsp; / &nbsp; &nbsp;</u></i></cfoutput>
	</div></td>
</tr>
</table><br>

<table width='100%' cellpadding=2 cellspacing="0" align="center" frame="below">
	<tr bgcolor="CCCCCC"><th width="75%">Representative</th><th width="25%">Total</th></tr>
</table>
<table width='100%' cellpadding=2 cellspacing="0" align="center" frame="below">
<tr><td width="40%">Student</td><td width="20%">Company</td><td width="20%">Program</td><td width="20%">Region Assigned</td></tr>
</table><br>

<cfoutput query="list_users">
<table width='100%' cellpadding=2 cellspacing="0" align="center" frame="box">
	<tr bgcolor="CCCCCC"><th width="75%">#firstname# #lastname# (#placerepid#)</th><th width="25%">#total#</th></tr>
</table>
 	<cfquery name="list_students" datasource="caseusa">
	SELECT s.firstname, s.familylastname, s.studentid, s.regionassigned, p.programname, c.companyshort, r.regionname
	FROM smg_students s
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	INNER JOIN smg_regions r ON s.regionassigned = r.regionid
	WHERE s.canceldate is null AND placerepid = '#list_users.placerepid#'
			AND	( <cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
	ORDER BY companyshort, regionname, familylastname
	</cfquery>

<Table width=100% frame=below cellpadding=2 cellspacing="0" >
	<cfloop query="list_students">
	<tr bgcolor="#iif(list_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
		<td width="40%">#firstname# #familylastname# (#studentid#)</td>
		<td width="20%">#companyshort#</td><td width="20%">#programname#</td>
		<td width="20%">#regionname#</td>
	</tr>
	</cfloop>
</table><br>
</cfoutput>