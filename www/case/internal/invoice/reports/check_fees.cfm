<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Check Fees for Intl. Agent</title>
</head>

<body>

<cfsetting requestTimeOut = "1000">

<cfoutput>

<cfif form.chargetype EQ '0'> <cfset feetype = ''>
<cfelseif form.chargetype EQ '1'> <cfset feetype = 'deposit'>
<cfelseif form.chargetype EQ '2'> <cfset feetype = 'program fee'>
<cfelseif form.chargetype EQ '3'> <cfset feetype = 'insurance'>
<cfelseif form.chargetype EQ '4' or form.chargetype EQ '5'> <cfset feetype = 'guarantee'>
<cfelseif form.chargetype EQ '6'> <cfset feetype = 'sevis'> 
<cfelseif form.chargetype EQ '7'> <cfset feetype = 'Pre-AYP Camp'>
<cfelseif form.chargetype EQ '8'> <cfset feetype = 'cancellation fee'> 				
</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>List of International Representatives to be charged &nbsp; - &nbsp; Charge type: <b><cfif form.chargetype EQ '4'>Region<cfelseif form.chargetype EQ '5'>State</cfif> #feetype# <cfif form.chargetype NEQ '2' OR form.chargetype NEQ '8'>fee</cfif></b> </h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width=100% border=0 cellpadding=5 cellspacing=2 class="section">
	<cfif NOT IsDefined('form.showstudents')>
		<tr>
			<td width="40%"><b>International Agent</b></td>
			<td width="15%"><b>Total of students</b></td>
			<td width="45%">&nbsp;</td>
		</tr>
	<cfelse>
		<tr>
			<td width="50%"><b>International Agent</b></td>
			<td width="50%">Total</td>
		</tr>
	</cfif>

<cfif form.chargetype EQ '0' OR form.seasonid EQ '0'>
		<tr><td colspan="3"><br>In order to continue you must select a season and/or charge type. Please try again.<br></td></tr>
	</table>
	<cfinclude template="../../table_footer.cfm">
	<cfabort>
</cfif>

<cfquery name="get_agent" datasource="caseusa">
	SELECT u.userid, u.businessname
	FROM smg_students s
	INNER JOIN smg_users u ON s.intrep = u.userid
	INNER JOIN smg_programs p ON s.programid = p.programid
	WHERE p.seasonid = '#form.seasonid#'
		AND s.companyid = '#client.companyid#'	
		<cfif form.chargetype EQ '3'>
			AND u.insurance_typeid > 1
		<cfelseif form.chargetype EQ '4'>
			AND s.regionalguarantee != '0'
		<cfelseif form.chargetype EQ '5'>
			AND s.state_guarantee != '0'
		<cfelseif form.chargetype EQ '6'>
			AND s.sevis_fee_paid_date IS NOT NULL
		<cfelseif form.chargetype EQ '7'>
			AND s.aypenglish != '0'
		</cfif>
		<cfif form.chargetype EQ '8'>
			AND s.active = '0'
			AND s.hostid != '0'
			AND s.canceldate IS NOT NULL
		<cfelse>		
			AND s.active = '1'
		</cfif>
	GROUP BY u.userid
	ORDER BY u.businessname		
</cfquery>

<cfloop query="get_agent">
	<cfquery name="get_students" datasource="caseusa">
		SELECT s.studentid, s.firstname, s.familylastname, u.businessname
		FROM smg_students s
		INNER JOIN smg_programs p ON s.programid = p.programid
		INNER JOIN smg_users u ON s.intrep = u.userid
		WHERE p.seasonid = '#form.seasonid#'
			AND s.intrep = '#get_agent.userid#' 
			AND s.companyid = '#client.companyid#'		
			<cfif form.chargetype EQ '3'>
				AND u.insurance_typeid > 1
			<cfelseif form.chargetype EQ '4'>
				AND s.regionalguarantee != '0'
			<cfelseif form.chargetype EQ '5'>
				AND s.state_guarantee != '0'
			<cfelseif form.chargetype EQ '6'>
				AND s.sevis_fee_paid_date IS NOT NULL
			<cfelseif form.chargetype EQ '7'>
				AND s.aypenglish != '0'
			</cfif>
			<cfif form.chargetype EQ '8'>
				AND s.active = '0'
				AND s.hostid != '0'
				AND s.canceldate IS NOT NULL
			<cfelse>		
				AND s.active = '1'
			</cfif>
			AND s.studentid NOT IN (SELECT stuid FROM smg_charges WHERE type = '#feetype#' AND agentid = '#get_agent.userid#' AND companyid = '#client.companyid#')
	</cfquery>
	<cfif get_students.recordcount NEQ 0>
		<cfif NOT IsDefined('form.showstudents')>
			<tr bgcolor="#iif(get_agent.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td>#get_agent.businessname#</td>
				<td align="center">#get_students.recordcount#</td>
				<td>&nbsp;</td>
			</tr>
		<cfelse>
			<tr>
				<td><b>#get_agent.businessname#</b></td>
				<td>#get_students.recordcount#</td>
			</tr>		
			<cfloop query="get_students">
			<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td colspan="2">&nbsp; &nbsp; &nbsp;#get_students.firstname# #get_students.familylastname# (###get_students.studentid#)</td>
			</tr>
			</cfloop>
		</cfif>
	</cfif>
</cfloop>

</table>

<!----footer of table---->
<cfinclude template="../../table_footer.cfm">

</cfoutput>	

</body>
</html>