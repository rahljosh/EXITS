<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		September 22, 2011
	Desc:		Progress Reports - Report Section

	Updated:	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>
		/*
			REPORTS PER PROGRAM
			10 MONTH - OCT - DEC - FEB - APRIL - JUNE - TYPE = 1
			12 MONTH - FEB - APRIL - AUG - OCT - DEC - TYPE = 2
			1ST SEMESTER - OCT - DEC - FEB - TYPE = 3
			2ND SEMESTER - FEB - APRIL - JUNE - TYPE = 4
			
			10 MONTH PRIVATE - PROGRAM END DATE 06/31
			12 MONTH PRIVATE - PROGRAM END DATE 12/31
			1ST SEMESTER PRIVATE - PROGRAM END DATE 06/31
			2ND SEMESTER PRIVATE - PROGRAM END DATE 01/15
			USE #DateFormat(current_students_status.enddate, 'mm')# EQ '12'
		*/
	
		// Get Programs
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(dateActive=1);
	
		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, userType=CLIENT.userType);
	</cfscript>
    
</cfsilent>

<cfoutput>

	<!--- Table Header --->
	<gui:tableHeader
		imageName="user.gif"
		tableTitle="Online Reports"
		width="98%"
	/>

		<!--- Page Messages --->
		<gui:displayPageMessages 
			pageMessages="#SESSION.pageMessages.GetCollection()#"
			messageType="tableSection"
			width="98%"
			/>
	
		<!--- Form Errors --->
		<gui:displayFormErrors 
			formErrors="#SESSION.formErrors.GetCollection()#"
			messageType="tableSection"
			width="98%"
			/>	

		<table border="0" cellpadding="8" cellspacing="2" width="98%" class="section" align="center">
			<tr>
				<td width="50%" valign="top">

					<form action="progressReports/missingProgressReportByRegion.cfm" method="post" target="_blank">
                        <table class="nav_bar" cellpadding="6" cellspacing="0" width="90%" align="center">
                            <tr><th colspan="2" bgcolor="##e2efc7">Missing Progress Reports by Region</th></tr>
                            <tr>
                                <td valign="top">Program:</td>
                                <td align="left">
                                    <select name="programID" id="programID" class="xLargeField" multiple size="5">
                                        <cfloop query="qGetProgramList">
                                            <option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option>
                                        </cfloop>
                                    </select>
                                </td>
                             </tr>
                            <tr>
                                <td valign="top">Region: </td>
                                <td align="left">
                                    <select name="regionID" id="regionID" class="xLargeField" multiple size="5">
                                        <cfloop query="qGetRegionList">
                                            <option value="#qGetRegionList.regionID#">#qGetRegionList.regionName#</option>
                                        </cfloop>
                                    </select>
                                </td>
                             </tr>
                            <tr>
                                <td valign="top">Phase:</td>
                                <td>
                                	<select name="monthReport" id="monthReport" class="xLargeField" multiple size="5">
                                        <option value="10">Phase 1 (Aug &amp; Sep) - due Oct 1st</option>		
                                        <option value="12">Phase 2 (Oct &amp; Nov) - due Dec 1st</option>
                                        <option value="2">Phase 3 (Dec &amp; Jan) - due Feb 1st</option>
                                        <option value="4">Phase 4 (Feb &amp; Mar) - due Apr 1st</option>
                                        <option value="6">Phase 5 (Apr &amp; May) - due Jun 1st</option>
                                        <option value="8">Phase 6 (Jun &amp; Jul) - due Aug 1st</option>
                                    </select>
                                </td>		
                            </tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                        </table>
					</form>
				
                </td>            
				<td width="50%" valign="top">

					<form action="progressReports/missingStudentUpdatesByRegion.cfm" method="post" target="_blank">
                        <input type="hidden" name="submitted" value="1">
                        <table class="nav_bar" cellpadding="6" cellspacing="0" width="90%" align="center">
                            <tr><th colspan="2" bgcolor="##e2efc7">Missing Student Updates by Region</th></tr>
                            <tr>
                                <td valign="top">Program:</td>
                                <td align="left">
                                    <select name="programID" id="programID" class="xLargeField" multiple size="5">
                                        <cfloop query="qGetProgramList">
                                            <option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option>
                                        </cfloop>
                                    </select>
                                </td>
                             </tr>
                            <tr>
                                <td valign="top">Region: </td>
                                <td align="left">
                                    <select name="regionID" id="regionID" class="xLargeField" multiple size="5">
                                        <cfloop query="qGetRegionList">
                                            <option value="#qGetRegionList.regionID#">#qGetRegionList.regionName#</option>
                                        </cfloop>
                                    </select>
                                </td>
                             </tr>
                            <tr>
                                <td valign="top">Time Frame:</td>
                                <td>
                                	<select name="monthReport" id="monthReport" class="xLargeField" multiple size="5">
                                        <option value="9">Update 1 - Due Sept 1</option>
                                        <option value="11">Update 2 - Due Nov 2</option>
                                        <option value="1">Update 3 - Due Jan 1</option>
                                        <option value="3">Update 4 - Due Mar 1</option>
                                        <option value="5">Update 5 - Due May 1</option>
                                        <option value="7">Update 6 - Due July 1</option>
                                    </select>
                                </td>		
                            </tr>
                            <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                        </table>
					</form>
				
                </td>            
			</tr>
		</table>

	<!--- Table Footer --->
	<gui:tableFooter 
		width="98%"
	/>

</cfoutput>
