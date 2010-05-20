<!--- Kill Extra Output --->
<cfsilent>

    <cfinclude template="../querys/get_programs.cfm">
    
    <cfquery name="get_seasons" datasource="MySql">
        SELECT seasonid, season
        FROM smg_seasons
        WHERE active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>CBC Menu - Re-Run CBCs</title>
</head>

<body>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>CBC Re-Run Feature</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput>
<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
<tr><td>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/re_run_users.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Check CBCS for All Active Users</th></tr>
				<tr>
					<td colspan="2">
						This feature checks CBCS ran for users and members before #DateFormat(DateAdd('yyyy', -1, now()),'mm-dd-yyyy')# and 
						creates a new set of record for the following season in order to send a new batch.
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/re_run_hosts.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Repeat Hosts</th></tr>
				<tr>
					<td colspan="2">
						This feature checks for repeat host families with CBCS ran before #DateFormat(DateAdd('yyyy', -1, now()),'mm-dd-yyyy')# and creates a 
						new set of record for the following season in order to send a new batch.
					</td>
				</tr>
				<tr align="left">
					<TD width="25%">Program Season :</td>
					<TD><cfselect name="seasonid" query="get_seasons" display="season" value="seasonid" queryPosition="below">			
						<option value=0>Select a season</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<TD>Host type :</td>
					<TD><cfselect name="cbc_type">			
						<option value=0>Select an host type</option>
						<option value="father">Host Father</option>
						<option value="mother">Host Mother</option>
						<option value="member">Host Members</option>
						</cfselect>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>	
		</td>
	</tr>
</table><br>

</td></tr>
</table>

</cfoutput>

<!----footer of table --- new message ---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table><br>

</body>
</html>
