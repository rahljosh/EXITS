<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_regions.cfm">

<cfinclude template="../querys/get_intl_rep.cfm">

<cfinclude template="../querys/get_all_intl_rep.cfm">

<cfinclude template="../querys/get_countries.cfm">

<cfinclude template="../querys/get_states.cfm">

<cfinclude template="../querys/get_facilitators.cfm">

<cfinclude template="../querys/get_insurance_type.cfm">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Overall Program Reports</h2></td>
		<td background="pics/header_background.gif" align="right">
			<cfif NOT IsDefined('url.all')>
				<a href="?curdoc=reports/overall_reports_menu&all=1">Show All Programs</a>
			<cfelse>
				<a href="?curdoc=reports/overall_reports_menu">Show Active Programs Only</a>
			</cfif>
		</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>

<!--- ROW 1 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
			<cfform action="reports/students_per_region.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Students per Region</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Status :</td>
					<td><select name="status" size="1">
						<option value=0>All</option><option value=1>Placed</option><option value=2>Unplaced</option>
						</select></td></tr>
				<tr><td>Continent :</td>
				<td><select name="continent" size="1">
					<option value=0>All</option>
					<option value="Asia">Asia</option><option value="Europe">Europe</option><option value="South America">South America</option>
					</select></td></tr>
				<tr><td>Pre-AYP :</td>
				<td><select name="preayp" size="1">
					<option value='none'>None</option>
					<option value="english">English Camp</option><option value="orientation">Orientation Camp</option><option value="all">Both Camps</option>
					</select></td></tr>	
				<tr>
					<td align="right"><input type="checkbox" name="usa"></input></td>
					<td>American Citizen Students (Birth, Resident or Citizenship Countries)</td>
				</tr>								
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
</td>
<td width="50%" valign="top">
		<cfform action="reports/students_per_intl_rep.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Students per International Rep.</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><select name="intrep" size="1">
						<option value=0>All Intl. Reps</option>
						<cfoutput query="get_intl_rep"><option value="#intrep#">#businessname#</option></cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Status :</td>
					<td><select name="status" size="1">
						<option value=0>All</option><option value=1>Placed</option><option value=2>Unplaced</option>
					</select></td></tr>
				<tr align="left">
					<td>Active :</td>
					<td><select name="active" size="1">
						<option value=1>Active</option>
						<option value=0>Inactive</option>
						<option value=2>Canceled</option>					
						<option value=3>All</option>
						</select></td></tr>					
				<tr><td>Pre-AYP :</td>
				<td><select name="preayp" size="1">
					<option value='none'>None</option>
					<option value="english">English Camp</option><option value="orientation">Orientation Camp</option><option value="all">Both Camps</option>
					</select></td></tr>			
				<tr><td>&nbsp;</td></tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
</td>
</tr>
</table><br>

<!--- ROW 2 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
			<cfform action="reports/students_region_guarantee.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Students - Region Guarantee Only</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Status :</td>
					<td><select name="status" size="1">
						<option value=0>All</option><option value=1>Placed</option><option value=2>Unplaced</option>
						</select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
</td>
<td width="50%" valign="top">
			<cfform action="reports/students_state_guarantee.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Students - State Guarantee Only</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Status :</td>
					<td><select name="status" size="1">
						<option value=0>All</option><option value=1>Placed</option><option value=2>Unplaced</option>
						</select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
</td>
</tr>
</table><br>

<!--- ROW 2 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
		<cfform action="reports/students_us_citizens.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">US Citizen Students in Program</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td>
					<select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif #len(programname)# gt 25>#Left(programname, 23)#..<cfelse>#programname#</cfif></option></cfoutput>
					</select>
					</td>
				</tr>
				<tr><td colspan="2">Countries of Birth, Citizen and/or Residence = USA</td></tr>
				<tr>
					<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0 ></td>
				</tr>
			</table>
		</cfform>
</td>
<td width="50%" valign="top">
		<cfform action="reports/overall_students_per_fac.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Overall Students by Facilitator</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td>
					<select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif #len(programname)# gt 25>#Left(programname, 23)#..<cfelse>#programname#</cfif></option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<td>Facilitator :</td>
					<td>
					<select name="userid" size="1">
					<option value=0>All </option>		
					<cfoutput query="get_facilitators"><option value="#userid#">#get_facilitators.firstname# #get_facilitators.lastname#</option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0 ></td>
				</tr>
			</table>
		</cfform>
</td>
</tr>
</table><br>

<!--- ROW 3 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
		<cfform action="reports/total_students_graduated.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Total of Graduated Students per Country (12th grade)</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
			<tr align="left">
				<td>Country :</td>
				<td><select name="countryid" size="1">			
					<option value=0>All Countries</option>
					<cfoutput query="get_countries"><option value="#Countryid#">#countryname#</option></cfoutput>
					</select></td></tr>
			<tr><td></td><td><input type="text" size="8" name="dateplaced" maxlength="10" readonly="yes"></td></tr>
			<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>
</td>
<td width="50%" valign="top">
		<cfform action="reports/graduate_students_region.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Total of Graduated Students per Region (Placed Only)</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
			<tr><td>Last Placement Date:</td><td><input type="text" size="8" name="dateplaced" maxlength="10"> mm/dd/yyyy</td></tr>
			<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>		
</td>
</tr>
</table><br>


<!--- ROW 4 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
			<cfform action="reports/scholarship_students.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Scholarship Students</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
				<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Status :</td>
					<td><select name="status" size="1">
						<option value=0>All</option><option value=1>Placed</option><option value=2>Unplaced</option>
						</select></td></tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
</td>
<td width="50%" valign="top">
<!--- 	<cfform action="?curdoc=reports/students_per_intl_rep" method="POST"> --->
		<cfform action="reports/iff_students.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">IFF Students</th></tr>
				<tr align="left">
					<td>Program : </td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>					</select></td></tr>
					</select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Status :</td>
					<td><select name="status" size="1">
						<option value=0>All</option><option value=1>Placed</option><option value=2>Unplaced</option>
					</select></td></tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
</td>
</tr>
</table><br>


<!--- ROW 5 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
		<cfform action="reports/total_students_per_country.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Total of Students per Country</th></tr>
			<tr align="left">
				<td>Program : </td>
				<td><select name="programid" multiple  size="6">
				<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>					</select></td></tr>
				</select></td></tr>
			<tr align="left">
				<td>Country :</td>
				<td><select name="countryid" size="1">			
					<option value=0>All Countries</option>
					<cfoutput query="get_countries"><option value="#Countryid#">#countryname#</option></cfoutput>
					</select></td></tr>
			<tr align="left">
				<td>Place Status :</td>
				<td><select name="status" size="1">
					<option value=0>All</option><option value=1>Placed</option><option value=2>Unplaced</option>
				</select></td></tr>
			<tr><td align="right"><input type="checkbox" name="all" /></td><td>Include All Students (canceled and inactive)</td></tr>
			<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>
</td>
<td width="50%" valign="top">
		<cfform action="reports/total_students_per_country_agent.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Total of Students per Country and Intl. Rep.</th></tr>
			<tr>
				<td>Program(s) :</td>
				<td>
					<select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>					</select></td></tr>
					</select>
				</td>
			</tr>
			<tr align="left">
				<td>Country :</td>
				<td><select name="countryid" size="1">			
					<option value=0>All Countries</option>
					<cfoutput query="get_countries"><option value="#Countryid#">#countryname#</option></cfoutput>
					</select></td></tr>
			<tr>
				<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
			</tr>
		</table>
		</cfform>
</td>
</tr>
</table><br>


<!--- ROW 6 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
		<cfform action="reports/total_students_per_agent.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Total of Students per International Rep.</th></tr>
			<tr>
				<td>Program(s) :</td>
				<td>
					<select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>					</select></td></tr>
					</select>
				</td>
			</tr>
			<tr align="left">
				<td>Country :</td>
				<td><select name="countryid" size="1">			
					<option value=0>All Countries</option>
					<cfoutput query="get_countries"><option value="#Countryid#">#countryname#</option></cfoutput>
					</select></td></tr>
			<tr>
				<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
			</tr>
		</table>
		</cfform>
</td>
<td width="50%" valign="top">
	<cfform action="reports/student_unplaced_days.cfm" method="POST" target="blank">
	<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
		<tr><th colspan="2" bgcolor="#e2efc7">Total of Unplaced Days</th></tr>
		<tr>
			<td>Program(s) :</td>
			<td>
				<select name="programid" multiple  size="6">
				<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>					</select></td></tr>
				</select>
			</td>
		</tr>
		<tr align="left">
			<td>Regions :</td>
			<td><select name="regionid" size="1">
					<option value=0>All Regions</option>			
					<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
		</tr>
	</table>
	</cfform>		
</td>
</tr>
</table><br>


<!--- ROW 7 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
		<cfform action="reports/flight_information_report.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Arrival Flight Information</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Arrival Date)</input></td></tr>
				<tr>
					<td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td>
				</tr>
				<tr>
					<td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td></tr>			
			<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>
</td>
<td width="50%" valign="top">
		<cfform action="reports/flight_info_depart_report.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Departure Flight Information</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
								<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Depar. Date)</input></td></tr>
				<tr>
					<td width="5">From : </td><td><cfinput type="text" name="date1" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td>
				</tr>
				<tr>
					<td width="5">To : </td><td><cfinput type="text" name="date2" size="7" maxlength="10" validate="date"> mm-dd-yyyy</td></tr>			
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
</td>
</tr>
</table><br>

<!--- ROW 8 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
		<cfform action="reports/flight_info_missing.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Missing Arrival Flight Information (placed students)</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
				<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><select name="intrep" size="1">
						<option value=0>All Intl. Reps</option>
						<cfoutput query="get_intl_rep"><option value="#intrep#"><cfif #len(get_intl_rep.businessname)# gt 45>#Left(get_intl_rep.businessname, 17)#...<cfelse>#businessname#</cfif></option></cfoutput>
						</select></td></tr>
				<tr><td>Pre-AYP :</td>
				<td><select name="preayp" size="1">
					<option value='none'>None</option>
					<option value="english">English Camp</option>
					<option value="orientation">Orientation Camp</option>
					<option value="all">Both Camps</option>
					</select></td></tr>							
			<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>
</td>
<td width="50%" valign="top">
		<cfform action="reports/flight_info_missing_by_region.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Missing Arrival Flight Info By Region</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr><td>Pre-AYP :</td>
				<td><select name="preayp" size="1">
					<option value='none'>None</option>
					<option value="english">English Camp</option>
					<option value="orientation">Orientation Camp</option>
					<option value="all">Both Camps</option>
					</select></td></tr>					
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
</td>
</tr>
</table><br>

<!--- ROW 8 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
		<cfform action="reports/flight_depart_missing.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Missing Departure Flight Information (placed students)</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
				<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><select name="intrep" size="1">
						<option value=0>All Intl. Reps</option>
						<cfoutput query="get_intl_rep"><option value="#intrep#"><cfif #len(get_intl_rep.businessname)# gt 45>#Left(get_intl_rep.businessname, 17)#...<cfelse>#businessname#</cfif></option></cfoutput>
						</select></td></tr>
			<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>
</td>
<td width="50%" valign="top">
		<cfform action="reports/flight_depart_missing_by_region.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Missing Departure Flight Info By Region</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
</td>
</tr>
</table><br>


<!--- ROW 9 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
		<cfform action="reports/report_stu_school.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Students in School</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
				<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>State :</td>
					<td><cfselect name="stateid" query="get_states" display="statename" value="state" queryPosition="below">
						<option value="0">All</option>
						</cfselect>
					</td>
				</tr>		
				<tr><td align="right"><cfinput type="checkbox" name="school_filter"></td><td>Schools with more than 5 students attending.</td></tr>
			<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>
</td>
<td width="50%" valign="top">
		<!--- new box here  --->
		<cfform action="reports/stu_missing_school_accep.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Students in the USA Missing School Acceptance Letter</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
				<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr><td>Pre-AYP :</td>
				<td><select name="preayp" size="1">
					<option value='none'>None</option>
					<option value="english">English Camp</option>
					<option value="orientation">Orientation Camp</option>
					<option value="all">Both Camps</option>
					</select></td></tr>	
			<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>	
</td>
</tr>
</table><br>


<!--- ROW 10 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
		<cfform action="reports/continent_report.cfm" method="POST" target="blank">
		<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
			<tr><th colspan="2" bgcolor="#e2efc7">Continent Report</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
			<tr align="left">
				<td>Status :</td>
				<td><select name="status" size="1">
					<option value=0>All</option>
					<option value=1>Placed</option>
					<option value=2>Unplaced</option>
					</select></td></tr>
			<tr align="left">
				<td>Continent :</td>
				<td><select name="continent" size="1">
					<option value="Asia">Asia</option>
	 				<!--- <!--- <option value="Africa">Africa</option> ---> --->
					<option value="Europe">Europe</option>
					<!--- <option value="North America">North America</option> --->
					<option value="South America">South America</option>
					<!--- <option value="Oceania">Oceania</option> --->		
					</select></td></tr>
			<tr><td></td><td><input  type="text" size="8">&nbsp;</input></td></tr>
			<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
		</table>
		</cfform>
</td>
<td width="50%" valign="top">
		<cfform action="reports/continent_report_region.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Continent Report By Region</th></tr>
				<tr align="left">
					<td>Program :</td>
					<td><select name="programid" multiple  size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr align="left">
					<td>Status :</td>
					<td><select name="status" size="1">
						<option value=0>All</option>
						<option value=1>Placed</option>
						<option value=2>Unplaced</option>
						</select></td></tr>
				<tr></tr><td>Continent :</td>
					<td><select name="continent" size="1">
						<option value="Asia">Asia</option>
	 					<!--- <!--- <option value="Africa">Africa</option> ---> --->
						<option value="Europe">Europe</option>
						<!--- <option value="North America">North America</option> --->
						<option value="South America">South America</option>
						<!--- <option value="Oceania">Oceania</option> --->		
					</select></td></tr>						
				<tr align="left">
					<td>Region :</td>
					<td><select name="regionid" size="1">
						<option value=0>All Regions</option>
						<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
						</select></td></tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
</td>
</tr>
</table><br>


<!--- ROW 11 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
			<cfform action="reports/intl_rep_list.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">International Representatives by Country</th></tr>
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><select name="intrep" size="1">
						<option value=0>All Reps</option>
						<cfoutput query="get_all_intl_rep"><option value="#userid#">#businessname#</option></cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Country :</td>
					<td><select name="countryid" multiple  size="6">			
						<option value=0>All Countries</option>
						<cfoutput query="get_countries"><option value="#Countryid#">#countryname#</option></cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Insurance :</td>
					<td><select name="insurance" size="1">
						<option value="0">
						<cfoutput query="get_insurance_type">
						<option value="#insutypeid#">#type#</option>
						</cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Status :</td>
					<td><select name="status" size="1">
						<option value=0>Active</option>
						<option value=1>Inactive</option>
						<option value=2>All</option>
						</select></td></tr>					
				<tr><td></td><td><input  type="text" size="8">&nbsp;</input></td></tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>		
</td>
<td width="50%" valign="top">
			<cfform action="reports/intl_contact_list.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">International Representatives</th></tr>
				<tr align="left">
					<td>Intl. Rep:</td>
					<td><select name="intrep" size="1">
						<option value=0>All Reps</option>
						<cfoutput query="get_all_intl_rep"><option value="#userid#">#businessname#</option></cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Country :</td>
					<td><select name="countryid" multiple  size="6">			
						<option value=0>All Countries</option>
						<cfoutput query="get_countries"><option value="#Countryid#">#countryname#</option></cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Insurance :</td>
					<td><select name="insurance" size="1">
						<option value="0">
						<cfoutput query="get_insurance_type">
						<option value="#insutypeid#">#type#</option>
						</cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Status :</td>
					<td><select name="status" size="1">
						<option value=0>Active</option>
						<option value=1>Inactive</option>
						<option value=2>All</option>
						</select></td></tr>
				<tr></tr><td>Continent :</td>
					<td><select name="continent" size="1">
						<option value="0"></option>
						<option value="Asia">Asia</option>
	 					<!--- <!--- <option value="Africa">Africa</option> ---> --->
						<option value="Europe">Europe</option>
						<!--- <option value="North America">North America</option> --->
						<option value="South America">South America</option>
						<!--- <option value="Oceania">Oceania</option> --->	
						<option value="non-asia">Non-Asia</option>	
					</select></td></tr>						
				<tr align="left">
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>		
</td>
</tr>
</table><br>

<cfif client.companyid is 5>
<!--- ROW 12 - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
<td width="50%" valign="top">
<cfform action="reports/smg_total_stu_country.cfm" method="POST" target="blank"> 
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">SMG Students per Country</th></tr>
				<tr align="left">
					<td>Country :</td>
					<td><select name="countryid" size="1">			
						<option value=0>All Countries</option>
						<cfoutput query="get_countries"><option value="#countryid#">#countryname#</option></cfoutput>
						</select></td></tr>
				<tr align="left">
					<td>Status :</td>
					<td><select name="status" size="1">
						<option value=0>All</option>
						<option value=1>Placed</option>
						<option value=2>Unplaced</option>
						</select></td></tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
</td>
</tr>
</table><br><br>
</cfif>

</td></tr>
</table>
<cfinclude template="../table_footer.cfm">	