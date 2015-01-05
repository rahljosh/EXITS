<!--- ------------------------------------------------------------------------- ----
	
	File:		_listTrainingsByRegion.cfm
	Author:		James Griffiths
	Date:		May 2, 2012
	Desc:		List Trainings By Region

	Updated:
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default=0;
		param name="FORM.trainingID" default=0;
		param name="FORM.compliance" default=0;
		param name="FORM.outputType" default="flashPaper";
		
		// Get Regions
      	qGetRegions = APPLICATION.CFC.REGION.getRegionsByList(regionIDList=FORM.regionID, companyID=CLIENT.companyID);

		if (compliance != "on") {
			// Get Programs
			qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		}
		
		// Get Training Options
		qGetTrainingOptions = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='smgUsersTraining');
		
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
            if ( NOT VAL(FORM.programID) AND (FORM.compliance EQ 0) ) {
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
        
            <!--- This gets the total number of representatives that will be displayed --->
            <cfscript>
                vTotalReps = 0;
            </cfscript>
            
            <cfloop query="qGetRegions">
                <cfscript>
					if (FORM.compliance EQ '0') {
						qGetResults = APPLICATION.CFC.USER.reportTrainingByRegion(
							regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType,programID=FORM.programID
						);
					} else {
						qGetResults = APPLICATION.CFC.USER.reportTrainingNonCompliance(
							regionID=qGetRegions.regionID,trainingID=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType
						);
					}
                </cfscript>
                
                <cfquery name="qTotal" dbtype="query">
                    SELECT DISTINCT
                        userID
                    FROM
                        qGetResults
                </cfquery>
                
                <cfscript>
                    vTotalReps += qTotal.RecordCount;
                </cfscript>
                
            </cfloop>

		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>
	
    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->
    
    <script type="text/javascript">
	
		$('#compliance').click(function() {
										if (programs.style.display == "none") {
											$('#programID').removeAttr('required');
											$('#trainingID').removeAttr('multiple');
											$('#trainingID').removeAttr('size');
										} else {
											$('#programID').attr('required', '');
											$('#trainingID').attr('multiple', '');
											$('#trainingID').attr('size', '6');	
										}
										});
		
		// This function removes the region selection list if the user only wants a non-compliance report
		function removePrograms() {
			var programs = document.getElementById("programs");
			if (programs.style.display == "none") {
				programs.style.display = "";
			} else {
				programs.style.display = "none";
			}
		}
	</script>
    
	<cfoutput>

        <form action="report/index.cfm?action=userTrainingList" name="userTrainingList" id="userTrainingList" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">Representative Management - User Training List</th></tr>
                <tr class="on" id="programs">
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
                    <td class="subTitleRightNoBorder">Training: <span class="required">*</span></td>
                    <td>
                        <select name="trainingID" id="trainingID" class="xLargeField" multiple size="6" required>
                            <cfloop query="qGetTrainingOptions"><option value="#qGetTrainingOptions.fieldID#">#qGetTrainingOptions.name#</option></cfloop>
                        </select>
                    </td>
                </tr>
                <tr class="on">
                	<td class="subTitleRightNoBorder">Show Only Non-Compliant: </td>
                    <td>
                    	<input type="checkbox" name="compliance" id="compliance" onclick="removePrograms()"/>
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
        <cfheader name="Content-Disposition" value="attachment; filename=TrainingReport.xls"> 
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr>
                <th colspan="4">Training Report<cfif FORM.compliance NEQ 0> - Non-Compliance</cfif></th>            
            </tr>
            <tr style="font-weight:bold;">
                <td>Region</td>
                <td>Representative</td>
                <td>Status</td>
                <td>Training</td>
            </tr>
            
            <cfscript>
                vCurrentRow = 1;
            </cfscript>
                    
            <cfloop query="qGetRegions">
            
                <cfscript>
                    if (FORM.compliance EQ 0) {
						qGetResults = APPLICATION.CFC.USER.reportTrainingByRegion(
							regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType,programID=FORM.programID);
					} else {
						qGetResults = APPLICATION.CFC.USER.reportTrainingNonCompliance(
							regionID=qGetRegions.regionID,trainingID=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType);
						
						qGetTrainingInfo = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='smgUsersTraining',fieldID=FORM.trainingID);
					}
                </cfscript>
                
                <cfoutput query="qGetResults" group="userID">
                    
                    <cfscript>
                        // Set Row Color
                        if ( vCurrentRow MOD 2 ) {
                            vRowColor = '##E6E6E6';
                        } else {
                            vRowColor = '##FFFFFF';
                        }
						
						vCurrentRow++;
                    </cfscript>
                    
                    <tr>
                    	<td bgcolor="#vRowColor#">#qGetRegions.regionName#</td>
                    	<td bgcolor="#vRowColor#">#qGetResults.firstName# #qGetResults.lastName# (###qGetResults.userID#)</td>
                
                        <cfquery name="qGetTraining" datasource="#APPLICATION.DSN#">
                            SELECT
                                t.date_trained,
                                t.has_passed,
                                t.score,
                                t.training_id,
                                al.name
                            FROM
                                smg_users_training t
                            INNER JOIN
                                applicationlookup al ON al.fieldID = t.training_id
                            WHERE
                                t.training_id IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.trainingID#"> )
                            AND
                                t.user_id = #qGetResults.userID#
                            ORDER BY
                                date_trained DESC
                        </cfquery>
                
                    	<td bgcolor="#vRowColor#">
                        
                        	<cfloop list="#FORM.trainingID#" index="i">
    
                                <cfquery name="qGetThisTraining" dbtype="query">
                                    SELECT
                                        *
                                    FROM
                                        qGetTraining
                                    WHERE
                                        training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                </cfquery>
                            
								<cfif qGetThisTraining.recordCount>
                                    <cfloop query="qGetThisTraining">
                                        <cfif LEN(qGetThisTraining.date_trained)>
                                            <cfif i EQ 2 AND NOT VAL(qGetThisTraining.has_passed)>
                                                Failed
                                            <cfelse>
                                                <cfif DateAdd("yyyy", 1, qGetThisTraining.date_trained) LTE now()>
                                                    Expired
                                                <cfelse>
                                                    Approved
                                                </cfif>
                                            </cfif>
                                        <cfelse>
                                            Missing
                                        </cfif>
                                        <br />
                                    </cfloop>
                                <cfelse>
                                    Missing
                                    <br />
                                </cfif>
                        
                        	</cfloop>
                        
                   		</td>
                    
                    	<td bgcolor="#vRowColor#">
                    
                            <cfloop list="#FORM.trainingID#" index="i">
                            
                                <cfquery name="qGetThisTraining" dbtype="query">
                                    SELECT
                                        *
                                    FROM
                                        qGetTraining
                                    WHERE
                                        training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                </cfquery>
                                
                                <cfif qGetThisTraining.recordCount>
                                    <cfloop query="qGetThisTraining">
                                        <cfif LEN(qGetThisTraining.date_trained)>
                                            Date: #DateFormat(qGetThisTraining.date_trained, 'mm/dd/yyyy')# - #qGetThisTraining.name# 
                                            <cfif LEN(qGetThisTraining.score) AND i EQ 2> 
                                                - Score: #qGetThisTraining.score#
                                            </cfif>
                                        <cfelse>
                                            #qGetThisTraining.name# is required
                                        </cfif>
                                        <br />
                                    </cfloop>
                                <cfelse>
                                    <cfquery name="qGetMissing" datasource="#APPLICATION.DSN#">
                                        SELECT
                                            name
                                        FROM 
                                            applicationlookup 
                                        WHERE
                                            fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                    </cfquery>
                                    #qGetMissing.name# is required
                                    <br />
                                </cfif>
                                
                            </cfloop>
                            
                    	</td>
                    
                	</tr>
                
            	</cfoutput>
            
        	</cfloop>
                           
        </table>    
    
    <!--- On Screen Report --->
    <cfelse>
    
    	<cfsavecontent variable="report">
    
			<cfoutput>
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th width="33%"></th>
                        <th class="center" width="34%"><cfif FORM.compliance EQ '0'>Training Report<cfelse>Non-Compliance Report</cfif></th>
                        <th class="right" width="33%">#vTotalReps# Total Representatives</th>
                    </tr>
                    <tr>
                        <cfif FORM.compliance EQ '0'>
                            <td class="center" colspan="3">
                                Program(s) included in this report: <br />
                                <cfloop query="qGetPrograms">
                                    #qGetPrograms.programName# <br />
                                </cfloop>
                            </td>
                        </cfif>
                    </tr>
                </table>
            </cfoutput>
            
            <cfloop query="qGetRegions">
                       
                <cfscript>
                    if (FORM.compliance EQ 0) {
                        qGetResults = APPLICATION.CFC.USER.reportTrainingByRegion(
                            regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType,programID=FORM.programID);
                    } else {
                        qGetResults = APPLICATION.CFC.USER.reportTrainingNonCompliance(
                        
                        regionID=qGetRegions.regionID,trainingID=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType);
                        
                        qGetTrainingInfo = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='smgUsersTraining',fieldID=FORM.trainingID);
                    }
                </cfscript>
                
                <cfquery name="qTotalInRegion" dbtype="query">
                    SELECT DISTINCT
                        userID
                    FROM 
                        qGetResults
                </cfquery>
                
                <cfoutput>
                
                    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                        <tr>
                            <th class="left" colspan="2">#qGetResults.regionName# Region</th>
                            <th class="right">#qTotalInRegion.recordCount# Representatives</th>
                        </tr>
                        <tr>
                            <td class="subTitleLeft" width="40%" style="font-size:9px">Representative</td>
                            <td class="subTitleLeft" width="20%" style="font-size:9px">Status</td>
                            <td class="subTitleLeft" width="40%" style="font-size:9px">Training</td>
                        </tr>
                </cfoutput>
                        
                <cfscript>
                    vCurrentRow = 0;
                </cfscript>
                
                <cfoutput query="qGetResults" group="userID">
                    
                     <cfscript>
                        if (vCurrentRow MOD 2)
                            vClass = "class='off'";
                        else
                            vClass = "class='on'";
                        vCurrentRow++;
                    </cfscript>
                    
                    <tr #vClass#>
                        <td style="font-size:9px">#qGetResults.firstName# #qGetResults.lastName# (###qGetResults.userID#)</td>
                    
                        <cfquery name="qGetTraining" datasource="#APPLICATION.DSN#">
                            SELECT
                                t.date_trained,
                                t.has_passed,
                                t.score,
                                t.training_id,
                                al.name
                            FROM
                                smg_users_training t
                            INNER JOIN
                                applicationlookup al ON al.fieldID = t.training_id
                            WHERE
                                t.training_id IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#FORM.trainingID#"> )
                            AND
                                t.user_id = #qGetResults.userID#
                            ORDER BY
                                date_trained DESC
                        </cfquery>
                    
                        <td style="font-size:9px">
                            <cfloop list="#FORM.trainingID#" index="i">
        
                                <cfquery name="qGetThisTraining" dbtype="query">
                                    SELECT
                                        *
                                    FROM
                                        qGetTraining
                                    WHERE
                                        training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                </cfquery>
                                
                                <cfif qGetThisTraining.recordCount>
                                    <cfloop query="qGetThisTraining">
                                        <cfif LEN(qGetThisTraining.date_trained)>
                                            <cfif i EQ 2 AND NOT VAL(qGetThisTraining.has_passed)>
                                                <span style="color:##F00;">Failed</span>
                                            <cfelse>
                                                <cfif DateAdd("yyyy", 1, qGetThisTraining.date_trained) LTE now()>
                                                    <span style="color:##F00;">Expired</span>
                                                <cfelse>
                                                    <span style="color:##00F;">Approved</span> 
                                                </cfif>
                                            </cfif>
                                        <cfelse>
                                            <span style="color:##F00;">Missing</span>
                                        </cfif>
                                        <br />
                                    </cfloop>
                                <cfelse>
                                    <span style="color:##F00;">Missing</span>
                                    <br />
                                </cfif>
                            
                            </cfloop>
                        </td>
                        <td style="font-size:9px">
                            <cfloop list="#FORM.trainingID#" index="i">
                            
                                <cfquery name="qGetThisTraining" dbtype="query">
                                    SELECT
                                        *
                                    FROM
                                        qGetTraining
                                    WHERE
                                        training_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                </cfquery>
                                
                                <cfif qGetThisTraining.recordCount>
                                    <cfloop query="qGetThisTraining">
                                        <cfif LEN(qGetThisTraining.date_trained)>
                                            <cfif i EQ 2 AND NOT VAL(qGetThisTraining.has_passed)>
                                                <span style="color:##F00;">
                                            <cfelse>
                                                <cfif DateAdd("yyyy", 1, qGetThisTraining.date_trained) LTE now()>
                                                    <span style="color:##F00;">
                                                <cfelse>
                                                    <span style="color:##00F;"> 
                                                </cfif>
                                            </cfif>
                                            Date: #DateFormat(qGetThisTraining.date_trained, 'mm/dd/yyyy')# - #qGetThisTraining.name# 
                                            <cfif LEN(qGetThisTraining.score) AND i EQ 2> 
                                                - Score: #qGetThisTraining.score#
                                            </cfif>
                                            </span>
                                        <cfelse>
                                            <span style="color:##F00;">#qGetThisTraining.name# is required</span>
                                        </cfif>
                                        <br />
                                    </cfloop>
                                <cfelse>
                                    <cfquery name="qGetMissing" datasource="#APPLICATION.DSN#">
                                        SELECT
                                            name
                                        FROM 
                                            applicationlookup 
                                        WHERE
                                            fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                    </cfquery>
                                    <span style="color:##F00;">#qGetMissing.name# is required</span>
                                    <br />
                                </cfif>
                                
                            </cfloop>
                        </td>
                        
                    </tr>
                    
                </cfoutput>
                
            </cfloop>
                    
            </table>
            
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

    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    