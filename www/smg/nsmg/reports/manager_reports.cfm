<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<!--- PROGRAM LIST --->
<cfinclude template="../querys/get_programs.cfm">
<!--- REGION LIST --->
<!--- <cfinclude template="../querys/get_user_regions.cfm"> --->

<cfif client.usertype LTE 4>
	<!--- Query for Office Users --->
	<cfquery name="get_regions" datasource="MySQL">
	select regionid, regionname, companyshort
	from smg_regions
	INNER JOIN smg_companies ON company = companyid
	WHERE subofregion = '0'
	<cfif #client.companyid# NEQ '5'>
		AND company = '#client.companyid#'
	</cfif>
	ORDER BY companyshort, regionname
	</cfquery> 
<cfelse>
	<!--- Query for the field  --->
	<cfquery name="get_regions" datasource="MySQL">
		SELECT user_access_rights.regionid, smg_regions.regionname, user_access_rights.usertype
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' 
			AND user_access_rights.companyid = '#client.companyid#'
		ORDER BY default_region DESC, regionname
	</cfquery>
</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Reports</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>

<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
	<td width="50%" valign="top">
		<cfform action="reports/flight_information_report.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Flight Arrival Information</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" multiple  size="4">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid is '5'>#get_program.companyshort# - </cfif>#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<TD>Region :</td>
					<TD><select name="regionid" size="1">
						<cfif client.usertype GT 4><cfelse>
						<option value=0>All Regions</option>
						</cfif>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Arrival Date)</input></td></tr>
				<tr>
					<td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td>
				</tr>
				<tr>
					<td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td></tr>			
			<tr><TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>
	</td>
	<td width="50%">
		<cfform action="reports/flight_info_depart_report.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Flight Departure Information</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" multiple  size="4">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid is '5'>#get_program.companyshort# - </cfif>#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<TD>Region :</td>
					<TD><select name="regionid" size="1">
						<cfif client.usertype GT 4><cfelse>
						<option value=0>All Regions</option>
						</cfif>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
								<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Depar. Date)</input></td></tr>
				<tr>
					<td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td>
				</tr>
				<tr>
					<td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td></tr>			
				<tr><TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	</tr>
</table><br>

<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
	<td width="50%">
		<cfform action="reports/flight_info_missing_by_region.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Flight Info Missing By Region</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" multiple  size="4">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid is '5'>#get_program.companyshort# - </cfif>#programname#</option></cfoutput></select></td></tr>
					<TD>Region :</td>
					<TD><select name="regionid" size="1">
						<cfif client.usertype GT 4><cfelse>
						<option value=0>All Regions</option>
						</cfif>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr><td>Pre-AYP :</td>
				<td><select name="preayp" size="1">
					<option value='none'>None</option>
					<option value="english">English Camp</option>
					<option value="orientation">Orientation Camp</option>
					<option value="all">Both Camps</option>
					</select></td></tr>									
				<tr><TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	<td width="50%">
			<!--- new form here --->
	</td>
	</tr>
</table><br>

</td></tr>
</table>
<cfinclude template="../table_footer.cfm">	