<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>CBC Managers Reports</title>
</head>

<body>

<cfif client.usertype GT '5'>
	Sorry, you do not have access to this page.
	<cfabort>
</cfif>

<cfinclude template="../querys/get_regions.cfm">

<cfinclude template="../querys/get_programs.cfm">

<cfquery name="get_seasons" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
	WHERE active = '1'
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>CBC Authorization Form Reports</h2></td>
		<cfif client.usertype LTE 4>
		<td background="pics/header_background.gif" align="right">
			<cfif NOT IsDefined('url.all')>
				<a href="?curdoc=cbc/managers_menu&all=1">Show All Programs</a>
			<cfelse>
				<a href="?curdoc=cbc/managers_menu">Show Active Programs Only</a>
			</cfif>
		</td>
		</cfif>		
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput>
<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
<tr><td>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr><th colspan="2" bgcolor="e2efc7">R E P O R T S</th></tr>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_hosts_auth_not_rec.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Hosts - Authorization not received (Current placing/assigned to student)</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value="1">Host Parents</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<td>Region :</td>
					<td><cfselect name="regionid" multiple size="4">
						<cfif client.usertype LTE '4'><option value="0" selected="selected">All Regions</option></cfif>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</cfselect>
					</td>
				</tr>		
				<tr align="left">
					<TD width="15%">Season :</td>
					<TD><cfselect name="seasonid">			
						<option value=0>Select a season</option>
						<cfloop query="get_seasons">
						<option value="#seasonid#">#season#</option>
						</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td colspan="2">* Active programs only.</td></tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_hosts_auth_prog.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Hosts - Authorization not received</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value="1">Host Parents</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<td>Region :</td>
					<td><cfselect name="regionid" multiple size="4">
						<cfif client.usertype LTE 4><option value=0 selected="selected">All Regions</option></cfif>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</cfselect>
					</td>
				</tr>												
				<tr align="left">
					<TD width="15%">Program :</td>
					<TD><cfselect name="programid" multiple size="4">			
							<cfloop query="get_program">
								<option value="#ProgramID#"><cfif client.companyid EQ '5'>#get_program.companyshort# - </cfif>#programname#</option>
							</cfloop>
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

	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_members_auth_not_rec.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Host Members 18+ living with Parents - Authorization not received</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value="1">Other Members</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<td>Region :</td>
					<td><cfselect name="regionid" multiple size="4">
						<cfif client.usertype LTE '4'><option value="0" selected="selected">All Regions</option></cfif>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</cfselect>
					</td>
				</tr>		
				<tr align="left">
					<TD width="15%">Season :</td>
					<TD><cfselect name="seasonid">			
						<option value=0>Select a season</option>
						<cfloop query="get_seasons">
						<option value="#seasonid#">#season#</option>
						</cfloop>
						</cfselect>
					</td>
				</tr>
				<tr><td colspan="2">* Active programs only.</td></tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_members_auth_prog.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Host Members 18+ living with Parents - Authorization not received</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<option value="1">Host Parents</option>
						</cfselect>
					</td>
				</tr>
				<tr align="left">
					<td>Region :</td>
					<td><cfselect name="regionid" multiple size="4">
						<cfif client.usertype LTE 4><option value=0 selected="selected">All Regions</option></cfif>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</cfselect>
					</td>
				</tr>												
				<tr align="left">
					<TD width="15%">Program :</td>
					<TD><cfselect name="programid" multiple size="4">			
							<cfloop query="get_program">
								<option value="#ProgramID#"><cfif client.companyid EQ '5'>#get_program.companyshort# - </cfif>#programname#</option>
							</cfloop>
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

	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="cbc/rp_users_auth_not_rec.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Active Users - CBC Authorization Forms Not Received</th></tr>
				<tr align="left">
					<TD width="15%">Usertype :</td>
					<TD><cfselect name="usertype">			
						<cfif client.usertype LTE '4'><option value="1">Office</option></cfif>
						<option value="2">Reps</option>
						</cfselect>
					</td>
				</tr>	
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<cfif client.usertype LTE '4'><option value="0">All</option></cfif>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</select>
					</td>
				</tr>				
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<!--- available --->
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