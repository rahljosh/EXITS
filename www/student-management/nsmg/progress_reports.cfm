<!--- ------------------------------------------------------------------------- ----
	
	File:		progress_reports.cfm
	Author:		Marcus Melo
	Date:		February 2, 2012
	Desc:		Progress Reports

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param CLIENT Variables --->
    <cfparam name="CLIENT.pr_regionID" default="#CLIENT.regionID#">
    <cfparam name="CLIENT.pr_cancelled" default="0">
    <cfparam name="CLIENT.reportType" default="1">
    <cfparam name="CLIENT.pr_rmonth" default="#Month(now())#">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.regionID" default="0">
    <cfparam name="FORM.reportType" default="1">
    <cfparam name="FORM.rmonth" default="">
    <cfparam name="FORM.reportType" default="1">
    <cfparam name="FORM.cancelled" default="0">
    
    <!--- Param LOCAL Variables --->
    <cfparam name="startDate" default="">
    <cfparam name="endDate" default="">
    <cfparam name="repDueDate" default="">
    <cfparam name="vPreviousReportMonth" default="">
    <cfparam name="vIsStudentInCountry" default="1">
    <cfparam name="vIsPreviousReportApproved" default="0">

	<cfscript>
		// This page will always display progress reports
		CLIENT.reportType = 1;
		
		// Get Regions
		qGetRegionList = APPCFC.region.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=CLIENT.usertype);

		// save the submitted values
        if ( VAL(FORM.submitted) ) {
        
            // Set CLIENT Variable
            CLIENT.pr_rmonth = FORM.rmonth;
			CLIENT.pr_cancelled = FORM.cancelled;		

			if ( VAL(FORM.regionID) ) {
				CLIENT.pr_regionID = FORM.regionID;
			}

		}
	</cfscript>

	<!--- Second Visit Report --->
	<cfif CLIENT.usertype EQ 15>
        <cflocation url="index.cfm?curdoc=secondVisitReports" addtoken="no">
    </cfif>

    <cfquery name="qGetSeasonDateRange" datasource="#APPLICATION.DSN#">
        SELECT 
        	seasonid, 
            startDate, 
            endDate
        FROM 
        	smg_seasons
        WHERE 
        	startdate <= CURRENT_DATE
        AND 
        	endDate >= CURRENT_DATE
    </cfquery>
    
    <!--- Loop Through Months in a season | July needs to be included here --->
    <cfloop from="#qGetSeasonDateRange.startDate#" to="#DateAdd("m", 1, qGetSeasonDateRange.endDate)#" index="i" step="#CreateTimeSpan(31,0,0,0)#">
       	
        <cfif CLIENT.pr_rmonth EQ DatePart('m', i)>
        
            <cfset startDate = '#DateAdd("d", "-7", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
            <cfset endDate = '#DateAdd("d", "21", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
            <cfset vPreviousReportMonth = "#DatePart('m','#startDate#')#">
            <cfset repReqDate = '#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01'>
            <cfset repDueDate = '#DateAdd("m", "0", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                       
         </cfif>
         
    </cfloop>
    
	<!----All available Reports---->
    <cfquery name="qGetReportTypes" datasource="#APPLICATION.DSN#">
        SELECT 
        	*
        FROM 
        	reportTrackingType
        WHERE 
        	isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		<cfif CLIENT.companyid eq 14>
            AND
                esi = <cfqueryparam cfsqltype="cf_sql_integer" value="14">
        </cfif>
    </cfquery>
    
    <!----get Menu options for seleted report---->
    <cfquery name="qGetReportOptions" dbtype="query">
        SELECT 
        	*
        FROM 
        	qGetReportTypes
        WHERE 
       		reportTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.reportType#">
    </cfquery>
    
</cfsilent>

<script>
	<!--
	// If second visit report is selected, load the 2nd visit page
	var checkSelectedReport = function() { 
	
		if ( $("#reportType").val() == 2 ) {			
			window.location.replace('index.cfm?curdoc=secondVisitReports&setVariables');			
		}		
	
	}
	
	// opens letters in a defined format
	function OpenLetter(url) {
		newwindow=window.open(url, 'Application', 'height=700, width=850, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
		if (window.focus) {newwindow.focus()}
	}
	//-->
</script>

<cfif NOT listFind("1,2,3,4,5,6,7", CLIENT.userType)>
    You do not have access to this page.
    <cfabort>
</cfif>

<style type="text/css">
	<!--
	.advisor {
		font-size: 13px;
		font-weight: bold;
		background-color: #FFDDBB;
		line-height: 20px;
	}
	.rep {
		font-weight: bold;
		background-color: #CCCCCC;
	}
	-->
</style>

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="current_items.gif"
        tableTitle="Reports"
        tableRightTitle='<a href="index.cfm?curdoc=forms/progress_report_list">Progress Reports submitted prior to 09/16/2009</a>'
        width="100%"
    />    

    <cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <input name="submitted" type="hidden" value="1">
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
            <tr>
                <td><input name="send" type="submit" value="Submit" /></td>
                <td>
                    Reports Available<br />
                    <select name="reportType" id="reportType" onchange="checkSelectedReport();" class="largeField">
                    	<cfloop query="qGetReportTypes">
                        	<option value="#qGetReportTypes.reportTypeID#" <cfif qGetReportTypes.reportTypeID EQ CLIENT.reportType> selected="selected" </cfif>>#qGetReportTypes.description#</option>
                        </cfloop>
                    </select>
                </td>
            
                <cfif ListFind("1,2,3,4", CLIENT.usertype)>
                    <td>
                        Region<br />
                        <cfselect name="regionID" query="qGetRegionList" value="regionID" display="regionName" selected="#CLIENT.pr_regionID#" class="largeField" />
                    </td>
                </cfif>
            
                <td>
                    Phase<br />
                    <select name="rmonth" class="mediumField">
                        <option value="0"></option>
                        <cfloop list="8,9,10,11,12,1,2,3,4,5,6,7" index="reportMonth">
                            <option value="#reportMonth#" <cfif CLIENT.pr_rmonth EQ reportMonth> selected="selected" </cfif> >#Left(MonthAsString(reportMonth), 3)# Report</option>
                        </cfloop>
                    </select>                        
                </td>
                <td>
                    Status<br />
                    <select name="cancelled" class="mediumField">
                        <option value="0" <cfif CLIENT.pr_cancelled EQ 0>selected</cfif>>Active</option>
                        <option value="1" <cfif CLIENT.pr_cancelled EQ 1>selected</cfif>>Cancelled</option>
                    </select>            
                </td>
            </tr>
            <tr>
                <td colspan="5" align="center" style="border-top:1px solid ##ccc">
                    The <strong>#DateFormat('#endDate#', 'mmmm')#</strong> report is for contact durring the month of <strong>#DateFormat('#startDate#', 'mmmm')#</strong> 
                    and due on <strong>#DateFormat('#repDueDate#','mmm. d, yyyy')#</strong>. 
                </td>
            </tr>
        </table>
    </cfform>

</cfoutput>

<!--- 
	the supervising rep (smg_students.arearepid) and the regional advisor (user_access_rights.advisorID) are normally the same as the ones in the report
	(progress_reports.fk_sr_user & fk_ra_user) but since we want to display students without reports, we can't use the report fields here.
	But in the output below we use the report fields where a report has been submitted, otherwise use the student and user fields. 
--->
<cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
    SELECT 
    	s.studentID, 
        s.uniqueID, 
        s.firstName, 
        s.familyLastName, 
        <!--- Arrival Date --->
        (
            SELECT 
                dep_date 
            FROM 
                smg_flight_info 
            WHERE 
                studentID = s.studentID 
            AND 
                flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
            AND
                programID = s.programID
            AND 
                isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            ORDER BY 
                dep_date ASC,
                dep_time ASC
            LIMIT 1                            
        ) AS dateArrived, 
        <!--- Departure Date --->
        (
            SELECT 
                dep_date 
            FROM 
                smg_flight_info 
            WHERE 
                studentID = s.studentID 
            AND 
                flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure"> 
            AND
                programID = s.programID
            AND 
                isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
            ORDER BY 
                dep_date ASC,
                dep_time ASC
            LIMIT 1                            
        ) AS dateDepartured, 
        <!--- Program --->
		p.programID,
        p.programName,
        p.startDate,
        p.endDate,
        p.type as programType,
        <!--- Area Rep --->
        s.arearepid, 
        rep.firstName as rep_firstName, 
        rep.lastname as rep_lastname,
        <!--- alias advisor.userid here instead of using user_access_rights.advisorID because the later can be 0 and we want null, and the 0 might be phased out later. --->
        advisor.userid AS advisorID, 
        advisor.firstName as advisor_firstName, 
        advisor.lastname as advisor_lastname, 
        spt.aug_report, 
        spt.oct_report, 
        spt.dec_report, 
        spt.feb_report, 
        spt.april_report, 
        spt.june_report
    FROM 
    	smg_students s
    INNER JOIN 
        smg_users rep ON s.arearepid = rep.userid
    INNER JOIN user_access_rights ON s.arearepid = user_access_rights.userid
        AND 
            s.regionassigned = user_access_rights.regionID
    LEFT JOIN 
    	smg_users advisor ON user_access_rights.advisorID = advisor.userid
    INNER JOIN 
    	smg_programs p ON s.programid = p.programid
    INNER JOIN
    	smg_program_type spt ON p.type = spt.programtypeid
    WHERE 
    	
    <cfif ListFind("1,2,3,4", CLIENT.usertype)>
    	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.pr_regionID#">
    <cfelse>
    	<!--- don't use CLIENT.pr_regionID because if they change access level this is not reset. --->
    	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
    </cfif>
    
    <cfif NOT VAL(CLIENT.pr_cancelled)>
        AND 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    <cfelse>
        AND 
        	s.canceldate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(DateAdd('m', -2, now()),'yyyy-mm-dd')#">
    </cfif>
    
    <!----Only Progress Reports have active and fieldviewable variables---->
    AND 
        p.progress_reports_active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND 
        p.fieldviewable = <cfqueryparam cfsqltype="cf_sql_integer" value="1">

    <!--- regional advisor sees only their reps or their students. --->
    
	<cfif CLIENT.usertype EQ 6>
        AND (
            	user_access_rights.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            OR 
                s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
        )
    <!--- supervising reps sees only their students. --->
    <cfelseif CLIENT.usertype EQ 7>
        AND 
            s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    </cfif>

    <!--- include the advisorID and arearepid because we're grouping by those in the output, just in case two have the same first and last name. --->
    ORDER BY 
    	advisor_lastname, 
        advisor_firstName, 
        user_access_rights.advisorID, 
        rep_lastname, 
        rep_firstName, 
        s.arearepid, 
        s.familyLastName, 
        s.firstName
</cfquery>

<cfif VAL(qGetResults.recordCount)>

	<!--- get the reports, used in a query of query below, because LEFT JOIN is too slow in #APPLICATION.DSN#. --->
    <cfquery name="qGetAllReports" datasource="#APPLICATION.DSN#">
        SELECT 
        	*
        FROM 
        	progress_reports
        WHERE 
        	fk_student IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#valueList(qGetResults.studentID)#" list="yes"> )
        AND 
            pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.pr_rmonth#">
        AND 
        	fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.reportType#">
    </cfquery>
	
    <table border="0" cellpadding="3" cellspacing="0" class="section" width="100%">
        <cfoutput query="qGetResults" group="advisorID">
      
            <cfif currentRow NEQ 1>
                <tr>
                    <td colspan="9" height="20">&nbsp;</td>
                </tr>
            </cfif>
            
            <tr>
                <td colspan="9" class="advisor">
                    <cfif NOT LEN(advisorID)>
                        Reports Directly to Regional Director
                    <cfelse>
                        #qGetResults.advisor_firstName# #qGetResults.advisor_lastname# (###qGetResults.advisorID#)
                  </cfif>
                </td>
            </tr>
            
            <!--- Group by AreaRepID --->
			<cfoutput group="areaRepID">
                <tr>
                    <td colspan="9" class="rep">#qGetResults.rep_firstName# #qGetResults.rep_lastname# (###qGetResults.arearepid#)</td>
                <tr>
                <tr style="font-weight:bold;">
                    <td width="10">&nbsp;</td>
                    <td>Student</td>
                    <td>Submitted</td>
                    <td>Action</td>
                    <td align="center">SR Approved</td>
                    <td align="center">RA Approved</td>
                    <td align="center">RD Approved</td>
                    <td align="center">Facilitator Approved</td>
                    <td align="center">Rejected</td>
                </tr>
                
                <cfset vMyCurrentRow = 0>
                
                <!--- Loop Through Query to Display Students --->
                <cfoutput>

                    <cfquery name="qGetCurrentReport" dbtype="query">
                        SELECT 
                        	*
                        FROM 
                        	qGetAllReports
                        WHERE 
                        	fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.studentID#">
                        AND 
                        	fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.reportType#">
                    </cfquery>

					<!---Check if previous months report is approved---->
                    <cfquery name="qCheckPreviousReport" datasource="#APPLICATION.DSN#">
                        SELECT 
                        	pr_rd_approved_date, pr_ny_approved_date, pr_sr_approved_date
                        FROM 
                        	progress_reports
                        WHERE
                        	fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                        AND 
                        	fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.reportType#">
                        AND 
                        	fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.studentID#">
                        AND 
                        	pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(vPreviousReportMonth)#">
                    </cfquery>
                    
                    <cfscript>
						/**********************************
							Set Up Previous Report Month
							ID		Program Type	
							1,5		10 Month
							2,24	12 Month
							3,25	1st Semester
							4,26	2nd Semester
						**********************************/
					
						// Current Row
						vMyCurrentRow++;
						
						// Check if previous report is approved
						if ( isDate(qCheckPreviousReport.pr_sr_approved_date) OR isDate(qCheckPreviousReport.pr_rd_approved_date) OR isDate(qCheckPreviousReport.pr_ny_approved_date) ) {
							vIsPreviousReportApproved = 1;
						} else {
							vIsPreviousReportApproved = 0;
						}
					
                    	// If no arrival info is on file, we set to program start date
						if ( IsDate(qGetResults.dateArrived) ) {
							vSetArrivalDate = qGetResults.dateArrived;
						} else {
							vSetArrivalDate = qGetResults.startDate; // qGetSeasonDateRange.startDate; (eg: 08-01-2011)
						}

						// If no departure info is on file, we set to the program end date
						if ( IsDate(qGetResults.dateDepartured) ) {
							vSetDepartureDate = qGetResults.dateDepartured;
						} else {
							vSetDepartureDate = qGetResults.endDate; // qGetSeasonDateRange.endDate; (eg: 06-30-2012)
						}
						 
						// Arrival and Departure dates are set to the first day of arrival month and last day of departure month so calculation includes the month of arrival not just after day.
                    	vInCountryArrival = '#Month(vSetArrivalDate)#/01/#Year(vSetArrivalDate)#';
                    	
						if ( Month(vSetDepartureDate) EQ 2 ) {
							// Account for February
							vInCountryDeparture  = '#Month(vSetDepartureDate)#/28/#Year(vSetDepartureDate)#';
						} else {
							vInCountryDeparture  = '#Month(vSetDepartureDate)#/30/#Year(vSetDepartureDate)#';
						}
					</cfscript>
                    
                    <!--- Set report date correctly - use year from program start and end date ---->
					<cfswitch expression="#CLIENT.pr_rmonth#">
                    	
                        <!--- August, September, October, November, December --->
                    	<cfcase value="8,9,10,11,12">
							
                            <!--- These reports should use the same Year as the program start date --->
                            <cfset vReportDate = '#CLIENT.pr_rmonth - 1#/01/#Year(qGetResults.startDate)#'>	
                            
                        </cfcase>

                        <!--- January (return December dates) --->
                    	<cfcase value="1">

                            <!--- This should have the same Year as the program start date --->
                            <cfset vReportDate = '12/01/#Year(qGetResults.startDate)#'>	
                        
                        </cfcase>

                        <!--- February (return January dates - work out issue with 12 month program) --->
                    	<cfcase value="2">
							
							<!--- This should have the same Year as the program end date for 5, 10 and 12 month programs to work --->
                            <cfset vReportDate = '#CLIENT.pr_rmonth - 1#/01/#Year(qGetResults.endDate)#'>	
                            
                        </cfcase>

                    	<cfdefaultcase>
							
                            <!--- These reports should use the same Year as the program end date --->
                            <cfset vReportDate = '#CLIENT.pr_rmonth - 1#/01/#Year(qGetResults.endDate)#'>	
                            
                        </cfdefaultcase>
                        
					</cfswitch>
                    
					<cfscript>
						// Determin if student is IN or OUT of the country
						if ( vReportDate GTE vInCountryArrival AND vReportDate LTE vInCountryDeparture ) {
							vIsStudentInCountry = 1;
						} else { 
							vIsStudentInCountry = 0;
						}
						
						// Approve previous report if arrival month is the same as report date / first report
						if ( Month(vInCountryArrival) EQ Month(vReportDate) ) {
                        	vIsPreviousReportApproved = 1;
                        }
					</cfscript>

					<!--- Do we need this? --->
                    <!---
					<cfif CLIENT.pr_rmonth EQ 10>
						<cfset vIsPreviousReportApproved = 1>
					</cfif>
					--->
                
                   	<tr bgcolor="#iif(vMyCurrentRow MOD 2 ,DE("eeeeee") ,DE("white") )#">
                        <td>&nbsp;</td>
                        <td>
                        	<!--- put in red if user is the supervising rep for this student.  don't do for usertype 7 because they see only those students. --->
                            <a href="javascript:OpenLetter('reports/PlacementInfoSheet.cfm?uniqueID=#qGetResults.uniqueID#');">
								<cfif arearepid EQ CLIENT.userid and CLIENT.usertype NEQ 7>
                                    <font color="##FF0000"><strong>#qGetResults.firstName# #qGetResults.familyLastName# (###qGetResults.studentID#)</strong></font>
                                <cfelse>
                                    #qGetResults.firstName# #qGetResults.familyLastName# (###qGetResults.studentID#)
                                </cfif>
                            </a>
                            
                            <span style="font-size:0.8em;">- #qGetResults.programName#</span>
                        </td>
                        <td>#yesNoFormat(qGetCurrentReport.recordCount)#</td>
                        <td>

							<cfif qGetCurrentReport.recordCount>
                            
								<!--- access is limited to: CLIENT.usertype LTE 4, second vist rep, supervising rep, regional advisor, regional director, and facilitator. --->
                                <cfif CLIENT.usertype LTE 4 or listFind("#qGetCurrentReport.fk_secondVisitRep#,#qGetCurrentReport.fk_sr_user#,#qGetCurrentReport.fk_ra_user#,#qGetCurrentReport.fk_rd_user#,#qGetCurrentReport.fk_ny_user#, #qGetCurrentReport.fk_secondVisitRep#", CLIENT.userid)>
									
									<!--- restrict view of report until the supervising rep approves it. --->
                                    <!----check the type of report, use appropriate person to view---->
                                    <cfif qGetCurrentReport.pr_sr_approved_date EQ '' AND areaRepID NEQ CLIENT.userid>
                                    
										<!----allow office to view so can delete if needed---->
                                        <cfif listfind('1,12313,13799,510', CLIENT.userid)>
                                            <form action="index.cfm?curdoc=progress_report_info" method="post" name="theForm_#qGetCurrentReport.pr_id#" id="theForm_#qGetCurrentReport.pr_id#">
                                            	<input type="hidden" name="pr_id" value="#qGetCurrentReport.pr_id#">
                                            </form>
                                        </cfif>	
                                        
                                		<a href="javascript:document.theForm_#qGetCurrentReport.pr_id#.submit();">Pending</a>
                                
                                	<!----end allow view to delete---->
                                	<cfelse>
                                    
                                        <form action="index.cfm?curdoc=progress_report_info" method="post" name="theForm_#qGetCurrentReport.pr_id#" id="theForm_#qGetCurrentReport.pr_id#">
                                        	<input type="hidden" name="pr_id" value="#qGetCurrentReport.pr_id#">
                                        </form>
                                        
                                        <a href="javascript:document.theForm_#qGetCurrentReport.pr_id#.submit();">View</a>
                                        
                                	</cfif>
                                    
                                <cfelse>
                                	N/A 
                                </cfif>
                                
							<!--- add report link --->
                            <cfelse>
                            	
                            	<!--- to add a progress report, user must be the supervising rep, and the program has a report for this phase. --->
								<cfif NOT VAL(vIsStudentInCountry)>
                                
                                    Not in Country - No Report Required
                                    
                                <cfelseif (areaRepID EQ CLIENT.userid and vIsPreviousReportApproved eq 1)>
                            
                                    <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                        <input type="hidden" name="studentID" value="#studentID#">
                                        <input type="hidden" name="type_of_report" value="#CLIENT.reportType#">
                                        <input type="hidden" name="month_of_report" value="#CLIENT.pr_rmonth#">
                                        <input name="Submit" type="image" src="pics/new.gif" alt="Add New Report" border="0">
                                    </form>
                                    
                                <cfelseif NOT VAL(vIsPreviousReportApproved)>
                                   
									Waiting on Previous Report Approval 
                                
								<cfelse>
                                
                                    Report Not Submitted
                                
								</cfif>
                                    
							</cfif>
                          	
                            <!--- Not In Country Issue | Troubleshooting --->
							<!---
							<cfif CLIENT.userType EQ 1>
								<br />
								vInCountryArrival --> #DateFormat(vInCountryArrival, 'mm/dd/yyyy')# <br />

								vInCountryDeparture --> #DateFormat(vInCountryDeparture, 'mm/dd/yyyy')# <br />

								vReportDate -> #DateFormat(vReportDate, 'mm/dd/yyyy')# <br />	
		
								vIsStudentInCountry --> #YesNoFormat(VAL(vIsStudentInCountry))# <br />
							</cfif>
							--->
                            
                        </td>
                        <td align="center">#dateFormat(qGetCurrentReport.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                        <td align="center">
							<cfif NOT VAL(qGetResults.advisorID)>
								N/A
                            <cfelse>
								#dateFormat(qGetCurrentReport.pr_ra_approved_date, 'mm/dd/yyyy')#
                            </cfif>
                        </td>
                        <td align="center">#dateFormat(qGetCurrentReport.pr_rd_approved_date, 'mm/dd/yyyy')#</td>
                        <td align="center">
                        	<cfif listFind("1,2,3,4", CLIENT.userType) AND isDate(qGetCurrentReport.pr_rd_approved_date) AND NOT isDate(qGetCurrentReport.pr_ny_approved_date)>
                            	<a href="javascript:document.theForm_#qGetCurrentReport.pr_id#.submit();">[ Click here to Approve ]</a>
                            <cfelse>
		                        #dateFormat(qGetCurrentReport.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                            </cfif>
                        <td align="center">#dateFormat(qGetCurrentReport.pr_rejected_date, 'mm/dd/yyyy')#</td>
                    </tr>
                </cfoutput> <!--- list students --->
                
            </cfoutput> <!--- group="areaRepID" --->
            
        </cfoutput> <!--- group="advisorID" --->
    </table>

    <table width="100%" bgcolor="#eeeeee" class="section">
        <tr>
            <td>
                <table>
                    <tr>
		                <td bgcolor="#FFDDBB" width="15">&nbsp;</td>
        		        <td>Regional Advisor</td>
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
            <!--- don't do for usertype 7 because they see only students they're supervising. --->
            <cfif CLIENT.usertype NEQ 7>
            	<td><font color="FF0000"><strong>Students that you're supervising</strong></font></td>
            </cfif>
        </tr>
    </table>
           
<cfelse>
    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
        <tr>
            <td>No progress reports matched your criteria.</td>
        </tr>
    </table>
</cfif>

<!--- Table Footer --->
<gui:tableFooter 
	width="100%"
/>