<!--- ------------------------------------------------------------------------- ----
	
	File:		_missingAreaRepPaperwork.cfm
	Author:		James Griffiths
	Date:		May 4, 2012
	Desc:		Missing Area Representative Paperwork
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=missingAreaRepPaperwork
				
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
		param name="FORM.programID" default=0;
		param name="FORM.seasonID" default=0;
		param name="FORM.statusID" default="";
		param name="FORM.outputType" default="";
		
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
			
			// Get List of Users Under Advisor and the Advisor self
			vListOfAdvisorUsers = "";
			if ( CLIENT.usertype EQ 6 ) {
				
				// Get Available Reps
				qGetUserUnderAdv = APPLICATION.CFC.USER.getSupervisedUsers(userType=CLIENT.userType, userID=CLIENT.userID, regionIDList=FORM.regionID);
			   
				// Store Users under Advisor on a list
				vListOfAdvisorUsers = ValueList(qGetUserUnderAdv.userID);
	
			}
		</cfscript>
    	
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>

            <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                SELECT DISTINCT 
                    u.userid,
                    u.firstname, 
                    u.lastname,
                    uar.regionID,
                    r.regionName,
                    pw.ar_info_sheet, 
                    pw.ar_ref_quest1, 
                    pw.ar_ref_quest2, 
                    pw.ar_cbc_auth_form, 
                    pw.ar_agreement, 
                    pw.ar_training
                FROM 
                    smg_users u 
                INNER JOIN
                    user_access_rights uar ON uar.userID = u.userID AND uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                INNER JOIN
                    smg_regions r ON r.regionID = uar.regionID
                LEFT OUTER JOIN 
                    smg_users_paperwork pw ON pw.userid = u.userid AND pw.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
                WHERE 
                    1 = 1
                AND   (uar.usertype = 5 OR uar.usertype = 6 OR uar.usertype = 7)
                    <cfif FORM.status NEQ '0'>
                        <cfif FORM.status EQ '1'>
                            AND
                                u.dateAccountVerified <= NOW()
                            AND
                                u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        <cfelseif FORM.status EQ '2'>
                            AND
                                u.dateAccountVerified IS NULL
                            AND
                                u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        <cfelseif FORM.status EQ '3'>
                            AND
                                u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        </cfif>
                    </cfif>            
                    
                    AND
                    (
                            pw.ar_info_sheet IS NULL 
                        OR 
                            pw.ar_ref_quest1 IS NULL 
                        OR 
                            pw.ar_ref_quest2 IS NULL 
                        OR
                            pw.ar_cbc_auth_form IS NULL
                        OR 
                            pw.ar_agreement IS NULL 
                        OR 
                            pw.ar_training IS NULL
                    )
              	<!--- Regional Advisors --->
               	<cfif CLIENT.userType EQ 6>
                	AND 
                        (
                            uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                        OR
                            u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                        )
              	</cfif>
                ORDER BY
                    u.lastname
            </cfquery>

		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=userAreaRepPaperwork" name="userAreaRepPaperwork" id="userAreaRepPaperwork" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">Representative Management - Missing Area Representative Paperwork</th></tr>
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
                    <td class="subTitleRightNoBorder">Season: <span class="required">*</span></td>
                    <td>
                        <select name="seasonID" id="seasonID" class="xLargeField" required>
                            <cfloop query="qGetSeasonList"><option value="#qGetSeasonList.seasonID#">#qGetSeasonList.season#</option></cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Status: <span class="required">*</span></td>
                    <td>
                        <select name="status" id="status" class="xLargeField" required>
                            <option value="0">All</option>
                            <option value="1">Active and Fully Enabled</option>
                            <option value="2">Active and not Fully Enabled</option>
                            <option value="3">Inactive</option>
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
                        This report will provide a list of all the area reps assigned to your region and the paperwok they have completed. 
                        You can choose to search for active or inactive reps as well as enabled or disabled. If paperwork is missing, it will show up on the report.
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
        <cfheader name="Content-Disposition" value="attachment; filename=missingAreaRepPaperwork.xls"> 
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr><th colspan="3">Representative Management - Missing Area Representative Paperwork</th></tr>
            <tr style="font-weight:bold;">
                <td>Region</td>
                <td>Representative</td>
                <td>Missing Paperwork</td>
            </tr>
            
            <cfscript>
                vCurrentRow = 0;
            </cfscript>
        
            <cfoutput query="qGetResults">
            
                <cfscript>
                    vCurrentRow++;
                
                    vRowColor = '';	
                    if ( vCurrentRow MOD 2 ) {
                        vRowColor = 'bgcolor="##E6E6E6"';
                    } else {
                        vRowColor = 'bgcolor="##FFFFFF"';
                    }
                </cfscript>
                
                <tr>
                    <td #vRowColor#>#qGetResults.regionName#</td>
                    <td #vRowColor#>#qGetResults.firstname# #qGetResults.lastname# (###qGetResults.userID#)</td>
                    <td #vRowColor#>
                        <cfif NOT LEN(ar_info_sheet)>AR Info Sheet &nbsp; &nbsp; </cfif>
                        <cfif NOT LEN(ar_ref_quest1)>AR Ref Quest. 1 &nbsp; &nbsp; </cfif>
                        <cfif NOT LEN(ar_ref_quest2)>AR Ref Quest. 2 &nbsp; &nbsp; </cfif>
                        <cfif NOT LEN(ar_cbc_auth_form)>CBC Authorization Form &nbsp; &nbsp; </cfif>
                        <cfif NOT LEN(ar_agreement)>AR Agreement &nbsp; &nbsp; </cfif>
                        <cfif NOT LEN(ar_training)>AR Training Form &nbsp; &nbsp; </cfif>
                    </td>
                </tr>
                
            </cfoutput>
            
        </table>
    
    <!--- On Screen Report --->
    <cfelse>
    
        <cfoutput>
            
            <!--- Include Report Header --->   
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th>Representative Management - Missing Area Representative Paperwork</th>            
                </tr>
                <tr>
                    <td class="center"><strong>Total Number of Representatives in this report:</strong> #qGetResults.recordcount# <br /></td>
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
        
        <cfquery name="qGetRegions" datasource="#APPLICATION.DSN#">
            SELECT
                regionID,
                regionName
            FROM
                smg_regions
            WHERE
                regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
        </cfquery>
        
        <cfoutput query="qGetRegions">
            
            <cfquery name="qGetRepsInRegion" dbtype="query">
                SELECT
                    *
                FROM
                    qGetResults
                WHERE
                    qGetResults.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionID#">
                ORDER BY
                    qGetResults.lastName
            </cfquery>
            
            <cfscript>
                vCurrentRow = 0;
            </cfscript>
    
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th class="left">
                        #regionName# Region
                    </th>
                    <th class="right">
                        #qGetRepsInRegion.recordCount#
                    </th>
                </tr>      
                <tr>
                    <td class="subTitleLeft" width="20%">Representative</td>		
                    <td class="subTitleLeft" width="80%">Missing Paperwork</td>
                </tr>
                
                <cfloop query="qGetRepsInRegion">
                
                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                        <td>#qGetRepsInRegion.firstname# #qGetRepsInRegion.lastname# (###qGetRepsInRegion.userID#)</td>                         
                        <td>
                            <cfif NOT LEN(ar_info_sheet)>AR Info Sheet &nbsp; &nbsp; </cfif>
                            <cfif NOT LEN(ar_ref_quest1)>AR Ref Quest. 1 &nbsp; &nbsp; </cfif>
                            <cfif NOT LEN(ar_ref_quest2)>AR Ref Quest. 2 &nbsp; &nbsp; </cfif>
                            <cfif NOT LEN(ar_cbc_auth_form)>CBC Authorization Form &nbsp; &nbsp; </cfif>
                            <cfif NOT LEN(ar_agreement)>AR Agreement &nbsp; &nbsp; </cfif>
                            <cfif NOT LEN(ar_training)>AR Training Form &nbsp; &nbsp; </cfif>
                        </td>
                    </tr>
                    
                    <cfscript>
                        vCurrentRow++;
                    </cfscript>
            
                </cfloop>
                
            </table>
              
        </cfoutput>
        
    </cfif>

    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    