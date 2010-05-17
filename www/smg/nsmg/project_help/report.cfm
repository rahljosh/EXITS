<!--- ------------------------------------------------------------------------- ----
	
	File:		report.cfm
	Author:		Marcus Melo
	Date:		April 12, 2010
	Desc:		Project Help Report

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
	
    <!--- Param Variables --->
	<cfparam name="FORM.submitted" default="0">

    <cfparam name="FORM.regionID" default="#CLIENT.regionID#">
    <cfparam name="FORM.programID" default="">
	<cfparam name="FORM.approvedStatus" default="">
	<cfparam name="FORM.minimumHours" default="">
    <cfparam name="FORM.maxHours" default="">
    <Cfparam name="FORM.noHours" default="0">
	<cfparam name="FORM.isActive" default="1">
    <cfparam name="FORM.printExcel" default="0">
	<cfparam name="FORM.noHours" default="0">
    <cfparam name="URL.regionID" default="0">
	<cfparam name="URL.isActive" default="">

	<cfscript>
		// Get Active Programs
		qGetPrograms = APPCFC.PROGRAM.getPrograms(isActive=1);
	
		// Check if we have a valid URL.isActive
		if ( LEN(URL.isActive) ) {
			FORM.isActive = URL.isActive;	
		}

		// Office Users
		if ( VAL(CLIENT.userType) LTE 4 ) {
		
			// Get All Regions
			qGetRegions = APPCFC.REGION.getRegions(			
				companyID=CLIENT.companyID,
				userID=CLIENT.userID
			);	

			if ( VAL(URL.regionID) ) {
				FORM.regionID = URL.regionID;	
			} 
			
			if (NOT VAL(FORM.regionID)) {
				FORM.regionID = qGetRegions.regionID;	
			}		
			
			// FORM submitted
			if (FORM.submitted) {			
				// Get Student List
				qGetStudents = APPCFC.STUDENT.getProjectHelpReport(
					userID=CLIENT.userID,					
					regionID=FORM.regionID,
					userType=CLIENT.userType,
					isActive=FORM.isActive,
					programID=FORM.programID,
					statusKey = FORM.approvedStatus,
					minimumHours = FORM.minimumHours,
					maxHours = FORM.maxHours,
					noHours = FORM.noHours
				);
			}

		// Area Reps, Advisors and Managers
		} else {	
			
			// Get User Regions
			qGetRegions = APPCFC.REGION.getUserRegions(			
				companyID=CLIENT.companyID,
				userType=CLIENT.userType,
				userID=CLIENT.userID);
		
			// Set Regions List
			regionList = ValueList(qGetRegions.regionID);
			
			if ( VAL(URL.regionID) AND ListFind(regionList, URL.regionID) ) {
				FORM.regionID = URL.regionID;		
			}
			
			if (NOT VAL(FORM.regionID)) {
				FORM.regionID = qGetRegions.regionID;	
			}		

			// FORM submitted
			if (FORM.submitted) {
				// Get Student List
				qGetStudents = APPCFC.STUDENT.getProjectHelpReport(
					userID=CLIENT.userID,
					regionID=FORM.regionID,
					userType=qGetRegions.userType,					
					isActive=FORM.isActive,
					programID=FORM.programID,
					statusKey = FORM.approvedStatus,
					minimumHours = FORM.minimumHours,
					maxHours = FORM.maxHours,
					noHours = FORM.noHours
				);
			}
		}
	</cfscript>

	<!--- Check Access --->
	<cfif VAL(CLIENT.usertype) GT 7>
        <cflocation url="index.cfm?curdoc=progress_reports" addtoken="no">
        <cfabort>
    </cfif>

</cfsilent>

<!--- Form not submitted, display options --->
<cfif NOT FORM.submitted>

	<cfoutput>

		<!--- Table Header --->
        <gui:tableHeader
            imageName="current_items.gif"
            tableTitle="H.E.L.P. Community Service Hours Report"
            tableRightTitle=""
        />    
    
        <cfform action="index.cfm?curdoc=project_help/report" method="post">
            <input name="submitted" type="hidden" value="1">
            
            <table border="0" cellpadding="10" cellspacing="0" class="section" width="100%">
                <tr>
                    
                    <td width="100%">
                        
                        <table class="nav_bar" cellpadding="10" cellspacing="0" align="center" width="50%">
                            <th colspan="2" bgcolor="##e2efc7">Community Service - Total Hours Per Student</th>                        
                            <tr>
                                <td valign="top">
                                    <label for="programID">Program: </label>
                                </td>
                                <td>                
                                    <cfselect 
                                        name="programID"
                                        id="programID" 
                                        query="qGetPrograms" 
                                        value="programID" 
                                        display="programName" 
                                        selected="#FORM.programID#"
                                        multiple="yes"
                                        size="5">
                                    </cfselect>
                                </td>
                            </tr>
                    
                            <tr>
                                <td>
                                    <label for="regionID">Region: </label>
                                </td>
                                <td>                
                                    <cfselect 
                                        name="regionID" 
                                        id="regionID"
                                        query="qGetRegions" 
                                        value="regionID" 
                                        display="regionname" 
                                        queryPosition="below"
                                        selected="#FORM.regionID#"
                                        multiple="yes"
                                        size="5">                                    
                                    </cfselect>
                                </td>
                            </tr>
    
                            <tr>
                                <td>
                                    <label for="approvedStatus">Activity Status </label>
                                </td>
                                <td>                
                                    <select name="approvedStatus" id="approvedStatus">
                                        <option value="" <cfif NOT LEN(FORM.approvedStatus)>selected</cfif>> All </option>
                                        <option value="#APPLICATION.Constants.projectHelpStatus[7]#" <cfif FORM.approvedStatus EQ APPLICATION.Constants.projectHelpStatus[7]>selected</cfif>>Approved Hours by NY Office</option>
                                        <option value="#APPLICATION.Constants.projectHelpStatus[5]#" <cfif FORM.approvedStatus EQ APPLICATION.Constants.projectHelpStatus[5]>selected</cfif>>Approved Hours by Regional Manager</option>
                                    </select>            
                                </td>
                            </tr>
							<tr>
                            	<td>
                                    <label for="minimumHours">Student W/O Hours </label>
                                </td>
                                <td>                
                                    <input type="checkbox" name="noHours" value=1 />         
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="minimumHours">Minimum Hours </label>
                                </td>
                                <td>                
                                    <select name="minimumHours" id="minimumHours">
                                       <!----
                                        <option value="20"> 20 </option>
                                        ---->
                                        <cfloop from="1" to="20" index="i">
                                        	<option value="#i#" <cfif FORM.minimumHours EQ i>selected</cfif> > #i# </option>
                                        </cfloop>
										
                                    </select>            
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <label for="maxHours">Maximum Hours </label>
                                </td>
                                <td>                
                                    <select name="maxHours" id="maxHours">
                                       
                                        <!----
                                        <option value="20"> 20 </option>
                                        ---->
                                        <cfloop from="1" to="20" index="i">
                                        	<option value="#i#" <cfif FORM.maxHours EQ i></cfif> > #i# </option>
                                        </cfloop>
										 <option value="9999" <cfif NOT LEN(FORM.maxHours)>selected</cfif>> All </option>
                                    </select>            
                                </td>
                            </tr>   
                            <tr>
                                <td>
                                    <label for="isActive">Student Status </label>
                                </td>
                                <td>                
                                    <select name="isActive" id="isActive">
                                        <option value="" <cfif NOT LEN(FORM.isActive)>selected</cfif>>All</option>
                                        <option value="1" <cfif VAL(FORM.isActive)>selected</cfif>>Active</option>
                                        <option value="0" <cfif FORM.isActive EQ 0>selected</cfif>>Cancelled</option>
                                    </select>            
                                </td>
                            </tr>
                    
                            <tr>
                                <td colspan="2">
                                    <input type="checkbox" name="printExcel" id="printExcel" value="1" <cfif FORM.printExcel> checked="checked" </cfif> />      
                                    <label for="printExcel">Output Report in Excel Format</label> <br />                           
                                </td>
                            </tr>
                    
                            <tr>
                                <td colspan="2" bgcolor="##e2efc7" align="center"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                            </tr>
                        </table>
                        
                    </td>
                    
                    <td width="50%">&nbsp;
                        
                    </td>	
                        
                </tr>                
            </table>
            
        </cfform>
    
        <!--- Table Footer --->
        <gui:tableFooter />

	</cfoutput>

<!--- FORM SUBMITTED --->
<cfelse>

	<cfif VAL(qGetStudents.recordCount)>

		<!--- Output in Excel --->
		<cfif FORM.printExcel>
			
			<!--- set content type --->
            <cfcontent type="application/msexcel">
            
            <!--- suggest default name for XLS file --->
            <cfheader name="Content-Disposition" value="attachment; filename=projectHelp.xls"> 

		</cfif>
        
        <table width="100%" cellpadding="2" <cfif FORM.printExcel> border="1" </cfif> >

			<!--- Group By Region --->		
            <cfoutput query="qGetStudents" group="regionID"> 	
        
                <tr>
                    <td colspan="3" bgcolor="##EEEEEE"><strong>Region: &nbsp; #regionName#</strong></td>
                <tr>
                
                <!--- Group by Area Reps --->
                <cfoutput group="arearepID"> 
                    <tr>
                        <td colspan="3" bgcolor="##EEEEEE" style="padding-left:30px;"><strong>Area Representative: &nbsp; #rep_firstname# #rep_lastname# (###arearepID#)</strong></td>
                    <tr>
                    <tr align="left">
                        <td style="padding-left:60px;"><strong>Student</strong></td>
                        <td><strong>Program</strong></td>
                        <td><strong>Hours</strong></td>
                    </tr>
                
                    <cfoutput> 
                        <tr bgcolor="#IIF(qGetStudents.currentRow MOD 2 ,DE("EEEEEE") ,DE("FFFFFF") )#">
                            <td style="padding-left:60px;">#firstname# #familylastname# (###studentID#)</td>
                            <td>#programName#</td>
                            <td><cfif not isDefined('hours')>0<cfelse>#hours#</cfif></td>
                        </tr>
                    </cfoutput> <!--- Students --->
 					
                    <tr><td colspan="3">&nbsp;</td></tr>
                                   
                </cfoutput> <!--- group="arearepID" --->
        
            </cfoutput> <!--- group="regionID" --->                

        </table>
    
    <cfelse>

		<!--- Table Header --->
        <gui:tableHeader
            imageName="current_items.gif"
            tableTitle="H.E.L.P. Community Service Hours Report"
            tableRightTitle=""
        />    
    
        <table border="0" cellpadding="10" cellspacing="0" class="section" width="100%">
            <tr>
                <td>No students matched your criteria. <a href="index.cfm?curdoc=project_help/report">Click here to try again.</a></td>
            </tr>
        </table>

		<!--- Table Footer --->
        <gui:tableFooter />
    
    </cfif>

</cfif>