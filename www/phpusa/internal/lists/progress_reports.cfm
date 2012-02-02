<!--- ------------------------------------------------------------------------- ----
	
	File:		progress_reports.cfm
	Author:		Marcus Melo
	Date:		January 27, 2012
	Desc:		

	Updated:  
	
	Program Type	Reports
	1st Semester	September / December
	2nd Semester	February / April / June
	10 Month		September / December / February / April / June
	12 Month		September / December / February / April / June												
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.isCancelled" default="0">
    <cfparam name="FORM.reportMonth" default="0">

    <!--- Param CLIENT Variables --->
    <cfparam name="CLIENT.programID" default="">
    <cfparam name="CLIENT.isCancelled" default="0">
    <cfparam name="CLIENT.reportMonth" default="0">
    
    <cfscript>
		// Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(isActive=1,companyID=CLIENT.companyID);	
		
		vDateLimit = DateFormat(DateAdd('m', -2, now()),'yyyy-mm-dd');

		// Set CLIENT variables
		IF ( VAL(FORM.submitted) ) {
			CLIENT.programID = FORM.programID;
			CLIENT.isCancelled = FORM.isCancelled;
			CLIENT.reportMonth = FORM.reportMonth;
		}
		
		if ( VAL(CLIENT.reportMonth) ) {
			FORM.submitted = 1;	
		}
	</cfscript>

	<!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
		
        <cfscript>    
			// Could Not find Student
			if ( NOT VAL(CLIENT.reportMonth) ) {
				// Set Page Message
				SESSION.formErrors.Add("Please select a month");
			}
    	</cfscript>
        
        <!--- No Errors --->
        <cfif NOT SESSION.formErrors.length()>
        
			<!--- 
                the student supervising rep (php_students_in_program.arearepid) and the school supervising rep (php_schools.supervising_rep) are normally the same
                as the ones in the report (progress_reports.fk_sr_user & fk_ssr_user) but since we want to display students without reports, we can't use the report fields here.
                But in the output below we use the report fields where a report has been submitted, otherwise use the student and user fields. 
            --->
            <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                SELECT 
                    s.studentid, 
                    s.firstname, 
                    s.familylastname, 
                    php.assignedid,
                    php.arearepid,
                    rep.firstname AS rep_firstname, 
                    rep.lastname AS rep_lastname,
                    suNY.userid AS facilitatorID, 
                    suNY.firstname AS facilitatorFirstName, 
                    suNY.lastname AS facilitatorLastName,
                    p.programid, 
                    p.programname, 
                    p.startdate,
                    spt.sept_report, 
                    spt.dec_report, 
                    spt.feb_report, 
                    spt.april_report, 
                    spt.june_report
                FROM 
                    smg_students s
                INNER JOIN 
                    php_students_in_program php ON s.studentid = php.studentid
                INNER JOIN 
                    smg_users rep ON php.arearepid = rep.userid
                INNER JOIN 
                    php_schools ON php.schoolid = php_schools.schoolid
                LEFT JOIN 
                    smg_users suNY ON php_schools.supervising_rep = suNY.userid
                INNER JOIN 
                    smg_programs p ON php.programid = p.programid
                INNER JOIN 
                    smg_program_type spt ON p.type = spt.programtypeid
                WHERE 
                    php.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                AND 
                    p.progress_reports_active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    p.fieldviewable = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            
                <cfif VAL(CLIENT.programID)>
                    AND
                        php.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.programID#">
                </cfif>
                    
                <cfif NOT VAL(CLIENT.isCancelled)>
                    AND 
                        php.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                <cfelse>
                    AND 
                        php.canceldate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vDateLimit#">
                </cfif>
                
                <!--- these users see only students who they are the supervising rep of, or school supervising rep. --->
                <cfif CLIENT.usertype GT 4>
                    AND (
                            php.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                        OR 
                            php_schools.supervising_rep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                        )
                </cfif>
                
                <!--- include the suNYID and arearepid because we're grouping by those in the output, just in case two have the same first and last name. --->
                ORDER BY 
                    facilitatorLastName, 
                    facilitatorFirstName, 
                    rep_lastname, 
                    rep_firstname, 
                    s.familylastname, 
                    s.firstname, 
                    p.startdate DESC
            </cfquery>
    	
        <cfelse>
        
        	<cfscript>
				// There is an error, set FORM as not submitted
				FORM.submitted = 0;
			</cfscript>        
        
        </cfif> <!--- Errors --->
        
    </cfif> <!--- Submitted --->

	<!---
	<cfif NOT VAL(CLIENT.reportMonth)>
    
        <cfswitch expression="#month(now())#">
        	
			<!--- SEPT --->
            <cfcase value="7,8,9">
                <cfset CLIENT.reportMonth = 9>
            </cfcase>
            
            <!--- DEC --->
            <cfcase value="10,11,12">
                <cfset CLIENT.reportMonth = 12>
            </cfcase>
            
            <!--- FEB --->
            <cfcase value="1,2">
                <cfset CLIENT.reportMonth = 2>
            </cfcase>
            
            <!--- APRIL --->
            <cfcase value="3,4">
                <cfset CLIENT.reportMonth = 4>
            </cfcase>
            
            <!--- JUNE --->
            <cfcase value="5,6">
                <cfset CLIENT.reportMonth = 6>
            </cfcase>
            
        </cfswitch>
        
    </cfif>
	--->

	<!--- set the corresponding database field used in the output. --->
    <cfswitch expression="#CLIENT.reportMonth#">
    
        <cfcase value="9">
            <cfset dbfield = 'sept_report'>
        </cfcase>
        
        <cfcase value="12">
            <cfset dbfield = 'dec_report'>
        </cfcase>
        
        <cfcase value="2">
            <cfset dbfield = 'feb_report'>
        </cfcase>
        
        <cfcase value="4">
            <cfset dbfield = 'april_report'>
        </cfcase>
        
        <cfcase value="6">
            <cfset dbfield = 'june_report'>
        </cfcase>
    
    </cfswitch>

</cfsilent>

<cfif not CLIENT.usertype LTE 7>
	You do not have access to this page.
    <cfabort>
</cfif>

<style type="text/css">
	<!--
	.school_rep {
		font-size: 14px;
		font-weight: bold;
		background-image: url(images/back_menu2.gif);
		height: 26px;
	}
	-->
</style>

<table width="95%" align="center">
	<tr>
		<td>

			<!--- Page Messages --->
            <gui:displayPageMessages 
                pageMessages="#SESSION.pageMessages.GetCollection()#"
                messageType="onlineApplication"
                width="98%"
                />
            
            <!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="onlineApplication"
                width="98%"
                />
			
            <!---
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td><font size="4"><strong>Progress Reports</strong></font></td>
					<td align="right"><a href="index.cfm?curdoc=lists/agent_approve_list">Progress Reports submitted prior to 09/16/2009</a></td>
				</tr>
			</table>
			--->

            <cfform action="index.cfm?curdoc=lists/progress_reports" method="post">
            	<input name="submitted" type="hidden" value="1">
                <table cellpadding="4" cellspacing="4" width="100%" style="border:1px solid #343366; margin:10px 0px 10px 0px; padding:5px;">
                    <tr>
                        <td>
                            <strong>Program</strong><br />
                            <cfselect name="programID" query="qGetProgramList" value="programid" display="programname" selected="#CLIENT.programID#" queryPosition="below" class="largeField">
                            	<option value="">All</option>
                            </cfselect>
                        </td>
                        <td>
                            <strong>Month</strong><br />
                            <select name="reportMonth" class="largeField">
                            	<option value="0" <cfif CLIENT.reportMonth EQ 0>selected</cfif>>Select a Month</option>
                                <option value="9" <cfif CLIENT.reportMonth EQ 9>selected</cfif>>September</option>
                                <option value="12" <cfif CLIENT.reportMonth EQ 12>selected</cfif>>December</option>
                                <option value="2" <cfif CLIENT.reportMonth EQ 2>selected</cfif>>February</option>
                                <option value="4" <cfif CLIENT.reportMonth EQ 4>selected</cfif>>April</option>
                                <option value="6" <cfif CLIENT.reportMonth EQ 6>selected</cfif>>June</option>
                            </select>            
                        </td>
                        <td>
                            <strong>Status</strong><br />
                            <select name="isCancelled" class="largeField">
                                <option value="0" <cfif CLIENT.isCancelled EQ 0>selected</cfif>>Active</option>
                                <option value="1" <cfif CLIENT.isCancelled EQ 1>selected</cfif>>Cancelled</option>
                            </select>            
                        </td>
                        <td><input name="send" type="submit" value="Submit" /></td>
                    </tr>
                    <cfif NOT VAL(FORM.submitted)>
                        <tr><th colspan="4"><h3>Please select a month and click on SUBMIT</h3></th></tr>
                    </cfif>
                </table>
            </cfform>

			<!--- FORM Submitted --->
            <cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>

				<cfif VAL(qGetResults.recordCount)>
                
					<!--- get the reports, used in a query of query below, because LEFT JOIN is too slow in mySQL. --->
                    <cfquery name="qGetAllReports" datasource="#APPLICATION.DSN#">
                        SELECT 
                        	*
                        FROM 
                        	progress_reports
                        WHERE 
                        	fk_student IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#valueList(qGetResults.studentid)#" list="yes"> )
                        AND 
                        	pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.reportMonth#">
                    </cfquery>
                    
                    <table width="100%" cellspacing="2" cellpadding="2" border="0">
						<cfoutput query="qGetResults" group="facilitatorID">
							
							<cfif currentRow NEQ 1>
                                <tr>
                                	<td colspan="9" height="25">&nbsp;</td>
                                </tr>
                            </cfif>
                            
                            <tr>
                                <td colspan="9" class="school_rep">
                                    <cfif NOT LEN(qGetResults.facilitatorID)>
                                        &nbsp; Reports Directly to NY
                                    <cfelse>
                                        &nbsp; #qGetResults.facilitatorFirstName# #qGetResults.facilitatorLastName# (###qGetResults.facilitatorID#)
                                    </cfif>
                                </td>
                            </tr>
                            
                            <cfoutput group="arearepid">
                                <tr>
                                    <th colspan="9" align="left" bgcolor="##CCCCCC">&nbsp;#rep_firstname# #rep_lastname# (#arearepid#)</th>
                                </tr>                               
                                <tr style="font-weight:bold;">
                                    <td width="15">&nbsp;</td>
                                    <td>Student</td>
                                    <td>Program</td>
                                    <td>Submitted</td>
                                    <td>Action</td>
                                    <td align="center">SR Approved</td>
                                    <td align="center">SSR Approved</td>
                                    <td align="center">NY Approved</td>
                                    <td align="center">Rejected</td>
                                </tr>
                                
                            	<cfset vCurrentRow = 0>
                            
								<cfoutput>
                                
                                    <cfquery name="qGetStudentReport" dbtype="query">
                                        SELECT 
                                        	*
                                        FROM 
                                        	qGetAllReports
                                        WHERE 
                                        	fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.studentID#">
                                        AND 
                                        	fk_program = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.programID#">
                                    </cfquery>
                                    
									<cfset vCurrentRow = vCurrentRow + 1>
                                    
                                    <tr <cfif vCurrentRow MOD 2>bgcolor="##ffffff"</cfif>>
                                        <td>&nbsp;</td>
                                        <td>
											<!--- put in red if user is the supervising rep for this student. --->
                                            <cfif arearepid EQ CLIENT.userid>
                                            	<font color="FF0000"><strong>#qGetResults.firstname# #qGetResults.familylastname# (###qGetResults.studentid#)</strong></font>
                                            <cfelse>
                                            	#qGetResults.firstname# #qGetResults.familylastname# (###qGetResults.studentid#)
                                            </cfif>
                                        </td>
                                        <td>#qGetResults.programname#</td>
                                        <td>#yesNoFormat(qGetStudentReport.recordCount)#</td>
                                        <!--- these <td>'s are separate because the add form needs to be outside them. --->
                                        <cfif qGetStudentReport.recordCount>
											
											<!--- access is limited to: CLIENT.usertype LTE 4, supervising rep, school supervising rep, and NY. --->
                                            <cfif CLIENT.usertype LTE 4 or listFind("#qGetStudentReport.fk_sr_user#,#qGetStudentReport.fk_ssr_user#,#qGetStudentReport.fk_ny_user#", CLIENT.userid)>
												
												<!--- restrict view of report until the supervising rep approves it. --->
                                                <cfif qGetStudentReport.pr_sr_approved_date EQ '' and qGetStudentReport.fk_sr_user NEQ CLIENT.userid>
                                        
                                                    <td>Pending</td>
                                                    
                                        		<cfelse>
                                                
                                                    <form action="index.cfm?curdoc=lists/progress_report_info" method="post" name="theForm_#qGetStudentReport.pr_id#" id="theForm_#qGetStudentReport.pr_id#">
                                                        <input type="hidden" name="pr_id" value="#qGetStudentReport.pr_id#">
                                                    </form>
                                                
                                                    <td><a href="javascript:document.theForm_#qGetStudentReport.pr_id#.submit();">View</a></td>
                                        		
												</cfif>
                                        
											<cfelse>
                                            
                                        		<td>N/A</td>
                                       		
											</cfif>
                                        
										<!--- add report link --->
                                        <cfelse>

											<cfscript>
                                                // Set Previous Report Month
                                                vPreviousReportMonth = 0;
												vIsPreviousReportApproved = 0;
                                                
                                                switch(CLIENT.reportMonth) {
                                                    case "12":
                                                        vPreviousReportMonth = 9;
                                                        break;
                        
                                                    case "2":
                                                        vPreviousReportMonth = 12;
                                                        break;
                        
                                                    case "4":
                                                        vPreviousReportMonth = 2;
                                                        break;
                        
                                                    case "6":
                                                        vPreviousReportMonth = 4;
                                                        break;
                                                }
												
												// There is no previous report - allow entering a new one
												if ( NOT VAL(vPreviousReportMonth) ) {
													vIsPreviousReportApproved = 1;	
												}
                                            </cfscript>
                                                
											<!--- Check if previous report has been submitted --->
                                            <Cfquery name="qGetPreviousReport" datasource="#APPLICATION.DSN#">
                                                SELECT 
                                                    pr_ny_approved_date 
                                                FROM 
                                                    progress_reports
                                                WHERE 
                                                    fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                                                AND 
                                                    fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.studentid#">
                                                AND 
                                                    pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vPreviousReportMonth)#">
                                            	AND
                                                	fk_sr_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.arearepid#">
                                            </cfquery>
                                        
                                            <cfscript>
                                                // There is an approved previous report - allow entering a new one
                                                if ( isDate(qGetPreviousReport.pr_ny_approved_date) ) {
                                                    vIsPreviousReportApproved = 1;	
                                                }
                                            </cfscript>
                                                    
                                        	<td>
												<!--- to add a progress report, user must be the supervising rep, and the program has a report for this phase. --->
                                                <cfif arearepid EQ CLIENT.userid AND EVALUATE(dbfield) AND VAL(vIsPreviousReportApproved)>
                                                    <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                                        <input type="hidden" name="assignedid" value="#assignedid#">
                                                        <input type="hidden" name="month_of_report" value="#CLIENT.reportMonth#">
                                                        <input name="Submit" type="image" src="pics/new.gif" alt="Add New Report" border="0">
                                                    </form>
                                                <!---
												<cfelseif VAL(vPreviousReportMonth) AND NOT VAL(qGetPreviousReport.recordCount)>
													<span style="color:##F00">
                                                    	Previous report is MISSING. You must submit #MonthAsString(vPreviousReportMonth)# report prior to #MonthAsString(CLIENT.reportMonth)# report.
                                                    </span>
												--->
												<cfelseif VAL(vPreviousReportMonth) AND NOT VAL(vIsPreviousReportApproved)>
													Waiting on #MonthAsString(vPreviousReportMonth)# report approval. Once previous report is approved you will be able to create #MonthAsString(CLIENT.reportMonth)# report.				                                                    
                                                <cfelse>
                                                    N/A
                                                </cfif>
                                            </td>
                                            
                                        </cfif>
                                        
                                        <td align="center">#dateFormat(qGetStudentReport.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                                        <td align="center">
											<cfif facilitatorID EQ ''>
                                                N/A
                                            <cfelse>
                                                #dateFormat(qGetStudentReport.pr_ssr_approved_date, 'mm/dd/yyyy')#
                                            </cfif>
                                        </td>
                                        <td align="center">#dateFormat(qGetStudentReport.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                                        <td align="center">#dateFormat(qGetStudentReport.pr_rejected_date, 'mm/dd/yyyy')#</td>
                                    </tr>
                            	</cfoutput> <!--- Students --->
                                
                            </cfoutput> <!--- Area Rep --->
                            
                        </cfoutput> <!--- NY Office --->
                    </table>
                    
                    <br />
                    
                    <table width="100%">
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                	    <td class="school_rep" width="26">&nbsp;</td>
                                    	<td>School Supervising Rep</td>
                                    </tr>
                                </table>
                        	</td>
                        	<td>
                        		<table>
                                    <tr>
                                        <td bgcolor="#CCCCCC" width="15">&nbsp;</td>
                                        <td>Supervising Rep</td>
                                    </tr>
                                </table>
                        	</td>
                        	<td><font color="FF0000"><strong>Students that you're supervising</strong></font></td>
                        </tr>
                    </table>
                
                <cfelse>
                
                    <table border="0" cellpadding="4" cellspacing="0" width="100%">
                        <tr><th><h3>No progress reports matched your criteria.</h3></th></tr>
                    </table>
                
                </cfif>

            </cfif>
            
		</td>
	</tr>
</table>