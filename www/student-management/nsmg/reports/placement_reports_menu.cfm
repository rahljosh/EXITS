<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM variables --->
	<cfparam name="URL.all" default="0">
    
</cfsilent>    

<cfinclude template="../querys/get_programs.cfm">

<cfinclude template="../querys/get_intl_rep.cfm">

<cfinclude template="../querys/get_all_intl_rep.cfm">

<cfinclude template="../querys/get_countries.cfm">

<cfinclude template="../querys/get_facilitators.cfm">

<cfinclude template="../querys/get_user_regions.cfm">

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign="middle" height="24">
		<td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Placement Reports</h2></td>
		<cfif ListFind("1,2,3,4", CLIENT.userType)>
            <td background="pics/header_background.gif" align="right">
                <cfif NOT VAL(URL.All)>
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
			<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Placed Students by Supervising Rep.</th></tr>
				<tr align="left">
					<td valign="top">Program :</td>
					<td>
					<select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select>
					</td>
				</tr>
				<tr align="left">
					<td valign="top">Region :</td>
					<td>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfloop query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 25>#Left(get_regions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfloop>
					</select>
					</td>		
				</tr>
				<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Placement Date)</input></td></tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	<td width="50%" align="right" valign="top">
		<cfform action="reports/placed_students_place.cfm" method="POST" target="blank">
			<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Placed Students by Placing Rep.</th></tr>
				<tr align="left">
					<td valign="top">Program:</td>
					<td><select name="programid" multiple  size="6">
					  <cfloop query="get_program">
					    <option value="#ProgramID#">#programname#</option>
				      </cfloop>
				    </select></td>
				</tr>
				<tr align="left">
					<td valign="top">Region :</td>
					<td>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfloop query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 25>#Left(get_regions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfloop>
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
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
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
			<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">State Preference Students by Placing Rep.</th></tr>
				<tr align="left">
					<td valign="top">Program :</td>
					<td>
					<select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select>
					</td>
				</tr>
				<tr align="left">
					<td valign="top">Region :</td>
					<td>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfloop query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 25>#Left(get_regions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfloop>
					</select>
					</td>		
				</tr>
				<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Placement Date)</input></td></tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr><tr>		
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	<td width="50%" align="right" valign="top">
		<cfform action="reports/relocation.cfm" method="POST" target="blank">
			<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Relocation Report</th></tr>
				<tr align="left">
					<td valign="top">Program :</td>
					<td>
					<select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select>
					</td>
				</tr>
				<tr align="left">
					<td valign="top">Region :</td>
					<td>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
					</select>
					</td>		
				</tr>
				<tr><td colspan="2"><input type="checkbox" name="dates">&nbsp; Including Period Below (Placement Date)</input></td></tr>
				<tr><td width="5">From : </td><td><cfinput type="text" name="date1" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr>
				<tr><td width="5">To : </td><td><cfinput type="text" name="date2" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr><tr>		
				<tr>
					<td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
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
			<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Welcome Family Report</th></tr>
				<tr align="left">
					<td valign="top">Program :</td>
					<td>
					<select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select>
					</td>
				</tr>
				<tr align="left">
					<td valign="top">Region :</td>
					<td>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfloop query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 25>#Left(get_regions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfloop>
					</select>
					</td>		
				</tr>
				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
			</table>
		</cfform>
	</td>
	<td width="50%" align="right" valign="top">
		<cfform action="reports/double_placement.cfm" method="POST" target="blank">
			<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Double Placement - All Students</th></tr>
				<tr align="left">
					<td valign="top">Program :</td>
					<td>
					<select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select>
					</td>
				</tr>
				<tr align="left">
					<td valign="top">Region :</td>
					<td>
					<select name="regionid" size="1">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
					</select>
					</td>		
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
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
                <form action="reports/document_tracking.cfm" method="POST" target="blank">
                    <table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
                        <tr><th colspan="3" bgcolor="##e2efc7">Missing Placement Docs</th></tr>
                        <tr align="left">
                            <td valign="top">Program :</td>
                            <td>
                                <select name="programid" size="6" multiple>
                                    <cfloop query="get_program">
                                        <option value="#ProgramID#">#programname#</option>
                                    </cfloop>
                                </select>		
                            </td>
                        </tr>
                        <tr align="left">
                            <td valign="top">Region :</td>
                            <td>
                                <select name="regionID" size="6" multiple> 
                                    <cfloop query="get_regions">
                                        <option value="#get_regions.regionid#" <cfif get_regions.recordcount eq 1>selected</cfif>>#get_regions.regionname#</option>
                                    </cfloop> 
                                </select>
                            </td>
                        </tr>
                        <!--- Add Option to List by Facilitator --->
                        <cfif ListFind("1,2,3,4", CLIENT.userType)>
                            <tr align="left">
                                <td>Facilitator :</td>
                                <td>
                                    <select name="facilitatorID" size="1">
                                        <option value="0">All </option>		
                                        <cfloop query="get_facilitators"><option value="#get_facilitators.userid#">#get_facilitators.firstname# #get_facilitators.lastname#</option></cfloop>
                                    </select>
                                </td>		
                            </tr>
                        </cfif>

                        <tr align="left">
                            <td>Send as email to manager :</td>
                            <td>
                                <input type="radio" name="sendemail" id="sendEmailNo" value="0" checked="checked"> <label for="sendEmailNo">No</label>  
                                <input type="radio" name="sendemail" id="sendEmailYes" value="1"> <label for="sendEmailYes">Yes</label>
                            </td>
                        </tr>
                        <tr>
                            <td>Report By :</td>
                            <td>
                                <select name="reportBy"> 
                                    <option value="Placing">Placing Representative</option>	
                                    <option value="Supervising">Supervising Representative</option>	
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
                        </tr>
                    </table>
                </form>
            </td>
            <td width="50%" align="right" valign="top">
				<cfform action="reports/document_tracking_previous_host.cfm" method="POST" target="blank">
					<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
						<tr><th colspan="2" bgcolor="##e2efc7">Missing Previous Placement Docs</th></tr>
						<tr align="left">
							<td valign="top">Program :</td>
							<td>
							<select name="programid" multiple size="6" selected>
							<cfloop query="get_program">
                                <option value="#ProgramID#"> #programname#</option> </cfloop>
							</select>
							</td>
						</tr>
                        <tr align="left">
                            <td valign="top">Region :</td>
                            <td colspan="2"><cfselect enabled="Yes" name="regionid" size="6" multiple> <cfloop query="get_regions">
                              <option value="#regionid#" <cfif get_regions.recordcount eq 1>selected</cfif>>#regionname#
                                <cfif #get_program.currentrow# eq 1></cfif>
                              </option>
                            </cfloop> </cfselect></td>
                        </tr>
                        <tr><td width="5">From : </td><td><cfinput type="text" name="dateFrom" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr>
                        <tr><td width="5">To : </td><td><cfinput type="text" name="dateTo" size="8" maxlength="10" value="mm/dd/yyyy" OnClick="this.value='';"></cfinput></td></tr><tr>		
						<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
					</table>
				</cfform>
            </td>
        </tr>
	</table>
	<br>

	<!--- Row 6 - 2 boxes --->
	<table cellpadding=6 cellspacing="0" align="center" width="97%">
	<tr>
	<td width="50%" align="left" valign="top">
		<cfform action="reports/double_doc_tracking.cfm" method="POST" target="blank">
			<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Missing Double Placement Docs</th></tr>
				<tr align="left">
					<td valign="top">Program :</td>
					<td>
                        <select name="programid" multiple  size="6">
                        <cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
                        </select>
					</td>
				</tr>
				<tr align="left">
					<td>Region :</td>
					<td>
					<select name="regionid">
					<cfif client.usertype GT 4><cfelse>
					<option value=0>All Regions</option>
					</cfif>
					<cfloop query="get_regions"><option value="#regionid#">#regionname#</option></cfloop>
					</select>
					</td>
					<!--- Add Option to List by Facilitator
                        <cfif ListFind("1,2,3,4", CLIENT.userType)>
                            <tr align="left">
                                <td>Facilitator :</td>
                                <td>
                                    <select name="facilitatorID" size="1">
                                        <option value="0">All </option>		
                                        <cfloop query="get_facilitators"><option value="#get_facilitators.userid#">#get_facilitators.firstname# #get_facilitators.lastname#</option></cfloop>
                                    </select>
                                </td>		
                            </tr>
                        </cfif> --->
                        <tr align="left">
                            <td>Send as email to manager :</td>
                            <td>
                                <input type="radio" name="sendemail" id="sendEmailNo" value="0" checked="checked"> <label for="sendEmailNo">No</label>  
                                <input type="radio" name="sendemail" id="sendEmailYes" value="1"> <label for="sendEmailYes">Yes</label>
                            </td>
                        </tr>
                        <!----
                        <tr>
                            <td>Report By :</td>
                            <td>&nbsp;</td>
                        </tr>	
				
                <tr>
				  <select name="reportBy2">
				    <option value="Placing">Placing Representative</option>
				    <option value="Supervising">Supervising Representative</option>
			      </select>
				</tr>
				---->	
				<tr>
					<td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
				</tr>
			</table>
		</cfform>
	</td>
	<td width="50%" align="right" valign="top">
	<cfif client.usertype LTE '4'>
		<cfform action="reports/double_doc_tracking_by_fac.cfm" method="POST" target="blank">
			<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
				<tr><th colspan="2" bgcolor="##e2efc7">Missing Double Placement Docs by Fac.</th></tr>
				<tr align="left">
					<td valign="top">Program :</td>
				  <td>
					<select name="programid" multiple  size="6">
					<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
					</select>
					<select name="userid" size="1">
					  <option value=0>All </option>
					  <cfloop query="get_facilitators">
					    <option value="#userid#">#get_facilitators.firstname# #get_facilitators.lastname#</option>
				      </cfloop>
				    </select></td>
				</tr>
				<tr align="left">
					<td valign="top">Facilitator :</td>
					<td>&nbsp;</td>		
				</tr>
				<tr>
					<td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
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
				<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##e2efc7">Host Family x Supervising Rep Distance in Miles (> 75 miles)</th></tr>
					<tr align="left">
						<td valign="top">Program :</td>
						<td>
						<select name="programid" multiple  size="6">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
						</select>
						</td>
					</tr>
					<tr align="left">
						<td valign="top">Region :</td>
						<td>
							<select name="regionid" size="1">
							<cfif client.usertype LT 4><option value=0>All Regions</option></cfif>
							<cfloop query="get_regions"><option value="#regionid#"><cfif #len(get_regions.regionname)# gt 25>#Left(get_regions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfloop>
							</select>
						</td>		
					</tr>
					<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>				
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
				<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##e2efc7">Complete Placement List</th></tr>
					<tr align="left">
						<td valign="top">Program :</td>
						<td>
						<select name="programid" multiple  size="6">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
						</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
			</cfform>
		</td>
		<td width="50%" align="right" valign="top">
			<cfform action="reports/total_placements.cfm" method="POST" target="blank">
				<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##e2efc7">Total no. of Placements x Total no. of Reps</th></tr>
					<tr align="left">
						<td valign="top">Program :</td>
						<td>
						<select name="programid" multiple  size="6">
						<cfloop query="get_program"><option value="#ProgramID#">#programname#</option></cfloop>
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
					<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
				</table>
			</cfform>
		</td>
	</tr>
	</table><br>
	
	</cfif>
	
</td></tr>
</table>

</cfoutput>

<cfinclude template="../table_footer.cfm">		