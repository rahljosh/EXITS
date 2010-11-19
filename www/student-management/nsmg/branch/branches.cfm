<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Branches List</title>
</head>
<body>

<cfif isDefined("url.order")>
<cfelse> 
	<cfset url.order = "businessname">
</cfif>
<cfquery name="check_if_master" datasource="mysql">
select master_account
from smg_users
where userid = #client.userid#
</cfquery>
<Cfif check_if_master.master_account eq 0>
	<cfquery name="branches" datasource="MySQL">
		SELECT *
		FROM smg_users
		WHERE intrepid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
		ORDER BY '#url.order#'
	</cfquery>
<cfelse>
	<cfquery name="branches" datasource="MySQL">
		SELECT *
		FROM smg_users
		WHERE master_accountid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
		ORDER BY '#url.order#'
	</cfquery>

</Cfif>
<style type="text/css">
<!--
div.scroll {
	height: 325px;
	width: 99,5%;
	overflow: auto;
	border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
}
-->
</style>

<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
		<td background="pics/header_background.gif"><h2>Branches</h2> </td>
		<td background="pics/header_background.gif" align="right">[ &nbsp; #branches.recordcount# branches displayed &nbsp; ]</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr> 
		<td width=50><a href="?curdoc=branch/branches&order=branchid">ID</a></td>
		<td width=160><a href="?curdoc=branch/branches&order=businessname">Branch Name</a></td>
		<td width=160><a href="?curdoc=branch/branches&order=firstname">Contact</a></td>
		<td width=100><a href="?curdoc=branch/branches&order=phone">Phone</a></td>
		<td width=100><a href="?curdoc=branch/branches&order=email">Email</a></td>
		<td width=100><a href="?curdoc=branch/branches&order=city">City</a></td>
		<td width=50><a href="?curdoc=branch/branches&order=state">State</a></td>
	</tr>
</table>

<div class="scroll">
<table border=0 cellpadding=4 cellspacing=0 width=100%>
	<cfif branches.recordcount EQ '0'>
		<tr><td width="600">You have no branches on your list. If you wish to add a new branch please use the button below.</td></tr>
	<cfelse>
		<cfloop query="branches">
		<tr bgcolor="#iif(branches.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
				<td width=50><a href='?curdoc=branch/branch_info&branchid=#userid#&m=#check_if_master.master_account#'>#userid#</a></td>
				<td width=160><a href='?curdoc=branch/branch_info&branchid=#userid#&m=#check_if_master.master_account#'>#businessname#</a></td>
				<td width=160><a href='?curdoc=branch/branch_info&branchid=#userid#&m=#check_if_master.master_account#'>#firstname# #lastname#</a></td>
				<td width=100>#phone#</td>
				<td width=100>#email#</td>
				<td width=100>#city#</td>
				<td width=50>#state#</td>
			</tr>
		</cfloop>
	</cfif>
</table>
</div>

<table border=0 cellpadding=4 cellspacing=0 width=100% class=section>
<tr><td align="center">
		<cfform action="?curdoc=branch/add_branch" name="new_branch" method="post">
			<cfinput type="submit" name="submit" value="   New Branch   ">
		</cfform>
</td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table><br>

</cfoutput>

</body>
</html>
