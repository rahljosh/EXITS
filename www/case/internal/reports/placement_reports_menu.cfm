<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_all_programs.cfm">

<cfinclude template="../querys/get_intl_rep.cfm">

<cfinclude template="../querys/get_all_intl_rep.cfm">

<cfinclude template="../querys/get_countries.cfm">

<cfinclude template="../querys/get_facilitators.cfm">

<cfinclude template="../querys/get_user_regions.cfm">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign="middle" height="24">
		<td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Placement Reports</h2></td>
		<cfif client.usertype LTE 4>
		<td background="pics/header_background.gif" align="right">
			<cfif NOT IsDefined('url.all')>
				<a href="?curdoc=reports/placement_reports_menu&all=1">Show All Programs</a>
			<cfelse>
				<a href="?curdoc=reports/placement_reports_menu">Show Active Programs Only</a>
			</cfif>
		</td>
		</cfif>
		<td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
<tr><td>

	<!--- Row 1 - 2 boxes --->
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
	<td width="50%" align="left" valign="top">
		<cfform action="reports/placed_students_super.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Placed Students by Supervising Rep.</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD>
					<select name="programid" multiple  size="5">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<TD>Region :</td>
					<TD>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfoutput query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 25>#Left(get_regions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Placement Date)</input></td></tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr>
				<tr><TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	<td width="50%" align="right" valign="top">
		<cfform action="reports/placed_students_place.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Placed Students by Placing Rep.</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD>
					<select name="programid" multiple  size="5">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<TD>Region :</td>
					<TD>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfoutput query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 25>#Left(get_regions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfoutput>
					</select>
					</td>		
				</tr>
				<cfif client.usertype LTE 4>
				<tr align="left">
					<td>Active :</td>
					<td><select name="active" size="1">
						<option value=1>Active</option>
						<option value=0>Inactive</option>
						<option value=2>Canceled</option>					
						<option value=3>All</option>
						</select>
					</td>
				</tr>
				</cfif>					
				<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Placement Date)</input></td></tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr><tr>		
				<tr><TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	</tr>
	</table><br>
	
	<!--- Row 2 - 2 boxes --->
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
	<td width="50%" align="left" valign="top">
		<cfform action="reports/state_guarantee_per_region.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">State Guarantee Students by Placing Rep.</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD>
					<select name="programid" multiple  size="5">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<TD>Region :</td>
					<TD>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfoutput query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 25>#Left(get_regions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Placement Date)</input></td></tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr><tr>		
				<tr><TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	<td width="50%" align="right" valign="top">
		<cfform action="reports/relocation.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Relocation Report</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD>
					<select name="programid" multiple  size="5">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<TD>Region :</td>
					<TD>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Placement Date)</input></td></tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr><tr>		
				<tr>
					<TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
		</cfform>						
	</td>
	</tr>
	</table><br>
	
	<cfif client.usertype LTE '4'>
	<!--- Row 3 - 2 boxes --->
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
	<td width="50%" align="left" valign="top">
		<cfform action="reports/welcome_fam_report.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Welcome Family Report</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD>
					<select name="programid" multiple  size="5">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<TD>Region :</td>
					<TD>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfoutput query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 25>#Left(get_regions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr><TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	<td width="50%" align="right" valign="top">
		<cfform action="reports/double_placement.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Double Placement - All Students</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD>
					<select name="programid" multiple  size="5">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<TD>Region :</td>
					<TD>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr>
					<TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
		</cfform>
	</td>
	</tr>
	</table><br>
	</cfif>
	
	<!--- Row 4 - 2 boxes --->
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
	<td width="50%" align="left" valign="top">
		<cfform action="reports/document_tracking.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Missing Placement Docs</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD>
					<select name="programid" multiple size="5">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<TD>Region :</td>
					<TD><cfselect name="regionid" multiple size="5">
						<cfoutput query="get_regions"><option value="#regionid#" selected>#regionname#</option></cfoutput>
						</cfselect></td>		
				</tr>
				<tr>
					<TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
		</cfform>
	</td>
	<td width="50%" align="right" valign="top">
	<cfif client.usertype LTE '4'>
		<cfform action="reports/document_tracking_by_fac.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Misssing Placement Docs by Facilitator</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD>
					<select name="programid" multiple  size="5">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<TD>Facilitator :</td>
					<TD>
					<select name="userid" size="1">
					<option value=0>All </option>		
					<cfoutput query="get_facilitators"><option value="#userid#">#get_facilitators.firstname# #get_facilitators.lastname#</option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr>
					<TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0 ></td>
				</tr>
			</table>
		</cfform>
	</cfif>
	</td>
	</tr>
	</table>
	<br>
	
	<cfif client.usertype LTE 1>
	<!--- Row 5 - 2 boxes --->
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
		<tr>
			<td width="50%" align="left" valign="top">
				<cfform action="reports/document_tracking_previous_host.cfm" method="POST" target="blank">
					<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
						<tr><th colspan="2" bgcolor="#e2efc7">Missing Previous Placement Docs</th></tr>
						<tr align="left">
							<TD>Program :</td>
							<TD>
							<select name="programid" multiple size="5">
							<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
							</select>
							</td>
						</tr>
						<tr align="left">
							<TD>Region :</td>
							<TD><cfselect name="regionid" multiple size="5">
								<cfoutput query="get_regions"><option value="#regionid#" selected>#regionname#</option></cfoutput>
								</cfselect>
							</td>		
						</tr>
						<tr><TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
					</table>
				</cfform>
			</td>
			<td width="50%" align="right" valign="top">

			</td>
		</tr>
	</table>
	<br>
	</cfif>
	
	<!--- Row 6 - 2 boxes --->
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
	<td width="50%" align="left" valign="top">
		<cfform action="reports/double_doc_tracking.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Missing Double Placement Docs</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD>
					<select name="programid" multiple  size="5">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<TD>Region :</td>
					<TD>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfoutput query="get_regions"><option value="#regionid#">#regionname#</option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr>
					<TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
		</cfform>
	</td>
	<td width="50%" align="right" valign="top">
	<cfif client.usertype LTE '4'>
		<cfform action="reports/double_doc_tracking_by_fac.cfm" method="POST" target="blank">
			<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="#e2efc7">Missing Double Placement Docs by Fac.</th></tr>
				<tr align="left">
					<TD>Program :</td>
					<TD>
					<select name="programid" multiple  size="5">
					<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
					</select>
					</td>
				</tr>
				<tr align="left">
					<TD>Facilitator :</td>
					<TD>
					<select name="userid" size="1">
					<option value=0>All </option>		
					<cfoutput query="get_facilitators"><option value="#userid#">#get_facilitators.firstname# #get_facilitators.lastname#</option></cfoutput>
					</select>
					</td>		
				</tr>
				<tr>
					<TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
		</cfform>
	</cfif>
	</td>
	</tr>
	</table><br>
	
	<cfif client.usertype LTE '4'>
	
	<!--- Row 7 - 2 boxes --->
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
		<tr bgcolor="e2efc7"><th colspan="2">Visible for Office users only</th></tr>
	</table>
	
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
		<td width="50%" align="left" valign="top">
			<cfform action="reports/hf_x_supervising_distance.cfm" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="#e2efc7">Host Family x Supervising Rep Distance in Miles (> 75 miles)</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD>
						<select name="programid" multiple  size="5">
						<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
						</select>
						</td>
					</tr>
					<tr align="left">
						<TD>Region :</td>
						<TD>
							<select name="regionid" size="1">
							<cfif client.usertype LT 4><option value=0>All Regions</option></cfif>
							<cfoutput query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 25>#Left(get_regions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfoutput>
							</select>
						</td>		
					</tr>
					<tr><TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>				
				</table>
			</cfform>
		</td>
		<td width="50%" align="right" valign="top">
		</td>
	</tr>
	</table><br>
	
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
		<td width="50%" align="left" valign="top">
			<cfform action="reports/placement_list_all_by_rep.cfm" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="#e2efc7">Complete Placement List</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD>
						<select name="programid" multiple  size="5">
						<cfoutput query="get_all_programs"><option value="#ProgramID#">#companyshort# - #programname#</option></cfoutput>
						</select>
						</td>
					</tr>
					<tr>
						<TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
			</cfform>
		</td>
		<td width="50%" align="right" valign="top">
			<cfform action="reports/total_placements.cfm" method="POST" target="blank">
				<Table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="#e2efc7">Total no. of Placements x Total no. of Reps</th></tr>
					<tr align="left">
						<TD>Program :</td>
						<TD>
						<select name="programid" multiple  size="5">
						<cfoutput query="get_program"><option value="#ProgramID#"><cfif client.companyid EQ '5'>#companyshort# - </cfif>#programname#</option></cfoutput>
						</select>
						</td>
					</tr>
					<tr align="left">
						<td>Active :</td>
						<td><select name="active" size="1">
							<option value=1>Active</option>
							<option value=0>Inactive</option>
							<option value=2>Canceled</option>					
							<option value=3>All</option>
							</select>
						</td>
					</tr>
					<tr><TD colspan="2" align="center" bgcolor="#e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
			</cfform>
		</td>
	</tr>
	</table><br>
	
	</cfif>
	
</td></tr>
</table>
<cfinclude template="../table_footer.cfm">		