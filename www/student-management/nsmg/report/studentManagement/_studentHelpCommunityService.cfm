<!--- ------------------------------------------------------------------------- ----
	
	File:		_studentHelpCommunityService.cfm
	Author:		James Griffiths
	Date:		May 4, 2012
	Desc:		Help Community Service - report by hours
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=studentHelpCommunityService
				
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
		param name="FORM.activityStatus" default="";
		param name="FORM.studentStatus" default="";
		param name="FORM.noHours" default=0;		
		param name="FORM.minHours" default=0;
		param name="FORM.maxHours" default=21;
		param name="FORM.outputType" default="flashPaper";
		
		// Set Report Title To Keep Consistency
		vReportTitle = "Student Management - Help Community Service";
		
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

			<cfscript>
				// Get Programs
				qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
				
				// Get Students
				qGetStudents = APPCFC.STUDENT.getProjectHelpReport(
							userID=CLIENT.userID,					
							regionID=FORM.regionID,
							userType=CLIENT.userType,
							isActive=FORM.studentStatus,
							programID=FORM.programID,
							statusKey = FORM.activityStatus,
							noHours = FORM.noHours,
							minimumHours = FORM.minHours,
							maxHours = FORM.maxHours
						);
			</cfscript>
                    
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

		<!--- Help Community Service Report --->
        <form action="report/index.cfm?action=studentHelpCommunityService" name="helpCommunityService" id="helpCommunityService" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">#vReportTitle#</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                    <td>
                        <select name="programID" id="programID" class="xLargeField" multiple size="6" required>
                            <cfloop query="qGetProgramList"><option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option></cfloop>
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
                    <td class="subTitleRightNoBorder">Activity Status: <span class="required">*</span></td>
                    <td>
                        <select name="activityStatus" id="activityStatus" class="xLargeField">
                            <option value="">All</option>
                            <option value="#APPLICATION.Constants.projectHelpStatus[7]#">Approved Hours by NY Office</option>
                            <option value="#APPLICATION.Constants.projectHelpStatus[5]#">Approved Hours by Regional Manager</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Student Status: <span class="required">*</span></td>
                    <td>
                        <select name="studentStatus" id="studentStatus" class="xLargeField">
                            <option value="">All</option>
                            <option value="1">Active</option>
                            <option value="0">Cancelled</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Options:</td>
                    <td>
                    	<input type="checkbox" name="noHours" id="noHours" />
                    	<label for="noHours">Students W/O Hours</label>
                    </td>
                </tr>                                             
                <tr class="on">
                    <td class="subTitleRightNoBorder">Minimum Hours: <span class="required">*</span></td>
                    <td>
                        <select name="minHours" id="minHours" class="xLargeField" required>
                            <cfloop from="1" to="20" index="i">
                                <option value="#i#">#i#</option>
                            </cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Maximum Hours: <span class="required">*</span></td>
                    <td>
                        <select name="maxHours" id="maxHours" class="xLargeField" required>
                            <cfloop from="1" to="20" index="i">
                                <option value="#i#">#i#</option>
                            </cfloop>
                            <option value="9999" selected="selected">Any</option>
                        </select>
                    </td>		
                </tr>                  
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" id="outputTypeStudentListByRegion" class="xLargeField">
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
                        This report will offer you a list of students, by AR, and the amount of HELP hours each student has completed. 
                        You can also generate a list of students that have not completed any hours so you know who still needs some motivation. 
                        You can export this report into Excel.
                    </td>		
                </tr>
                <tr>
                    <th colspan="2" align="center"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                </tr>
            </table>
        </form>

    </cfoutput>
        
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
        <cfheader name="Content-Disposition" value="attachment; filename=helpCommunityServiceHours.xls"> 
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr>
                <th colspan="5">#vReportTitle#</th>            
            </tr>
            <tr style="font-weight:bold;">
                <td>Region</td>
                <td>Area Representative</td>
                <td>Student</td>
                <td>Program</td>
                <td>Hours</td>
            </tr>      
            
            <cfoutput query="qGetStudents">
            
            	<cfquery name="qGetStudentsUnderAdvisor" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetStudents
                    WHERE
                        1 = 1
                    <!--- Regional Advisors --->
                    <cfif LEN(vListOfAdvisorUsers)>
                        AND
                            (
                                s.areaRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                            OR
                                s.placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                            )
                    </cfif>           
                </cfquery>
                
                <cfscript>
                    // Set Row Color
                    if ( qGetStudents.currentRow MOD 2 ) {
                        vRowColor = 'bgcolor="##E6E6E6"';
                    } else {
                        vRowColor = 'bgcolor="##FFFFFF"';
                    }
                </cfscript>
            
                <tr>
                    <td #vRowColor#>#qGetStudentsUnderAdvisor.regionName#</td>
                    <td #vRowColor#>#qGetStudentsUnderAdvisor.rep_firstName# #qGetStudents.rep_lastName# ###qGetStudents.areaRepID#</td>
                    <td #vRowColor#>#qGetStudentsUnderAdvisor.firstName# #qGetStudents.familyLastName# ###qGetStudents.studentID#</td>
                    <td #vRowColor#>#qGetStudentsUnderAdvisor.programName#</td>
                    <td #vRowColor#>#qGetStudentsUnderAdvisor.hours#</td>
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
                    <tr>
                        <td class="center">
                            <strong>Program(s) included in this report: </strong> <br />
                            <cfloop query="qGetPrograms">
                                #qGetPrograms.programName# <br />
                            </cfloop>
                        </td>
                    </tr>
                    <tr>
                        <td class="center"><strong>Total of #qGetStudents.recordCount# students in this report</strong></td>
                    </tr>
                </table>
                
                <!--- No Records Found --->
                <cfif NOT VAL(qGetStudents.recordCount)>
                    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                        <tr class="on">
                            <td class="subTitleCenter">No records found</td>
                        </tr>      
                    </table>
                    <cfabort>
                </cfif>
                
            </cfoutput>
            
            <!--- Loop Regions ---> 
            <cfloop list="#FORM.regionID#" index="currentRegionID">
        
                <cfquery name="qGetStudentsInRegion" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetStudents
                    WHERE
                        regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currentRegionID#"> 
                    <!--- Regional Advisors --->
                    <cfif LEN(vListOfAdvisorUsers)>
                        AND
                            (
                                s.areaRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                            OR
                                s.placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                            )
                    </cfif>           
                </cfquery>
                
                <cfif qGetStudentsInRegion.recordCount>
                
                    <cfoutput>
                        
                        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif ListGetAt(FORM.regionID, 1) NEQ currentRegionID>style="margin-top:30px;"</cfif>>
                            <tr>
                                <th class="left">#qGetStudentsInRegion.regionName# Region</th>
                                <th class="right note">Total of #qGetStudentsInRegion.recordCount# records</th>
                            </tr>      
                        </table>
                    
                    </cfoutput>                    
    
                    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">      
                        <tr class="on">
                            <td class="subTitleLeft" width="30%" style="font-size:9px">Area Representative</td>
                            <td class="subTitleLeft" width="30%" style="font-size:9px">Student</td>
                            <td class="subTitleLeft" width="20%" style="font-size:9px">Program</td>
                            <td class="subTitleLeft" width="20%" style="font-size:9px">Hours</td>
                        </tr>
                
                        <cfscript>
                            // Set Current Row
                            vCurrentRow = 0;			
                        </cfscript>
                
                        <cfoutput query="qGetStudentsInRegion" group="rep_lastName">
            
                            <!--- Loop Through Query --->
                            <cfoutput>
            
                                <cfscript>
                                    // Set Current Row
                                    vCurrentRow ++;			
                                </cfscript>
                                
                                <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                    <td style="font-size:9px">#qGetStudentsInRegion.rep_firstName# #qGetStudentsInRegion.rep_lastName# ###qGetStudentsInRegion.areaRepID#</td>
                                    <td style="font-size:9px">#qGetStudentsInRegion.firstName# #qGetStudentsInRegion.familyLastName# ###qGetStudentsInRegion.studentID#</td>
                                    <td style="font-size:9px">#qGetStudentsInRegion.programName#</td>
                                    <td style="font-size:9px">#qGetStudentsInRegion.hours#</td>
                                </tr>
                
                            </cfoutput>
                        
                        </cfoutput>
                    
                    </table>
        
                </cfif>
                
            </cfloop>
            
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