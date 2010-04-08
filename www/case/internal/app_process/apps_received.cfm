<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Received / On Hold Applications</title>
</head>

<body>

<style type="text/css">
<!--
div.scroll {
	height: 400px;
	width: 100%;
	overflow: auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
}
-->
</style>

<!--- ONLY OFFICE USERS --->
<cfif client.usertype GTE 5>
	You do not have the rights to see this page.
	<cfabort>
</cfif>

<cfif NOT IsDefined('url.order')>
	<cfset url.order = 'familylastname'>
</cfif>

<cfif NOT IsDefined('url.status')>
	<cfset url.status = 'received'>
</cfif>

<cfquery name="students" datasource="caseusa">
	SELECT s.studentid, s.uniqueid, s.familylastname, s.firstname, s.dob, s.sex, s.countryresident, s.active, s.app_current_status, s.app_indicated_program, 
		s.dateapplication, s.hostid, s.randid, s.companyid,
		smg_countrylist.countryname,
		p.app_program,
		c.companyshort,
		u.businessname,
		hold.hold_reason
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	LEFT JOIN smg_countrylist ON countryresident = smg_countrylist.countryid
	LEFT JOIN smg_student_app_programs p ON p.app_programid = s.app_indicated_program
	LEFT JOIN smg_companies c ON c.companyid = s.companyid
	LEFT JOIN smg_student_app_hold hold ON hold.holdid = s.onhold_reasonid
	WHERE 1 = 1
		<cfif client.companyid NEQ 5>AND s.companyid = #client.companyid#</cfif>
		<cfif url.status EQ 'received'>
			AND s.app_current_status = '8'
			AND s.active = '1'
		<cfelseif url.status EQ 'hold'>
			AND s.app_current_status = '10'
			AND s.active = '1'
		<cfelseif url.status EQ 'denied'>
			AND s.app_current_status = '9'		
		</cfif>
	ORDER BY #url.order#
</cfquery>

<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Students</h2></td>
		<td background="pics/header_background.gif" align="right">
			<font size=-1>[
			<!--- RECEIVED / ON HOLD LINKS - OFFICE ONLY --->
			<cfif url.status EQ 'received'><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif><a href="index.cfm?curdoc=app_process/apps_received&status=received">Received</a></span> &middot; 
			<cfif url.status EQ 'hold'><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif><a href="index.cfm?curdoc=app_process/apps_received&status=hold">On Hold</a></span> &middot;
			<cfif url.status EQ 'denied'><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif><a href="index.cfm?curdoc=app_process/apps_received&status=denied">Denied</a></span> ]
			#students.recordcount# student(s) displayed
		</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<!--- APPLICATIONS RECEIVED --->
<cfif url.status EQ 'received'>
	<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
		<tr>
			<td width="6%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=studentid">ID</a></td>
			<td width="14%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=familylastname">Last Name</a></td>
			<td width="14%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=firstname">First Name</a></td>
			<td width="8%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=sex">Sex</a></td>
			<td width="14%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=countryname">Country</a></td>
			<td width="6%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=randid">Type</a></td>
			<td width="14%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=randid">Intl. Agent</a></td>
			<td width="16%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=app_program">Program</a></td>
			<td width="8%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=companyshort">Company</a></td>
		</tr>
	</table>
	<div class="scroll">
	<table border=0 cellpadding=4 cellspacing=0 width=100%>
		<cfloop query="students">
		<cfset urllink = "index.cfm?curdoc=app_process/app_received_info&studentid=#studentid#">
		<cfif dateapplication GT client.lastlogin>
			<tr bgcolor="e2efc7">
		<cfelseif  #DateDiff('d',dateapplication, now())# GTE 25 AND #DateDiff('d',dateapplication, now())# LTE 34>
			<tr bgcolor="B3D9FF">
		<cfelseif  #DateDiff('d',dateapplication, now())# GTE 35 AND #DateDiff('d',dateapplication, now())# LTE 49>
			<tr bgcolor="FFFF9D">
		<cfelseif  #DateDiff('d',dateapplication, now())# GTE 50>
			<tr bgcolor="FF9D9D">
		<cfelse>
			<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
		</cfif>
				<td width="6%"><a href='#urllink#'>#Studentid#</a></td>
				<td width="14%"><a href='#urllink#'><cfif #len(familylastname)# gt 15>#Left(familylastname, 12)#...<Cfelse>#familylastname#</cfif></a></td>
				<td width="14%"><a href='#urllink#'>#firstname#</a></td>
				<td width="8%">#sex#</td>
				<td width="14%"><cfif len(#countryname#) lt 10>#countryname#<cfelse>#Left(countryname,13)#..</cfif></td>
				<td width="6%"><cfif randid EQ 0>Paper<cfelse>Online</cfif></td>
				<td width="14%">#businessname#</td>
				<td width="16%">#app_program#</td>
				<td width="6%"><a href="index.cfm?curdoc=app_process/apps_received_assignment&studentid=#studentid#"><cfif companyid EQ 0>Assign<cfelse>#companyshort#</cfif></a></td>
			</tr>
		</cfloop>
	</table>
	</div>
<!--- APPLICATIONS ON HOLD --->
<cfelseif url.status EQ 'hold'>
	<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
		<tr><td width="6%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=studentid">ID</a></td>
			<td width="14%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=familylastname">Last Name</a></td>
			<td width="14%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=firstname">First Name</a></td>
			<td width="6%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=sex">Sex</a></td>
			<td width="14%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=countryname">Country</a></td>
			<td width="6%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=randid">Type</a></td>
			<td width="18%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=app_program">Program</a></td>
			<td width="10%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=app_program">Hold Reason</a></td>
			<td width="12%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=companyshort">Company</a></td>
		</tr>
	</table>
	<div class="scroll">
	<table border=0 cellpadding=4 cellspacing=0 width=100%>
	<cfloop query="students">
		<cfset urllink = "index.cfm?curdoc=app_process/app_onhold_info&studentid=#studentid#">
		<cfif dateapplication GT client.lastlogin>
			<tr bgcolor="e2efc7">
		<cfelseif  #DateDiff('d',dateapplication, now())# GTE 25 AND #DateDiff('d',dateapplication, now())# LTE 34>
			<tr bgcolor="B3D9FF">
		<cfelseif  #DateDiff('d',dateapplication, now())# GTE 35 AND #DateDiff('d',dateapplication, now())# LTE 49>
			<tr bgcolor="FFFF9D">
		<cfelseif  #DateDiff('d',dateapplication, now())# GTE 50>
			<tr bgcolor="FF9D9D">
		<cfelse>
			<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
		</cfif>
				<td width="6%"><a href='#urllink#'>#Studentid#</a></td>
				<td width="14%"><a href='#urllink#'><cfif #len(familylastname)# gt 15>#Left(familylastname, 12)#...<Cfelse>#familylastname#</cfif></a></td>
				<td width="14%"><a href='#urllink#'>#firstname#</a></td>
				<td width="6%">#sex#</td>
				<td width="14%"><cfif len(#countryname#) lt 10>#countryname#<cfelse>#Left(countryname,13)#..</cfif></td>
				<td width="6%"><cfif randid EQ 0>Paper<cfelse>Online</cfif></td>
				<td width="18%">#app_program#</td>
				<td width="10%">#hold_reason#</td>
				<td width="11%">#companyshort#</td>
			</tr>
	</cfloop>
	</table>
	</div>
<!--- APPLICATIONS DENIED --->
<cfelse>
	<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
		<tr><td width="6%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=studentid">ID</a></td>
			<td width="14%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=familylastname">Last Name</a></td>
			<td width="14%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=firstname">First Name</a></td>
			<td width="6%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=sex">Sex</a></td>
			<td width="14%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=countryname">Country</a></td>
			<td width="6%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=randid">Type</a></td>
			<td width="18%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=app_program">Program</a></td>
			<td width="10%"><a href="?curdoc=app_process/apps_received&status=#url.status#">Denied By</a></td>
			<td width="12%"><a href="?curdoc=app_process/apps_received&status=#url.status#&order=companyshort">Company</a></td>
		</tr>
	</table>
	<div class="scroll">
	<table border=0 cellpadding=4 cellspacing=0 width=100%>
	<cfloop query="students">
		<cfquery name="denied_by" datasource="caseusa">
			SELECT hist.studentid, hist.status, hist.date,
				u.firstname, u.lastname, u.userid
			FROM smg_student_app_status hist
			INNER JOIN smg_users u ON u.userid = approvedby
			WHERE hist.studentid = '#studentid#'
				AND hist.status = '9'
			ORDER BY hist.date DESC
		</cfquery>	
		<cfset urllink = "index.cfm?curdoc=app_process/deny_app_info&studentid=#studentid#">
			<tr bgcolor="#iif(students.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td width="6%"><a href='#urllink#'>#Studentid#</a></td>
				<td width="14%"><a href='#urllink#'><cfif #len(familylastname)# gt 15>#Left(familylastname, 12)#...<Cfelse>#familylastname#</cfif></a></td>
				<td width="14%"><a href='#urllink#'>#firstname#</a></td>
				<td width="6%">#sex#</td>
				<td width="14%"><cfif len(#countryname#) lt 10>#countryname#<cfelse>#Left(countryname,13)#..</cfif></td>
				<td width="6%"><cfif randid EQ 0>Paper<cfelse>Online</cfif></td>
				<td width="18%">#app_program#</td>
				<td width="10%">#denied_by.firstname# #denied_by.lastname#</td>
				<td width="11%">#companyshort#</td>
			</tr>
	</cfloop>
	</table>
	</div>
</cfif>

<table width=100% bgcolor="##ffffe6" class="section">
	<tr>
		<td bgcolor="e2efc7">Students in Green have been added since your last vist.</td>
		<td align="right">CTRL-F to search</td>
	</tr>
	<tr>
		<td bgcolor="B3D9FF">Applications waiting  for 25-34 days.</td>
		<td bgcolor="FFFF9D">Student waiting for 35-49 days</td>
		<td bgcolor="FF9D9D">Student waiting more than 50 days</td>
	</tr>
	<tr>
		<td colspan=4 align="Center">
			<a href="index.cfm?curdoc=app_process/new_paper_app"><img src="pics/add-student.gif" border="0" align="middle"></img></a>&nbsp; &nbsp; &nbsp; &nbsp;
		</td>
	</tr>
</table>

</cfoutput>

<cfinclude template="../table_footer.cfm">

</body>
</html>