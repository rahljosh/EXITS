<!--- ------------------------------------------------------------------------- ----
	
	File:		_regionAllocation.cfm
	Author:		James Griffiths
	Date:		May 17, 2012
	Desc:		Allocation Per Region
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=regionalAllocation
				
	Updated: 				
				
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
		param name="FORM.augJan" default=0;
		param name="FORM.outputType" default="";
		
        // Summary
        vSummaryPlaced = 0;
        vSummaryPending = 0;
        vSummaryPlacement = 0;
        vSummaryGoal = 0;
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
                    u.userID,
                    u.firstName,
                    u.lastName,
                    r.regionID,
                    r.regionName,
                    r.company,
                    <cfif FORM.augJan EQ 1>
                    	a.augustAllocation AS allocation,
                   	<cfelse>
                    	a.januaryAllocation AS allocation,
                  	</cfif>
                    a.ID,
                    a.seasonID,
                    c.companyName,
                    c.companyShort
                FROM
                    smg_users u
                INNER JOIN
                    user_access_rights uar ON uar.userID = u.userID
                INNER JOIN
                    smg_regions r ON r.regionID = uar.regionID
                    AND
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.regionID#"> )
                INNER JOIN
                	smg_companies c ON c.companyID = r.company
                LEFT JOIN
                    smg_users_allocation a ON a.userID = u.userID
                    AND
                        a.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
                WHERE
                    uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                AND
                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                ORDER BY
                    c.companyShort,
                    r.regionName
            </cfquery>
            
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

	<cfoutput>

        <form action="report/index.cfm?action=regionAllocation" name="regionAllocation" id="regionAllocation" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="8" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">Office Management - Region Allocation</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Season: <span class="required">*</span></td>
                    <td>
                        <select name="seasonID" id="seasonID" class="xLargeField" required>
                            <cfloop query="qGetSeasonList"><option value="#qGetSeasonList.seasonID#">#qGetSeasonList.season#</option></cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                	<td class="subTitleRightNoBorder">August/January: <span class="required">*</span></td>
                    <td>
                    	<select name="augJan" id="augJan" class="xLargeField" required>
                        	<option value="1">August Allocation</option>
                            <option value="2">January Allocation</option>
                    	</select>
                    </td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                    <td>
                        <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
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
                        This report will provide a list of each region's allocation for a chosen season and August/January allocation.
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
        <cfheader name="Content-Disposition" value="attachment; filename=regionAllocation.xls">
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr><th colspan="8">Office Management - Region Allocation</th></tr>
            <tr style="font-weight:bold;">
                <td>Company</td>
                <td>Region</td>
                <td>Regional Manager</td>
                <td>Placed</td>
                <td>Pending</td>
                <td>Total Placements</td>
                <td>Goal</td>
                <td>Percentage</td>
            </tr>
        
            <cfoutput query="qGetResults">

                <cfquery name="qGetPlacedStudents" datasource="#APPLICATION.DSN#">
                    SELECT
                        s.studentID,
                        s.host_fam_approved
                    FROM
                        smg_students s
                    WHERE
                        s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND
                        s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.regionID#">
                    AND
                        s.hostID > <cfqueryparam cfsqltype="cf_sql_integer" value="0">	
                </cfquery>

                <cfquery name="qGetPlaced" dbtype="query">
                    SELECT
                        studentID
                    FROM
                        qGetPlacedStudents
                    WHERE
                        host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="1,2,3,4"> )
                </cfquery>
                
                <cfquery name="qGetPending" dbtype="query">
                    SELECT
                        studentID
                    FROM
                        qGetPlacedStudents 
                    WHERE
                        host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="5,6,7"> )
                </cfquery>
                
                <cfscript>
					vPlacement = 0;
					vPercentage = 0;

					vPlacement = qGetPlaced.recordCount + qGetPending.recordCount;
					
					if ( VAL(qGetResults.allocation) ) {
						vPercentage = ( vPlacement / qGetResults.allocation ) * 100;
					}
					
					// Calculate Summary Total
					vSummaryPlaced += qGetPlaced.recordCount;
					vSummaryPending += qGetPending.recordCount;
					vSummaryGoal += VAL(qGetResults.allocation);
				
					// Set Row Color
					if ( qGetResults.currentRow MOD 2 ) {
						vRowColor = 'bgcolor="##E6E6E6"';
					} else {
						vRowColor = 'bgcolor="##FFFFFF"';
					}
				</cfscript>
                
                <tr>
                    <td #vRowColor#>#qGetResults.companyShort#</td>
                    <td #vRowColor#>#qGetResults.regionName#</td>
                    <td #vRowColor#>#qGetResults.firstName# #qGetResults.lastName# ###qGetResults.userID#</td>
                    <td #vRowColor#>#qGetPlaced.recordCount#</td>
                    <td #vRowColor#>#qGetPending.recordCount#</td>
                    <td #vRowColor#>#vPlacement#</td>
                    <td #vRowColor#>#qGetResults.allocation#</td>
                    <td #vRowColor#>#NumberFormat(vPercentage, '___.__')#%</td>
                </tr> 
                
            </cfoutput>
            
			<cfscript>
				qGetResults.currentRow += 1;
				
				// Set Row Color
				if ( qGetResults.currentRow MOD 2 ) {
					vRowColor = 'bgcolor="##E6E6E6"';
				} else {
					vRowColor = 'bgcolor="##FFFFFF"';
				}
			
                vSummaryPlacement = vSummaryPlaced + vSummaryPending;
                
                if ( VAL(vSummaryGoal) ) {
                    vSummaryPercentage = ( vSummaryPlacement / vSummaryGoal ) * 100;
                }				
            </cfscript>
            
            <cfoutput>
                <tr>
                    <td class="subTitleLeft" colspan="3">Total</td>
                    <td class="subTitleLeft">#vSummaryPlaced#</td>
                    <td class="subTitleLeft">#vSummaryPending#</td>
                    <td class="subTitleLeft">#vSummaryPlacement#</td>
                    <td class="subTitleLeft">#vSummaryGoal#</td>
                    <td class="subTitleLeft">#NumberFormat(vSummaryPercentage, '___.__')#%</td>
                </tr>
            </cfoutput>
		</table>
    
    <!--- On Screen Report --->
    <cfelse>
            
		<!--- Include Report Header --->   
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th>Office Management - Region Allocation</th>            
            </tr>
        </table>
        
		<cfoutput query="qGetResults" group="companyShort">
    
            <cfscript>
                vCurrentRow = 0;
            </cfscript>
            
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th class="left" colspan="7">#qGetResults.companyShort#</th>
                </tr>      
                <tr>
                    <td class="subTitleLeft" width="25%">Region</td>	
                    <td class="subTitleLeft" width="25%">Regional Manager</td>
                    <td class="subTitleLeft" width="10%">Placed</td>
                    <td class="subTitleLeft" width="10%">Pending</td>
                    <td class="subTitleLeft" width="10%">Total Placements</td>
                    <td class="subTitleLeft" width="10%">Goal</td>
                    <td class="subTitleLeft" width="10%">Percentage</td>
                </tr>

                <cfoutput>

                    <cfquery name="qGetPlacedStudents" datasource="#APPLICATION.DSN#">
                        SELECT
                            s.studentID,
                            s.host_fam_approved
                        FROM
                            smg_students s
                        WHERE
                            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        AND
                            s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.regionID#">
                        AND
                            s.hostID > <cfqueryparam cfsqltype="cf_sql_integer" value="0">	
                    </cfquery>
    
                    <cfquery name="qGetPlaced" dbtype="query">
                        SELECT
                            studentID
                        FROM
                            qGetPlacedStudents
                        WHERE
                            host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="1,2,3,4"> )
                    </cfquery>
                    
                    <cfquery name="qGetPending" dbtype="query">
                        SELECT
                            studentID
                        FROM
                            qGetPlacedStudents 
                        WHERE
                            host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="5,6,7"> )
                    </cfquery>
                    
                    <cfscript>
                        vCurrentRow ++;
                        
                        vPlacement = 0;
                        vPercentage = 0;

						vPlacement = qGetPlaced.recordCount + qGetPending.recordCount;
						
						if ( VAL(qGetResults.allocation) ) {
                        	vPercentage = ( vPlacement / qGetResults.allocation ) * 100;
						}
						
						// Calculate Summary Total
                        vSummaryPlaced += qGetPlaced.recordCount;
                        vSummaryPending += qGetPending.recordCount;
                        vSummaryGoal += VAL(qGetResults.allocation);
					</cfscript>
                        
                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                        <td>#qGetResults.regionName#</td>
                        <td>#qGetResults.firstName# #qGetResults.lastName# ###qGetResults.userID#</td>                        
                        <td>#qGetPlaced.recordCount#</td>
                        <td>#qGetPending.recordCount#</td>
                        <td>#vPlacement#</td>
                        <td>#qGetResults.allocation#</td>
                        <td>#NumberFormat(vPercentage, '___.__')#%</td>
                    </tr>
                    
                </cfoutput>
                
                <cfscript>
					vCurrentRow ++;
					
					vSummaryPlacement = vSummaryPlaced + vSummaryPending;
					
					if ( VAL(vSummaryGoal) ) {
						vSummaryPercentage = ( vSummaryPlacement / vSummaryGoal ) * 100;
					}				
				</cfscript>
                
                <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td class="subTitleLeft" colspan="2">Total</td>
                    <td class="subTitleLeft">#vSummaryPlaced#</td>
                    <td class="subTitleLeft">#vSummaryPending#</td>
                    <td class="subTitleLeft">#vSummaryPlacement#</td>
                    <td class="subTitleLeft">#vSummaryGoal#</td>
                    <td class="subTitleLeft">#NumberFormat(vSummaryPercentage, '___.__')#%</td>
                </tr>
            </table>
            
		</cfoutput>
        
    </cfif>

    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    