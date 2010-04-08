<link rel="stylesheet" href="../smg.css" type="text/css">

<cfsetting requesttimeout="300">

<!--- Company Information --->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="master" datasource="caseusa">
	SELECT  s.studentid, s.firstname, s.familylastname, s.sex, s.countryresident, s.schoolid, 
		sc.schoolname, sc.state as schoolstate, 
		p.programname, c.countryname
	FROM smg_students s
	INNER JOIN smg_schools sc ON sc.schoolid = s.schoolid
	INNER JOIN smg_countrylist c ON s.countryresident = c.countryid
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE s.active = '1'
		AND s.companyid = '#client.companyid#' 
		<cfif form.stateid NEQ '0'>AND sc.state = '#form.stateid#'</cfif>
		<!--- <cfif IsDefined('form.school_filter')>AND count(s.studentid) > 5</cfif> --->
		AND	( <cfloop list="#form.programid#" index="prog">
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )	
	ORDER BY schoolstate, sc.schoolname
</cfquery>

<cfoutput>
<table width="650" cellpadding=4  cellspacing="0" align="center">
	<tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - Students per School</span></td></tr>
</table><br>
</cfoutput>

<table align="center" width="650" frame="below" cellpadding=4  cellspacing="0">
	<tr><td width="60%" align="left"><h3>High School</h3></td><td align="center" width="15%"><h3>State</h3></td><td align="center" width="25%"><h3>Total of Student(s)</h3></td></tr>
</table><br>

<cfif IsDefined('form.school_filter')>

	<cfoutput query="master" group="schoolid">
		<cfquery name="detail" dbtype="query">
		   SELECT studentid, firstname, familylastname, sex, countryresident, programname, countryname
		   FROM master
		   WHERE schoolid = #schoolid#
		 </cfquery>	
	
		<cfif detail.recordcount GT 5>
			<table align="center" width="650" frame="below" cellpadding=4  cellspacing="0">			
				<tr>
					<td width="60%">#schoolname# &nbsp; (###schoolid#)</td>
					<td align="center" width="15%">#schoolstate#</td>
					<td align="center" width="25%">#detail.recordcount#</td>
				</tr>
			</table>	
			<table align="center" width="650" cellpadding=4  cellspacing="0">		
				<tr>
					<td width="10%" align="left"><h3>ID</h3></td>
					<td width="36%"><h3>Name</h3></td>
					<td width="10" align="center"><h3>Sex</h3></td>
					<td width="22%" align="center"><h3>Country</h3></td>
					<td width="22%"><h3>Program</h3></td>
				</tr>
				<cfloop query="detail">
				<tr bgcolor="#iif(detail.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td>###studentid#</td>
					<td>#firstname# #familylastname#</td>
					<td align="center">#sex#</td>
					<td align="center">#countryname#</td>
					<td>#programname#</td>
				</tr>	
				</cfloop>
			</table><br> 
		</cfif>
	</cfoutput>
	
<cfelse>

	<cfoutput query="master" group="schoolid">
		<cfquery name="detail" dbtype="query">
		   SELECT studentid, firstname, familylastname, sex, countryresident, programname, countryname
		   FROM master
		   WHERE schoolid = #schoolid#
		 </cfquery>	
		<table align="center" width="650" frame="below" cellpadding=4  cellspacing="0">			
			<tr>
				<td width="60%">#schoolname# &nbsp; (###schoolid#)</td>
				<td align="center" width="15%">#schoolstate#</td>
				<td align="center" width="25%">#detail.recordcount#</td>
			</tr>
		</table>
		<table align="center" width="650" cellpadding=4  cellspacing="0">		
			<tr>
				<td width="10%" align="left"><h3>ID</h3></td>
				<td width="36%"><h3>Name</h3></td>
				<td width="10" align="center"><h3>Sex</h3></td>
				<td width="22%" align="center"><h3>Country</h3></td>
				<td width="22%"><h3>Program</h3></td>
			</tr>
			<cfloop query="detail">
			<tr bgcolor="#iif(detail.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>###studentid#</td>
				<td>#firstname# #familylastname#</td>
				<td align="center">#sex#</td>
				<td align="center">#countryname#</td>
				<td>#programname#</td>
			</tr>	
			</cfloop>
		</table><br> 
	</cfoutput>
	
</cfif>

<table width="100%" align="center" cellpadding=4  cellspacing="0">
	<tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>

<!--- ALL SCHOOLS --->
<!---
<style type="text/css">
<!--
.style1 {font-family: Arial, Helvetica, sans-serif; font-size: xx-small;}
-->
</style>

<cfquery name="schools" datasource="caseusa">
	SELECT *
	FROM smg_schools
	ORDER BY schoolname
</cfquery>

<table align="center" width="90%" cellpadding=0 cellspacing="0" border="0">		
	<tr><td class="style1">School</td><td>Address</td><td>City</td><td>State &nbsp;</td><td>Principal</td></tr>
	<cfoutput query="schools">
		<tr>
			<td class="style1">#schoolname# &nbsp; (###schoolid#)</td>
			<td class="style1">#address#</td>
			<td class="style1">#city#</td>
			<td class="style1">#state#</td>
			<td class="style1">#Principal#</td>
		</tr>
	</cfoutput>
</table>
---->