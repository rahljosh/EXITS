<!--- ------------------------------------------------------------------------- ----
	
	File:		reports_menu.cfm
	Author:		Marcus Melo
	Date:		December 6, 2011
	Desc:		Compliance Reports Menu

	Updated:	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>
		// Get Programs
		qGetProgramList = APPLICATION.CFC.program.getPrograms(isActive=1);
	
		// Get User Regions
		qGetRegions = APPLICATION.CFC.REGION.getUserRegions(
			companyID=CLIENT.companyID,
			userID=CLIENT.userID,
			userType=CLIENT.userType
		);
	</cfscript>
        
    <cfinclude template="../querys/get_facilitators.cfm">
        
    <cfinclude template="../querys/get_seasons.cfm">

</cfsilent>

<cfoutput>

	<!--- Table Header --->
	<gui:tableHeader
		imageName="students.gif"
		tableTitle="COMPLIANCE - Placement Reports"
	/>

    <table border="0" cellpadding="8" cellspacing="2" width="100%" class="section">
    	<tr>
        	<td>
    			
                <!--- Office Users Only --->
                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                
					<!--- Row 1 - 2 boxes --->
                    <table cellpadding="6" cellspacing="0" align="center" width="95%">
                        <tr>
                            <td width="50%" valign="top">
                                <cfform action="compliance/documents_received.cfm" name="doc_received" method="post" target="blank">
                                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                    <tr><th colspan="2" bgcolor="##e2efc7">Placement Documents Received per Period</th></tr>
                                    <tr>
                                        <td>Program :</td>
                                        <td><cfselect name="programID" query="qGetProgramList" value="programID" display="programName" multiple="yes" size="6" required="yes" message="You must select at least one program."></cfselect></td>
                                    </tr>
                                    <tr>
                                        <td>Region :</td>
                                        <td>
                                            <cfselect name="regionID" size="1">
                                                <option value="0">All Regions</option>
                                                <cfloop query="qGetRegions"><option value="#qGetRegions.regionID#">#qGetRegions.regionname#</option></cfloop>
                                            </cfselect>
                                        </td>		
                                    </tr>
                                    <tr>
                                        <td>From:</td>
                                        <td><input type="text" name="date1" value="" size="7" maxlength="10" class="datePicker"> mm-dd-yyyy</td>
                                    </tr>
                                    <tr>
                                        <td>To: </td>
                                        <td><input type="text" name="date2" value="" size="7" maxlength="10" class="datePicker"> mm-dd-yyyy</td>
                                    </tr>			
                                    <tr>
                                        <td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                    </tr>
                                </table>
                                </cfform>
                            </td>
                            <td width="50%" valign="top">
                                <cfform action="compliance/rp_arrival_x_cbc.cfm" name="doc_received" method="post" target="blank">
                                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                    <tr><th colspan="2" bgcolor="##e2efc7">Student Arrival Date x CBC Date (No Relocations)</th></tr>
                                    <tr>
                                        <td>Program :</td>
                                        <td><cfselect name="programID" query="qGetProgramList" value="programID" display="programName" multiple size="6" required="yes" message="You must select at least one program."></cfselect></td>
                                    </tr>
                                    <tr>
                                        <td>Region :</td>
                                        <td>
                                            <cfselect name="regionID" size="1">
                                                <option value="0">All Regions</option>
                                                <cfloop query="qGetRegions"><option value="#qGetRegions.regionID#">#qGetRegions.regionname#</option></cfloop>
                                            </cfselect>
                                        </td>		
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                    </tr>
                                </table>
                                </cfform>
                            </td>
                        </tr>
                    </table><br />
				                    
                    
                    <!--- Row 2 - 2 boxes --->
                    <table cellpadding="6" cellspacing="0" align="center" width="95%">
                        <tr>
                            <td width="50%" valign="top">
                                <cfform action="compliance/missing_area_rep_paperwork.cfm" name="area_rep" method="post" target="blank">
                                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                    <tr><th colspan="2" bgcolor="##e2efc7">Missing Area Representative Paperwork</th></tr>
                                    <tr>
                                        <td>Season :</td>
                                        <td><cfselect name="seasonid" query="get_seasons" display="season" value="seasonid" queryPosition="below">			
                                            <option value="0">Contract AYP</option>
                                            </cfselect>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Region :</td>
                                        <td>
                                            <cfselect name="regionID" size="1">
                                                <option value="0">All Regions</option>
                                                <cfloop query="qGetRegions"><option value="#qGetRegions.regionID#">#qGetRegions.regionname#</option></cfloop>
                                            </cfselect>
                                        </td>		
                                    </tr>
                                    <tr>
                                        <td>Status :</td>
                                        <td><cfselect name="status">
                                                <option value="All">All</option>
                                                <option value="1">Active</option>
                                                <option value="0">Inactive</option>
                                            </cfselect>						
                                        </td>
                                    </tr>															
                                    <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                                </table>
                                </cfform>
                            </td>
                            <td width="50%" valign="top">
                                <cfform action="compliance/rp_placement_x_cbc_relocated.cfm" name="doc_received" method="post" target="blank">
                                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                    <tr><th colspan="2" bgcolor="##e2efc7">Placement Approval x CBC Date (Students Relocated Only)</th></tr>
                                    <tr>
                                        <td>Program :</td>
                                        <td><cfselect name="programID" query="qGetProgramList" value="programID" display="programName" multiple size="6" required="yes" message="You must select at least one program."></cfselect></td>
                                    </tr>
                                    <tr>
                                        <td>Region :</td>
                                        <td>
                                            <cfselect name="regionID" size="1">
                                                <option value="0">All Regions</option>
                                                <cfloop query="qGetRegions"><option value="#qGetRegions.regionID#">#qGetRegions.regionname#</option></cfloop>
                                            </cfselect>
                                        </td>		
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                    </tr>
                                </table>
                                </cfform>	
                            </td>
                        </tr>
                    </table><br />
        
				
					<!--- Row 3 - 2 boxes --->
                    <table cellpadding="6" cellspacing="0" align="center" width="95%">
                        <tr>
                            <td width="50%" valign="top">
                            
                                <cfform action="compliance/arrival_school_acceptance_check.cfm" name="doc_received" method="post" target="blank">
                                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                    <tr><th colspan="2" bgcolor="##e2efc7">Students with Arrival Information and Missing School Acceptance (Place Management)</th></tr>
                                    <tr>
                                        <td>Program :</td>
                                        <td><cfselect name="programID" query="qGetProgramList" value="programID" display="programName" multiple size="6" required="yes" message="You must select at least one program."></cfselect></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                    </tr>
                                </table>
                                </cfform>			
                            
                            </td>
                            <td width="50%" valign="top">
    
                                <form action="compliance/singlePlacementPaperworkByIntlRep.cfm" method="POST" target="_blank">
                                    <table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
                                        <tr><th colspan="3" bgcolor="##e2efc7">Single Placement Paperwork by International Representative</th></tr>
                                        <tr align="left">
                                            <td width="30%" valign="top">Program :</td>
                                            <td>
                                                <select name="programID" size="6" multiple>
                                                    <cfloop query="qGetProgramList">
                                                        <option value="#programID#">#programname#</option>
                                                    </cfloop>
                                                </select>		
                                            </td>
                                        </tr>
                                        <tr align="left">
                                            <td valign="top">Region :</td>
                                            <td>
                                                <select name="regionID" multiple size="6" class="xLargeField">
                                                    <cfloop query="qGetRegions">
                                                        <option value="#qGetRegions.regionID#"><cfif CLIENT.companyID EQ 5>#qGetRegions.companyShort# - </cfif>#qGetRegions.regionname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">Report Type :</td>
                                            <td>
                                                <select name="compliantOption" class="xLargeField">
                                                    <option value="">Comprehensive Report</option>
                                                    <option value="missing">Missing Paperwork</option>
                                                    <option value="non-compliant">Non-compliant Paperwork</option>                                                
                                                </select>
                                            </td>		
                                        </tr>
                                        <tr>
                                            <td valign="top">Output Type :</td>
                                            <td>
                                                <select name="outputType" class="xLargeField">
                                                    <option value="onScreen">On Screen</option>
                                                    <option value="Excel">Excel Spreadsheet</option>
                                                </select>
                                            </td>		
                                        </tr>
                                        <tr align="left">
                                            <td>Send as email to Intl. Representative :</td>
                                            <td>
                                                <input type="radio" name="sendEmail" id="sendEmailSPNo" value="0" checked="checked"> <label for="sendEmailSPNo">No</label>  
                                                <input type="radio" name="sendEmail" id="sendEmailSPYes" value="1"> <label for="sendEmailSPYes">Yes</label>
                                                <br /><font size="-2">Available only on screen option</font>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
                                        </tr>
                                    </table>
                                </form>
    
                            </td>
                        </tr>
                    </table><br />
                    
                
					<!--- Row 4 - 2 boxes --->
                    <table cellpadding="6" cellspacing="0" align="center" width="95%">
                        <tr>
                            <td width="50%" valign="top">
                                <form action="compliance/doublePlacementPaperworkByIntlRep.cfm" method="POST" target="_blank">
                                    <table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
                                        <tr><th colspan="3" bgcolor="##e2efc7">Double Placement Paperwork by International Representative</th></tr>
                                        <tr align="left">
                                            <td width="30%" valign="top">Program :</td>
                                            <td>
                                                <select name="programID" size="6" multiple>
                                                    <cfloop query="qGetProgramList">
                                                        <option value="#programID#">#programname#</option>
                                                    </cfloop>
                                                </select>		
                                            </td>
                                        </tr>
                                        <tr align="left">
                                            <td valign="top">Region :</td>
                                            <td>
                                                <select name="regionID" multiple size="6" class="xLargeField">
                                                    <cfloop query="qGetRegions">
                                                        <option value="#qGetRegions.regionID#"><cfif CLIENT.companyID EQ 5>#qGetRegions.companyShort# - </cfif>#qGetRegions.regionname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">Filter :</td>
                                            <td>
                                                <select name="compliantOption" class="xLargeField">
                                                    <option value="">Comprehensive Report</option>
                                                    <option value="missing">Missing Paperwork</option>
                                                    <option value="non-compliant">Non-compliant Paperwork</option>                                                
                                                </select>
                                            </td>		
                                        </tr>
                                        <tr>
                                            <td valign="top">Output Type :</td>
                                            <td>
                                                <select name="outputType" class="xLargeField">
                                                    <option value="onScreen">On Screen</option>
                                                    <option value="Excel">Excel Spreadsheet</option>
                                                </select>
                                            </td>		
                                        </tr>
                                        <tr align="left">
                                            <td>Send as email to Intl. Representative :</td>
                                            <td>
                                                <input type="radio" name="sendEmail" id="sendEmailDPNo" value="0" checked="checked"> <label for="sendEmailDPNo">No</label>  
                                                <input type="radio" name="sendEmail" id="sendEmailDPYes" value="1"> <label for="sendEmailDPYes">Yes</label>
                                                <br /><font size="-2">Available only on screen option</font>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
                                        </tr>
    
                                    </table>
                                </form>
                            </td>
                            <td width="50%" valign="top">
                                <form action="compliance/doublePlacementPaperworkByRegion.cfm" method="POST" target="_blank">
                                    <table class="nav_bar" cellpadding=6 cellspacing="0" width="100%">
                                        <tr><th colspan="3" bgcolor="##e2efc7">Double Placement Paperwork by Region</th></tr>
                                        <tr align="left">
                                            <td width="30%" valign="top">Program :</td>
                                            <td>
                                                <select name="programID" size="6" multiple>
                                                    <cfloop query="qGetProgramList">
                                                        <option value="#programID#">#programname#</option>
                                                    </cfloop>
                                                </select>		
                                            </td>
                                        </tr>
                                        <tr align="left">
                                            <td valign="top">Region :</td>
                                            <td>
                                                <select name="regionID" multiple size="6" class="xLargeField">
                                                    <cfloop query="qGetRegions">
                                                        <option value="#qGetRegions.regionID#"><cfif CLIENT.companyID EQ 5>#qGetRegions.companyShort# - </cfif>#qGetRegions.regionname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">Filter :</td>
                                            <td>
                                                <select name="compliantOption" class="xLargeField">
                                                    <option value="">Comprehensive Report</option>
                                                    <option value="missing">Missing Paperwork</option>
                                                    <option value="non-compliant">Non-compliant Paperwork</option>                                                
                                                </select>
                                            </td>		
                                        </tr>
                                        <tr>
                                            <td valign="top">Report By :</td>
                                            <td>
                                                <select name="reportBy" class="xLargeField">
                                                    <option value="placeRepID">Placing Representative</option>
                                                    <option value="areaRepID">Supervising Representative</option>
                                                </select>
                                            </td>		
                                        </tr>                                    
                                        <tr>
                                            <td valign="top">Output Type :</td>
                                            <td>
                                                <select name="outputType" class="xLargeField">
                                                    <option value="onScreen">On Screen</option>
                                                    <option value="Excel">Excel Spreadsheet</option>
                                                </select>
                                            </td>		
                                        </tr>
                                        <tr align="left">
                                            <td>Send as email to Regional Manager :</td>
                                            <td>
                                                <input type="radio" name="sendEmail" id="sendEmailDPNo" value="0" checked="checked"> <label for="sendEmailDPNo">No</label>  
                                                <input type="radio" name="sendEmail" id="sendEmailDPYes" value="1"> <label for="sendEmailDPYes">Yes</label>
                                                <br /><font size="-2">Available only on screen option</font>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
                                        </tr>
    
    
                                    </table>
                                </form>
                            </td>
                        </tr>
                    </table><br />
				
                </cfif>
                
				<!--- Row 5 - 2 boxes --->
                <table cellpadding="6" cellspacing="0" align="center" width="95%">
                    <tr>
                        <td width="50%" valign="top">
                            <form name="secondVisit" action="compliance/dosSecondVisitCompliance.cfm" method="post" target="_blank">
                                <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                    <tr><th colspan="2" bgcolor="##e2efc7">2<sup>nd</sup> Visit Representative Compliance By Region</th></tr>
                                    <tr>
                                        <td width="30%" valign="top">Program :</td>
                                        <td>
                                            <select name="programID" multiple="yes" size="6" class="xLargeField">
                                                <cfloop query="qGetProgramList">
                                                    <option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">Region :</td>
                                        <td>
                                            <select name="regionID" multiple size="6" class="xLargeField">
                                                <cfloop query="qGetRegions">
                                                	<option value="#qGetRegions.regionID#"><cfif CLIENT.companyID EQ 5>#qGetRegions.companyShort# - </cfif>#qGetRegions.regionname#</option>
                                                </cfloop>
                                            </select>
                                        </td>		
                                    </tr>
                                    <tr>
                                        <td valign="top">Output Type :</td>
                                        <td>
                                            <select name="outputType" class="xLargeField">
                                                <option value="onScreen">On Screen</option>
                                                <option value="Excel">Excel Spreadsheet</option>
                                            </select>
                                        </td>		
                                    </tr>
                                    <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                        <tr align="left">
                                            <td>Send as email to Regional Manager :</td>
                                            <td>
                                                <input type="radio" name="sendEmail" id="sendEmailSVNo" value="0" checked="checked"> <label for="sendEmailSVNo">No</label>  
                                                <input type="radio" name="sendEmail" id="sendEmailSVYes" value="1"> <label for="sendEmailSVYes">Yes</label>
                                                <br /><font size="-2">Available only on screen option</font>
                                            </td>
                                        </tr>
                                    </cfif>
                                    <tr>
                                        <td align="right">
                                            <input type="checkbox" name="isDueSoon" id="isDueSoon" value="1" <cfif NOT ListFind("1,2,3,4", CLIENT.userType)> checked disabled </cfif> />
                                        </td>
                                        <td>
                                            <label for="isDueSoon">Display only records due within 14 days</label>
                                        </td>
                                    </tr>  
                                    <tr>
                                        <td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                    </tr>
                                </table>
                            </form>
                        </td>
                        <td width="50%" valign="top">

							<!--- Office Users Only --->
                            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                            
                                <form name="secondVisitStatistics" action="compliance/dosSecondVisitStatistics.cfm" method="post" target="_blank">
                                    <table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
                                        <tr><th colspan="2" bgcolor="##e2efc7">2<sup>nd</sup> Visit Representative Statistics By Region</th></tr>
                                        <tr>
                                            <td width="30%" valign="top">Program :</td>
                                            <td>
                                                <select name="programID" multiple="yes" size="6" class="xLargeField">
                                                    <cfloop query="qGetProgramList">
                                                        <option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">Region :</td>
                                            <td>
                                                <select name="regionID" multiple size="6" class="xLargeField">
                                                    <cfloop query="qGetRegions">
                                                        <option value="#qGetRegions.regionID#"><cfif CLIENT.companyID EQ 5>#qGetRegions.companyShort# - </cfif>#qGetRegions.regionname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>		
                                        </tr>
                                        <tr>
                                            <td valign="top">Output Type :</td>
                                            <td>
                                                <select name="outputType" class="xLargeField">
                                                    <option value="onScreen">On Screen</option>
                                                    <option value="Excel">Excel Spreadsheet</option>
                                                </select>
                                            </td>		
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                        </tr>
                                    </table>
                                </form>

							</cfif>
                                                            
                        </td>
                    </tr>
                </table><br />
                
    		</td>
		</tr>
    </table>

	<!--- Table Footer --->
	<gui:tableFooter />

</cfoutput>