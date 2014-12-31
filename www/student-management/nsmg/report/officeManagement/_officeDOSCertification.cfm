<!--- ------------------------------------------------------------------------- ----
	
	File:		_officeDOSCertification.cfm
	Author:		James Griffiths	
	Date:		July 3, 2012
	Desc:		Shows users that have/not taken the DOS test
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=officeDOSCertification
				
	Updated: 		
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.regionID" default="";
		param name="FORM.completed" default="all";
		param name="FORM.outputType" default="flashPaper";

		// Set Report Title To Keep Consistency
		vReportTitle = "Office Management - DOS Certification";
	</cfscript>	
    
    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
    
    	<cfscript>
            if ( NOT VAL(FORM.regionID) ) {
                SESSION.formErrors.Add("You must select at least one region");
            }
		</cfscript>

        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>
        
        	<cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
            	SELECT
                	u.userID,
                    u.firstName,
                    u.lastName,
                    u.email,
                    r.regionID,
                    r.regionName,
                    t.date_trained,
                    ut.userType AS userTypeName
               	FROM
                	smg_users u
               	INNER JOIN
                	user_access_rights uar ON uar.userID = u.userID
                    AND
                        uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                    AND
                    	uar.userType IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,6,7" list="yes"> )
               	INNER JOIN
                	smg_regions r ON r.regionID = uar.regionID
              	INNER JOIN
                	smg_usertype ut ON ut.userTypeID = uar.userType
               	LEFT OUTER JOIN
                	smg_users_training t ON t.user_id = u.userID
                        AND
                        	t.training_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                   		AND
                        	t.has_passed = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        AND
							<cfif ListFind("7,8,9,10,11,12", Month(Now()))>
                                t.date_trained > <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Year(Now()),06,30)#">
                            <cfelse>
                            	<!--- Set deadline to 07/01 of previous year --->
                            	t.date_trained > <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Year(Now())-1,6,30)#">
                            </cfif>

						<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                            AND          
                                t.company_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                        <cfelse>
                            AND          
                                t.company_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                        </cfif>
                            
              	WHERE
                <!--- Get Active and Fully Enabled --->
                    u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND
                    accountCreationVerified > <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND
                    u.dateAccountVerified IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">  
              	
				<cfif FORM.completed EQ "completed">
                	AND
                    	t.ID IS NOT NULL
                <cfelseif FORM.completed EQ "notCompleted">
                	AND
                    	t.ID IS NULL
                </cfif>
                
                GROUP BY
                	u.userID
               	ORDER BY
                	uar.userType,
                	u.lastName,
                    u.firstName
            </cfquery>
                    
        </cfif>
    
    </cfif>

</cfsilent>

<!--- FORM Not Submitted --->
<cfif NOT VAL(FORM.submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->
    
    <cfoutput>
    	
        <form action="report/index.cfm?action=officeDOSCertification" name="officeDOSCertification" id="officeDOSCertification" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">#vReportTitle#</th></tr>
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
                    <td class="subTitleRightNoBorder">Option: <span class="required">*</span></td>
                    <td>
                        <select name="completed" id="completed" class="xLargeField" required>
                            <option value="all">All</option>
                            <option value="completed">Complete</option>
                            <option value="notCompleted">Not Complete</option>
                        </select>
                    </td>		
                </tr>                                            
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" id="outputType" class="xLargeField">
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
                        This report will show a list of all active fully enabled users and their DOS Certification test date in the specified region.
                        It will show the date as Missing for any user who has not taken the test since the previous July 1st.
                    </td>		
                </tr>
                <tr>
                    <th colspan="2" align="center"><input type="image" src="pics/view.gif" align="center" border="0"> </th>
                </tr>
            </table>
        </form>
        
    </cfoutput>

<!--- FORM submitted --->
<cfelse>

	<!--- Page Header --->
    <gui:pageHeader headerType="applicationNoHeader"/>	

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

	<!--- Excel Report --->
	<cfif FORM.outputType EQ "excel">
     
        <!--- set content type --->
		<cfcontent type="application/msexcel">
        
        <!--- suggest default name for XLS file --->
        <cfheader name="Content-Disposition" value="attachment; filename=DOSCertification.xls">
        
        <cfoutput>
         
            <table cellpadding="4" cellspacing="0" align="center" border="1">
                <tr>
                    <th colspan="6">#vReportTitle#</th>            
                </tr>
                <tr style="font-weight:bold;">
                    <td>Region</td>
                    <td>ID</td>
                    <td>First Name</td>
                    <td>Last Name</td>
                    <td>Email</td>
                    <td>User Type</td>
                    <td>Date</td>
                </tr>
                
                <cfscript>
					vCurrentRow = 0;
				</cfscript>
                
                <cfloop list="#FORM.regionID#" index="regionID">
                    
                    <cfquery name="qGetResultsInRegion" dbtype="query">
                        SELECT
                            *
                        FROM
                            qGetResults
                        WHERE
                            regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionID#">
                    </cfquery>
                      
                    <cfloop query="qGetResultsInRegion">
                    	
                        <cfscript>
							vCurrentRow++;
							if ( vCurrentRow MOD 2 ) {
								vRowColor = 'bgcolor="##E6E6E6"';
							} else {
								vRowColor = 'bgcolor="##FFFFFF"';
							}
						</cfscript>
                        
                        <tr>
                            <td #vRowColor#>#qGetResultsInRegion.regionName#</td>
                            <td #vRowColor# align="left">#qGetResultsInRegion.userID#</td>
                            <td #vRowColor#>#qGetResultsInRegion.firstName#</td>
                            <td #vRowColor#>#qGetResultsInRegion.lastName#</td>
                            <td #vRowColor#>#qGetResultsInRegion.email#</td>
                            <td #vRowColor#>#qGetResultsInRegion.userTypeName#</td>
                            <td #vRowColor# align="left">
                                <cfif IsDate(qGetResultsInRegion.date_trained)>
                                    #DateFormat(qGetResultsInRegion.date_trained,"mm/dd/yyyy")#
                                <cfelse>
                                    <span style="color:red;">Missing</span>
                                </cfif>
                            </td>
                        </tr>
                        
                    </cfloop>
                    
                </cfloop>
            
            </table>
            
      	</cfoutput>
    
    <!--- On Screen Report --->
    <cfelse>
    
    	<cfsavecontent variable="report">
    
			<cfoutput>
        
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th>#vReportTitle#</th>            
                    </tr>
                </table>
                
                <cfloop list="#FORM.regionID#" index="iRegionID">
                    
                    <!--- This query is used to make sure we always display the name of the region even if there are not any records there --->
                    <cfquery name="qGetRegion" datasource="#APPLICATION.DSN#">
                        SELECT
                            r.regionID,
                            r.regionName
                        FROM
                            smg_regions r
                        INNER JOIN
                            smg_companies c ON c.companyID = r.company
                        WHERE
                            regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iRegionID#">
                    </cfquery>
                    
                    <cfquery name="qGetResultsInRegion" dbtype="query">
                        SELECT
                            *
                        FROM
                            qGetResults
                        WHERE
                            regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iRegionID#">
                    </cfquery>
                    
                    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                        <tr>
                            <th class="left" colspan="5">
                                <cfif CLIENT.companyID EQ 5>#qGetRegionList.companyShort# -</cfif>
                                #qGetRegion.regionName#                        
                            </th>
                            <th class="right">#qGetResultsInRegion.recordCount# Users</th>
                        </tr>
                        <tr class="on">
                            <td class="subTitleLeft" width="10%" style="font-size:9px">ID</td>
                            <td class="subTitleLeft" width="15%" style="font-size:9px">First Name</td>
                            <td class="subTitleLeft" width="15%" style="font-size:9px">Last Name</td>
                            <td class="subTitleLeft" width="15%" style="font-size:9px">Email</td>
                            <td class="subTitleLeft" width="35%" style="font-size:9px">User Type</td>
                            <td class="subTitleLeft" width="10%" style="font-size:9px">Date</td>
                        </tr>
                      
                        <cfloop query="qGetResultsInRegion">
                            
                            <tr class="#iif(qGetResultsInRegion.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                                <td style="font-size:9px">#qGetResultsInRegion.userID#</td>
                                <td style="font-size:9px">#qGetResultsInRegion.firstName#</td>
                                <td style="font-size:9px">#qGetResultsInRegion.lastName#</td>
                                <td style="font-size:9px">#qGetResultsInRegion.email#</td>
                                <td style="font-size:9px">#qGetResultsInRegion.userTypeName#</td>
                                <td style="font-size:9px">
                                    <cfif IsDate(qGetResultsInRegion.date_trained)>
                                        #DateFormat(qGetResultsInRegion.date_trained,"mm/dd/yyyy")#
                                    <cfelse>
                                        <span style="color:red;">Missing</span>
                                    </cfif>
                                </td>
                            </tr>
                            
                        </cfloop>
                        
                        <cfif NOT VAL(qGetResultsInRegion.recordcount)>
                            <tr class="off">
                                <td colspan="6">No records found</td>
                            </tr>
                        </cfif>
                        
                    </table>
                    
                </cfloop>
                
                <!--- Total --->
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th class="left" colspan="5">Total</th>
                        <th class="right">#qGetResults.recordcount#</th>
                    </tr>
                </table>
                                        
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

</cfif>