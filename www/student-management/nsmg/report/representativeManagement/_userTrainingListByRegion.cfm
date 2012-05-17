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
		param name="FORM.outputType" default="onScreen";
		
		// Get Regions
      	qGetRegions = APPLICATION.CFC.REGION.getRegionsByList(regionIDList=FORM.regionID, companyID=CLIENT.companyID);

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get Training Options
		qGetTrainingOptions = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(applicationID=7,fieldKey='smgUsersTraining');
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
        
            <!--- This gets the total number of representatives that will be displayed --->
            <cfscript>
                vTotalReps = 0;
            </cfscript>
            
            <cfloop query="qGetRegions">
                <cfscript>
                    qGetResults = APPLICATION.CFC.USER.reportTrainingByRegion(regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType,programID=FORM.programID);
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
    
	<cfoutput>

        <form action="report/index.cfm?action=userTrainingListByRegion" name="userTrainingListByRegion" id="userTrainingListByRegion" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">User Training List by Region</th></tr>
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
                            <cfloop query="qGetRegionList"><option value="#qGetRegionList.regionID#">#qGetRegionList.regionname#</option></cfloop>
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
                <th colspan="3">Training Report</th>            
            </tr>
            <tr style="font-weight:bold;">
                <td>Region</td>
                <td>Representative</td>
                <td>Training</td>
            </tr>
            
            <cfscript>
                vCurrentRow = 1;
            </cfscript>
                    
            <cfloop query="qGetRegions">
            
                <cfscript>
                    qGetResults = APPLICATION.CFC.USER.reportTrainingByRegion(regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType,programID=FORM.programID);
                </cfscript>
                
                <cfoutput query="qGetResults">
                    
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
                        <td bgcolor="#vRowColor#">#qGetResults.regionName#</td>
                        <td bgcolor="#vRowColor#">#qGetResults.firstName# #qGetResults.lastName# ###qGetResults.userID#</td>
                        <td bgcolor="#vRowColor#">
                            <cfif LEN(qGetResults.date_trained)>
                                Date: #DateFormat(qGetResults.date_trained, 'mm/dd/yyyy')# - #qGetResults.trainingName#
                                <cfif LEN(qGetResults.score)> 
                                    - Score: #qGetResults.score#
                                </cfif>
                            </cfif>
                        </td>
                    </tr>
                    
                </cfoutput>
                
            </cfloop>
                           
        </table>    
    
    <!--- On Screen Report --->
    <cfelse>
    
        <cfoutput>
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th width="33%"></th>
                    <th class="center" width="34%"> Training Report</th>
                    <th class="right" width="33%">#vTotalReps# Total Representatives</th>
                </tr>
                <tr>
                    <td class="center" colspan="3">
                        Program(s) included in this report: <br />
                        <cfloop query="qGetPrograms">
                            #qGetPrograms.programName# <br />
                        </cfloop>
                    </td>
                </tr>
            </table>
        </cfoutput>
        
        <!--- Loopt through regions --->
        <cfloop query="qGetRegions">
        
            <cfscript>
                qGetResults = APPLICATION.CFC.USER.reportTrainingByRegion(regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType,programID=FORM.programID);
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
                        <th class="left">#qGetResults.regionName# Region</th>
                        <th class="right">#qTotalInRegion.recordCount# Representatives</th>
                    </tr>
                    <tr>
                        <td class="subTitleLeft" width="50%">Representative</td>
                        <td class="subTitleLeft" width="50%">Training</td>
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
                    <td>#qGetResults.firstName# #qGetResults.lastName# ###qGetResults.userID#</td>
                    <td>
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
                
            </cfoutput>
                
            </table>
                    
        </cfloop>
            
    </cfif>

    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    