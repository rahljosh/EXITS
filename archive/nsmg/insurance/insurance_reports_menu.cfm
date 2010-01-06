<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_intl_rep.cfm">

<cfquery name="get_regions" datasource="MySQL">
	select regionid, regionname,
		   companyshort
	from smg_regions
	INNER JOIN smg_companies ON company = companyid
	where regionid > 7 
	<cfif #client.companyid# is 5><cfelse>
		and company = '#client.companyid#'</cfif>
	<cfif client.usertype GT 4>
		and regionid like '#client.regions#'</cfif>
	order by companyshort, regionname
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Caremed Insurance - Excel files and Reports</h2></td>
		<td background="pics/header_background.gif" align="right">
			<cfif NOT IsDefined('url.all')>
				<a href="?curdoc=insurance/insurance_reports_menu&all=1">Show All Programs</a>
			<cfelse>
				<a href="?curdoc=insurance/insurance_reports_menu">Show Active Programs Only</a>
			</cfif>
		</td>		
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>

	<table class="nav_bar" cellpadding=6 cellspacing="0" align="center" width="95%">
	<tr><th colspan="2" bgcolor="e2efc7"><span class="get_attention"><b>::</b></span> Reports</th></tr></table>
	
	<table cellpadding=4 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
		<cfform action="insurance/caremed_report.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="left" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Students Termination Date</th></tr>
				<tr><td>Program(s):</td>
					<td><select name="programid" multiple  size="6">
						<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# &nbsp; </cfif>#programname#</option></cfoutput>
						</select></td></tr>
				<tr align="left">
					<TD>Regions :</td>
					<TD><select name="regionid" size="1">
						<option value=0>All Regions</option>			
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr><td align="right"><input type="checkbox" name="caremed"></td><td>Include Only Students Insured by SMG/Caremed</td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
		</td>
		<td width="50%" valign="top">
		<cfform action="insurance/caremed_report_extension.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="right" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Students - Invoicing Extension Report</th></tr>
				<tr><td>Program(s):</td>
					<td><select name="programid" multiple  size="6">
						<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# &nbsp; </cfif>#programname#</option></cfoutput>
						</select>
					</td></tr>
				<tr align="left">
					<TD>Intl. Agents :</td>
					<TD><select name="agentid" size="1">
							<option value=0>All Agents</option>			
							<cfoutput query="get_intl_rep"><option value="#userid#">#businessname#</option></cfoutput>
						</select>
					</td></tr>
					<tr><td align="right"><input type="checkbox" name="caremed" disabled></td><td></td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
		</td></tr>
	</table><br><br>

	<table cellpadding=4 cellspacing="0" align="center" width="96%">
	<tr>
		<td width="50%" valign="top">
		<cfform action="insurance/rp_program_duration.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="right" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Program Duration</th></tr>
				<tr><td>Program(s):</td>
					<td><select name="programid" multiple  size="6">
						<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# &nbsp; </cfif>#programname#</option></cfoutput>
						</select>
					</td></tr>
				<tr align="left">
					<TD>Intl. Agents :</td>
					<TD><select name="agentid" size="1">
							<option value=0>All Agents</option>			
							<cfoutput query="get_intl_rep"><option value="#userid#">#businessname#</option></cfoutput>
						</select>
					</td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
		</td>
		<td width="50%" valign="top">
		<!----<cfform action="insurance/students_not_covered.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" align="right" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Students Not Covered as of Today</th></tr>
				<tr><td>Program(s):</td>
					<td><select name="programid" multiple  size="6">
						<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# &nbsp; </cfif>#programname#</option></cfoutput>
						</select>
					</td></tr>
				<tr align="left">
					<TD>Intl. Agents :</td>
					<TD><select name="agentid" size="1">
							<option value=0>All Agents</option>			
							<cfoutput query="get_intl_rep"><option value="#userid#">#businessname#</option></cfoutput>
						</select>
					</td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>---->
		</td></tr>
	</table><br><br>
	

</td></tr>
</table>
<cfinclude template="../table_footer.cfm">