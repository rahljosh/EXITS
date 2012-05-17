<!--- ------------------------------------------------------------------------- ----
	
	File:		_regionalAllocation.cfm
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
	</cfscript>
    
    <cfquery name="qGetSeasons" datasource="#APPLICATION.DSN#">
        SELECT
            seasonID,
            season
        FROM
            smg_seasons
        WHERE
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>

    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
		
        <cfscript>
			// Data Validation
		</cfscript>
    	
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>

			 <cfquery name="qGetResults" datasource="MySql">
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
                    a.seasonID
                FROM
                    smg_users u
                INNER JOIN
                    user_access_rights uar ON uar.userID = u.userID
                INNER JOIN
                    smg_regions r ON r.regionID = uar.regionID
                LEFT JOIN
                    smg_users_allocation a ON a.userID = u.userID
                    AND
                        a.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
                WHERE
                    uar.userType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                AND
                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND
                    r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
               	AND
                	r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.regionID#"> )
               	<cfif FORM.regionID NEQ 5>
                    AND
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.regionID#"> )
           		</cfif>
                GROUP BY
                    r.regionName
                ORDER BY
                    r.regionName
            </cfquery>
            
		</cfif>

	</cfif>
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

	<cfoutput>

        <form action="report/index.cfm?action=regionalAllocation" name="regionalAllocation" id="regionalAllocation" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="8" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">Office Management - Regional Allocation</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Season: <span class="required">*</span></td>
                    <td>
                        <select name="seasonID" id="seasonID" class="xLargeField" required>
                            <cfloop query="qGetSeasons"><option value="#qGetSeasons.seasonID#">#qGetSeasons.season#</option></cfloop>
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
        <cfheader name="Content-Disposition" value="attachment; filename=regionalAllocation.xls"> 
        
        <cfoutput>
        	<table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
                <tr><th colspan="8">Office Management - Regional Allocation</th></tr>
                <tr style="font-weight:bold;">
                    <td>Company</td>
                    <td>Regional Manager</td>
                    <td>Region</td>
                    <td>Placed</td>
                    <td>Pending</td>
                    <td>Total</td>
                    <td>Goal</td>
                    <td>Percentage</td>
                </tr>
      	</cfoutput>
                
		<cfscript>
            vCurrentRow = 0;
        </cfscript>
        
        <cfquery name="qGetCompanies" datasource="#APPLICATION.DSN#">
            SELECT
                companyID,
                companyShort
            FROM
                smg_companies
            ORDER BY
                companyShort
        </cfquery>
                
		<cfoutput query="qGetCompanies">
        
        	<cfquery name="qGetRegionsInCompany" dbtype="query">
                SELECT
                    *
                FROM
                    qGetResults
                <cfif qGetCompanies.companyID NEQ 5>
                    WHERE
                        qGetResults.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCompanies.companyID#">
                </cfif>
            </cfquery>
            
            <cfloop query="qGetRegionsInCompany">
            
            	<cfquery name="qGetPending" datasource="#APPLICATION.DSN#">
                    SELECT
                        s.studentID
                    FROM
                        smg_students s
                    WHERE
                        s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND 
                        s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="5,6,7"> )
                    AND
                        s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegionsInCompany.regionID#">
                    AND
                        s.hostID > <cfqueryparam cfsqltype="cf_sql_integer" value="0">	
                </cfquery>
                
                <cfquery name="qGetPlaced" datasource="#APPLICATION.DSN#">
                    SELECT
                        s.studentID
                    FROM
                        smg_students s
                    WHERE
                        s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND 
                        s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="1,2,3,4"> )
                    AND
                        s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegionsInCompany.regionID#">
                    AND
                        s.hostID > <cfqueryparam cfsqltype="cf_sql_integer" value="0">	
                </cfquery>
                
                <cfscript>
					vCurrentRow++;
	
					vRowColor = '';	
					if ( vCurrentRow MOD 2 ) {
						vRowColor = 'bgcolor="##E6E6E6"';
					} else {
						vRowColor = 'bgcolor="##FFFFFF"';
					}
					
					innerTotal = 0;
					innerPercentage = 0;
				</cfscript>
                
                <tr>
                    <td #vRowColor#>#qGetCompanies.companyShort#</td>
                    <td #vRowColor#>#qGetRegionsInCompany.firstName# #qGetRegionsInCompany.lastName# ###qGetRegionsInCompany.userID#</td>
                    <td #vRowColor#>#qGetRegionsInCompany.regionName#</td>
                    <td #vRowColor#>#qGetRegionsInCompany.recordCount#</td>
                    <td #vRowColor#>#qGetRegionsInCompany.recordCount#</td>
                    <td #vRowColor#><cfset innerTotal=qGetPlaced.recordCount+qGetPending.recordCount>#innerTotal#</td>
                    <td #vRowColor#>#qGetRegionsInCompany.allocation#</td>
                    <td #vRowColor#>
                        <cfif VAL(qGetRegionsInCompany.allocation)>
                            <cfset innerPercentage=(innerTotal/qGetRegionsInCompany.allocation)*100>
                        </cfif>
                        #NumberFormat(innerPercentage, '___.__')#%
                    </td>
                </tr> 
                
            </cfloop>
            
        </cfoutput>
        
        <cfoutput>
        	</table>
        </cfoutput>
    
    <!--- On Screen Report --->
    <cfelse>
    
        <cfoutput>
            
            <!--- Include Report Header --->   
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th>Office Management - Regional Allocation</th>            
                </tr>
            </table>
            
            <!--- No Records Found --->
            <cfif NOT VAL(qGetResults.recordCount)>
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr class="on">
                        <td class="subTitleCenter">No records found</td>
                    </tr>      
                </table>
                <cfabort>
            </cfif>
        </cfoutput>
        
        <cfquery name="qGetCompanies" datasource="#APPLICATION.DSN#">
        	SELECT
            	companyID,
                companyShort
          	FROM
            	smg_companies
           	ORDER BY
            	companyShort
        </cfquery>
        
        <cfoutput query="qGetCompanies">
        	
            <cfquery name="qGetRegionsUnderCompany" dbtype="query">
            	SELECT
                	*
               	FROM
                	qGetResults
               	<cfif qGetCompanies.companyID NEQ 5>
                	WHERE
                    	qGetResults.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCompanies.companyID#">
                </cfif>
            </cfquery>
            
            <cfif qGetRegionsUnderCompany.recordCount>
            
				<cfscript>
                    vCurrentRow = 0;
					totalPlaced = 0;
					totalPending = 0;
					totalGoal = 0;
					total = 0;
					totalPercentage = 0;
                </cfscript>
                
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th class="left" colspan="7">
                            #qGetCompanies.companyShort#
                        </th>
                    </tr>      
                    <tr>
                        <td class="subTitleLeft" width="25%">Regional Manager</td>
                        <td class="subTitleLeft" width="25%">Region</td>	
                        <td class="subTitleLeft" width="10%">Placed</td>
                        <td class="subTitleLeft" width="10%">Pending</td>
                        <td class="subTitleLeft" width="10%">Total</td>
                        <td class="subTitleLeft" width="10%">Goal</td>
                        <td class="subTitleLeft" width="10%">Percentage</td>
                    </tr>
                    
                    <cfloop query="qGetRegionsUnderCompany">
                        
                        <cfquery name="qGetPending" datasource="#APPLICATION.DSN#">
                        	SELECT
                            	s.studentID
                          	FROM
                            	smg_students s
                           	WHERE
                            	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                           	AND 
                          		s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="5,6,7"> )
                           	AND
                            	s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegionsUnderCompany.regionID#">
                          	AND
                            	s.hostID > <cfqueryparam cfsqltype="cf_sql_integer" value="0">	
                        </cfquery>
                        
                        <cfquery name="qGetPlaced" datasource="#APPLICATION.DSN#">
                        	SELECT
                            	s.studentID
                          	FROM
                            	smg_students s
                           	WHERE
                            	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                           	AND 
                          		s.host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="1,2,3,4"> )
                          	AND
                            	s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegionsUnderCompany.regionID#">
                           	AND
                            	s.hostID > <cfqueryparam cfsqltype="cf_sql_integer" value="0">	
                        </cfquery>
                        
                        <cfscript>
                            vCurrentRow ++;
							
							totalPlaced += #qGetPlaced.recordCount#;
							totalPending += #qGetPending.recordCount#;
							
							innerTotal = 0;
							innerPercentage = 0;
							
							if (#qGetRegionsUnderCompany.allocation# != '')
								totalGoal += #qGetRegionsUnderCompany.allocation#;
                        </cfscript>
                            
                        <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                            <td>#qGetRegionsUnderCompany.firstName# #qGetRegionsUnderCompany.lastName# ###qGetRegionsUnderCompany.userID#</td>
                            <td>#qGetRegionsUnderCompany.regionName#</td>
                            <td>#qGetPlaced.recordCount#</td>
                            <td>#qGetPending.recordCount#</td>
                            <td><cfset innerTotal=qGetPlaced.recordCount+qGetPending.recordCount>#innerTotal#</td>
                            <td>#qGetRegionsUnderCompany.allocation#</td>
                            <td>
								<cfif VAL(qGetRegionsUnderCompany.allocation)>
									<cfset innerPercentage=(innerTotal/qGetRegionsUnderCompany.allocation)*100>
								</cfif>
                                #NumberFormat(innerPercentage, '___.__')#%
                         	</td>
                        </tr>
                        
                    </cfloop>
                    
                    <tr>
                        <td class="subTitleLeft" colspan="2">Total</td>
                        <td class="subTitleLeft">#totalPlaced#</td>
                        <td class="subTitleLeft">#totalPending#</td>
                        <td class="subTitleLeft"><cfset total=totalPlaced+totalPending>#total#</td>
                        <td class="subTitleLeft">#totalGoal#</td>
                        <td class="subTitleLeft">
                        	<cfif totalGoal GT 0>
								<cfset totalPercentage=(total/totalGoal)*100>
                          	</cfif>
                            #NumberFormat(totalPercentage, '___.__')#%
                        </td>
                 	</tr>
                    
                </table>
                
          	</cfif>
            
        </cfoutput>
        
    </cfif>

    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    