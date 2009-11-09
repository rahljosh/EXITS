<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-EQuiv="Content-Type" content="text/html;  charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>SMG - EXITS Online Application List</title>
</head>
<body>

<cfquery name="students" datasource="MySQL">
	SELECT DISTINCT u.userid, u.businessname, count(u.userid) as total 
	FROM smg_students s 
	LEFT JOIN smg_users u ON u.userid = s.intrep
	WHERE s.randid != '0'
		<cfif url.status NEQ '4' AND url.status NEQ '6' AND url.status NEQ '9'>AND s.active = '1'</cfif>
		AND (app_current_status = <cfqueryparam value="#url.status#" cfsqltype="cf_sql_integer"> <cfif client.usertype NEQ '11'><cfif url.status EQ '2'>OR app_current_status = '3' OR app_current_status = '4'</cfif></cfif> )
 		<!--- Intl. Rep --->
		<cfif client.usertype EQ '8'>AND s.intrep = '#client.userid#'</cfif>
		<cfif client.usertype EQ '11'>AND s.branchid = '#client.userid#'</cfif>
        <cfif client.companyid gt 5>AND s.companyid = 10</cfif>
	GROUP BY u.businessname
</cfquery>

<h2>
<cfif url.status EQ 1>
	Access has been sent to these applications, they have not followed the link to activate their account.
<cfelseif url.status EQ 2>
	These applications have activated their accounts and are working on their applications.
<cfelseif url.status EQ 3>
	These applications are waiting for <cfif client.usertype EQ 11>your<cfelse>the branch</cfif> approval.
<cfelseif url.status EQ 4>
	These applications have been rejected by <cfif client.usertype EQ 11>you<cfelse>the branch</cfif>.
<cfelseif url.status EQ 5>
	These applications are waiting for <cfif client.usertype EQ 8>your<cfelse>the international rep</cfif> approval.
<cfelseif url.status EQ 6>
	These applications have been rejected by <cfif client.usertype EQ 8>you<cfelse>the international rep</cfif>.
<cfelseif url.status EQ 7 OR url.status EQ 8>
	These applications have been approved by <cfif client.usertype EQ 8>you<cfelse>the international rep</cfif> and are waiting for the approval.
<cfelseif url.status EQ 9>
	These applications have been rejected.
<cfelseif url.status EQ 10>
	These applications have been approved.	
</cfif>
</h2>

<br>
<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Students </td>
		<td background="pics/header_background.gif" align="right"><a href="?curdoc=student_app/student_app_list&status=#url.status#">All Students</a></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr>
		<td><b>International Representative &nbsp; (#students.recordcount#)</b></td>
		<td><b>Total</b></td>
	</tr>
<cfloop query="students">
	<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
		<td><a href="?curdoc=student_app/student_app_list&status=#url.status#&intrep=#userid#">#businessname#</a></td>
		<td>#total#</td>
	</tr>
</cfloop>
</table>

</cfoutput>

<cfinclude template="../table_footer.cfm">

</body>
</html>