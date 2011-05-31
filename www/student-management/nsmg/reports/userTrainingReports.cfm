<!--- ------------------------------------------------------------------------- ----
	
	File:		userTrainingReports.cfm
	Author:		Marcus Melo
	Date:		March 22, 2011
	Desc:		Training Reports

	Updated:	05/31/2011 - Adding advisor access
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM Variable --->
    <cfparam name="FORM.action" default="">
    <cfparam name="FORM.regionID" default="">
    <cfparam name="FORM.trainingID" default="">
    <cfparam name="FORM.dateCreatedFrom" default="">
    <cfparam name="FORM.dateCreatedTo" default="">
    <cfparam name="FORM.excelFile" default="">

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
	<cfscript>
		// Get Regions
		qGetRegions = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, userType=CLIENT.userType);

		// Get Training Options
		qGetTrainingOptions = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(applicationID=7,fieldKey='smgUsersTraining');
		
		// Data Validation
		switch(FORM.action) {
			
			case 'trainingByRegion': {

				// RegionID
				if ( NOT LEN(FORM.regionID) ) {
					SESSION.formErrors.Add("Please select at least one region");
				}

				break;
			}

			case 'non-compliance': {

				// RegionID
				if ( NOT LEN(FORM.regionID) ) {
					SESSION.formErrors.Add("Please select at least one region");
				}

				if ( NOT VAL(FORM.trainingID) ) {
					SESSION.formErrors.Add("Please select a training");
				}
				
				break;
			}

			case 'exportExcel': {

				// RegionID
				if ( NOT LEN(FORM.regionID) ) {
					SESSION.formErrors.Add("Please select at least one region");
				}
				
				// Hired From
				if ( NOT LEN(FORM.dateCreatedFrom) OR NOT IsDate(FORM.dateCreatedFrom) ) {
					SESSION.formErrors.Add("Please enter a hired from date");
					FORM.dateCreatedFrom = '';
				}
				
				// Hired To
				if ( NOT LEN(FORM.dateCreatedTo) OR NOT IsDate(FORM.dateCreatedTo) ) {
					SESSION.formErrors.Add("Please enter a hired to date");
					FORM.dateCreatedTo = '';
				}

				break;
			}

			case 'importExcel': {

				// File Name
				if ( NOT LEN(FORM.excelFile) ) {
					SESSION.formErrors.Add("Please select a file");
				}
				
				// Check if there are no errors
				if ( NOT SESSION.formErrors.length() ) {				
					// Process File
					APPLICATION.CFC.USER.importDOSExcelFile(excelFile=FORM.excelFile);
					// Set Page Message
					SESSION.pageMessages.Add("Excel file successfully imported.");
					// Clear Action
					FORM.action = '';
				}
				
				break;
			}

		}
    </cfscript>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EXITS - WebEx Report By Region</title>

<style type="text/css">
	table.report {
		width:100%;
		border-spacing: 0px;
		border-collapse: collapse;
	}

	table.report td.top, th.top {
		border-top:1px solid #999;
		padding: 5px;
		-moz-border-radius: 0px 0px 0px 0px;
	}
	
	table.report td, th {
		border-bottom:1px solid #999;
		border-left:1px solid #999;
		border-right:1px solid #999;
		padding: 5px;
		-moz-border-radius: 0px 0px 0px 0px;
	}
</style>

</head>

<body>

<!--- Form Submitted - Check which report to display --->
<cfif LEN(FORM.action) AND NOT SESSION.formErrors.length()>

	<!--- Display Reports --->
    <cfswitch expression="#FORM.action#">
    
    	<!--- Training By Region Report --->
        <cfcase value="trainingByRegion">
    
            <cfscript>
                // Get Regions
                qGetRegions = APPLICATION.CFC.REGION.getRegionsByList(regionIDList=FORM.regionID, companyID=CLIENT.companyID);
            </cfscript>
        
            <table class="report" align="center">	
                <tr bgcolor="#e2efc7">
                    <th class="top">Training Report</th>
                </tr>
            </table>
        
            <br />
            
            <cfloop query="qGetRegions">
        
                <cfscript>
                    // Get Results
                    qGetResults = APPLICATION.CFC.USER.reportTrainingByRegion(
                                        regionID=qGetRegions.regionID,
                                        trainingID=FORM.trainingID,
										userID=CLIENT.userID,
										userType=CLIENT.userType
                                    );
                    
                    // set rowCount to 0 for new region
                    rowCount = 0;
                </cfscript>
        
                <table class="report" align="center">
                    <tr bgcolor="#e2efc7">
                        <td class="top" colspan="3"><strong>Region:</strong> <cfoutput>#qGetRegions.regionname#</td></cfoutput>
                    </tr>
                    <tr bgcolor="#FFFFE6">
						<!--- Only Apply for DOS Certification --->
                        <cfif FORM.trainingID EQ 2>
                        	<td width="35%" valign="top"><strong>Representative</strong></td>
	                        <td width="10%" valign="top" align="center"><strong>Status</strong></td>
                        <cfelse>
                        	<td width="45%" valign="top"><strong>Representative</strong></td>
						</cfif>                        
                        <td width="55%" valign="top"><strong>Training Information</strong></td>
                    </tr>
                </table>
        
                <cfoutput query="qGetResults" group="userID">
                
                    <cfscript>
                        // Start Count (Grouped cfoutput has incorrect currentrow after inner cfoutput loop)
                        rowCount = rowCount + 1;
                    </cfscript>
                                
                    <table class="report" align="center">
                        <tr bgcolor="#iif(rowCount MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
							<!--- Only Apply for DOS Certification --->
                            <cfif FORM.trainingID EQ 2>
                                <td width="35%" valign="top">
                                    #qGetResults.firstName# #qGetResults.lastName# (###qGetResults.userID#)
                                </td>
                                <td width="10%" valign="top" align="center"> 
                                    <cfif LEN(qGetResults.date_trained) AND NOT VAL(qGetResults.has_passed)>
                                        <span style="color:##F00;">Failed</span>
                                    <cfelseif LEN(qGetResults.date_trained) AND DateAdd("yyyy", 1, qGetResults.date_trained) LTE now()>
                                        <span style="color:##F00;">Expired</span>
                                    <cfelseif LEN(qGetResults.date_trained) AND VAL(qGetResults.has_passed)>
                                        <span style="color:##00F;">Approved</span>                                      
                                    <cfelse>
                                    	<span style="color:##F00;">Missing</span>
                                    </cfif>                                    
                                </td>
							<cfelse>
                                <td width="45%" valign="top">
                                    #qGetResults.firstName# #qGetResults.lastName# (###qGetResults.userID#)
                                </td>
							</cfif> 
                            <td width="55%" valign="top"> 
                            <cfoutput>                        
                                <cfif LEN(qGetResults.date_trained)>
									
                                    Date: #DateFormat(qGetResults.date_trained, 'mm/dd/yyyy')# - #qGetResults.trainingName# 
                                    
									<cfif LEN(qGetResults.score)> 
                                        - Score: #qGetResults.score#
                                    </cfif>
                                    
                                    <br />
                                </cfif>    
                            </cfoutput>
                            </td>
                        </tr>
                    </table>
        
                </cfoutput>           
                
                <br />
                
            </cfloop>
        
        </cfcase>
        
       	<!--- Non-Compliance Report --->
        <cfcase value="non-compliance">

            <cfscript>
                // Get Regions
                qGetRegions = APPLICATION.CFC.REGION.getRegionsByList(regionIDList=FORM.regionID, companyID=CLIENT.companyID);
				
				// Get Selected Training
				qGetTrainingInfo = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(applicationID=7,fieldKey='smgUsersTraining',fieldID=FORM.trainingID);
            </cfscript>
        
            <table class="report" align="center">	
                <tr bgcolor="#e2efc7">
                    <th class="top">Non-Compliance Report</th>
                </tr>
            </table>
        
            <br />
            
            <cfloop query="qGetRegions">
        
                <cfscript>
                    // Get Results
                    qGetResults = APPLICATION.CFC.USER.reportTrainingNonCompliance(
									  regionID=qGetRegions.regionID,
									  trainingID=FORM.trainingID,
									  userID=CLIENT.userID,
									  userType=CLIENT.userType
								  );
                    
                    // set rowCount to 0 for new region
                    rowCount = 0;
                </cfscript>
        
                <table class="report" align="center">
                    <tr bgcolor="#e2efc7">
                        <td class="top" colspan="3"><strong>Region:</strong> <cfoutput>#qGetRegions.regionname#</td></cfoutput>
                    </tr>
                    <tr bgcolor="#FFFFE6">
                        <td width="35%" valign="top"><strong>Representative</strong></td>
                        <td width="10%" valign="top" align="center"><strong>Status</strong></td>
                        <td width="55%" valign="top"><strong>Training History</strong></td>
                    </tr>
                </table>
        
                <cfoutput query="qGetResults" group="userID">
                
                    <cfscript>
                        // Start Count (Grouped cfoutput has incorrect currentrow after inner cfoutput loop)
                        rowCount = rowCount + 1;
                    </cfscript>
                                
                    <table class="report" align="center">
                        <tr bgcolor="#iif(rowCount MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                            <td width="35%" valign="top">
                                #qGetResults.firstName# #qGetResults.lastName# (###qGetResults.userID#)
                            </td>
                            <td width="10%" valign="top" align="center"> 
                                <cfif LEN(qGetResults.date_trained) AND NOT VAL(qGetResults.has_passed)>
                                    <span style="color:##F00;">Failed</span>
                                <cfelseif LEN(qGetResults.date_trained)>
                                    <span style="color:##F00;">Expired</span>
                                <cfelse>
                                    <span style="color:##F00;">Missing</span>
                                </cfif>
                            </td>
                            <td width="55%" valign="top"> 
                            	#qGetTrainingInfo.name# is required <br />
								
								<!--- Looop --->
								<cfoutput>                        
                                    
                                    <cfif LEN(qGetResults.date_trained)>
                                                                           
                                        Date: #DateFormat(qGetResults.date_trained, 'mm/dd/yyyy')# - #qGetResults.trainingName# 
                                        
                                        <cfif LEN(qGetResults.score)> 
                                            - Score: #qGetResults.score#
                                        </cfif>
                                         
                                        <br />
                                    </cfif>    
                                </cfoutput>
                            </td>
                        </tr>
                    </table>
        
                </cfoutput>           
                
                <br />
                
            </cfloop>
		
        </cfcase>


       	<!--- Export Excel --->
        <cfcase value="exportExcel">

			<cfscript>
                // Get Results
                qGetResults = APPLICATION.CFC.USER.exportDOSUserList(
									regionID=FORM.regionID,
									companyID=CLIENT.companyID,
									dateCreatedFrom=FORM.dateCreatedFrom,
									dateCreatedTo=FORM.dateCreatedTo
								);
            </cfscript>
			
   			<!--- set content type --->
            <cfcontent type="application/msexcel">
            
            <!--- suggest default name for XLS file --->
            <cfheader name="Content-Disposition" value="attachment; filename=userList-#DateFormat(now(),'mm-dd-yyyy')#_#TimeFormat(now(),'hh-mm-ss-tt')#.xls"> 
			
            <table class="report" align="center" border="1">
                <tr>
                    <th bgcolor="#e2efc7" colspan="6">User List</th>
                </tr>
                <tr>
                    <td bgcolor="#FFFFE6"><strong>First Name</strong></td>
                    <td bgcolor="#FFFFE6"><strong>Last Name</strong></td>
                    <td bgcolor="#FFFFE6"><strong>Email Address</strong></td>
                    <td bgcolor="#FFFFE6"><strong>Person ID</strong></td>
                    <td bgcolor="#FFFFE6"><strong>Comments</strong></td>
                    <td bgcolor="#FFFFE6"><strong>Date Created</strong></td>
                </tr>
				<cfoutput query="qGetResults" group="userID">
                    
                    <cfscript>
						// Check if there is a valid email address
						if ( IsValid("email", qGetResults.email) ) {
							// Check record as registered															
						}
					</cfscript>
                    <tr>
                        <td>#qGetResults.firstName#</td>
                        <td>#qGetResults.lastName#</td>
                        <td>#qGetResults.email#</td>
                        <td>#qGetResults.userID#</td>
                        <td>#qGetResults.regionName#</td>
                        <td>#DateFormat(qGetResults.dateCreated, 'mm/dd/yyyy')#</td>
                    </tr>
                </cfoutput>
            </table>

        </cfcase>
        
    </cfswitch>	    

<cfelse>
	
	<!--- Display Forms --->        
    <cfoutput>
    
        <!--- Table Header --->
        <gui:tableHeader
            imageName="students.gif"
            tableTitle="User Training Reports"
            width="100%"
        />  
        
			<!--- Page Messages --->
            <gui:displayPageMessages 
                pageMessages="#SESSION.pageMessages.GetCollection()#"
                messageType="tableSection"
                width="100%"
                />
            
            <!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="tableSection"
                width="100%"
                />
            
            <table border="0" cellpadding="8" cellspacing="2" width="100%" class="section">
                <tr>
                    <td>
                        
                        <table cellpadding="4" cellspacing="0" align="center" width="96%">
                            <tr>
                                <td width="50%" valign="top">
                                    <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                                        <input type="hidden" name="action" value="trainingByRegion" />
                                        <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                            <tr><th colspan="2" bgcolor="e2efc7">List of Trainings by Region</th></tr>
                                            <tr align="left">
                                                <td valign="top" align="right"><label for="regionID">Region:</label></td>
                                                <td>
                                                    <select name="regionID" id="regionID" multiple="multiple" size="6">
                                                        <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                            <option value="0">All</option>
                                                        </cfif>
                                                        <cfloop query="qGetRegions">
                                                            <option value="#regionID#">#regionName#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>		
                                            </tr>
                                            <tr>
                                                <td align="right"><label for="trainingID">Training:</label></td>
                                                <td>
                                                    <select name="trainingID" id="trainingID" onchange="displayTrainingScore(this.value);">
                                                        <option value="">All</option>
                                                        <cfloop query="qGetTrainingOptions">
                                                            <option value="#qGetTrainingOptions.fieldID#">#qGetTrainingOptions.name#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                            </tr>
                                        </table>
                                    </form>
                                </td>
                                <td width="50%" valign="top">
                                    <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                                        <input type="hidden" name="action" value="non-compliance" />
                                        <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                            <tr><th colspan="2" bgcolor="e2efc7">Non-Compliance Report</th></tr>
                                            <tr align="left">
                                                <td valign="top" align="right"><label for="regionID">Region:</label></td>
                                                <td>
                                                    <select name="regionID" multiple="multiple" size="6">
                                                        <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                            <option value="0">All</option>
                                                        </cfif>
                                                        <cfloop query="qGetRegions">
                                                            <option value="#regionID#">#regionName#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>		
                                            </tr>
                                            <tr>
                                                <td align="right"><label for="trainingID">Training:</label></td>
                                                <td>
                                                    <select name="trainingID" id="trainingID" onchange="displayTrainingScore(this.value);">
                                                        <option value="0">Select a training</option>
                                                        <cfloop query="qGetTrainingOptions">
                                                            <option value="#qGetTrainingOptions.fieldID#">#qGetTrainingOptions.name#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                            </tr>
                                        </table>
                                    </form>
                                </td>		
                            </tr>
                        </table>
                        
                        <!--- Only Office Users --->
                        <cfif ListFind("1,2,3,4", CLIENT.userType)>
                        
                            <br />
                            
                            <!--- Export / Import --->
                            <table cellpadding="4" cellspacing="0" align="center" width="96%">
                                <tr>
                                    <td width="50%" valign="top">
                                        <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                                            <input type="hidden" name="action" value="exportExcel" />
                                            <input type="hidden" name="trainingID" value="2" />
                                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                                <tr><th colspan="2" bgcolor="e2efc7">DOS Certification - Export to Excel</th></tr>
                                                <tr align="left">
                                                    <td valign="top" align="right"><label for="regionID">Region:</label></td>
                                                    <td>
                                                        <select name="regionID" id="regionID" multiple="multiple" size="6">
                                                            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                                                <option value="0">All</option>
                                                            </cfif>
                                                            <cfloop query="qGetRegions">
                                                                <option value="#regionID#">#regionName#</option>
                                                            </cfloop>
                                                        </select>
                                                    </td>		
                                                </tr>
                                                <tr>
                                                    <td align="right"><label for="dateCreatedFrom">Hired From:</label></td>
                                                    <td><input type="text" name="dateCreatedFrom" id="dateCreatedFrom" value="#FORM.dateCreatedFrom#" class="datePicker" maxlength="10" /></td>
                                                </tr>
                                                <tr>
                                                    <td align="right"><label for="dateCreatedTo">To:</label></td>
                                                    <td><input type="text" name="dateCreatedTo" id="dateCreatedTo"  value="#FORM.dateCreatedTo#" class="datePicker" maxlength="10" /></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                                </tr>
                                            </table>
                                        </form>
                                    </td>
                                    <td width="50%" valign="top">
                                        <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="action" value="importExcel" />
                                            <table class="nav_bar" cellpadding="6" cellspacing="0" align="left" width="100%">
                                                <tr><th colspan="2" bgcolor="e2efc7">DOS Certification - Import Excel File</th></tr>
                                                <tr align="left">
                                                    <td valign="top" align="right"><label for="excelFile">File:</label></td>
                                                    <td><input type="file" name="excelFile" id="excelFile" /></td>		
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        Required Columns: Person ID | Score | Completion Date 
                                                    </td>
                                                </tr>                                                
                                                <tr>
                                                    <td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td>
                                                </tr>
                                            </table>
                                        </form>
                                    </td>		
                                </tr>
                            </table>
                        
                        </cfif>
                        
                    </td>
                </tr>
            </table>
            
        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="100%"
        />
    
    </cfoutput>
    
</cfif>

</body>
</html>