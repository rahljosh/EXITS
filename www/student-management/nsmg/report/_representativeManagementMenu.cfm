<!--- ------------------------------------------------------------------------- ----
	
	File:		_representativeManagementMenu.cfm
	Author:		Marcus Melo
	Date:		April 19, 2012
	Desc:		Representative Management Report Options
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=representativeManagementMenu
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>
		// Get Programs
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(dateActive=1);
	
		// Get User Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(
			companyID=CLIENT.companyID,
			userID=CLIENT.userID,
			userType=CLIENT.userType
		);
		
		// Get Training Options
		qGetTrainingOptions = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(applicationID=7,fieldKey='smgUsersTraining');
	</cfscript>
	
</cfsilent>

<cfoutput>

<!--- Table Header --->
<gui:tableHeader
	imageName="docs.gif"
	tableTitle="Reports - Representative Management"
	tableRightTitle='<h2><a href="#CGI.SCRIPT_NAME#?curdoc=report/index" title="Click for Student Management Reports">[ Reports Menu ]</a></h2>'
/>

    <tr>
    	<td>
        
        	<!--- Row 2 Column 1 - Second Visit Representatives Compliance By Region --->
            <form action="report/index.cfm?action=secondVisitRepCompliance" name="secondVisitRepCompliance" id="secondVisitRepCompliance" method="post" target="blank">
                
                <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable left">
                    <tr><th colspan="2">Second Visit Representatives Compliance By Region</th></tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                        <td>
                            <select name="programID" id="programID" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetProgramList"><option value="#qGetProgramList.programID#">#qGetProgramList.programname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                        <td>
                            <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetRegionList"><option value="#qGetRegionList.regionID#">#qGetRegionList.regionname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Options</td>
                        <td>
                        	<input type="checkbox" name="isDueSoon" id="isDueSoon" />Only show records due within 14 days
                            <br />
                            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                            	<input type="checkbox" name="sendEmail" id="sendEmail" />Send as email to regional manager
                            	<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(only available in on screen report)
							</cfif>
                        </td>
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                        <td>
                            <select name="outputType" class="xLargeField">
                                <option value="onScreen">On Screen</option>
                                <option value="Excel">Excel Spreadsheet</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td>&nbsp;</td>
                        <td class="required noteAlert">* Required Fields</td>
                    </tr>
                    <tr>
                        <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                    </tr>
                </table>
            </form>	
            
        </td>
        <td>
        
        	<!--- Row 2 Column 2 - Pending Student Missing Second Visit Representative --->
            <form action="report/index.cfm?action=pendingStudentMissingSecondVisitRep" name="pendingStudentMissingSecondVisitRep" id="pendingStudentMissingSecondVisitRep" method="post" target="blank">
                
                <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable left">
                    <tr><th colspan="2">Pending Students Missing Second Visit Representative</th></tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                        <td>
                            <select name="programID" id="programID" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetProgramList"><option value="#qGetProgramList.programID#">#qGetProgramList.programname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                        <td>
                            <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetRegionList"><option value="#qGetRegionList.regionID#">#qGetRegionList.regionname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Status: <span class="required">*</span></td>
                        <td>
                        	<select name="status" class="xLargeField">
                                <option value="0">All</option>
                                <option value="1">Placed</option>
                                <option value="2">Unplaced</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                        <td>
                            <select name="outputType" class="xLargeField">
                                <option value="onScreen">On Screen</option>
                                <option value="Excel">Excel Spreadsheet</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td>&nbsp;</td>
                        <td class="required noteAlert">* Required Fields</td>
                    </tr>
                    <tr>
                        <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                    </tr>
                </table>
            </form>	
        
        </td>
    </tr>
    <tr>
    	<td>
        
        	<!--- Row 3 Column 1 - List of Trainings by Region --->
            <form action="report/index.cfm?action=userTrainingListByRegion" name="userTrainingListByRegion" id="userTrainingListByRegion" method="post" target="blank">
                
                <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable left">
                    <tr><th colspan="2">User Training List by Region</th></tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                        <td>
                            <select name="programID" id="programID" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetProgramList"><option value="#qGetProgramList.programID#">#qGetProgramList.programname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                        <td>
                            <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetRegionList"><option value="#qGetRegionList.regionID#">#qGetRegionList.regionname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Training: <span class="required">*</span></td>
                        <td>
                        	<select name="trainingID" id="trainingID" class="xLargeField" multiple size="6" required>
                            	<cfloop query="qGetTrainingOptions"><option value="#qGetTrainingOptions.fieldID#">#qGetTrainingOptions.name#</option></cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                        <td>
                            <select name="outputType" class="xLargeField">
                                <option value="onScreen">On Screen</option>
                                <option value="Excel">Excel Spreadsheet</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td>&nbsp;</td>
                        <td class="required noteAlert">* Required Fields</td>
                    </tr>
                    <tr>
                        <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                    </tr>
                </table>
            </form>	
        
        </td>
        <td>
        
        	<!--- Row 3 Column 2 - Non Compliance Report --->
            <form action="report/index.cfm?action=userTrainingNonCompliant" name="userTrainingNonCompliant" id="userTrainingNonCompliant" method="post" target="blank">
                
                <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable left">
                    <tr><th colspan="2">User Training Non-Compliant Report</th></tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                        <td>
                            <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetRegionList"><option value="#qGetRegionList.regionID#">#qGetRegionList.regionname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Training: <span class="required">*</span></td>
                        <td>
                        	<select name="trainingID" class="xLargeField" required>
                            	<cfloop query="qGetTrainingOptions"><option value="#qGetTrainingOptions.fieldID#">#qGetTrainingOptions.name#</option></cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                        <td>
                            <select name="outputType" class="xLargeField">
                                <option value="onScreen">On Screen</option>
                                <option value="Excel">Excel Spreadsheet</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td>&nbsp;</td>
                        <td class="required noteAlert">* Required Fields</td>
                    </tr>
                    <tr>
                        <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                    </tr>
                </table>
            </form>	
        
        
        <!--- Active Users Authorization Not Received --->
            <form action="report/index.cfm?action=usersCBCAuthorizationNotReceived" name="usersCBCAuthorizationNotReceived" id="usersCBCAuthorizationNotReceived" method="post" target="blank">
                
                <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                    <tr><th colspan="2">Active Users Authorization Not Received</th></tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">User Type: <span class="required">*</span></td>
                        <td>
                            <select name="type" id="type" class="xLargeField" required>
                                <option value="0">Office</option>
                                <option value="1">Reps</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                        <td>
                            <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetRegionList"><option value="#qGetRegionList.regionID#">#qGetRegionList.regionname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                        <td>
                            <select name="outputType" class="xLargeField">
                                <option value="onScreen">On Screen</option>
                                <option value="Excel">Excel Spreadsheet</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td>&nbsp;</td>
                        <td class="required noteAlert">* Required Fields</td>
                    </tr>
                    <tr>
                        <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                    </tr>
                </table>
            </form>
        
        </td>
    </tr>
</table>    

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>