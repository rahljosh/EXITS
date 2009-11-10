<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Users List</title>
</body>
<link href="../style.css" rel="stylesheet" type="text/css">

<cftry>

<cfquery name="users" datasource="MySql">
	SELECT u.userid, u.firstname, u.lastname, u.uniqueid, u.city, u.phone,
		sta.state
	FROM smg_users u
	INNER JOIN user_access_rights uar ON uar.userid = u.userid
	LEFT JOIN smg_states sta ON sta.id = u.state
	WHERE u.active = '1'
		AND uar.usertype <= '4'
		AND uar.companyid = '#client.companyid#' 
	ORDER BY <cfif IsDefined('url.order')>#url.order#<cfelse>u.firstname</cfif>
</cfquery>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" bgcolor="#FFFFFF">
  <tr>
    <td bordercolor="#FFFFFF">
		<cfoutput>
		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
			<tr valign=middle height=24>
				<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp; Users</td>
				<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">#users.recordcount# User(s) found</td>
				<td width="2%" bgcolor="##E4E4E4">&nbsp;</td>
			</tr>
		</table>
		<br>
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
			<tr>
				<td width="6%" bgcolor="4F8EA4"><a href="?curdoc=user/users&order=userid&active=1" class="style2">ID</a></td>
				<td width="22%" bgcolor="4F8EA4"><a href="?curdoc=user/users&order=firstname&active=1" class="style2">First Name</a></td>
				<td width="22%" bgcolor="4F8EA4"><a href="?curdoc=user/users&order=lastname&active=1" class="style2">Last Name</a></td>	
				<td width="20%" bgcolor="4F8EA4"><a href="?curdoc=user/users&order=city&active=1" class="style2">City</a></td>
				<td width="10%" bgcolor="4F8EA4"><a href="?curdoc=user/users&order=state&active=1" class="style2">State</a></td>
				<td width="20%" bgcolor="4F8EA4"><a href="?curdoc=user/users&order=phone&active=1" class="style2">Phone</a></td>
			</tr>
			<cfloop query="users">
			<tr bgcolor="#iif(users.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5">
				<td><a href="?curdoc=user/user_info&uniqueid=#uniqueid#" class="style4">#userid#</a></td>
				<td><a href="?curdoc=user/user_info&uniqueid=#uniqueid#" class="style4">#firstname#</a></td>
				<td><a href="?curdoc=user/user_info&uniqueid=#uniqueid#" class="style4">#lastname#</a></td>
				<td>#city#</td>
				<td>#state#</td>
				<td>#phone#</td>
			</tr>
			</cfloop>
		</table>
		<br><br>
		</cfoutput>
		<div align="center">
		<a href="index.cfm?curdoc=user/new_user_question"><img src="../pics/add-user.gif" border="0" align="middle" alt="Add an User"></img></a></div>
		<br>
	</td>
  </tr>
</table>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</html>