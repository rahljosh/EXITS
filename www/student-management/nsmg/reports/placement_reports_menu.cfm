<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM variables --->
	<cfparam name="URL.all" default="0">
    
</cfsilent>    

<cfscript>
	// Get Regions
	qGetRegions = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, userType=CLIENT.userType);
	
	if ( VAL(URL.all) ) {
		// Programs
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms();
	} else {
		// Programs
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(dateActive=1);
	}
</cfscript>

<cfinclude template="../querys/get_intl_rep.cfm">

<cfinclude template="../querys/get_all_intl_rep.cfm">

<cfinclude template="../querys/get_countries.cfm">

<cfinclude template="../querys/get_facilitators.cfm">

<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign="middle" height="24">
		<td height="24" width="13" background="pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Placement Reports</h2></td>
		<cfif ListFind("1,2,3,4,5", CLIENT.userType)>
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
					<cfloop query="qGetProgramList"><option value="#ProgramID#">#programname#</option></cfloop>
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
					<cfloop query="qGetRegions"><option value="#regionid#"><cfif #len(qGetRegions.regionname)# gt 25>#Left(qGetRegions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfloop>
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
					  <cfloop query="qGetProgramList">
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
					<cfloop query="qGetRegions"><option value="#regionid#"><cfif #len(qGetRegions.regionname)# gt 25>#Left(qGetRegions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfloop>
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
					<cfloop query="qGetProgramList"><option value="#ProgramID#">#programname#</option></cfloop>
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
					<cfloop query="qGetRegions"><option value="#regionid#"><cfif #len(qGetRegions.regionname)# gt 25>#Left(qGetRegions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfloop>
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
					<cfloop query="qGetProgramList"><option value="#ProgramID#">#programname#</option></cfloop>
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
					<cfloop query="qGetRegions"><option value="#regionid#">#regionname#</option></cfloop>
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
					<cfloop query="qGetProgramList"><option value="#ProgramID#">#programname#</option></cfloop>
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
					<cfloop query="qGetRegions"><option value="#regionid#"><cfif #len(qGetRegions.regionname)# gt 25>#Left(qGetRegions.regionname, 23)#...<cfelse>#regionname#</cfif></option></cfloop>
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
					<cfloop query="qGetProgramList"><option value="#ProgramID#">#programname#</option></cfloop>
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
					<cfloop query="qGetRegions"><option value="#regionid#">#regionname#</option></cfloop>
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
                            <td width="20%" valign="top">Program :</td>
                            <td>
                                <select name="programid" size="6" multiple>
                                    <cfloop query="qGetProgramList">
                                        <option value="#ProgramID#">#programname#</option>
                                    </cfloop>
                                </select>		
                            </td>
                        </tr>
                        <tr align="left">
                            <td valign="top">Region :</td>
                            <td>
                                <select name="regionID" size="6" multiple> 
                                    <cfloop query="qGetRegions">
                                        <option value="#qGetRegions.regionid#" <cfif qGetRegions.recordcount eq 1>selected</cfif>>#qGetRegions.regionname#</option>
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
                            <td width="20%" valign="top">Program :</td>
                            <td>
                                <select name="programid" size="6" multiple>
                                    <cfloop query="qGetProgramList">
                                        <option value="#ProgramID#">#programname#</option>
                                    </cfloop>
                                </select>		
                            </td>
                        </tr>
                        <tr align="left">
                            <td valign="top">Region :</td>
                            <td>
                                <select name="regionID" size="6" multiple> 
                                    <cfloop query="qGetRegions">
                                        <option value="#qGetRegions.regionid#" <cfif qGetRegions.recordcount eq 1>selected</cfif>>#qGetRegions.regionname#</option>
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
                            <td>Report By :</td>
                            <td>
                                <select name="reportBy"> 
                                    <option value="Placing">Placing Representative</option>	
                                    <option value="Supervising">Supervising Representative</option>	
                                </select>
                            </td>
                        </tr>
                        <tr align="left">
                        	<td>Date Placed From : </td>
                        	<td><input type="text" name="dateFrom" size="8" maxlength="10" value="" class="datePicker"></td>
                        </tr>
                        <tr align="left">
                        	<td>To : </td>
                            <td><input type="text" name="dateTo" size="8" maxlength="10" value="" class="datePicker"></td>
                        </tr>
                        <tr align="left">
                            <td>Send as email to manager :</td>
                            <td>
                                <input type="radio" name="sendemail" id="sendPreviousEmailNo" value="0" checked="checked"> <label for="sendPreviousEmailNo">No</label>  
                                <input type="radio" name="sendemail" id="sendPreviousEmailYes" value="1"> <label for="sendPreviousEmailYes">Yes</label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
                        </tr>
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
                        <cfloop query="qGetProgramList"><option value="#ProgramID#">#programname#</option></cfloop>
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
					<cfloop query="qGetRegions"><option value="#regionid#">#regionname#</option></cfloop>
					</select>
					</td>
                </tr>
                <tr align="left">
                    <td>Send as email to manager :</td>
                    <td>
                        <input type="radio" name="sendemail" id="sendEmailNo" value="0" checked="checked"> <label for="sendEmailNo">No</label>  
                        <input type="radio" name="sendemail" id="sendEmailYes" value="1"> <label for="sendEmailYes">Yes</label>
                    </td>
                </tr>
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
					<cfloop query="qGetProgramList"><option value="#ProgramID#">#programname#</option></cfloop>
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
			<cfform action="reports/complianceMileageReport.cfm" method="POST" target="blank">
				<table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="##e2efc7">Compliance Mileage Report</th></tr>
					<tr align="left">
						<td valign="top">Program :</td>
						<td>
						<select name="programid" multiple="multiple" size="6" class="xLargeField">
                            <cfloop query="qGetProgramList">
                                <option value="#qGetProgramList.ProgramID#">#qGetProgramList.programname#</option>
                            </cfloop>
						</select>
						</td>
					</tr>
					<tr align="left">
						<td valign="top">Region :</td>
						<td>
							<select name="regionid" multiple="multiple" size="6" class="xLargeField">
								<cfloop query="qGetRegions">
                                	<option value="#qGetRegions.regionid#">
                                    	<cfif CLIENT.companyID EQ 5>
                                    		#qGetRegions.companyShort# - 
                                    	</cfif>
                                        #qGetRegions.regionname#
                                    </option>
                                </cfloop>
							</select>
						</td>		
					</tr>
                    <tr>
                    	<td align="right">
                        	<input type="checkbox" name="displayOutOfCompliance" id="displayOutOfCompliance" value="1" checked="checked" />
                        </td>
                        <td>
                        	<label for="displayOutOfCompliance">Display only out of compliance records</label>
                        </td>
					</tr>                                             
					<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>				
				</table>
			</cfform>
		</td>
		<td width="50%" align="right" valign="top">
        
          <form action="reports/studentMissingSecondVisitRep.cfm" method="POST" target="blank">
                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                   <tr><th colspan="2" bgcolor="##e2efc7">Student Missing Second Visit Rep</td></tr>
                    <tr>
                        <td class="reportFieldTitle">Program:</td>
                        <td>
                            <select name="programID" multiple size="6">
                                <cfloop query="qGetProgramList">
                                    <option value="#programID#">#programname#</option>
                                </cfloop>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Region:</td>
                        <td>
                        <select name="regionid">
							<cfif client.usertype GT 4><cfelse>
                            <option value=0>All Regions</option>
                            </cfif>
                            <cfloop query="qGetRegions"><option value="#regionid#">#regionname#</option></cfloop>
                            </select>
					            
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Status:</td>
                        <td>
                        	<select name="status">
                                <option value="0">All</option>
                                <option value="1">Placed</option>
                                <option value="2">Unplaced</option>
                            </select>               
                        </td>
                    </tr>
                    <tr>
                        <td class="reportFieldTitle">Active:</td>
                        <td>
                        	<select name="active">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                                <option value="2">Canceled</option>					
                                <option value="3">All</option>
	                        </select>
						</td>
                    </tr>					
    				<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
                 </table>
            </form>

        
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
						<cfloop query="qGetProgramList"><option value="#ProgramID#">#programname#</option></cfloop>
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
						<cfloop query="qGetProgramList"><option value="#ProgramID#">#programname#</option></cfloop>
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