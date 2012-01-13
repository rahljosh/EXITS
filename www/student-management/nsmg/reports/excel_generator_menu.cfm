<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfparam name="URL.all" default="0">

<cfinclude template="../querys/get_programs.cfm">
<cfinclude template="../querys/get_regions.cfm">
<cfinclude template="../querys/get_intl_rep.cfm">
<cfinclude template="../querys/get_company_short.cfm">
<cfinclude template="../querys/get_states.cfm">
<cfinclude template="../querys/get_countries.cfm">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Excel Spreadsheet Reports</h2></td>
		<td background="pics/header_background.gif" align="right">
			<cfif NOT VAL(URL.all)>
				<a href="?curdoc=reports/excel_generator_menu&all=1">Show All Programs</a>
			<cfelse>
				<a href="?curdoc=reports/excel_generator_menu">Show Active Programs Only</a>
			</cfif>
		</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td align="center">Select the following report and criteria to export your data to an Excel spreadsheet.</td></tr>
<tr><td>

<!--- First Row - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="reports/excel_students_all.cfm" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7"><u>All Students - Host/Program/Region</u></th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" multiple size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td>
				</tr>
				<tr align="left">
					<TD>Region :</td>
					<TD>
					<select name="regionid" size="1">
					<option value=0>All Regions</option>
					<cfoutput query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 30>#Left(get_regions.regionname, 27)#...<cfelse>#regionname#</cfif></option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="reports/excel_students_list.cfm" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7"><u>Student/Host/Program/Region/School/Area Rep</u></th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" multiple size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td>
				</tr>
				<tr align="left">
					<TD>Region :</td>
					<TD>
					<select name="regionid" size="1">
					<option value=0>All Regions</option>
					<cfoutput query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 30>#Left(get_regions.regionname, 27)#...<cfelse>#regionname#</cfif></option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr>
					<td colspan="2"><input type="checkbox" name="grade">11th and 12th grade students</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
			</cfform>
		</td>
	</tr>
</table><br>

<!--- Second Row - 2 boxes --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="reports/excel_explore_america.cfm" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Explore America Excell Spreadsheet</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><select name="programid" multiple  size="7">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></select></td></tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="reports/excel_hosts_list.cfm" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7"><u>Host Families Currently Hosting Students</u></th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD><cfselect name="programid" multiple size="6">
					<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput></cfselect></td>
				</tr>
				<tr align="left">
					<td>From Placement Date</td>
					<td><cfinput type="text" name="date" size="7" validate="date"> mm/dd/yyyy</td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
			</cfform>		
		</td>
	</tr>
</table><br>

<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
		<td width="50%" valign="top">
			<cfform action="reports/excel_students_per_region.cfm" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7"><u>Students Per Region</u></th></tr>		
				<tr><TD class="label">Active : </td>
					<TD><select name="active" size="1">
							<option value="1">Yes</option>
							<option value="0">No</option>
							<option value="2">All</option>
						</select></td></tr>
				<tr><TD class="label">Placement Status : </td>
					<TD><select name="status" size="1">
							<option value="0">All</option>
							<option value="placed">Placed</option>
							<option value="unplaced">Unplaced</option>
						</select></td></tr>
				<tr><TD class="label">Region :</td>
					<TD><select name="regionid" size="1">
							<cfif client.usertype LTE 4>
							<option value="0">All</option>
							</cfif>
							<cfif client.companyid EQ 5>
								<cfoutput query="get_regions"><option value="#regionid#">#companyshort# &nbsp; #regionname#</option></cfoutput>
							<cfelse>
								<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
							</cfif>
						</select></td></tr>
				<tr><TD class="label">Program :</td>
					<TD><select name="programid" multiple  size="6">
						<option value="0" selected>All</option>
						<cfif #client.companyid# is 5>
							<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>
						<cfelse>	
							<cfoutput query="get_program"><option value="#ProgramID#">#ProgramName# </option></cfoutput>
						</cfif>
						</select></td>
				</tr>
				<tr><td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>		
			</table>
			</cfform>
		</td>
		<td width="50%" valign="top">
			<cfform action="reports/excel_students_per_state.cfm" method="POST">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7"><u>Placed Studenst per School State</u></th></tr>		
				<tr><TD class="label">Active : </td>
					<TD><select name="active" size="1">
							<option value="1">Yes</option>
							<option value="0">No</option>
							<option value="2">All</option>
						</select></td></tr>
				<tr><TD class="label">Region :</td>
					<TD><select name="regionid" size="1">
							<cfif client.usertype LTE 4>
							<option value="0">All</option>
							</cfif>
							<cfif client.companyid EQ 5>
								<cfoutput query="get_regions"><option value="#regionid#">#companyshort# &nbsp; #regionname#</option></cfoutput>
							<cfelse>
								<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
							</cfif>
						</select></td></tr>
				<tr><td class="label">State :</td>
					<TD><select name="state" size="1">
							<cfif client.usertype LTE 4>
							<option value="0">All</option>
							</cfif>
								<cfoutput query="get_states"><option value="#state#">#statename#</option></cfoutput>
						</select></td></tr>
				<tr><TD class="label">Program :</td>
					<TD><select name="programid" multiple  size="6">
						<option value="0" selected>All</option>
						<cfif #client.companyid# is 5>
							<cfoutput query="get_program"><option value="#ProgramID#">#programname#</option></cfoutput>
						<cfelse>	
							<cfoutput query="get_program"><option value="#ProgramID#">#ProgramName# </option></cfoutput>
						</cfif>
						</select></td>
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>		
			</table>
			</cfform>
		</td>
	</tr>
</table>
<br>

<!--- 4th Row - Big Box --->
<table cellpadding=6 cellspacing="0" align="center" width="97%">
<tr>
	<Td width="100%">
		<cfform action="reports/excel_generator_users.cfm" method="POST" target="_blank">
		<Table class="nav_bar" cellpadding=4 cellspacing="0" align="left" width="100%">
			<tr bgcolor="#e2efc7">
				<th colspan="2" bgcolor="#e2efc7"><u>Users List (Create Your Own Report)</u></th>
			</tr>
			<tr bgcolor="e2efc7">
				<td colspan="2"><span class="get_attention"><b> > </b></span><u>User Type</u></td>
			</tr>
			<tr align="left">
				<TD width="50%">				
					<input type="checkbox" name="manager">Regional Manager<br>		
					<input type="checkbox" name="advisor">Regional Advisor
				</td>
				<TD width="50%">				
					<input type="checkbox" name="representative">Area Representative<br>				
					<input type="checkbox" name="agent">Intl. Representative
				</td>
			</tr>
			<tr bgcolor="#e2efc7">
				<td colspan="2"><span class="get_attention"><b> > </b></span><u>Active</u></td>
			</tr>
			<tr align="left">
				<TD width="50%">	
			  		<input type="radio" name="active" value="1" checked>Yes
				</td>
				<TD width="50%">	
			  		<input type="radio" name="active" value="0">No
				</td>
			</tr>
			<tr bgcolor="#e2efc7">
				<td colspan="2"><span class="get_attention"><b> > </b></span><u>Region</u></td>
			</tr>
			<tr align="left">
				<TD colspan="2">&nbsp; &nbsp;	
			  		<select name="regionid" multiple size="6">
					<option value="none" selected>All Regions</option>
					<cfoutput query="get_regions"><option value="#regionid#">#RegionName# </option></cfoutput>
					</select>
				</td>
			</tr>			
			<tr bgcolor="#e2efc7">
				<td colspan="2"><span class="get_attention"><b> > </b></span><u>Company</u></td>
			</tr>		
			<tr align="left">
				<TD width="50%">				
					<input type="checkbox" name="ise" value="1" <cfif client.companyid is 1 or client.companyid is 5>checked</cfif> disabled>Red<br>
					<input type="checkbox" name="ise" value="2" <cfif client.companyid is 2 or client.companyid is 5>checked</cfif> disabled>Blue<br>
				</td>
				<TD width="50%">				
					<input type="checkbox" name="asa" value="3" <cfif client.companyid is 3 or client.companyid is 5>checked</cfif> disabled>Green<br>
					<input type="checkbox" name="dmd" value="4" <cfif client.companyid is 4 or client.companyid is 5>checked</cfif> disabled>Yellow
				</td>
			</tr>
			<tr bgcolor="#e2efc7">
				<td colspan="2"><span class="get_attention"><b> > </b></span><u>Order By</u></td>
			</tr>
			<tr align="left">
				<TD width="50%">	
			  		<input name="orderby" type="radio" value="lastname" checked>Last Name<br>
			  		<input name="orderby" type="radio" value="city">City
				</td>
				<TD width="50%">	
			  		<input name="orderby" type="radio" value="firstname">First Name<br>
			  		<input name="orderby" type="radio" value="state">State
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center" bgcolor="#e2efc7"><input type="Submit" value="View">&nbsp; &nbsp; &nbsp; &nbsp; <input type="Reset"></td>
			</tr>
		</table>
		</cfform>										
	</td>
</tr>
</table>
<br>

</td></tr>
</table>
<cfinclude template="../table_footer.cfm">
