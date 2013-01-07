<!--- ------------------------------------------------------------------------- ----
	
	File:		_studentProgressReport.cfm
	Author:		James Griffiths
	Date:		May 30, 2012
	Desc:		Student Progress Report
	
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=studentProgressReport

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
		param name="FORM.regionID" default="";
		param name="FORM.monthID" default="";
		param name="FORM.status" default="approved";
		param name="FORM.outputType" default="flashPaper";

		// Set Report Title To Keep Consistency
		vReportTitle = "Student Management - Progress Report";

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get Regions
		qGetRegions = APPLICATION.CFC.REGION.getRegions(regionIDList=FORM.regionID);
	</cfscript>	

    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>

        <cfscript>
			/*
				REPORTS PER PROGRAM
				10 MONTH - OCT - DEC - FEB - APRIL - JUNE - TYPE = 1
				12 MONTH - FEB - APRIL - AUG - OCT - DEC - TYPE = 2
				1ST SEMESTER - OCT - DEC - FEB - TYPE = 3
				2ND SEMESTER - FEB - APRIL - JUNE - TYPE = 4
				
				10 MONTH PRIVATE - PROGRAM END DATE 06/31
				12 MONTH PRIVATE - PROGRAM END DATE 12/31
				1ST SEMESTER PRIVATE - PROGRAM END DATE 06/31
				2ND SEMESTER PRIVATE - PROGRAM END DATE 01/15
			*/
	
			// 10 month
			FORM.prtype1 = "10,12,2,4,6"; 
			// 12 month
			FORM.prtype2 = "2,4,8,10,12";
			// 1st semester
			FORM.prtype3 = "10,12,2";
			// 2nd semester
			FORM.prtype4 = "2,4,6";
			// J1 Private Program - Various in lenght (Deprecated)
			FORM.prtype5 = "";
		
			// Stores list of user IDs that are supervised by an Advisor
			vListOfAdvisorUsers = '';
		
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
			
			// Month
            if ( NOT VAL(FORM.monthID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one month");
            }
		</cfscript>

        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>
        
			<cfscript>
				// Get List of Users Under Advisor and the Advisor self
				if ( CLIENT.usertype EQ 6 ) {
			
					// Get Available Reps
					qGetUserUnderAdv = APPLICATION.CFC.USER.getSupervisedUsers(userType=CLIENT.userType, userID=CLIENT.userID, regionIDList=FORM.regionID);
					
					// Store Users under Advisor on a list
					vListOfAdvisorUsers = ValueList(qGetUserUnderAdv.userid, ',');
	
				}
			</cfscript>
        
            <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                SELECT 
                    s.studentid, 
                    s.firstname, 
                    s.familylastname,
                    s.regionAssigned, 
                    p.type, 
                    p.programname, 
                    p.startdate, 
                    p.enddate,
                    u.userID,
                    u.firstname AS userFirstName, 
                    u.lastname AS userLastName
                FROM 
                    smg_students s
                INNER JOIN 
                    smg_programs p ON p.programid = s.programid
                INNER JOIN 
                    smg_users u ON u.userid = s.arearepid
                WHERE 
                    s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND 
                    s.hostid != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                AND 
                    s.regionassigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                AND 
                    s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )

                <!--- Regional Advisors --->
                <cfif LEN(vListOfAdvisorUsers)>
                    AND
                        (
                       		s.areaRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                        OR
                     		s.placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                        )
                </cfif>		

                <!--- Area Reps --->                 
                <cfif CLIENT.usertype EQ 7>
                    AND 
                        s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#"> 
                </cfif>
                    
                ORDER BY 
                    u.lastname, 
                    s.familylastname
            </cfquery>
            
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=studentProgressReports" name="studentProgressReports" id="studentProgressReports" method="post" target="blank">
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
                    <td class="subTitleRightNoBorder">Month: <span class="required">*</span></td>
                    <td>
                    	<select name="monthID" id="monthID" class="xLargeField" multiple size="6">
                            <option value="10">Aug &amp; Sep - due Oct 1st</option>		
                            <option value="12">Oct &amp; Nov - due Dec 1st</option>
                            <option value="2">Dec &amp; Jan - due Feb 1st</option>
                            <option value="4">Feb &amp; Mar - due Apr 1st</option>
                            <option value="6">Apr &amp; May - due Jun 1st</option>
                            <option value="8">Jun &amp; Jul - due Aug 1st</option>
                        </select>
                    </td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Status: <span class="required">*</span></td>
                    <td>
                    	<select name="status" id="status" class="xLargeField">
                            <option value="approved">Approved</option>
                            <option value="notApproved">Not Approved</option>
                            <option value="missing">Missing</option>
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
                        This report will provide you with a list, by student, of any relocation information. 
                    </td>		
                </tr>
                <tr>
                    <th colspan="2" align="center"><input type="image" src="pics/view.gif" align="center" border="0"> </th>
                </tr>
            </table>
        </form>            

	</cfoutput>

<!--- FORM SUBMITTED --->
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
        <cfheader name="Content-Disposition" value="attachment; filename=studetn_progress_reports.xls">
         
      	 <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
      		<tr>
                <th colspan="5">#vReportTitle#</th>            
            </tr>
            <tr style="font-weight:bold;">
                <td>Region</td>
                <td>Supervising Representative</td>
                <td>Student</td>
                <td>Program</td>
                <td>
                	<cfif FORM.status EQ "missing">
                        Missing Report(s)
                    <cfelseif FORM.status EQ "notApproved">
                        Completed Report(s) - awaiting approval
                    <cfelse>
                        Completed Report(s) - approved
                    </cfif>
                </td>
            </tr>
            
            <cfscript>
				vCurrentRow = 0;
			</cfscript>
       		
            <!--- Loop Regions ---> 
        	<cfloop query="qGetRegions">
            	
                <cfquery name="qGetStudentsInRegion" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetResults
                    WHERE
                        regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#">               
                </cfquery>
                
                <cfoutput query="qGetStudentsInRegion">
                
                	<cfscript>
						// This will store a list of missing reports
						vMissingReportsList = '';
	
						// J1 Private Program - select which reports are required
						if ( qGetStudentsInRegion.type EQ 5 ) {
							
							if ( Month(qGetStudentsInRegion.enddate) EQ 6 AND DateDiff("m", qGetStudentsInRegion.startdate, qGetStudentsInRegion.enddate) EQ 10 ) {
								// 10 Month Program
								FORM.prtype5 = FORM.prtype1;
							} else if ( Month(qGetStudentsInRegion.enddate) EQ 6 AND DateDiff("m", qGetStudentsInRegion.startdate, qGetStudentsInRegion.enddate) EQ 5) {
								// 2nd Semester Program
								FORM.prtype5 = FORM.prtype4;
							} else if ( Month(qGetStudentsInRegion.enddate) EQ 12 ) {
								// 12 Month Program
								FORM.prtype5 = FORM.prtype2; 
							} else if ( Month(qGetStudentsInRegion.enddate) EQ 1 ) {
								// 1st Semester Program
								FORM.prtype5 = FORM.prtype3;
							}
							
						}
					</cfscript>
                    
                    <cfloop list="#FORM.monthID#" index="i">
						
						<cfquery name="qGetmonthID" datasource="#APPLICATION.DSN#">
							SELECT DISTINCT 
								fk_student,
                                pr_ny_approved_date 
							FROM
								progress_reports 
							WHERE 
								fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsInRegion.studentid#">
							AND 
								pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
						</cfquery>
						
						<cfscript>
						
							if ( FORM.status EQ "missing") {
								if ( NOT VAL(qGetmonthID.recordCount) AND (ListLast(FORM.monthID) NEQ i) ) {
									vMissingReportsList = vMissingReportsList & MonthAsString(i) & ", &nbsp;";	
								} else if ( NOT VAL(qGetmonthID.recordCount) ) {
									vMissingReportsList = vMissingReportsList & MonthAsString(i);
								}
							} else if (FORM.status EQ "approved") {
								if ( VAL(qGetmonthID.recordCount) AND (qGetMonthID.pr_ny_approved_date NEQ "") ) {
									if ( VAL(qGetmonthID.recordCount) AND (ListLast(FORM.monthID) NEQ i) ) {
										vMissingReportsList = vMissingReportsList & MonthAsString(i) & ", &nbsp;";	
									} else if ( VAL(qGetmonthID.recordCount) ) {
										vMissingReportsList = vMissingReportsList & MonthAsString(i);
									}
								}
							} else {
								if ( VAL(qGetmonthID.recordCount) AND (qGetMonthID.pr_ny_approved_date EQ "") ) {
									if ( VAL(qGetmonthID.recordCount) AND (ListLast(FORM.monthID) NEQ i) ) {
										vMissingReportsList = vMissingReportsList & MonthAsString(i) & ", &nbsp;";	
									} else if ( VAL(qGetmonthID.recordCount) ) {
										vMissingReportsList = vMissingReportsList & MonthAsString(i);
									}
								}
							}							
						</cfscript>
						
					</cfloop>
                    
                    <cfif LEN(vMissingReportsList)>
                    
                    	<cfscript>
							// Set the current row
							vCurrentRow++;
							
							if ( vCurrentRow MOD 2 ) {
								vRowColor = 'bgcolor="##E6E6E6"';
							} else {
								vRowColor = 'bgcolor="##FFFFFF"';
							}
						</cfscript>
                            
                        <tr>
                        	<td #vRowColor#>#qGetRegions.regionName#</td>
                            <td #vRowColor#>#qGetStudentsInRegion.userFirstName# #qGetStudentsInRegion.userLastName# (###qGetStudentsInRegion.userID#)</td>
                            <td #vRowColor#>#qGetStudentsInRegion.firstname# #qGetStudentsInRegion.familylastname# (###qGetStudentsInRegion.studentID#)</td>
                            <td #vRowColor#>#qGetStudentsInRegion.programname#</td>
                            <td #vRowColor#>#vMissingReportsList#</td>
                        </tr>
                                
          			</cfif>
                
                </cfoutput>
                
            </cfloop>
    
    <!--- On Screen Report --->
    <cfelse>
    
        <cfsavecontent variable="report">
    
    		<!--- Page Header --->
            <gui:pageHeader
                headerType="applicationNoHeader"
                filePath="../"
            />
    
			<cfoutput>
            
                <!--- Run Report --->
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th>#vReportTitle#</th>            
                    </tr>
                    <tr>
                        <td class="center">
                            Program(s) included in this report: <br />
                            <cfloop query="qGetPrograms">
                                #qGetPrograms.programName# <br />
                            </cfloop>
                        </td>
                    </tr>
                </table><br />
                
            </cfoutput>
        
			<cfscript>
                vCurrentRow = 0;
            </cfscript>
                
			<!--- Loop Regions ---> 
            <cfloop query="qGetRegions">
            
                <cfscript>
                    vCurrentRow = 0;
                </cfscript>
            
                <cfscript>
                    // Get Regional Manager
                    qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=qGetRegions.regionID);
                    
                    // Set the current row to 0 
                    vCurrentRow = 0;
                </cfscript>
        
                <cfquery name="qGetStudentsInRegion" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetResults
                    WHERE
                        regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#">               
                </cfquery>
                
                <!--- DETERMINE HOW MANY STUDENTS WILL BE DISPLAYED --->
                <cfscript>
                    vStudentCount = 0;
                </cfscript>
                <cfloop query="qGetStudentsInRegion">
                    <cfscript>
                        vMonthCount = 0;
                    </cfscript>
                    <cfloop list="#FORM.monthID#" index="i">
                        <cfquery name="qGetmonthID" datasource="#APPLICATION.DSN#">
                            SELECT DISTINCT 
                                fk_student,
                                pr_ny_approved_date 
                            FROM
                                progress_reports 
                            WHERE 
                                fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsInRegion.studentid#">
                            AND 
                                pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                        </cfquery>
                        <cfscript>
                            if ( FORM.status EQ "missing") {
                                if ( NOT VAL(qGetmonthID.recordCount) )
                                    vMonthCount++;
                            } else if (FORM.status EQ "approved") {
                                if ( VAL(qGetmonthID.recordCount) AND (qGetMonthID.pr_ny_approved_date NEQ "") )
                                    vMonthCount++;
                            } else {
                                if ( VAL(qGetmonthID.recordCount) AND (qGetMonthID.pr_ny_approved_date EQ "") )
                                    vMonthCount++;
                            }
                        </cfscript>
                    </cfloop>
                    <cfscript>
                        if (vMonthCount > 0)
                            vStudentCount++;
                    </cfscript>
                </cfloop>
                <!------>
            
				<!--- Only display if there are records in this region --->
                <cfif VAL(qGetStudentsInRegion.recordCount)>
                
                    <cfoutput>
                        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                            <tr>
                                <th class="left" colspan="3">#qGetRegions.regionName# Region - #qGetRegionalManager.firstName# #qGetRegionalManager.lastName# (###qGetRegionalManager.userID#)</th>
                                <th class="right"><span id="qGetRegions.regionID"></span> #vStudentCount# Students</th>
                            </tr>      
                            <tr class="on">
                                <td class="subTitleLeft" width="20%" style="font-size:9px">Supervising Representative</td>
                                <td class="subTitleLeft" width="20%" style="font-size:9px">Student</td>
                                <td class="subTitleLeft" width="20%" style="font-size:9px">Program</td>
                                <td class="subTitleLeft" width="40%" style="font-size:9px">
                                    <cfif FORM.status EQ "missing">
                                        Missing Report(s)
                                    <cfelseif FORM.status EQ "notApproved">
                                        Completed Report(s) - awaiting approval
                                    <cfelse>
                                        Completed Report(s) - approved
                                    </cfif>
                                </td>
                            </tr>  
                    </cfoutput>
                    
                    <cfoutput query="qGetStudentsInRegion">      
                            
                        <cfscript>
                            // This will store a list of missing reports
                            vMissingReportsList = '';
        
                            // J1 Private Program - select which reports are required
                            if ( qGetStudentsInRegion.type EQ 5 ) {
                                
                                if ( Month(qGetStudentsInRegion.enddate) EQ 6 AND DateDiff("m", qGetStudentsInRegion.startdate, qGetStudentsInRegion.enddate) EQ 10 ) {
                                    // 10 Month Program
                                    FORM.prtype5 = FORM.prtype1;
                                } else if ( Month(qGetStudentsInRegion.enddate) EQ 6 AND DateDiff("m", qGetStudentsInRegion.startdate, qGetStudentsInRegion.enddate) EQ 5) {
                                    // 2nd Semester Program
                                    FORM.prtype5 = FORM.prtype4;
                                } else if ( Month(qGetStudentsInRegion.enddate) EQ 12 ) {
                                    // 12 Month Program
                                    FORM.prtype5 = FORM.prtype2; 
                                } else if ( Month(qGetStudentsInRegion.enddate) EQ 1 ) {
                                    // 1st Semester Program
                                    FORM.prtype5 = FORM.prtype3;
                                }
                                
                            }
                        </cfscript>
                    
                        <cfloop list="#FORM.monthID#" index="i">
                            
                            <cfquery name="qGetmonthID" datasource="#APPLICATION.DSN#">
                                SELECT DISTINCT 
                                    fk_student,
                                    pr_ny_approved_date 
                                FROM
                                    progress_reports 
                                WHERE 
                                    fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsInRegion.studentid#">
                                AND 
                                    pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                            </cfquery>
                            
                            <cfscript>
                            
                                if ( FORM.status EQ "missing") {
                                    if ( NOT VAL(qGetmonthID.recordCount) AND (ListLast(FORM.monthID) NEQ i) ) {
                                    vMissingReportsList = vMissingReportsList & MonthAsString(i) & ", &nbsp;";	
                                    } else if ( NOT VAL(qGetmonthID.recordCount) ) {
                                        vMissingReportsList = vMissingReportsList & MonthAsString(i);
                                    }
                                } else if (FORM.status EQ "approved") {
                                    if ( VAL(qGetmonthID.recordCount) AND (qGetMonthID.pr_ny_approved_date NEQ "") )
                                        if ( VAL(qGetmonthID.recordCount) AND (ListLast(FORM.monthID) NEQ i) ) {
                                        vMissingReportsList = vMissingReportsList & MonthAsString(i) & ", &nbsp;";	
                                        } else if ( VAL(qGetmonthID.recordCount) ) {
                                            vMissingReportsList = vMissingReportsList & MonthAsString(i);
                                        }
                                } else {
                                    if ( VAL(qGetmonthID.recordCount) AND (qGetMonthID.pr_ny_approved_date EQ "") )
                                        if ( VAL(qGetmonthID.recordCount) AND (ListLast(FORM.monthID) NEQ i) ) {
                                        vMissingReportsList = vMissingReportsList & MonthAsString(i) & ", &nbsp;";	
                                        } else if ( VAL(qGetmonthID.recordCount) ) {
                                            vMissingReportsList = vMissingReportsList & MonthAsString(i);
                                        }
                                }							
                            </cfscript>
                            
                        </cfloop>
                          
                        <cfif LEN(vMissingReportsList)>  
                        
                            <cfscript>
                                vCurrentRow++;
                            </cfscript>
                          
                            <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                <td style="font-size:9px">#qGetStudentsInRegion.userFirstName# #qGetStudentsInRegion.userLastName# (###qGetStudentsInRegion.userID#)</td>
                                <td style="font-size:9px">#qGetStudentsInRegion.firstname# #qGetStudentsInRegion.familylastname# (###qGetStudentsInRegion.studentID#)</td>
                                <td style="font-size:9px">#qGetStudentsInRegion.programname#</td>
                                <td style="font-size:9px">#vMissingReportsList#</td>
                            </tr>
                                    
                        </cfif>
                        
                    </cfoutput>
                    
                    <cfoutput>
                        </table>
                    </cfoutput>
                    
                </cfif>
    
        	</cfloop>
            
      	</cfsavecontent>
		
		<cfif FORM.outputType EQ "flashPaper">
    		<cfdocument format="flashpaper" orientation="portrait" backgroundvisible="yes" overwrite="yes" fontembed="yes" margintop="0.3" marginright="0.2" marginbottom="0.3" marginleft="0.2">
        		<cfoutput>#report#</cfoutput>
        	</cfdocument>    
   		<cfelse>
			<cfoutput>#report#</cfoutput>                    
   		</cfif>
    
    </cfif>
    
    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    