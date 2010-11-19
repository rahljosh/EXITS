<!--- GRAPHICS REPORT --->
<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_seasons.cfm">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>G R A P H I C S &nbsp; * CURRENTLY ONLY WORKS WITH FIREFOX * </h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>
	<table width="96%" align="center" cellpadding=6 cellspacing="0">
	<tr>
		<td width="50%" valign="top">
		<cfform action="?curdoc=reports/graphics_report" method="POST">
			<Table class="nav_bar" align="center" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Statistical Graphics per Program</th></tr>
				<tr>
					<td>Program(s) :</td>
					<td>
						<select name="programid" multiple  size="6">
						<cfif client.companyid is '5'>
							<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>
						<cfelse>
							<cfoutput query="get_program"><option value="#ProgramID#">#ProgramName#</option></cfoutput>
						</cfif>
						</select>
					</td>
				</tr>
				<tr><td colspan="2">
					Select the programs you want to include to generate the graphics:<br>
					<font size=-2>*hold down shift to select a consecutive range of  programs</font><br>
					<font size=-2>**hold down ctrl to select individual programs</font><br><br>
				</td></tr>
				<tr>
					<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
		</cfform>
		<cfif client.usertype eq 1><br />
			<cfform action="reports/graphics_report.cfm" method="POST" target="_blank">		
				<Table class="nav_bar" align="center" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="#e2efc7">Statistical Graphics per Program TEST</th></tr>
					<tr>
						<td>Program(s) :</td>
						<td>
							<select name="programid" multiple  size="6">
							<cfif client.companyid is '5'>
								<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>
							<cfelse>
								<cfoutput query="get_program"><option value="#ProgramID#">#ProgramName#</option></cfoutput>
							</cfif>
							</select>
						</td>
					</tr>
					<tr><td colspan="2">
						Select the programs you want to include to generate the graphics:<br>
						<font size=-2>*hold down shift to select a consecutive range of  programs</font><br>
						<font size=-2>**hold down ctrl to select individual programs</font><br><br>
					</td></tr>
					<tr>
						<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
			</cfform>
		</cfif>
		</td>
		<td width="50%" valign="top">
		<cfform action="?curdoc=reports/graphics_report_season" method="POST">
			<Table class="nav_bar" align="center" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Statistical Graphics per Season</th></tr>
				<tr>
					<td align="right">Season(s) :</td>
					<td align="left">
						<select name="seasonid" multiple  size="6">
							<cfoutput query="get_seasons"><option value="#seasonid#">#season#</option></cfoutput>
						</select>
					</td>
				</tr>
				<tr><td colspan="2">
					Select the seasons you want to include to generate the graphics:<br>
					<font size=-2>*hold down shift to select a consecutive range of seasons</font><br>
					<font size=-2>**hold down ctrl to select individual seasons</font><br><br>
				</td></tr>
				<tr>
					<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
		</cfform>
		</td>	
	</tr>
	</table>
	
</td></tr>
</table>
<cfinclude template="../table_footer.cfm">	