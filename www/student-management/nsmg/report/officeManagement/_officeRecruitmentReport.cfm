<!--- ------------------------------------------------------------------------- ----
	
	File:		_officeRecruitmentReport.cfm
	Author:		James Griffiths
	Date:		September 21, 2012
	Desc:		Rectruitment totals
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=officeRecruitmentReport		
				
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
		param name="FORM.outputType" default="flashPaper";

		// Set Report Title To Keep Consistency
		vReportTitle = "Representative Management - Recruitment Report";
		
		vExcelTotalRowColor = "##d8d8d8";
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
            
            <cfscript>
				// Get Season Info
				qGetSeasonInfo = APPLICATION.CFC.LOOKUPTABLES.getSeason(seasonID=FORM.seasonID);
			</cfscript>
                    
            <cfquery name="qGetCompanies" datasource="#APPLICATION.DSN#">
            	SELECT
                	c.companyName,
                    c.companyShort,
                    c.companyID
              	FROM
                	smg_companies c
               	WHERE
                	c.companyID IN ( SELECT company FROM smg_regions WHERE regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> ) )
            </cfquery>

			<cfquery name="qGetTotal" datasource="#APPLICATION.DSN#">
       			SELECT
                	u.userID,
                    uar.regionID
                FROM
                    smg_users u
              	INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
              	WHERE
               		uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
               	AND	
                	uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.regionID#"> )
              	AND
                	(
                    	<!--- Users that have started filling out paperwork --->
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#"> = ( SELECT MIN(seasonID) FROM smg_users_paperwork WHERE userID = u.userID  )
                    OR
                    	<!--- Users Created during the season period --->
                        u.dateCreated 
                        	BETWEEN 
                            	<cfqueryparam cfsqltype="cf_sql_date" value="#qGetSeasonInfo.datePaperworkStarted#"> 
                            AND 
                            	<cfqueryparam cfsqltype="cf_sql_date" value="#qGetSeasonInfo.datePaperworkEnded#"> 
                    )
                GROUP BY
                	u.userID
            </cfquery>
            
            <cfquery name="qGetTotalEnabled" datasource="#APPLICATION.DSN#">
       			SELECT
                	u.userID,
                    uar.regionID
                FROM
                    smg_users u
              	INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
              	INNER JOIN
                	smg_users_paperwork p ON p.userID = u.userID
                     	AND
                        	p.ar_agreement IS NOT NULL
                     	AND
                			<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#"> = ( SELECT MIN(seasonID) FROM smg_users_paperwork WHERE userID = u.userID )
              	WHERE
               		uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
              	AND	
                	uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.regionID#"> )
              	GROUP BY
                	u.userID
            </cfquery>
            
            <cfquery name="qGetTotalWithPlacement" datasource="#APPLICATION.DSN#">
       			SELECT
                	u.userID,
                    uar.regionID
                    count(s.studentID) AS studentsplaced
                FROM
                    smg_users u
              	INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
               	INNER JOIN
                	smg_students s ON s.placeRepID = u.userID
                    	AND
                        	s.programID IN ( SELECT programID FROM smg_programs WHERE seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#"> )
              	WHERE
               		uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
              	AND
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#"> = ( SELECT MIN(seasonID) FROM smg_users_paperwork WHERE userID = u.userID )
             	AND	
                	uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.regionID#"> )
              	GROUP BY
                	u.userID
            </cfquery>
            
            
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

	<cfoutput>

        <form action="report/index.cfm?action=officeRecruitmentReport" name="officeRegionGoal" id="officeRegionGoal" method="post" target="blank">
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
                        	<option value="flashPaper">FlashPaper</option>
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
                        This report will provide a total of all new area reps per region.
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
        <cfheader name="Content-Disposition" value="attachment; filename=RecruitmentReport.xls">

        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr><th colspan="8"><cfoutput>#vReportTitle#</cfoutput></th></tr>
            <tr style="font-weight:bold;">
            	<td>Company</td>
                <td>Region</td>
                <td>Region Manager</td>
                <td>Number of New Reps Added</td>
                <td>Number Contracted</td>
                <td>Percent Contracted</td>
                <td>Number with a placement</td>
                <td>Percent with a placement</td>
                <td>Number of placements</td>
            </tr>
            
            <cfscript>
				vRowCount = 0;
			</cfscript>
            
            <cfloop query="qGetCompanies">
                
                <cfquery name="qGetRegions" datasource="#APPLICATION.DSN#">
                    SELECT
                        r.company,
                        r.regionName,
                        r.regionID,
                        u.userID,
                        u.firstName,
                        u.lastName
                    FROM
                        smg_regions r
                    LEFT JOIN
                        user_access_rights uar ON uar.regionID = r.regionID
                        AND
                            uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                    LEFT JOIN
                        smg_users u ON u.userID = uar.userID
                        AND
                            u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                    WHERE
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                    AND
                        r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCompanies.companyID#">
                </cfquery>
                
                <cfquery name="qGetTotalInCompany" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetTotal
                    WHERE
                        regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetRegions.regionID)#" list="yes"> )
                </cfquery>
                
                <cfquery name="qGetTotalInCompanyEnabled" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetTotalEnabled
                    WHERE
                        regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetRegions.regionID)#" list="yes"> )
                </cfquery>
                
                <cfquery name="qGetTotalInCompanyWithPlacement" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetTotalWithPlacement
                    WHERE
                        regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetRegions.regionID)#" list="yes"> )
                </cfquery>
                
                <cfloop query="qGetRegions">
                        
                    <cfquery name="qGetTotalInRegion" dbtype="query">
                        SELECT
                            *
                        FROM
                            qGetTotal
                        WHERE
                            regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetRegions.regionID)#">
                    </cfquery>
                    
                    <cfquery name="qGetTotalInRegionEnabled" dbtype="query">
                        SELECT
                            *
                        FROM
                            qGetTotalEnabled
                        WHERE
                            regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetRegions.regionID)#">
                    </cfquery>
                    
                    <cfquery name="qGetTotalInRegionWithPlacement" dbtype="query">
                        SELECT
                            *
                        FROM
                            qGetTotalWithPlacement
                        WHERE
                            regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetRegions.regionID)#">
                    </cfquery>
                    
                    <cfscript>
                        percentEnabled = 0.00;
                        if ( (qGetTotalInRegionEnabled.recordCount NEQ 0) AND (qGetTotalInRegion.recordCount NEQ 0) ) {
                            percentEnabled = (qGetTotalInRegionEnabled.recordCount/qGetTotalInRegion.recordCount) * 100;
                        }
                        
                        percentWithPlacement = 0.00;
                        if ( (qGetTotalInRegionWithPlacement.recordCount NEQ 0) AND (qGetTotalInRegion.recordCount NEQ 0) ) {
                            percentWithPlacement = (qGetTotalInRegionWithPlacement.recordCount/qGetTotalInRegion.recordCount) * 100;
                        }
						
						if ( vRowCount MOD 2 ) {
							vRowColor = "##F2F2F2";
						} else {
							vRowColor = "##FFFFFF";
						}
						
						vRowCount ++;
                    </cfscript>
                    
                    <cfoutput>      
                        <tr>
                        	<td bgcolor="#vRowColor#">#qGetCompanies.companyShort#</td>
                            <td bgcolor="#vRowColor#">#regionName#</td>
                            <td bgcolor="#vRowColor#"><cfif VAL(userID)>#firstName# #lastName# (###userID#)<cfelse><i>Not Assigned</i></cfif></td>
                            <td bgcolor="#vRowColor#">#qGetTotalInRegion.recordCount#</td>
                            <td bgcolor="#vRowColor#">#qGetTotalInRegionEnabled.recordCount#</td>
                            <td bgcolor="#vRowColor#">#NumberFormat(percentEnabled,'99.99')#%</td>
                            <td bgcolor="#vRowColor#">#qGetTotalInRegionWithPlacement.recordCount#</td>
                            <td bgcolor="#vRowColor#">#NumberFormat(percentWithPlacement,'99.99')#%</td>
                            <td bgcolor="#vRowColor#"><b>#qGetTotalInRegionWithPlacement.studentsplaced#</b></td>
                        </tr>
                    </cfoutput>
                    
             	</cfloop>
                
                 <cfscript>
					percentEnabled = 0.00;
					if ( (qGetTotalInCompanyEnabled.recordCount NEQ 0) AND (qGetTotalInCompany.recordCount NEQ 0) ) {
						percentEnabled = (qGetTotalInCompanyEnabled.recordCount/qGetTotalInCompany.recordCount) * 100;
					}
					
					percentWithPlacement = 0.00;
					if ( (qGetTotalInCompanyWithPlacement.recordCount NEQ 0) AND (qGetTotalInCompany.recordCount NEQ 0) ) {
						percentWithPlacement = (qGetTotalInCompanyWithPlacement.recordCount/qGetTotalInCompany.recordCount) * 100;
					}
					
					if ( vRowCount MOD 2 ) {
						vRowColor = "##F2F2F2";
					} else {
						vRowColor = "##FFFFFF";
					}
					
					vRowCount ++;
				</cfscript>
                
                <cfoutput>
                    <tr>
                        <td bgcolor="#vRowColor#"><b>Company Total</b></td>
                        <td bgcolor="#vRowColor#"></td>
                    	<td bgcolor="#vRowColor#"></td>
                        <td bgcolor="#vRowColor#"><b>#qGetTotalInCompany.recordCount#</b></td>
                        <td bgcolor="#vRowColor#"><b>#qGetTotalInCompanyEnabled.recordCount#</b></td>
                        <td bgcolor="#vRowColor#"><b>#NumberFormat(percentEnabled,'99.99')#%</b></td>
                        <td bgcolor="#vRowColor#"><b>#qGetTotalInCompanyWithPlacement.recordCount#</b></td>
                        <td bgcolor="#vRowColor#"><b>#NumberFormat(percentWithPlacement,'99.99')#%</b></td>
                        <td bgcolor="#vRowColor#"><b>#qGetTotalInCompanyWithPlacement.studentsplaced#</b></td>
                    </tr>
                </cfoutput>
                
         	</cfloop>
            
            <cfscript>
				percentEnabled = 0.00;
				if ( (qGetTotalEnabled.recordCount NEQ 0) AND (qGetTotal.recordCount NEQ 0) ) {
					percentEnabled = (qGetTotalEnabled.recordCount/qGetTotal.recordCount) * 100;
				}
				
				percentWithPlacement = 0.00;
				if ( (qGetTotalWithPlacement.recordCount NEQ 0) AND (qGetTotal.recordCount NEQ 0) ) {
					percentWithPlacement = (qGetTotalWithPlacement.recordCount/qGetTotal.recordCount) * 100;
				}
				
				if ( vRowCount MOD 2 ) {
					vRowColor = "##F2F2F2";
				} else {
					vRowColor = "##FFFFFF";
				}
				
				vRowCount ++;
			</cfscript>
			
			<cfoutput>
				<tr>
					<td bgcolor="#vRowColor#"><b>Total</b></td>
                    <td bgcolor="#vRowColor#"></td>
                    <td bgcolor="#vRowColor#"></td>
					<td bgcolor="#vRowColor#"><b>#qGetTotal.recordCount#</b></td>
					<td bgcolor="#vRowColor#"><b>#qGetTotalEnabled.recordCount#</b></td>
					<td bgcolor="#vRowColor#"><b>#NumberFormat(percentEnabled,'99.99')#%</b></td>
					<td bgcolor="#vRowColor#"><b>#qGetTotalWithPlacement.recordCount#</b></td>
					<td bgcolor="#vRowColor#"><b>#NumberFormat(percentWithPlacement,'99.99')#%</b></td>
                    <td bgcolor="#vRowColor#"><b>#qGetTotalWithPlacement.studentsplaced#</b></td>
				</tr>
			</cfoutput>
            
     	</table>
    
    <!--- On Screen Report --->
    <cfelse>
    
    	<cfsavecontent variable="report">
        
			<cfoutput>
            
				<!--- Include Report Header --->   
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th>#vReportTitle#</th>            
                    </tr>
                </table>
                
                <cfloop query="qGetCompanies">
                
                	<cfquery name="qGetRegions" datasource="#APPLICATION.DSN#">
                        SELECT
                            r.company,
                            r.regionName,
                            r.regionID,
                            u.userID,
                            u.firstName,
                            u.lastName
                        FROM
                            smg_regions r
                      	LEFT JOIN
                        	user_access_rights uar ON uar.regionID = r.regionID
                            AND
                    			uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                      	LEFT JOIN
                        	smg_users u ON u.userID = uar.userID
                            AND
                    			u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                        WHERE
                            r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                      	AND
                        	r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCompanies.companyID#">
                    </cfquery>
                    
                    <cfquery name="qGetTotalInCompany" dbtype="query">
                    	SELECT
                            *
                        FROM
                            qGetTotal
                        WHERE
                            regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetRegions.regionID)#" list="yes"> )
                    </cfquery>
                    
                    <cfquery name="qGetTotalInCompanyEnabled" dbtype="query">
                        SELECT
                            *
                        FROM
                            qGetTotalEnabled
                        WHERE
                            regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetRegions.regionID)#" list="yes"> )
                    </cfquery>
                    
                    <cfquery name="qGetTotalInCompanyWithPlacement" dbtype="query">
                        SELECT
                            *
                        FROM
                            qGetTotalWithPlacement
                        WHERE
                            regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetRegions.regionID)#" list="yes"> )
                    </cfquery>
                
                	<table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                        
                        <tr>
                            <th class="left" colspan="9">#companyShort#</th>
                        </tr>
                        
                         <tr>
                            <td class="subTitleLeft" width="10%" style="font-size:10px;">Region</td>
                            <td class="subTitleLeft" width="10%" style="font-size:10px;">Region Manager</td>
                            <td class="subTitleCenter" width="15%" style="font-size:10px">Number of New Reps Added</td>	
                            <td class="subTitleCenter" width="15%" style="font-size:10px">Number Contracted</td>
                            <td class="subTitleCenter" width="20%" style="font-size:10px">Percent Contracted</td>
                            <td class="subTitleCenter" width="20%" style="font-size:10px">Number with a placement</td>
                            <td class="subTitleCenter" width="20%" style="font-size:10px">Percent with a placement</td>
                            <td class="subTitleCenter" width="20%" style="font-size:10px">Number of placements
                        </tr>
                        
                        <cfloop query="qGetRegions">
                        
                        	<cfquery name="qGetTotalInRegion" dbtype="query">
                                SELECT
                                    *
                                FROM
                                    qGetTotal
                                WHERE
                                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetRegions.regionID)#">
                            </cfquery>
                            
                            <cfquery name="qGetTotalInRegionEnabled" dbtype="query">
                                SELECT
                                    *
                                FROM
                                    qGetTotalEnabled
                                WHERE
                                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetRegions.regionID)#">
                            </cfquery>
                            
                            <cfquery name="qGetTotalInRegionWithPlacement" dbtype="query">
                                SELECT
                                    *
                                FROM
                                    qGetTotalWithPlacement
                                WHERE
                                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetRegions.regionID)#">
                            </cfquery>
                            
                            <cfscript>
                                percentEnabled = 0.00;
                                if ( (qGetTotalInRegionEnabled.recordCount NEQ 0) AND (qGetTotalInRegion.recordCount NEQ 0) ) {
                                    percentEnabled = (qGetTotalInRegionEnabled.recordCount/qGetTotalInRegion.recordCount) * 100;
                                }
                                
                                percentWithPlacement = 0.00;
                                if ( (qGetTotalInRegionWithPlacement.recordCount NEQ 0) AND (qGetTotalInRegion.recordCount NEQ 0) ) {
                                    percentWithPlacement = (qGetTotalInRegionWithPlacement.recordCount/qGetTotalInRegion.recordCount) * 100;
                                }
                            </cfscript>
                            
                            <tr>
                                <td style="font-size:10px" align="left"><b>#regionName#</b></td>
                                <td style="font-size:10px" align="left"><cfif VAL(userID)><b>#firstName# #lastName# (###userID#)</b><cfelse><span style="background-color:##FFFF66">Not Assigned</span></cfif></td>
                                <td style="font-size:10px" align="center"><b>#qGetTotalInRegion.recordCount#</b></td>
                                <td style="font-size:10px" align="center"><b>#qGetTotalInRegionEnabled.recordCount#</b></td>
                                <td style="font-size:10px" align="center"><b>#NumberFormat(percentEnabled,'99.99')#%</b></td>
                                <td style="font-size:10px" align="center"><b>#qGetTotalInRegionWithPlacement.recordCount#</b></td>
                                <td style="font-size:10px" align="center"><b>#NumberFormat(percentWithPlacement,'99.99')#%</b></td>
                                <td style="font-size:10px" align="center"><b>#qGetTotalinRegionWithPlacement.studentsplaced#%</b></td>
                            </tr>
                        
                        </cfloop>
                        
                        <cfscript>
							percentEnabled = 0.00;
							if ( (qGetTotalInCompanyEnabled.recordCount NEQ 0) AND (qGetTotalInCompany.recordCount NEQ 0) ) {
								percentEnabled = (qGetTotalInCompanyEnabled.recordCount/qGetTotalInCompany.recordCount) * 100;
							}
							
							percentWithPlacement = 0.00;
							if ( (qGetTotalInCompanyWithPlacement.recordCount NEQ 0) AND (qGetTotalInCompany.recordCount NEQ 0) ) {
								percentWithPlacement = (qGetTotalInCompanyWithPlacement.recordCount/qGetTotalInCompany.recordCount) * 100;
							}
						</cfscript>
                        
                        <tr>
                        	<td style="font-size:10px" align="center" colspan="2"><b>Company Total</b></td>
                            <td style="font-size:10px" align="center"><b>#qGetTotalInCompany.recordCount#</b></td>
                            <td style="font-size:10px" align="center"><b>#qGetTotalInCompanyEnabled.recordCount#</b></td>
                            <td style="font-size:10px" align="center"><b>#NumberFormat(percentEnabled,'99.99')#%</b></td>
                            <td style="font-size:10px" align="center"><b>#qGetTotalInCompanyWithPlacement.recordCount#</b></td>
                            <td style="font-size:10px" align="center"><b>#NumberFormat(percentWithPlacement,'99.99')#%</b></td>
                            <td style="font-size:10px" align="center"><b>#qGetTotalinCompanyWithPlacement.studentsplaced#%</b></td>
                        </tr>
                        
                  	</table>
                
                </cfloop>
                
				<cfscript>
                    percentEnabled = 0.00;
                    if ( (qGetTotalEnabled.recordCount NEQ 0) AND (qGetTotal.recordCount NEQ 0) ) {
                        percentEnabled = (qGetTotalEnabled.recordCount/qGetTotal.recordCount) * 100;
                    }
                    
                    percentWithPlacement = 0.00;
                    if ( (qGetTotalWithPlacement.recordCount NEQ 0) AND (qGetTotal.recordCount NEQ 0) ) {
                        percentWithPlacement = (qGetTotalWithPlacement.recordCount/qGetTotal.recordCount) * 100;
                    }
                </cfscript>
                
                 <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th class="left" colspan="9">Total</th>
                    </tr>      
                    <tr>
                        <td class="subTitleCenter" width="20%" style="font-size:10px">Number of New Reps Added</td>	
                        <td class="subTitleCenter" width="20%" style="font-size:10px">Number Contracted</td>
                        <td class="subTitleCenter" width="20%" style="font-size:10px">Percent Contracted</td>
                        <td class="subTitleCenter" width="20%" style="font-size:10px">Number with a placement</td>
                        <td class="subTitleCenter" width="20%" style="font-size:10px">Percent with a placement</td>
                        <td class="subTitleCenter" width="20%" style="font-size:10px">Number of placements</td>
                    </tr>
                    <tr>
                        <td style="font-size:10px" align="center"><b>#qGetTotal.recordCount#</b></td>
                        <td style="font-size:10px" align="center"><b>#qGetTotalEnabled.recordCount#</b></td>
                        <td style="font-size:10px" align="center"><b>#NumberFormat(percentEnabled,'99.99')#%</b></td>
                        <td style="font-size:10px" align="center"><b>#qGetTotalWithPlacement.recordCount#</b></td>
                        <td style="font-size:10px" align="center"><b>#NumberFormat(percentWithPlacement,'99.99')#%</b></td>
                        <td style="font-size:10px" align="center"><b>#qGetTotalWithPlacement.studentsplaced#%</b></td>
                    </tr>
                </table>
                
                <br />
                    
  			</cfoutput>
            
      	</cfsavecontent>
        
        <cfif FORM.outputType EQ "flashPaper">
    
   			<cfdocument format="flashpaper" orientation="landscape" backgroundvisible="yes" overwrite="yes" fontembed="yes" margintop="0.3" marginright="0.2" marginbottom="0.3" marginleft="0.2">
    
				<!--- Page Header --->
                <gui:pageHeader
                    headerType="applicationNoHeader"
                    filePath="../"
                />
                
                <cfoutput>#report#</cfoutput>
                
          	</cfdocument>
            
       	<cfelse>
        
        	<cfoutput>#report#</cfoutput>
            
        </cfif>
                                    
    </cfif>

    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    