<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Dept. of State - Reports</title>
</head>

<body>

<cfif client.usertype GT '4'>
	Sorry, you do not have access to this page.
	<cfabort>
</cfif>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_company_short.cfm">

<cfinclude template="../querys/get_regions.cfm">

<cfquery name="get_history_files" datasource="caseusa">
	SELECT DISTINCT companyid, datecreated, timecreated
	FROM smg_csiet_history
	WHERE companyid = '#client.companyid#'
	ORDER BY datecreated DESC
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>Department of State and CSIET Reports</h2></td>
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
			<cfform action="reports/ds2019_report_excel.cfm" method="POST">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">DOS - EXCEL SPREADSHEET - DS 2019 Placement Report</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#get_program.companyshort# - </cfif>#programname#</option></cfloop></select>
					</td>
				</tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
		</td>
	</tr>
</table><br>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="reports/ds2019_report.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">DOS - DS 2019 Placement Report</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#get_program.companyshort# - </cfif>#programname#</option></cfloop></select>
					</td>
				</tr>
			<tr><td></td><td><input type="text" disabled size="6"></td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="reports/ds2019_report_ver.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">DOS - DS 2019 Placement Report by Region</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#get_program.companyshort# - </cfif>#programname#</option></cfloop></select>
					</td>
				</tr>
				<tr>
					<TD>Region :</td>
					<TD><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
						</select></td></tr>				
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
</table><br>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="reports/csiet_direct_place_report.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">CSIET - Direct Placement Report</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#get_program.companyshort# - </cfif>#programname#</option></cfloop></select>
					</td>
				</tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="reports/csiet_graduated_students.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">CSIET - Graduated Students</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#get_program.companyshort# - </cfif>#programname#</option></cfloop></select>
					</td>
				</tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
</table><br>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="reports/dept_unplaced_list.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">Unplaced Students whom forms were issued by #companyshort.companyshort#</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#get_program.companyshort# - </cfif>#programname#</option></cfloop></select>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table><br>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">

		</td>
	</tr>
</table><br>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr><th colspan="2" bgcolor="e2efc7">H I S T O R Y &nbsp; &nbsp; R E P O R T S</th></tr>
	<tr>
		<td align="center" width="50%" valign="top">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
			<cfform action="reports/ds2019_history.cfm" method="POST" target="blank">
				<tr><th colspan="2" bgcolor="e2efc7">DOS - DS 2019 Placement Report</th></tr>
				<tr>
					<TD>History Files :</td>
					<TD><select name="datecreated" size="1">
						<cfloop query="get_history_files"><option value="#DateFormat(datecreated, 'yyyy-mm-dd')#">#DateFormat(datecreated, 'mm/dd/yyyy')# #TimeFormat(timecreated, 'hh:mm tt')#</option></cfloop>
						</select></td>
				</tr>				
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</cfform>
			<tr><td>&nbsp;</td></tr>
			<cfform action="reports/ds2019_history_word.cfm" method="POST">
				<tr><th colspan="2" bgcolor="e2efc7">DOS - DS 2019 Placement Report - Word Format</th></tr>
				<tr>
					<TD>History Files :</td>
					<TD><select name="datecreated" size="1">
						<cfloop query="get_history_files"><option value="#DateFormat(datecreated, 'yyyy-mm-dd')#">#DateFormat(datecreated, 'mm/dd/yyyy')# #TimeFormat(timecreated, 'hh:mm tt')#</option></cfloop>
						</select></td>
				</tr>				
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</cfform>					
			</table>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="reports/ds2019_history_references.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">CSIET - Long Term References</th></tr>
				<tr>
					<TD>History Files :</td>
					<TD><select name="datecreated" size="1">
						<cfloop query="get_history_files"><option value="#DateFormat(datecreated, 'yyyy-mm-dd')#">#DateFormat(datecreated, 'mm/dd/yyyy')# #TimeFormat(timecreated, 'hh:mm tt')#</option></cfloop>
						</select></td>
				</tr>
				<tr><td>Random Numbers :</td><td><textarea name="random" cols="35" rows="5"></textarea></td></tr>
				<tr><td colspan="2">* Random numbers must be separated by a comma.</td></tr>								
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
</table><br>

<table width=100% border=0 cellpadding=4 cellspacing=0>
	<tr>
		<td align="center" width="50%" valign="top">
			<cfform action="reports/ds2019_history_random.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">CSIET - DS 2019 According to Random numbers</th></tr>
				<tr>
					<TD>History Files :</td>
					<TD><select name="datecreated" size="1">
						<cfloop query="get_history_files"><option value="#DateFormat(datecreated, 'yyyy-mm-dd')#">#DateFormat(datecreated, 'mm/dd/yyyy')# #TimeFormat(timecreated, 'hh:mm tt')#</option></cfloop>
						</select></td>
				</tr>
				<tr><td>Random Numbers :</td><td><textarea name="random" cols="35" rows="5"></textarea></td></tr>
				<tr><td colspan="2">* Random numbers must be separated by a comma.</td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td align="center" width="50%" valign="top">
			<cfform action="reports/ds2019_history_rand_excel.cfm" method="POST" target="blank">
			<Table cellpadding=6 cellspacing="0" align="center" width="100%">
				<tr><th colspan="2" bgcolor="e2efc7">DOS - DS 2019 According to Random numbers (Excel File)</th></tr>
				<tr>
					<TD>History Files :</td>
					<TD><select name="datecreated" size="1">
						<cfloop query="get_history_files"><option value="#DateFormat(datecreated, 'yyyy-mm-dd')#">#DateFormat(datecreated, 'mm/dd/yyyy')# #TimeFormat(timecreated, 'hh:mm tt')#</option></cfloop>
						</select></td>
				</tr>
				<tr><td>Random Numbers :</td><td><textarea name="random" cols="35" rows="5"></textarea></td></tr>
				<tr><td colspan="2">* Random numbers must be separated by a comma.</td></tr>
				<tr><TD colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
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