<!--- ------------------------------------------------------------------------- ----
	
	File:		_officeRegionGoal.cfm
	Author:		James Griffiths
	Date:		May 17, 2012
	Desc:		Goal Per Region
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=officeRegionGoal
				
	Updated: 	06/14/2012 - Combing Great Lakes Region
				06/14/2012 - Renaming report from Allocation to Goal		
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.seasonID" default=0;
		param name="FORM.regionID" default=0;
		param name="FORM.goalPeriod" default="";
		param name="FORM.outputType" default="onScreen";

		// Set Report Title To Keep Consistency
		vReportTitle = "Office Management - Region Goal";

		// Set Program Types
		if ( FORM.goalPeriod EQ 'January' ) {
			 // 12 Month - 2nd Semester
			vProgramTypeList = '2,4';
		} else {
			// 10 Month - 1st Semester
			vProgramTypeList = '1,3'; 
		}
		
		vExcelTotalRowColor = "##d8d8d8";

		// Great Lakes Summary - Combining great lakes region
		vGreatLakesRegionIDList = "1086,1251,1250,1266";
		vGreatLakesSummaryAssigned = 0;
		vGreatLakesSummaryPlaced = 0;
		vGreatLakesSummaryPending = 0;
		vGreatLakesSummaryUnplaced = 0;
		vGreatLakesSummaryPlacement = 0;
		vGreatLakesSummaryAllocation = 0;
		vGreatLakesSummaryPercentage = 0;

		// Set Division Summary
		vDivisionSummaryAssigned = 0;
		vDivisionSummaryPlaced = 0;
		vDivisionSummaryPending = 0;
		vDivisionSummaryUnplaced = 0;
		vDivisionSummaryPlacement = 0;
		vDivisionSummaryAllocation = 0;
		vDivisionSummaryPercentage = 0;

        // Summary
		vSummaryAssigned = 0;
        vSummaryPlaced = 0;
        vSummaryPending = 0;
		vSummaryUnplaced = 0;
        vSummaryPlacement = 0;
        vSummaryAllocation = 0;
        vSummaryPercentage = 0;
	</cfscript>
    
    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
		
        <cfscript>
			// Data Validation

            // Region
            if ( NOT VAL(FORM.regionID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one region");
            }
		</cfscript>
    	
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>

			 <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                SELECT DISTINCT
                    r.regionID,
                    r.regionName,
                    r.company,
                    c.companyName,
                    c.companyShort,                    
                    u.userID,
                    u.firstName,
                    u.lastName,
                    <cfif FORM.goalPeriod EQ 'August'>
                    	a.augustAllocation AS allocation,
                   	<cfelse>
                    	a.januaryAllocation AS allocation,
                  	</cfif>
                    a.ID,
                    a.seasonID
                FROM
                    smg_regions r 
                INNER JOIN
                	smg_companies c ON c.companyID = r.company
                LEFT OUTER JOIN
                    user_access_rights uar ON r.regionID = uar.regionID
                    AND
                    	uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                LEFT OUTER JOIN
					smg_users u ON uar.userID = u.userID
					AND
                    	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">                        
                LEFT OUTER JOIN
                    smg_users_allocation a ON a.userID = u.userID
                    AND
                    	a.regionID = r.regionID
                    AND
                        a.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
                WHERE
                	r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.regionID#"> )                
                ORDER BY
                    c.companyShort,
                    r.regionName
            </cfquery>
            
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->


	<cffunction name="getStatisticsPerRegion" access="public" returntype="struct" output="false" hint="Returns stastics per region">
    	<cfargument name="regionID" default="0" hint="Region ID is required">

        <cfquery name="qGetStudents" datasource="#APPLICATION.DSN#">
            SELECT
                s.studentID,
                s.host_fam_approved,
                sh.hostID
            FROM
                smg_students s
            INNER JOIN 
                smg_programs p ON s.programID = p.programID
                    AND
                        p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vProgramTypeList#" list="yes"> )
                    AND
                        p.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#"> 
            LEFT OUTER JOIN
                smg_hostHistory sh ON sh.studentID = s.studentID
                AND
                    sh.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            WHERE
                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND
                s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.regionID#">
        </cfquery>
        
        <cfquery name="qGetUnplaced" dbtype="query">
            SELECT
                studentID
            FROM
                qGetStudents
            WHERE
                hostID IS NULL
        </cfquery>
        
        <cfquery name="qGetPlaced" dbtype="query">
            SELECT
                studentID
            FROM
                qGetStudents
            WHERE
                hostID IS NOT NULL
            AND
                host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="1,2,3,4"> )
        </cfquery>
        
        <cfquery name="qGetPending" dbtype="query">
            SELECT
                studentID
            FROM
                qGetStudents 
            WHERE
                hostID IS NOT NULL
            AND
                host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="5,6,7"> )
        </cfquery>
		
        <cfscript>
			// Set New Structure
			stRegionStatistics = StructNew();
			// Feed Results
			stRegionStatistics.totalStudents = qGetStudents.recordCount;
			stRegionStatistics.totalUnplaced = qGetUnplaced.recordCount;
			stRegionStatistics.totalPlaced = qGetPlaced.recordCount;
			stRegionStatistics.totalPending = qGetPending.recordCount;
			// Return Structure
			return stRegionStatistics;
		</cfscript>
        
	</cffunction>
    
    
	<cffunction name="setRowColor" access="public" returntype="string" output="false" hint="Sets excel row color">
    	<cfargument name="currentRow" hint="currentRow is required">
    
    	<cfscript>
			// Set Row Color
			if ( ARGUMENTS.currentRow MOD 2 ) {
				vRowColor = "##F2F2F2";
			} else {
				vRowColor = "##FFFFFF";
			}							
		
			return vRowColor;		
		</cfscript>
        
    </cffunction>
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

	<cfoutput>

        <form action="report/index.cfm?action=officeRegionGoal" name="officeRegionGoal" id="officeRegionGoal" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="8" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">#vReportTitle#</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Season: <span class="required">*</span></td>
                    <td>
                        <select name="seasonID" id="seasonID" class="xLargeField" required>
                            <cfloop query="qGetSeasonList"><option value="#qGetSeasonList.seasonID#">#qGetSeasonList.season#</option></cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                	<td class="subTitleRightNoBorder">Period: <span class="required">*</span></td>
                    <td>
                    	<select name="goalPeriod" id="goalPeriod" class="xLargeField" required>
                        	<option value="August">August Goal</option>
                            <option value="January">January Goal</option>
                    	</select>
                    </td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                    <td>
                        <select name="regionID" id="regionID" class="xLargeField" multiple size="8" required>
                            <cfloop query="qGetRegionList">
                            	<option value="#qGetRegionList.regionID#">
                                	<cfif CLIENT.companyID EQ 5>#qGetRegionList.companyShort# -</cfif>
                                    #qGetRegionList.regionname#
                                </option>
                            </cfloop>
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
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>
                        This report will provide a list of each region's goal for a chosen season and August/January goal.
                    </td>		
                </tr>
                <tr>
                    <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                </tr>
            </table>
        </form>	

	</cfoutput>
    
<!--- FORM Submitted --->
<cfelse>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	
    
    <!--- FORM Submitted with errors --->
    <cfif SESSION.formErrors.length()> 
       
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="100%"
            />	
            
		<cfabort>            
	</cfif>
    
	<!--- Output in Excel - Do not use GroupBy --->
    <cfif FORM.outputType EQ 'excel'>
        
        <!--- set content type --->
        <cfcontent type="application/msexcel">
        
        <!--- suggest default name for XLS file --->
        <cfheader name="Content-Disposition" value="attachment; filename=officeRegionGoal.xls">

        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr><th colspan="10">#vReportTitle#</th></tr>
            <tr style="font-weight:bold;">
                <td>Company</td>
                <td>Region</td>
                <td>Regional Manager</td>
                <td>Total Assigned</td>
                <td>Placed</td>
                <td>Pending</td>
                <td>Unplaced</td>
                <td>Total Placements</td>
                <td>Goal</td>
                <td>Percentage</td>
            </tr>

			<cfoutput query="qGetResults" group="companyShort">
        
                <cfscript>
                    vCurrentRow = 0;
                    
                    // Set Division Summary
                    vDivisionSummaryAssigned = 0;
                    vDivisionSummaryPlaced = 0;
                    vDivisionSummaryPending = 0;
                    vDivisionSummaryUnplaced = 0;
                    vDivisionSummaryPlacement = 0;
                    vDivisionSummaryAllocation = 0;
                    vDivisionSummaryPercentage = 0;
                </cfscript>
    
				<cfoutput>

                    <cfscript>
                        // Increase Current Row
                        vCurrentRow ++;

                        vCurrentRowPlacecement = 0;
                        vCurrentRowPercentage = 0;
                        
                        // Get Statistics Per Region
                        stGetStatisticsPerRegion = getStatisticsPerRegion(regionID=qGetResults.regionID);
    
                        // Set Total Placed and Percentage
                        vCurrentRowPlacecement = stGetStatisticsPerRegion.totalPlaced + stGetStatisticsPerRegion.totalPending;
                        
                        if ( VAL(qGetResults.allocation) ) {
                            vCurrentRowPercentage = ( vCurrentRowPlacecement / qGetResults.allocation ) * 100;
                        }
                            
                        // Calculate Division Summary
                        vDivisionSummaryAssigned += stGetStatisticsPerRegion.totalStudents;
                        vDivisionSummaryPlaced += stGetStatisticsPerRegion.totalPlaced;
                        vDivisionSummaryPending += stGetStatisticsPerRegion.totalPending;
                        vDivisionSummaryUnplaced += stGetStatisticsPerRegion.totalUnplaced;
                        vDivisionSummaryAllocation += VAL(qGetResults.allocation);
                        
                        // Calculate Summary
                        vSummaryAssigned += stGetStatisticsPerRegion.totalStudents;
                        vSummaryPlaced += stGetStatisticsPerRegion.totalPlaced;
                        vSummaryPending += stGetStatisticsPerRegion.totalPending;
                        vSummaryUnplaced += stGetStatisticsPerRegion.totalUnplaced;
                        vSummaryAllocation += VAL(qGetResults.allocation);

                        // Great Lakes Region - Calculate Total
                        if ( listFind(vGreatLakesRegionIDList, qGetResults.regionID) ) {
                            vGreatLakesSummaryAssigned += stGetStatisticsPerRegion.totalStudents;
                            vGreatLakesSummaryPlaced += stGetStatisticsPerRegion.totalPlaced;
                            vGreatLakesSummaryPending += stGetStatisticsPerRegion.totalPending;
                            vGreatLakesSummaryUnplaced += stGetStatisticsPerRegion.totalUnplaced;
                            vGreatLakesSummaryPlacement = vGreatLakesSummaryPlaced + vGreatLakesSummaryPending;
                            vGreatLakesSummaryAllocation += VAL(qGetResults.allocation);
                            
                            if ( VAL(vGreatLakesSummaryAllocation) ) {
                                vGreatLakesSummaryPercentage = ( vGreatLakesSummaryPlacement / vGreatLakesSummaryAllocation ) * 100;
                            }
                            
                        }
                    </cfscript>
                    
                    <!--- Do not display Great Lakes Regions --->
                    <cfif NOT listFind(vGreatLakesRegionIDList, qGetResults.regionID)>
                        
                        <tr>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#qGetResults.companyShort#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#qGetResults.regionName#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#"><cfif VAL(qGetResults.userID)>#qGetResults.firstName# #qGetResults.lastName#<cfelse><span class="attention">Not Assigned</span></cfif></td>                        
                            <td bgcolor="#setRowColor(vCurrentRow)#">#stGetStatisticsPerRegion.totalStudents#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#stGetStatisticsPerRegion.totalPlaced#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#stGetStatisticsPerRegion.totalPending#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#stGetStatisticsPerRegion.totalUnplaced#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#vCurrentRowPlacecement#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#qGetResults.allocation#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#NumberFormat(vCurrentRowPercentage, '___.__')#%</td>
                        </tr>
                    
                    <!--- Display Total for Great Lakes --->
                    <cfelseif qGetResults.regionID EQ ListLast(vGreatLakesRegionIDList)>
                    
                        <cfscript>
                            // Increase Current Row
                            vCurrentRow ++;
                        </cfscript>
                        <tr>
                        	<td bgcolor="#setRowColor(vCurrentRow)#">#qGetResults.companyShort#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">Great Lakes</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#"><cfif VAL(qGetResults.userID)>#qGetResults.firstName# #qGetResults.lastName#<cfelse><span class="attention">Not Assigned</span></cfif></td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#vGreatLakesSummaryAssigned#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#vGreatLakesSummaryPlaced#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#vGreatLakesSummaryPending#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#vGreatLakesSummaryUnplaced#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#vGreatLakesSummaryPlacement#</td>
                            <td bgcolor="#setRowColor(vCurrentRow)#">#vGreatLakesSummaryAllocation#</td>
							<td bgcolor="#setRowColor(vCurrentRow)#">#NumberFormat(vGreatLakesSummaryPercentage, '___.__')#% </td>
                        </tr> 
                        
                    </cfif>
                    
                </cfoutput>
                
                <cfscript>
                    // Increase Current Row
                    vCurrentRow ++;

                    vDivisionSummaryPlacement = vDivisionSummaryPlaced + vDivisionSummaryPending;
                    
                    if ( VAL(vDivisionSummaryAllocation) ) {
                        vDivisionSummaryPercentage = ( vDivisionSummaryPlacement / vDivisionSummaryAllocation ) * 100;
                    }		
                    
                    vSummaryPlacement = vSummaryPlaced + vSummaryPending;
                    
                    if ( VAL(vSummaryAllocation) ) {
                        vSummaryPercentage = ( vSummaryPlacement / vSummaryAllocation ) * 100;
                    }				
                </cfscript>
                
                <tr>
                    <td bgcolor="#vExcelTotalRowColor#" colspan="3">Total</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vDivisionSummaryAssigned#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vDivisionSummaryPlaced#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vDivisionSummaryPending#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vDivisionSummaryUnplaced#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vDivisionSummaryPlacement#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vDivisionSummaryAllocation#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#NumberFormat(vDivisionSummaryPercentage, '___.__')#%</td>
                </tr>
            
        </cfoutput>
            
		<!--- ISE - Display Total Divisions --->
        <cfif CLIENT.companyID EQ 5>

            <cfoutput>
                <tr>
                    <td bgcolor="#vExcelTotalRowColor#" colspan="3">Total Divisions</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vSummaryAssigned#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vSummaryPlaced#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vSummaryPending#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vSummaryUnplaced#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vSummaryPlacement#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#vSummaryAllocation#</td>
                    <td bgcolor="#vExcelTotalRowColor#">#NumberFormat(vSummaryPercentage, '___.__')#%</td>
                </tr>
            </cfoutput>
            
        </cfif>
	
    </table>
    
    <!--- On Screen Report --->
    <cfelse>
            
		<!--- Include Report Header --->   
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th><cfoutput>#vReportTitle#</cfoutput></th>            
            </tr>
        </table>
        
		<cfoutput query="qGetResults" group="companyShort">
    
            <cfscript>
                vCurrentRow = 0;
				
				// Set Division Summary
				vDivisionSummaryAssigned = 0;
				vDivisionSummaryPlaced = 0;
				vDivisionSummaryPending = 0;
				vDivisionSummaryUnplaced = 0;
				vDivisionSummaryPlacement = 0;
				vDivisionSummaryAllocation = 0;
				vDivisionSummaryPercentage = 0;
            </cfscript>
            
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th class="left" colspan="9">#qGetResults.companyShort#</th>
                </tr>      
                <tr>
                    <td class="subTitleLeft" width="15%">Region</td>	
                    <td class="subTitleLeft" width="15%">Regional Manager</td>
                    <td class="subTitleCenter" width="10%">Total Assigned</td>
                    <td class="subTitleCenter" width="10%">Placed</td>
                    <td class="subTitleCenter" width="10%">Pending</td>
                    <td class="subTitleCenter" width="10%">Unplaced</td>
                    <td class="subTitleCenter" width="10%">Total Placements</td>
                    <td class="subTitleCenter" width="10%">Goal</td>
                    <td class="subTitleCenter" width="10%">Percentage</td>
                </tr>

                <cfoutput>

                    <cfscript>
						// Increase Current Row
                        vCurrentRow ++;
                        
						vCurrentRowPlacecement = 0;
						vCurrentRowPercentage = 0;
						
						// Get Statistics Per Region
						stGetStatisticsPerRegion = getStatisticsPerRegion(regionID=qGetResults.regionID);
	
						// Set Total Placed and Percentage
						vCurrentRowPlacecement = stGetStatisticsPerRegion.totalPlaced + stGetStatisticsPerRegion.totalPending;
						
						if ( VAL(qGetResults.allocation) ) {
							vCurrentRowPercentage = ( vCurrentRowPlacecement / qGetResults.allocation ) * 100;
						}
							
						// Calculate Division Summary
						vDivisionSummaryAssigned += stGetStatisticsPerRegion.totalStudents;
						vDivisionSummaryPlaced += stGetStatisticsPerRegion.totalPlaced;
						vDivisionSummaryPending += stGetStatisticsPerRegion.totalPending;
						vDivisionSummaryUnplaced += stGetStatisticsPerRegion.totalUnplaced;
						vDivisionSummaryAllocation += VAL(qGetResults.allocation);
						
						// Calculate Summary
						vSummaryAssigned += stGetStatisticsPerRegion.totalStudents;
						vSummaryPlaced += stGetStatisticsPerRegion.totalPlaced;
						vSummaryPending += stGetStatisticsPerRegion.totalPending;
						vSummaryUnplaced += stGetStatisticsPerRegion.totalUnplaced;
						vSummaryAllocation += VAL(qGetResults.allocation);

						// Great Lakes Region - Calculate Total
						if ( listFind(vGreatLakesRegionIDList, qGetResults.regionID) ) {
							vGreatLakesSummaryAssigned += stGetStatisticsPerRegion.totalStudents;
							vGreatLakesSummaryPlaced += stGetStatisticsPerRegion.totalPlaced;
							vGreatLakesSummaryPending += stGetStatisticsPerRegion.totalPending;
							vGreatLakesSummaryUnplaced += stGetStatisticsPerRegion.totalUnplaced;
							vGreatLakesSummaryPlacement = vGreatLakesSummaryPlaced + vGreatLakesSummaryPending;
							vGreatLakesSummaryAllocation += VAL(qGetResults.allocation);
							
							if ( VAL(vGreatLakesSummaryAllocation) ) {
								vGreatLakesSummaryPercentage = ( vGreatLakesSummaryPlacement / vGreatLakesSummaryAllocation ) * 100;
							}
							
						}
					</cfscript>

                    <!--- Do not display Great Lakes Regions --->
                    <cfif NOT listFind(vGreatLakesRegionIDList, qGetResults.regionID)>
                        
                        <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                            <td>#qGetResults.regionName#</td>
                            <td><cfif VAL(qGetResults.userID)>#qGetResults.firstName# #qGetResults.lastName#<cfelse><span class="attention">Not Assigned</span></cfif></td>                        
                            <td class="center">#stGetStatisticsPerRegion.totalStudents#</td>
                            <td class="center">#stGetStatisticsPerRegion.totalPlaced#</td>
                            <td class="center">#stGetStatisticsPerRegion.totalPending#</td>
                            <td class="center">#stGetStatisticsPerRegion.totalUnplaced#</td>
                            <td class="center">#vCurrentRowPlacecement#</td>
                            <td class="center">#qGetResults.allocation#</td>
                            <td class="center">#NumberFormat(vCurrentRowPercentage, '___.__')#%</td>
                        </tr>
                    
					<!--- Display Total for Great Lakes --->
                    <cfelseif qGetResults.regionID EQ ListLast(vGreatLakesRegionIDList)>
                    
                    	<cfscript>
							// Increase Current Row
							vCurrentRow ++;
						</cfscript>
                        <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                            <td>Great Lakes</td>
                            <td><cfif VAL(qGetResults.userID)>#qGetResults.firstName# #qGetResults.lastName#<cfelse><span class="attention">Not Assigned</span></cfif></td>
                            <td class="center">#vGreatLakesSummaryAssigned#</td>
                            <td class="center">#vGreatLakesSummaryPlaced#</td>
                            <td class="center">#vGreatLakesSummaryPending#</td>
                            <td class="center">#vGreatLakesSummaryUnplaced#</td>
                            <td class="center">#vGreatLakesSummaryPlacement#</td>
                            <td class="center">#vGreatLakesSummaryAllocation#</td>
                            <td class="center">#NumberFormat(vGreatLakesSummaryPercentage, '___.__')#% </td>
                        </tr> 
                        
                    </cfif>
                    
                </cfoutput>
                
                <cfscript>
					// Increase Current Row
					vCurrentRow ++;
					
					vDivisionSummaryPlacement = vDivisionSummaryPlaced + vDivisionSummaryPending;
					
					if ( VAL(vDivisionSummaryAllocation) ) {
						vDivisionSummaryPercentage = ( vDivisionSummaryPlacement / vDivisionSummaryAllocation ) * 100;
					}		
					
					vSummaryPlacement = vSummaryPlaced + vSummaryPending;
					
					if ( VAL(vSummaryAllocation) ) {
						vSummaryPercentage = ( vSummaryPlacement / vSummaryAllocation ) * 100;
					}				
				</cfscript>
                
                <tr>
                    <th class="left" colspan="2">Total</td>
                    <th>#vDivisionSummaryAssigned#</th>
                    <th>#vDivisionSummaryPlaced#</th>
                    <th>#vDivisionSummaryPending#</th>
                    <th>#vDivisionSummaryUnplaced#</th>
                    <th>#vDivisionSummaryPlacement#</th>
                    <th>#vDivisionSummaryAllocation#</th>
                    <th>#NumberFormat(vDivisionSummaryPercentage, '___.__')#%</th>
                </tr>
            </table>
            
		</cfoutput>
        
        <!--- ISE - Display Total Divisions --->
		<cfif CLIENT.companyID EQ 5>

			<cfoutput>
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th class="left" colspan="9">Total Divisions</th>
                    </tr>      
                    <tr>
                        <td class="subTitleLeft" width="15%">Region</td>	
                        <td class="subTitleLeft" width="15%">Regional Manager</td>
                        <td class="subTitleCenter" width="10%">Total Assigned</td>
                        <td class="subTitleCenter" width="10%">Placed</td>
                        <td class="subTitleCenter" width="10%">Pending</td>
                        <td class="subTitleCenter" width="10%">Unplaced</td>
                        <td class="subTitleCenter" width="10%">Total Placements</td>
                        <td class="subTitleCenter" width="10%">Goal</td>
                        <td class="subTitleCenter" width="10%">Percentage</td>
                    </tr>
                    <tr>
                        <th class="left" colspan="2">&nbsp;</td>
                        <th class="subTitleCenter">#vSummaryAssigned#</th>
                        <th class="subTitleCenter">#vSummaryPlaced#</th>
                        <th class="subTitleCenter">#vSummaryPending#</th>
                        <th class="subTitleCenter">#vSummaryUnplaced#</th>
                        <th class="subTitleCenter">#vSummaryPlacement#</th>
                        <th class="subTitleCenter">#vSummaryAllocation#</th>
                        <th class="subTitleCenter">#NumberFormat(vSummaryPercentage, '___.__')#%</th>
                    </tr>
                </table>
			</cfoutput>
            
        </cfif>
                                    
    </cfif>

    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    