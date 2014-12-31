<!--- ------------------------------------------------------------------------- ----
	
	File:		_complianceMileageReport.cfm
	Author:		James Griffiths
	Date:		May 2, 2012
	Desc:		Compliance Mileage Report By Region
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=complianceMileageReport
				
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
		param name="FORM.regionID" default=0;
		param name="FORM.displayOutOfCompliance" default=0;
		param name="FORM.displayPendingPlacement" default=0;
		param name="FORM.outputType" default="flashPaper";
		
		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get List of Users Under Advisor and the Advisor self
		vListOfAdvisorUsers = "";
		if ( CLIENT.usertype EQ 6 ) {
			
			// Get Available Reps
			qGetUserUnderAdv = APPLICATION.CFC.USER.getSupervisedUsers(userType=CLIENT.userType, userID=CLIENT.userID, regionIDList=FORM.regionID);
		   
			// Store Users under Advisor on a list
			vListOfAdvisorUsers = ValueList(qGetUserUnderAdv.userID);

		}
    </cfscript>

    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
		
        <cfscript>
			// Data Validation
			
            // Program
            if ( NOT VAL(FORM.programID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one program");
            }

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
                    s.studentID, 
                    s.firstname, 
                    s.familylastname,
                    s.active,
                    s.cancelDate,
                    ht.historyID,
                    ht.hfSupervisingDistance,
                    h.hostid, 
                    h.familylastname AS hostlastname,
                    CONCAT(h.address, ', ', h.city, ', ', h.state, ', ', h.zip) AS hostAddress,
                    h.zip AS hostzip,
                    r.regionID,
                    r.regionName,
                    u.userid, 
                    u.firstname AS supervisingFirstName, 
                    u.lastname AS supervisingLastName, 
                    CONCAT(u.address, ', ', u.city, ', ', u.state, ', ', u.zip) AS supervisingAddress,
                    u.zip AS supervisingZip,
                    c.companyShort
                FROM 
                    smg_students s
                INNER JOIN 
                    smg_hosts h ON s.hostid = h.hostid
                INNER JOIN
                    smg_regions r ON r.regionID = s.regionAssigned
                    AND
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#" list="yes"> )
                INNER JOIN
                    smg_companies c ON c.companyID = r.company
                LEFT JOIN 
                    smg_users u ON s.arearepid = u.userid
                INNER JOIN
                    smg_hosthistory ht ON ht.studentID = s.studentID
                        AND 
                            ht.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">            	
                        AND
                            ht.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">    
                        AND
                            ht.hostID = h.hostID
                        AND
                            ht.areaRepID = u.userID
                        <cfif VAL(FORM.displayOutOfCompliance)>
                        AND
                            (
                                hfSupervisingDistance >= <cfqueryparam cfsqltype="cf_sql_integer" value="120">
                             OR
                                hfSupervisingDistance = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                            )
                        </cfif>                    
                WHERE 
                    s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
                    
				<cfif VAL(FORM.displayPendingPlacement)>
                    AND
                        s.host_fam_approved >= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
                </cfif>
                <!--- Regional Advisors --->
				<cfif LEN(vListOfAdvisorUsers)>
                	AND
                        (
                       		s.areaRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                        OR
                     		s.placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                        )
				</cfif> 

                ORDER BY	
                    c.companyShort,
                    r.regionName,
                    supervisingLastName,
                    s.familyLastName
            </cfquery> 
    
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=userComplianceMileageReport" name="userComplianceMileageReport" id="userComplianceMileageReport" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">Representative Management - Compliance Mileage Report</th></tr>
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
                    <td class="subTitleRightNoBorder">Options:</td>
                    <td>
                    	<input type="checkbox" name="displayOutOfCompliance" id="displayOutOfCompliance" value="1" checked="checked" /> 
                    	<label for="displayOutOfCompliance">Display only out of compliance records</label>
                    </td>
                </tr>                                             
                <tr class="on">
                    <td class="subTitleRightNoBorder">&nbsp;</td>
                    <td>
                    	<input type="checkbox" name="displayPendingPlacement" id="displayPendingPlacement" value="1" />
                    	<label for="displayPendingPlacement">Display only pending placements</label>
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
                		This report will generate a list of students and the distance, in miles, between their HF and Supervising rep. 
                        Any distance over 120 miles, will be highlighted in red, noting that it is non-compliant
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
        <cfheader name="Content-Disposition" value="attachment; filename=complianceMileageReport.xls"> 
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr><th colspan="5">Representative Management - Compliance Mileage Report</th></tr>
            <tr style="font-weight:bold;">
                <td>Region</td>
                <td>Student</td>
                <td>Supervising Representative</td>
                <td>Host Family</td>
                <td>Google Shortest Driving Distance</td>
            </tr>
            
            <cfscript>
                vCurrentRow = 0;
            </cfscript>
        
            <cfloop query="qGetResults">
            
                <cfoutput>
                                              
                    <cfscript>
                        vCurrentRow++;
						
                        vUpdateTable = 0;
                        
                        // Check if we have recorded distance in the database from Google driving directions
                        if ( VAL(qGetResults.hfSupervisingDistance) ) {
            
                            vGoogleDistance = qGetResults.hfSupervisingDistance;
            
                        } else {
                        
                            // New Method
                            vGoogleDistance = APPLICATION.CFC.UDF.calculateAddressDistance(origin=qGetResults.hostAddress,destination=qGetResults.supervisingAddress);
                            vUpdateTable = 1;
                            
                        }
                        
                        // Set Row Color
                        vRowColor = '';	
                        if ( vCurrentRow MOD 2 ) {
                            vRowColor = 'bgcolor="##E6E6E6"';
                        } else {
                            vRowColor = 'bgcolor="##FFFFFF"';
                        }
                        
                        // Set Alert Color
                        vSetColorCode = '';				
                        if ( VAL(vGoogleDistance) GT 120 ) {
                            vSetColorCode = 'bgcolor="##FF0000"';	
                        } else if ( VAL(vGoogleDistance) GTE 100 ) {
                            vSetColorCode = 'bgcolor="##FFE87C"';	
                        }
                    </cfscript>
                    
                    <tr>
                        <td #vRowColor#>#qGetResults.regionName#</td>
                        <td #vRowColor#>
                            #qGetResults.firstname# #qGetResults.familylastname# (###qGetResults.studentID#)
                            <cfif VAL(qGetResults.active)>
                                <span class="note">(Active)</span>
                            <cfelseif isDate(qGetResults.cancelDate)>
                                <span class="noteAlert">(Cancelled)</span>
                            </cfif>
                        </td>
                        <td #vRowColor#>
                            #qGetResults.supervisingFirstName# #qGetResults.supervisingLastName# (###qGetResults.userID#)
                            <span class="note">#qGetResults.supervisingAddress#</span>
                        </td>     
                        <td #vRowColor#>
                            #qGetResults.hostlastname# (###qGetResults.hostid#)
                            <span class="note">#qGetResults.hostAddress#</span>
                        </td>                           
                        <td #vSetColorCode#>#vGoogleDistance# mi</td>
                    </tr>
                    
                    <cfscript>
                        // Update Distance in the database
                        if ( VAL(vUpdateTable) AND IsNumeric(vGoogleDistance) ) {
                        
                            APPLICATION.CFC.STUDENT.updateHostSupervisingDistance(
                                historyID=qGetResults.historyID	,
                                distanceInMiles=vGoogleDistance												  																	  
                            );
                            
                        }
                    </cfscript>
                
                </cfoutput>
                        
            </cfloop>
            
        </table>
    
    <!--- On Screen Report --->
    <cfelse>
    
    	<cfsavecontent variable="report">
    
			<cfoutput>
                
                <!--- Include Report Header --->   
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th>Representative Management - Compliance Mileage Report</th>            
                    </tr>
                    <tr>
                        <td class="center" style="font-size:9px"><strong>Total Number of Students in this report:</strong> #qGetResults.recordcount# <br /></td>
                    </tr>
                    <tr>
                        <td class="center" style="font-size:9px">
                            Program(s) included in this report: <br />
                            <cfloop query="qGetPrograms">
                                #qGetPrograms.programName# <br />
                            </cfloop>
                        </td>
                    </tr>            
                </table>
                
                <!--- No Records Found --->
                <cfif NOT VAL(qGetResults.recordCount)>
                    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                        <tr class="on">
                            <td class="subTitleCenter" style="font-size:9px">No records found</td>
                        </tr>      
                    </table>
                    <cfabort>
                </cfif>
                
            </cfoutput>
                
            <cfoutput query="qGetResults" group="regionID">
        
                <cfscript>
                    // Set Current Row used to display light blue color on the table
                    vCurrentRow = 0;
                </cfscript>
        
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th class="left" colspan="5">
                            #qGetResults.regionName# Region
                        </th>
                    </tr>      
                    <tr>
                        <td class="subTitleLeft" width="28%" style="font-size:9px">Student</td>
                        <td class="subTitleLeft" width="28%" style="font-size:9px">Supervising Representative</td>		            
                        <td class="subTitleLeft" width="28%" style="font-size:9px">Host Family</td>				
                        <td class="subTitleCenter" width="16%" style="font-size:9px">Google Shortest Driving Distance</td>
                    </tr>      
        
                <cfoutput>
                                
                    <cfscript>
                        vCurrentRow++;
                    
                        vUpdateTable = 0;
                        
                        // Check if we have recorded distance in the database from Google driving directions
                        if ( VAL(qGetResults.hfSupervisingDistance) ) {
        
                            vGoogleDistance = qGetResults.hfSupervisingDistance;
        
                        } else {
                        
                            // New Method
                            vGoogleDistance = APPLICATION.CFC.UDF.calculateAddressDistance(origin=qGetResults.hostAddress,destination=qGetResults.supervisingAddress);
                            vUpdateTable = 1;
                            
                        }
                        
                        vSetColorCode = '';
                        
                        if ( VAL(vGoogleDistance) GT 120 ) {
                            vSetColorCode = 'alert';	
                        } else if ( VAL(vGoogleDistance) GTE 100 ) {
                            vSetColorCode = 'attention';	
                        }
                    </cfscript>
                                                
                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                        <td style="font-size:9px">
                            #qGetResults.firstname# #qGetResults.familylastname# (###qGetResults.studentID#)
                            <cfif VAL(qGetResults.active)>
                                <span class="note">(Active)</span>
                            <cfelseif isDate(qGetResults.cancelDate)>
                                <span class="noteAlert">(Cancelled)</span>
                            </cfif>
                        </td>
                        <td style="font-size:9px">
                            #qGetResults.supervisingFirstName# #qGetResults.supervisingLastName# (###qGetResults.userID#)
                            <span class="note">#qGetResults.supervisingAddress#</span>
                        </td>     
                        <td style="font-size:9px">
                            #qGetResults.hostlastname# (###qGetResults.hostid#)
                            <span class="note">#qGetResults.hostAddress#</span>
                        </td>                           
                        <td class="center">
                        	<table width="95%">
                            	<tr>
                                	<td class="center #vSetColorCode#" style="font-size:9px">#vGoogleDistance# mi</td>
                               	</tr>
                          	</table>
                      	</td>
                    </tr>
                    
                    <cfscript>
                        // Update Distance in the database
                        if ( VAL(vUpdateTable) AND IsNumeric(vGoogleDistance) ) {
                        
                            APPLICATION.CFC.STUDENT.updateHostSupervisingDistance(
                                historyID=qGetResults.historyID	,
                                distanceInMiles=vGoogleDistance												  																	  
                            );
                            
                        }
                    </cfscript>
                    
                </cfoutput>
                    
                </table>		
            
            </cfoutput>
            
      	</cfsavecontent>
        
        <cfif FORM.outputType EQ "flashPaper">
    
   			<cfdocument format="flashpaper" orientation="portrait" backgroundvisible="yes" overwrite="yes" fontembed="yes" margintop="0.3" marginright="0.2" marginbottom="0.3" marginleft="0.2">
    
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
    
    <!--- Page Footer --->
    <gui:pageFooter />	
    
</cfif>    