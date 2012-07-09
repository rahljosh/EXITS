<!--- ------------------------------------------------------------------------- ----
	
	File:		_hostFamilyList.cfm
	Author:		James Griffiths
	Date:		June 15, 2012
	Desc:		Host Family Spreadsheet
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=hostFamilyList
				
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
		param name="FORM.regionID" default=0;
		param name="FORM.stateID" default=0;
		param name="FORM.status" default=1;
		param name="FORM.hosting" default=1;
		param name="FORM.outputType" default="onScreen";
		
		// Set Report Title To Keep Consistency
		vReportTitle = "Host Family Management - Host Family List";
		
		// Get List of Users Under Advisor and the Advisor self
		vListOfAdvisorUsers = "";
		if ( CLIENT.usertype EQ 6 ) {
			
			// Get Available Reps
			qGetUserUnderAdv = APPLICATION.CFC.USER.getSupervisedUsers(userType=CLIENT.userType, userID=CLIENT.userID, regionIDList=FORM.regionID);
		   
			// Store Users under Advisor on a list
			vListOfAdvisorUsers = ValueList(qGetUserUnderAdv.userID);

		}
	</cfscript>
    
    <cfquery name="qGetStateList" datasource="#APPLICATION.DSN#">
    	SELECT
        	ID,
            stateName
       	FROM
        	smg_states
    </cfquery>
    
	
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
            	SELECT
                	h.hostID,
                    h.fatherFirstName,
                    h.motherFirstName,
                    h.familyLastName,
                    h.address,
                    h.city,
                    h.state,
                    h.zip,
                    h.email,
                    h.phone
               	FROM
                	smg_hosts h
               	INNER JOIN
                	smg_states s ON s.state = h.state
              	WHERE
                	h.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.status#">
               	AND
                	s.ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.stateID#" list="yes"> )
               	AND
                	h.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
               	<cfif FORM.hosting EQ 0>
                	AND
                		h.hostID NOT IN (
                        	SELECT 
                            	hostID 
                            FROM 
                            	smg_students 
                            WHERE 
                            	active=<cfqueryparam cfsqltype="cf_sql_integer" value="1">
                            )
               	<cfelse>
                	AND
                    	h.hostID IN (
                        	SELECT 
                            	hostID 
                            FROM 
                            	smg_students 
                            WHERE 
                            	active=<cfqueryparam cfsqltype="cf_sql_integer" value="1">
                            )
              	</cfif>
                <!--- Regional Advisors --->
				<cfif LEN(vListOfAdvisorUsers)>
                	AND
                    	h.hostID IN 
                        	( 
                        	SELECT 
                            	hostID 
                           	FROM 
                            	smg_students 
                           	WHERE 
                            	( 
                            		areaRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> ) 
                                OR 
                                	placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> ) 
                              	)
                        	)
				</cfif>
                GROUP BY
                	h.hostID
              	ORDER BY
                	h.familyLastName
            </cfquery>
            
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>


<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>
	
    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->
    
	<cfoutput>

        <form action="report/index.cfm?action=hostFamilyList" name="hostFamilyList" id="hostFamilyList" method="post" target="blank">
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
                    <td class="subTitleRightNoBorder">State: <span class="required">*</span></td>
                    <td>
                        <select name="stateID" id="stateID" class="xLargeField" multiple size="6" required>
                            <cfloop query="qGetStateList">
                            	<option value="#qGetStateList.ID#"> 
                                    #qGetStateList.stateName#
                                </option>
                            </cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Status: <span class="required">*</span></td>
                    <td>
                        <select name="status" id="status" class="xLargeField" required>
                            <option value="1">Active</option>
                            <option value="0">Inactive</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Currently Hosting: <span class="required">*</span></td>
                    <td>
                        <select name="hosting" id="hosting" class="xLargeField" required>
                            <option value="1">Yes</option>
                            <option value="0">No</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" id="outputType" class="xLargeField">
                            <option value="onScreen">On Screen</option>
                            <option value="Excel">Excel Spreadsheet</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on summaryRow">
                    <td class="subTitleRightNoBorder">Summary Only:</td>
                    <td>
                    	<input type="checkbox" name="summary" id="summary" value="1" /> <span style="font-size:9px;">Only available in On Screen report.</span>
                    </td>		
                </tr>
                <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">* Required Fields</td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>
                        This report will create a spreadsheet of all host families in the regions and states selected.
                </tr>
                <tr>
                    <th colspan="2" align="center"><input type="image" src="pics/view.gif" align="center" border="0"> </th>
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
        <cfheader name="Content-Disposition" value="attachment; filename=hostFamilyList.xls"> 
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr>
                <th colspan="5">#vReportTitle#</th>            
            </tr>
            <tr style="font-weight:bold;">
                <td>ID</td>
                <td>Host Family</td>
                <td>Address</td>
                <td>Email</td>
                <td>Phone</td>
            </tr>      
            
            <cfoutput query="qGetResults">
                
                <cfscript>
                    // Set Row Color
                    if ( qGetResults.currentRow MOD 2 ) {
                        vRowColor = 'bgcolor="##E6E6E6"';
                    } else {
                        vRowColor = 'bgcolor="##FFFFFF"';
                    }
                </cfscript>
                    
                    <tr>
                        <td #vRowColor#>###qGetResults.hostID#</td>
                        <td #vRowColor#>
                            #qGetResults.familyLastname#
                             - 
                            #qGetResults.fatherFirstName#
                            <cfif LEN(qGetResults.fatherFirstName) AND LEN(qGetResults.motherFirstName)>
                                 & 
                            </cfif>
                            #qGetResults.motherFirstname#
                        </td>
                        <td #vRowColor#>#qGetResults.address# #qGetResults.city#, #qGetResults.state#</td>
                        <td #vRowColor#>#qGetResults.email#</td>
                        <td #vRowColor#>#qGetResults.phone#</td>
                    </tr>
                    	
            </cfoutput>
    
        </table>
    
    <!--- On Screen Report --->
    <cfelse>
    
    	<cfdocument format="flashpaper" orientation="portrait" backgroundvisible="yes" overwrite="yes" fontembed="yes" margintop="0.3" marginright="0.2" marginbottom="0.3" marginleft="0.2">
    
    		<!--- Page Header --->
            <gui:pageHeader
                headerType="applicationNoHeader"
                filePath="../"
            />
    
			<cfoutput>
                
                <!--- Include Report Header --->   
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th width="15%"></th>
                        <th width="70%" align="center" colspan="3">#vReportTitle#</th>
                        <th width="15%">Total of #qGetResults.recordCount# records</th>
                    </tr>
                
                    <!--- No Records Found --->
                    <cfif NOT VAL(qGetResults.recordCount)>
                        <tr class="on">
                            <td class="subTitleCenter" colspan="5">No records found</td>
                        </tr>      
                        </table>
                        <cfabort>
                    </cfif>
                    
                    <tr class="on">
                        <td class="subTitleLeft" width="10%" style="font-size:9px">ID</td>
                        <td class="subTitleLeft" width="25%" style="font-size:9px">Host Family</td>
                        <td class="subTitleLeft" width="25%" style="font-size:9px">Address</td>
                        <td class="subTitleLeft" width="25%" style="font-size:9px">Email</td>
                        <td class="subTitleLeft" width="15%" style="font-size:9px">Phone</td>
                    </tr>
            
                    <cfscript>
                        vCurrentRow=0;
                    </cfscript>
            
                    <cfloop query="qGetResults">
                    
                        <cfscript>
                            vCurrentRow++;
                        </cfscript>
                        
                        <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                            <td style="font-size:9px">###qGetResults.hostID#</td>
                            <td style="font-size:9px">
                                #qGetResults.familyLastname#
                                 - 
                                #qGetResults.fatherFirstName#
                                <cfif LEN(qGetResults.fatherFirstName) AND LEN(qGetResults.motherFirstName)>
                                     & 
                                </cfif>
                                #qGetResults.motherFirstname#
                            </td>
                            <td style="font-size:9px">#qGetResults.address# #qGetResults.city#, #qGetResults.state#</td>
                            <td style="font-size:9px">#qGetResults.email#</td>
                            <td style="font-size:9px">#qGetResults.phone#</td>
                        </tr>	
                    
                    </cfloop>
            
                </table>
            
            </cfoutput>
            
      	</cfdocument>
        
  	</cfif>
    
    <!--- Page Footer --->
    <gui:pageFooter />	
    
</cfif>    