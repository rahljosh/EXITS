<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>International Representative List</title>
</body>
<link href="../style.css" rel="stylesheet" type="text/css">

<cftry>

<cfquery name="intagent" datasource="MySql">
	SELECT userid, firstname, lastname, businessname, uniqueid,
		smg_countrylist.countryname
	FROM smg_users
	LEFT JOIN smg_countrylist ON country = smg_countrylist.countryid
	WHERE usertype = 8
		AND active = '1'
	ORDER BY <cfif IsDefined('url.order')>#url.order#<cfelse>businessname</cfif>
</cfquery>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" bgcolor="#FFFFFF">
  <tr>
    <td bordercolor="#FFFFFF">

<cfoutput>
<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp;International Representative</td>
		<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">#intagent.recordcount# International Representative(s) found</td>
		<td width="2%" bgcolor="##E4E4E4">&nbsp;</td>
	</tr>
</table>
<br>
<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
	<tr bgcolor="##4F8EA4">
		<td width="6%"><a href="?curdoc=intrep/intreps&order=userid&active=1" class="style2">ID</a></td>
		<td width="30%"><a href="?curdoc=intrep/intreps&order=businessname&active=1" class="style2">International Rep.</a></td>
		<td width="22%"><a href="?curdoc=intrep/intreps&order=firstname&active=1" class="style2">First Name</a></td>
		<td width="22%"><a href="?curdoc=intrep/intreps&order=lastname&active=1" class="style2">Last Name</a></td>
		<td width="20%"><a href="?curdoc=intrep/intreps&order=countryname&active=1" class="style2">Country</a></td>
	</tr>
	<cfloop query="intagent">
    	<tr bgcolor="###iif(intagent.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
			<td class="style4"><a href="?curdoc=intrep/intrep_info&uniqueid=#uniqueid#" class="style4">#userid#</a></td>
			<td class="style4"><a href="?curdoc=intrep/intrep_info&uniqueid=#uniqueid#" class="style4">#businessname#</a></td>
			<td class="style5">#firstname#</td>
			<td class="style5">#lastname#</td>
			<td class="style5">#countryname#</td>
		</tr>
	</cfloop>
</table>
<br><br>
</cfoutput>
<div align="center">
<a href="index.cfm?curdoc=intrep/new_intrep"><img src="../pics/add-intrep.gif" border="0" align="middle" alt="Add a Intl. Rep."></img></a></div>
<br>


</td>
  </tr>
</table>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</html>