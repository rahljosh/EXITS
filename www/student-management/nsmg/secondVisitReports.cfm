<!--- ------------------------------------------------------------------------- ----
	
	File:		secondVisitReports.cfm
	Author:		Marcus Melo
	Date:		February 15, 2012
	Desc:		Second Visit Report Matrix

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param CLIENT Variables --->
    <cfparam name="CLIENT.pr_regionid" default="#CLIENT.regionid#">
    <cfparam name="CLIENT.pr_cancelled" default="0">
    <cfparam name="CLIENT.reportType" default="2">
    <Cfparam name="CLIENT.pr_rmonth" default="#DatePart('m', '#now()#')#">
    <cfparam name="CLIENT.selectedProgram" default="0">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.pr_action" default="">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.selectedProgram" default="">
    <cfparam name="FORM.reportType" default="2">
    <cfparam name="FORM.regionID" default="0">
    <Cfparam name="FORM.rmonth" default="#DatePart('m', '#now()#')#">
    <cfparam name="FORM.cancelled" default="0">
    
	<!--- Param Local Variables --->
    <Cfparam name="resetMonth" default="0">
    <cfparam name="startDate" default="">
    <cfparam name="endDate" default="">
    <cfparam name="repDUeDate" default="">
    <Cfparam name="inCountry" default= 1>
    <Cfparam name="PreviousReportApproved" default="0">
    
	<cfif isDefined('FORM.hideReport')>
        
        <Cfquery datasource="#APPLICATION.DSN#">
            INSERT INTO 
                smg_hide_reports 
                    (fk_student, fk_host, fk_secondVisitRep, fk_userid, dateChanged)
                VALUES 
                    (#FORM.fk_student#, #FORM.fk_host#, #FORM.fk_secondVisitRep#, #CLIENT.userid#, #now()#)
        </Cfquery>
        
    </cfif>
    
    <Cfif isDefined('FORM.unHideReport')>
        
        <Cfquery datasource="#APPLICATION.DSN#">
            delete 
                from 
            smg_hide_reports w
                here id = #FORM.unHideReport#
        </Cfquery>
        
    </cfif>

    <cfswitch expression="#FORM.pr_action#">
    
        <cfcase value="delete_report">
        
            <cfquery datasource="#APPLICATION.DSN#">
                DELETE FROM progress_report_dates
                WHERE fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
            </cfquery>
            
            <cfquery datasource="#APPLICATION.DSN#">
                DELETE FROM x_pr_questions
                WHERE fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
            </cfquery>
            
            <cfquery datasource="#APPLICATION.DSN#">
                DELETE FROM progress_reports
                WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
            </cfquery>
            <cflocation url="index.cfm?curdoc=secondVisitReports" addtoken="no">
        
        </cfcase>
        
    </cfswitch>
    
    <cfscript>
		//Check if paperwork is complete for season
		qGetPrograms = APPLICATION.CFC.program.getPrograms(isActive=1);
	
        // save the submitted values
        if ( VAL(FORM.submitted) ) {
        
            // Set CLIENT Variable
            CLIENT.pr_regionID = FORM.regionID;
            CLIENT.pr_cancelled = FORM.cancelled;
            CLIENT.selectedProgram = FORM.selectedProgram;
        
        } else if ( CLIENT.reportType EQ 1 ) {
            
            // Reset CLIENT Default Values 	
            CLIENT.pr_regionID = CLIENT.regionID;
            CLIENT.pr_cancelled = 0;
            CLIENT.selectedProgram = 0;
        
        }
        
        // This page will always display second visit report
        CLIENT.reportType = 2;
    </cfscript>

	<!---_Set the current year so when can set the correct start and end dates to figure if a report should be filled out---->
    <cfset year = DateFormat(now(), 'yyyy')>

    <Cfquery name="DateRange" datasource="mysql">
        SELECT seasonid, startDate, endDate
        FROM smg_seasons
        WHERE #now()# >= startdate and #now()# <= endDate
    </cfquery>

	<Cfif isDefined('FORM.reportType')>
        <cfif FORM.reportType neq CLIENT.ReportType>
            <Cfset resetMonth = 1>
        </cfif>
        <cfset CLIENT.reportType = FORM.reportType>
    </Cfif>
    
    <Cfif CLIENT.usertype EQ 15>
        <cfset CLIENT.reportType = 2>
        <Cfset enableReports = 'No'>
    <cfelse>
        <cfset enableReports = 'Yes'>
    </Cfif>
    
    <!----If a month is passed in from the form, use it for the month if its works with the current report type---->
    
    <Cfif FORM.rmonth neq 0 AND resetMonth eq 0>
        <Cfset CLIENT.pr_rmonth = #FORM.rmonth#>
    
          <Cfloop from="#DateRange.startDate#" to="#DateRange.endDate#" index=i step="#CreateTimeSpan(31,0,0,0)#">
                    <Cfif CLIENT.pr_rmonth eq "#DatePart('m', '#i#')#">
                        <Cfset CLIENT.pr_rmonth = '#DatePart('m', '#i#')#'>
                        <Cfset startDate = '#DateAdd("d", "-7", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                        <Cfset endDate = '#DateAdd("d", "21", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                        <cfset prevRepMonth = "#DatePart('m','#startDate#')#">
                        <cfset repReqDate = '#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01'>
                        <Cfset repDueDate = '#DateAdd("m", "0", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                   </Cfif>
               </Cfloop>
     </cfif>
    
    <!----All available Reports---->
    <cfquery name="reportTypes" datasource="#APPLICATION.DSN#">
    select *
    from reportTrackingType
    where isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    <cfif CLIENT.companyid eq 14>
    and esi = 14
    </cfif>
    </cfquery>
    
    <!----get Menu options for seleted report---->
    <cfquery name="reportOptions" dbtype="query">
    select *
    from reportTypes
    where reportTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.reportType#">
    </cfquery>
        
</cfsilent>    

<script language="javascript">
	<!--
	// If second visit report is selected, load the 2nd visit page
	var checkSelectedReport = function() { 
	
		if ( $("#reportType").val() == 1 ) {	
			// Disable submit button
			$("#submit").attr("disabled", "disabled");
			// Go to second visit page
			window.location.replace('index.cfm?curdoc=progress_reports');			
		}		
	
	}
	
	// opens letters in a defined format
	function OpenLetter(url) {
		newwindow=window.open(url, 'Application', 'height=700, width=850, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
		if (window.focus) {newwindow.focus()}
	}
	//-->
</script>

<cfif NOT listFind("1,2,3,4,5,6,7,15", CLIENT.userType)>
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
	background-color: #085dad;
	color:#FFF;
	padding-top: 5px;
	padding-bottom: 5px;
	padding-left: 5px;
	margin-top: 5px;
}
-->
</style>

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="current_items.gif"
        tableTitle="Second Visit Reports"
        width="100%"
    />    

    <cfform action="index.cfm?curdoc=secondVisitReports" method="post">
        <input name="submitted" type="hidden" value="1">
        <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
            <Tr>
                <td></td>
                
            </Tr>
            <tr>
                <td valign="top"><input name="submit" id="submit" type="submit" value="Submit" /></td>
            
                <td valign="top">Reports Available<br />
                <Cfif CLIENT.usertype NEQ 15>
                         <cfselect 
                          name="reportType" 
                          id="reportType" multiple="no"
                          query="reportTypes"
                          value="reportTypeID"
                          display="Description"
                          selected="#CLIENT.reportType#" 
                          onchange="checkSelectedReport();" 
                          class="largeField"/>
                <Cfelse>
                Second Host Family Visit    
                </Cfif>
                </td>
               
                <td valign="top">
                Programs <br />
                        <select name="selectedProgram" size="5" multiple="multiple" class="xLargeField">
                           <cfloop query="qGetPrograms">
                                <option value="#programID#" <Cfif ListFind(#CLIENT.selectedprogram#,#programID#)> selected </cfif> >#programName#</option>
                            </cfloop>
                        </select>
              </td>
            
            <cfif CLIENT.usertype LTE 4>
               <td valign="top">
                    <!--- GET ALL REGIONS --->
                    <cfquery name="list_regions" datasource="#APPLICATION.DSN#">
                        SELECT regionid, regionname
                        FROM smg_regions
                        WHERE company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                        AND subofregion = 0
                        ORDER BY regionname
                    </cfquery>
                    Region<br />
                    <cfselect NAME="regionid" query="list_regions" value="regionid" display="regionname" selected="#CLIENT.pr_regionid#" class="largeField" />
                </td>
            </cfif>
                <td valign="top">
                    Status<br />
                    <select name="cancelled" class="mediumField">
                        <option value="0" <cfif CLIENT.pr_cancelled EQ 0>selected</cfif>>Active</option>
                        <option value="1" <cfif CLIENT.pr_cancelled EQ 1>selected</cfif>>Cancelled</option>
                    </select>            
                </td>
            </tr>
            <tr>
                <Td colspan=5 align="Center">
                <cfif CLIENT.reportType neq 2>
                    <cfoutput>The #DateFormat('#endDate#', 'mmmm')# report is for contact durring the month of #DateFormat('#startDate#', 'mmmm')# and <Br />
                    due on  #DateFormat('#repDueDate#','mmm. d, yyyy')#. </cfoutput>
                </cfif>
                </Td>
            </tr>
        </table>
    </cfform>

</cfoutput>

<!---Get the current reports.  Old reports are retrieved below---->
<cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
    SELECT 
    	s.studentid, 
        s.uniqueid, 
        s.firstname, 
        s.familylastname, 
        smg_programs.type as programType, 
        s.hostid,
    	s.date_host_fam_approved, 
        s.arearepid, 
        s.secondVisitRepID, 
        rep.firstname as rep_firstname, 
        rep.lastname as rep_lastname,
        <!--- alias advisor.userid here instead of using user_access_rights.advisorid because the later can be 0 and we want null, and the 0 might be phased out later. --->
        advisor.userid AS advisorid, 
        advisor.firstname as advisor_firstname, 
        advisor.lastname as advisor_lastname
    FROM 
    	smg_students s
    INNER JOIN 
    	smg_users rep ON s.secondVisitRepID = rep.userid
    INNER JOIN 
    	user_access_rights ON s.secondVisitRepID = user_access_rights.userid
        AND 
        	s.regionassigned = user_access_rights.regionid
    LEFT JOIN 
    	smg_users advisor ON user_access_rights.advisorid = advisor.userid
    INNER JOIN 
    	smg_programs ON s.programid = smg_programs.programid
    WHERE 
    
    <cfif ListFind("1,2,3,4", CLIENT.usertype)>
    	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.pr_regionID#">
    <cfelse>
    	<!--- don't use CLIENT.pr_regionID because if they change access level this is not reset. --->
    	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
    </cfif>
    
	<cfif CLIENT.pr_cancelled eq 0>
        AND 
        	s.active = 1
    <cfelse>
        AND 
        	s.canceldate >= '#datelimit#'
    </cfif>
    
    AND
		s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.selectedprogram#" list="yes"> )

    <!--- regional advisor sees only their reps or their students. --->
    <cfif CLIENT.usertype EQ 6>
        AND (
            	user_access_rights.advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            OR 
            	s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
            OR 
            	s.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">           
        )
    <!--- supervising reps sees only their students. --->
    <cfelseif CLIENT.usertype EQ 7>
        AND 
        	s.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    <cfelseif CLIENT.usertype eq 15>
        AND 
        	s.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    </cfif>
	
    <!--- include the advisorid and arearepid because we're grouping by those in the output, just in case two have the same first and last name. --->
    ORDER BY 
    	advisor_lastname,
        advisor_firstname, 
        user_access_rights.advisorid, 
        rep_lastname, 
        rep_firstname, 
        s.arearepid, 
        s.familylastname, 
        s.firstname
</cfquery>

<cfif VAL(qGetResults.recordCount)>

	<!--- get the reports, used in a query of query below, because LEFT JOIN is too slow in mySQL. --->
    <cfquery name="get_reports" datasource="#APPLICATION.DSN#">
       SELECT *
        FROM progress_reports
        WHERE fk_student IN (#valueList(qGetResults.studentid)#)
        AND fk_reportType = 2
    </cfquery>
	
    <table width=100% class="section" cellpadding=4 cellspacing="0" border=0>
        <cfoutput query="qGetResults" group="advisorid">
      		<Cfset checkBlock.recordcount = 0>
            <cfif currentRow NEQ 1>
                <tr>
                    <td colspan=11 height="25">&nbsp;</td>
                </tr>
            </cfif>
            <tr>
                <td colspan=11 class="advisor">
                    <cfif advisorid EQ ''>
                        Reports Directly to Regional Director
                    <cfelse>
                        #advisor_firstname# #advisor_lastname# (#advisorid#)
                  </cfif>
                </td>
            </tr>
            	
            	<cfoutput group="secondVisitRepID">
                <!----
          		<Cfset subSetOfKids = ''>
                <Cfset subSetOfHosts = ''>
                <Cfset secondSubSetOfKids = ''>
                 <Cfset secondSubSetOfHosts = ''>
			    ---->
				<tr>
                    <td colspan=11 class="rep">#rep_firstname# #rep_lastname# (#secondVisitRepID#)</td>
                <tr>
                <tr align="left">
                    <th width="15">&nbsp;</th>
                    <th>Student</th>
                    <th>Days Placed</th>
                    <th>Host</th>
                    <th>Submitted</th>
                     <th width=80>Action</th>
                   <th>SR Approved</th>
                    <th>RA Approved</th>
                    <th>RD Approved</th>
                    <th>Facilitator Approved</th>
                    <th>Rejected</th>
                </tr>
                 <cfset mycurrentRow = 0>
                <cfoutput>
                    <cfquery name="get_report" dbtype="query">
                        SELECT * 
                        FROM get_reports
                        WHERE fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                        AND fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                        AND fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostid#">
                        AND fk_secondVisitRep = #secondVisitRepID#
                    </cfquery>
                   
				<!----Figure out how long they have been placed with this host family and host family info---->
                <Cfquery name="hostHistory" datasource="#APPLICATION.DSN#">
                SELECT original_place,  isWelcomeFamily, isRelocation, datePlaced
                FROM smg_hosthistory
                LEFT JOIN smg_hosts h on h.hostid = smg_hosthistory.hostid
                WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                AND smg_hostHistory.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(qGetResults.hostid)#">
                </cfquery> 
                <cfquery name="checkHostHistoryOriginal" datasource="#APPLICATION.DSN#">
                select hostid
                from smg_hosthistory
                where original_place = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                and studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                </cfquery>
                <cfquery name="hostName" datasource="#APPLICATION.DSN#">
                select familyLastName, hostid
                from smg_hosts
                where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.hostid#">
                </cfquery>
               		<cfset isWithOriginal = 'no'>
			   <cfif (checkHostHistoryOriginal.hostID eq hostName.hostid)>
               		<cfset isWithOriginal = 'yes'>
               </cfif>
               <Cfif isWithOriginal is 'no' and hostHistory.datePlaced lt #dateRange.startdate#>
               		<cfset isWithOriginal = 'yes'>
               </Cfif>
			   
                <Cfif isWithOriginal is 'yes' >
                	<cfquery name="arrivalInfo" datasource="#APPLICATION.DSN#">
                    SELECT max(dep_date) as dep_date
                    FROM smg_flight_info
                    WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                    AND flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
                    </cfquery>
                    <!----If no arrival info is on file, we set to August 1, the earliest to make sure---->
					<Cfif arrivalInfo.recordcount eq 0 or arrivalInfo.dep_date eq ''>
                    	<Cfset arrivalDate = '#DateRange.startDate#'>
                   	<cfelse>
                    	<cfset arrivalDate = '#arrivalInfo.dep_Date#'>
                    </Cfif>
                 	<cfset daysPlaced = #DateDiff('d','#arrivaldate#','#now()#')#>
                <Cfelse>
                	<cfset daysPlaced = #DateDiff('d','#hostHistory.datePlaced#','#now()#')#>
                	
            	</Cfif>
         		<Cfquery name="checkBlock" datasource="#APPLICATION.DSN#">
                                SELECT hr.id, hr.dateChanged, u.firstname, u.lastname
                                FROM smg_hide_reports hr
                                LEFT JOIN smg_users u on u.userid = hr.fk_userid
                                WHERE hr.fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                                AND hr.fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostid#">
                                AND hr.fk_secondVisitRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#secondVisitRepID#">
                            </cfquery>
                            
                
       
                <!----display info for the current report---->
                  <cfset mycurrentRow = mycurrentRow + 1>
                   <tr <Cfif hostHistory.isWelcomeFamily eq 1>bgcolor="##bed1fc"<cfelse> bgcolor="#iif(mycurrentRow MOD 2 ,DE("eeeeee") ,DE("white") )#"</cfif>>
                        <td>&nbsp;</td>
                        <td>
                        	<!--- put in red if user is the supervising rep for this student.  don't do for usertype 7 because they see only those students. --->
                            <a href="javascript:OpenLetter('reports/placementInfoSheet.cfm?uniqueID=#qGetResults.uniqueID#');">
							<cfif qGetResults.arearepid EQ CLIENT.userid and CLIENT.usertype NEQ 7>
                        		<font color="FF0000"><strong>#qGetResults.firstname# #qGetResults.familylastname# (#qGetResults.studentid#)</strong></font>
                            <cfelse>
                        		#qGetResults.firstname# #qGetResults.familylastname# (#qGetResults.studentid#)
                            </cfif>
                            </a>
                        </td>
                  
                        <td>
                     	  #daysPlaced#
                  </td>
                        <td>#hostName.familylastname# (#hostid#)</td>
                      
                        <td>#yesNoFormat(get_report.recordCount)#</td>
                        <td valign="center">

                        <cfif get_report.recordCount>
                            	<!--- access is limited to: CLIENT.usertype LTE 4, second vist rep, supervising rep, regional advisor, regional director, and facilitator. --->
								<cfif CLIENT.usertype LTE 4 or listFind("#get_report.fk_secondVisitRep#,#get_report.fk_sr_user#,#get_report.fk_ra_user#,#get_report.fk_rd_user#,#get_report.fk_ny_user#, #get_report.fk_secondVisitRep#", CLIENT.userid)>
									<!--- restrict view of report until the supervising rep approves it. --->
                                    <!----check the type of report, use appropriate person to view---->
								
                                        <cfset submittingRep = '#secondVisitRepID#'>
                                    
                                    <cfif get_report.pr_sr_approved_date EQ '' and submittingRep NEQ CLIENT.userid>
                                        <!----allow office to view so can delete if needed---->
                                        <Cfif listfind('1,12313,13799,510,12431,16652,12389', CLIENT.userid)>
                                       
                                            <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#get_report.pr_id#">
                                           
                                        </cfif>	
                                        Pending</a>
                                    	<!----end allow view to delete---->
                                    <cfelse>
                                        
                                        <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#get_report.pr_id#"><img src="pics/buttons/greyedView.png" border=0 /></a>
                                       
                                    </cfif>
                                <cfelse>
                                	N/A 
                                </cfif>
							<!--- add report link --->
                        <cfelse>
                        	
                            <!----check the type of report, use appropriate person to view---->
                            <cfif CLIENT.reportType EQ 2>
                            	<cfset submittingRep = '#qGetResults.secondVisitRepID#'>
                            <cfelse>
                            	<Cfset submittingRep = '#qGetResults.arearepid#'>
                            </cfif>
                            <Cfif CLIENT.pr_rmonth eq 10>
                        		<Cfset PreviousReportApproved = 1>
                            </Cfif>
                            	<!--- to add a progress report, user must be the supervising rep, and the program has a report for this phase. --->
                          			<Cfif inCountry eq 0>
                                    Not in Country - No Report Required
									<cfelseif (#submittingRep# EQ CLIENT.userid and PreviousReportApproved eq 1) OR CLIENT.reportType EQ 2  >
                                    	<Cfif checkBlock.recordcount gt 0>
                                           <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                                <input type="hidden" name="unHideReport" value="#checkBlock.id#" />
                                                <input type="hidden" name="selectedProgram" value="#CLIENT.selectedProgram#" />
                                                <input name="Submit" type="image" src="pics/plus.png" height="20" alt="Add New Report" border=0>
                                            </form>
                                        <cfelse>
                                            <table>
                                                <Tr>
                                                    <Td>
                                                   
                                                <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                                <input type="hidden" name="studentid" value="#qGetResults.studentid#">
                                                <input type="hidden" name="type_of_report" value="#CLIENT.reportType#">
                                                <input type="hidden" name="month_of_report" value="#CLIENT.pr_rmonth#">
                                                <input type="hidden" name="fk_host" value="#hostid#">
                                                <input name="Submit" type="image" src="pics/buttons/greenNew.png" alt="Add New Report" height="20"  border=0>
                                               </form>
                                                    </Td>
                                                    <td>
                                                   <cfif CLIENT.userid eq 8731 or 
												   		 CLIENT.userid eq 1 or 
														 CLIENT.userid eq 510 or
														 CLIENT.userid eq 12431 or 
														 CLIENT.userid eq 12313 or
														 CLIENT.userid eq 12389 or
														 CLIENT.userid eq 16652 or
														 CLIENT.userid eq 8743 or
														 CLIENT.userid eq 11364 or
														 CLIENT.userid eq 13799
														 >
                                                     <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                                        <input type="hidden" name="hideReport" />
                                                        <input type="hidden" name="fk_student" value="#studentid#">
                                                        <input type="hidden" name="fk_host" value="#hostid#">
                                                        <input type="hidden" name="fk_secondVisitRep" value="#secondVisitRepID#">
                                                        <input type="hidden" name="selectedProgram" value="#CLIENT.selectedProgram#" />
                                                        <input name="Submit" type="image" src="pics/smallDelete.png" height="20" alt="Add New Report" border=0>
                                                    </form>
                                                    </cfif>
                                                    </td>
                                                  </Tr>
                                                </table> 
                                         </Cfif>
                                    <cfelseif PreviousReportApproved eq 0>
                                       Waiting on Previous Report Approval 
                                    <Cfelse>
                                    	Report Not Submitted
                                     </cfif>
                                    
                                 <Cfset PreviousReportApproved = 0> 
                                 <cfset inCountry = 1>
                        </cfif>
                          
					
                        </td>
                        <cfif checkBlock.recordcount gt 0>
                          <td colspan=5> <em>#checkBlock.firstname# #checkBlock.lastname# determined that this report was not required on #dateFormat(checkBlock.dateChanged, 'mm/dd/yyyy')#</em> </td>
                        <cfelse>
                            <td>#dateFormat(get_report.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                            <td>
                                <cfif qGetResults.advisorid EQ ''>
                                   N/A
                                <cfelse>
                                    #dateFormat(get_report.pr_ra_approved_date, 'mm/dd/yyyy')#
                              </cfif>
                            </td>
                            <td>#dateFormat(get_report.pr_rd_approved_date, 'mm/dd/yyyy')#</td>
                            <td>#dateFormat(get_report.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                            <td>#dateFormat(get_report.pr_rejected_date, 'mm/dd/yyyy')#</td>
                        </cfif>
                        
                    </tr>
                <!----Get all the prvious hosts associated with kid---->    
               <Cfquery name="getPrevHosts" datasource="#APPLICATION.DSN#">
               select  distinct hh.hostID, hh.studentid, h.familylastname
               from smg_hostHistory hh
               LEFT JOIN smg_hosts h on h.hostid = hh.hostid
               where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
               and hh.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="#hostid#"> 
               and hh.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
               
			   </cfquery>
              
               <cfif getPrevHosts.recordcount gt 0>
                       <Cfquery name="checkWelcome" datasource="#APPLICATION.DSN#">
                           select  distinct hh.hostID, hh.studentid, h.familylastname, isWelcomeFamily
                           from smg_hostHistory hh
                           LEFT JOIN smg_hosts h on h.hostid = hh.hostid
                           where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                           and hh.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="#hostid#"> 
                           and hh.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 

                       </cfquery>
			   
  	                   <cfloop query="getPrevHosts">
                       <!---check to see if host family has been converted if welcome family---->
                       <Cfquery name="welcomeCheck" dbtype="query">
                       select *
                       from checkWelcome
                       where hostid = #hostID#
                       </cfquery>
                       <Cfif welcomeCheck.recordcount eq 1>
                       	<cfset isWelcomeFam = #welcomeCheck.isWelcomeFamily#>
                       <cfelse>
                       	 <Cfset isWelcomeFam = 0>
                       </Cfif>
					   
                         <tr <Cfif isWelcomeFam eq 1>bgcolor="##bed1fc"<cfelse> bgcolor="#iif(myCurrentRow MOD 2 ,DE("eeeeee") ,DE("white") )#" </cfif>>
                            <td></td>
                            <td></td>
                            <td></td>
                            <Td>#familylastname# (#hostid#)</Td>
                        <cfquery name="indReports" datasource="#APPLICATION.DSN#">
                        select *, u.firstname as svFirst, u.lastname as svLast
                        from progress_reports
                        left join smg_users u on u.userid = progress_reports.fk_secondvisitrep
                        where fk_student = #studentid#
                        and fk_host = #hostid# 
                        and fk_reportType = 2
                        
                        </cfquery>
                      
                        <!----check if block on report should be in place---->
                        <Cfquery name="checkBlock2" datasource="#APPLICATION.DSN#">
                        SELECT hr.id, hr.dateChanged, u.firstname, u.lastname
                        FROM smg_hide_reports hr
                        LEFT JOIN smg_users u on u.userid = hr.fk_userid
                        WHERE hr.fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPrevHosts.studentid#">
                        AND hr.fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPrevHosts.hostid#">
                        <!----
                        AND hr.fk_secondVisitRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.secondVisitRepID#">
						---->
                        </cfquery>
                        
                        <!----If no report is found, display option to add / hide---->
                            <Cfif indReports.recordcount eq 0>
                            <td>No</td>
                     <cfif checkBlock2.recordcount gt 0>
                                        <Td colspan=6>
                                            <table>
                                                <tr>
                                                    <td>
                                        <em>#checkBlock2.firstname# #checkBlock2.lastname# determined that this report was not required
                                         on #dateFormat(checkBlock2.dateChanged, 'mm/dd/yyyy')#</em> 									</td>
                                                    <td>
                                        <cfif CLIENT.userid eq 8731 or 
												   		 CLIENT.userid eq 1 or 
														 CLIENT.userid eq 510 or
														 CLIENT.userid eq 12431 or 
														 CLIENT.userid eq 12313 or
														 CLIENT.userid eq 12389 or
														 CLIENT.userid eq 16652 or
														 CLIENT.userid eq 8743 or
														 CLIENT.userid eq 11364 or
														 CLIENT.userid eq 13799
														 >
                                        <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                                <input type="hidden" name="unHideReport" value="#checkBlock2.id#" />
                                                <input type="hidden" name="selectedProgram" value="#CLIENT.selectedProgram#" />
                                                <input name="Submit" type="image" src="pics/plus.png" height="20" alt="Add New Report" border=0>
                                            </form>
                                        </cfif>
                                                    </td>
                                                 </tr>
                                              </table>			
                                        
                                        </Td>
                                       </tr>
                       <Cfelse>
                            

                      
                            <td>
                                <Table cellspacing="0" cellpadding="2" >
                                    <Tr>
                                        <TD>
                                       
                                <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                 
                                    <input type="hidden" name="studentid" value="#studentid#">
                                    <input type="hidden" name="type_of_report" value="2">
                                    <input type="hidden" name="month_of_report" value="#CLIENT.pr_rmonth#">
                                    <input type="hidden" name="fk_host" value="#hostid#" />
                                    <input type="hidden" name="fk_secondVisitRep" value="#qGetResults.secondVisitRepID#">
                                    <input name="Submit" type="image" src="pics/buttons/greenNew.png" alt="Add New Report" border=0>
                                </form>
                                        </TD>
                                        <Td>
                                        <Cfif CLIENT.usertype lte 4>
                                <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                    <input type="hidden" name="hideReport" />
                                    <input type="hidden" name="fk_student" value="#studentid#">
                                    <input type="hidden" name="fk_host" value="#hostid#">
                                    <input type="hidden" name="fk_secondVisitRep" value="#qGetResults.secondVisitRepID#">
                                    <input type="hidden" name="selectedProgram" value="#CLIENT.selectedProgram#" />
                                    <input name="Submit" type="image" src="pics/smallDelete.png" height="20" alt="Add New Report" border=0>
                                </form>
                                </Cfif>
                                        </Td>
                                     </Tr>
                                  </Table>
                       		</td>
                            <td colspan=5></td>
                            </tr>
                      </cfif>
                            <cfelse>         
                                 <Cfloop query="indReports">      
                                 <cfif indReports.currentrow gt 1>
                                 	<tr  ><td colspan=3><td>#getprevhosts.familylastname# (#getprevhosts.hostid#)</td>
                                 </cfif>    
                                    <cfif qGetResults.secondvisitrepid neq indReports.fk_secondvisitrep>
                                 	<td colspan=2>
                                    <cfelse>
                              		<td>
                                    
                                    </cfif>
									
									
									
                                    <cfif qGetResults.secondvisitrepid neq fk_secondvisitrep>
                                     <Cfif CLIENT.usertype lte 4><a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#indReports.pr_id#"></Cfif>
                                     <font size=-1><em> #svFirst# #svLast# (#fk_secondvisitrep#)
                                      <Cfif CLIENT.usertype lte 4>
                                     </a>
                                     </Cfif></em></font>
                                    <Cfelse>
                                    <cfif pr_sr_approved_date is ''>No<cfelse>Yes</cfif>
                                    </cfif>
                                    
                                    
                                    </td>
                                    <cfif checkBlock2.recordcount gt 0>
                                        <Td colspan=6>
                                            <table>
                                                <tr>
                                                    <td>
                                        <em>#checkBlock2.firstname# #checkBlock2.lastname# determined that this report was not required
                                         on #dateFormat(checkBlock2.dateChanged, 'mm/dd/yyyy')#</em> 									</td>
                                                    <td>
                                        <cfif CLIENT.usertype lte 4>
                                        <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                                <input type="hidden" name="unHideReport" value="#checkBlock.id#" />
                                                <input type="hidden" name="selectedProgram" value="#CLIENT.selectedProgram#" />
                                                <input name="Submit" type="image" src="pics/plus.png" height="20" alt="Add New Report" border=0>
                                            </form>
                                        </cfif>
                                                    </td>
                                                 </tr>
                                              </table>			
                                        
                                        </Td>
                                       </tr>
                                   <Cfelse>
                                        <cfif qGetResults.secondvisitrepid eq fk_secondvisitrep>
                                            <td>
                                             <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#pr_id#"><img src="pics/buttons/greyedView.png" border=0 /></a>
                                            </td>
                                       </cfif>
                                         <td>#dateFormat(indReports.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                                        <td>
                                            <cfif qGetResults.advisorid EQ ''>
                                               N/A
                                            <cfelse>
                                                #dateFormat(indReports.pr_ra_approved_date, 'mm/dd/yyyy')#
                                          </cfif>
                                        </td>
                                        <td>#dateFormat(indReports.pr_rd_approved_date, 'mm/dd/yyyy')#</td>
                                        <td>#dateFormat(indReports.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                                        <td>#dateFormat(indReports.pr_rejected_date, 'mm/dd/yyyy')#</td>
                                 		 </tr></cfif>
                                    
                                    <tr>
                                    	<td>&nbsp;</td>
                                    </tr>
                                 </Cfloop>
                            </cfif>
                           
                        </cfloop>
                        
               </cfif>     
                    <Cfquery name="checkManual" datasource="#APPLICATION.DSN#">
                    select *, h.familylastname
                    from progress_reports
                    left join smg_hosts h on h.hostid = progress_reports.fk_host
                    where fk_student =  <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                    and manual = 1
                    </cfquery>
                     <Cfif checkManual.recordcount gt 0>
                     <Cfquery name="checkWelcome" datasource="#APPLICATION.DSN#">
                           select  distinct hh.hostID, hh.studentid, h.familylastname, isWelcomeFamily
                           from smg_hostHistory hh
                           LEFT JOIN smg_hosts h on h.hostid = hh.hostid
                           where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkManual.fk_student#">
                           and hh.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="#checkManual.fk_host#"> 
                           and hh.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                       </cfquery>
                   
                    	<cfloop query="checkManual">
                        <Cfquery name="welcomeCheck" dbtype="query">
                       select *
                       from checkWelcome
                       where hostid = #hostID#
                       </cfquery>
                       <Cfif welcomeCheck.recordcount eq 1>
                       	<cfset isWelcomeFam2 = #welcomeCheck.isWelcomeFamily#>
                       <cfelse>
                       	 <Cfset isWelcomeFam2 = 0>
                       </Cfif>
                       
                       
                      	<Tr <Cfif isWelcomeFam2 eq 1>bgcolor="##bed1fc"</cfif>> 
                           <Td colspan=3></Td>
                           <td>#checkManual.familylastname# (#checkManual.fk_host#)</td>
                           <Td><Cfif #checkManual.pr_sr_approved_date# is ''> No<cfelse>Yes</Cfif> </Td>
                           <td>
                           <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#pr_id#">
                                   <Cfif #checkManual.pr_sr_approved_date# is ''>
                                   	 <img src="pics/buttons/greenNew.png" alt="Add New Report" border=0>
                            		<Cfelse>
                                      <img src="pics/buttons/greyedView.png" alt="Edit Report" border=0>
                                    </Cfif>
                            </a>
                            </td>
                            <td>#dateFormat(checkManual.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                            <td>
                                <cfif checkManual.fk_ra_user EQ ''>
                                   N/A
                                <cfelse>
                                    #dateFormat(checkManual.pr_ra_approved_date, 'mm/dd/yyyy')#
                              </cfif>
                            </td>
                            <td>#dateFormat(checkManual.pr_rd_approved_date, 'mm/dd/yyyy')#</td>
                            <td>#dateFormat(checkManual.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                            <td>#dateFormat(checkManual.pr_rejected_date, 'mm/dd/yyyy')#</td>
                        </Tr>  
                        </cfloop>  
                    </Cfif>
               
				</cfoutput>
                
                <!----Display previous kids assigned to this rep and any reports that have been filled out---->
                
                <cfset secondMyCurrentRow = 1>
                   
                   
             <!----
			 Display the pervious kids WITH reports that were assigned to this person
			 ---->
             <!----Kids from old Placement Management---->
			 <Cfquery name="previousKids" datasource="#APPLICATION.DSN#">
                      SELECT hh.studentid
                        FROM smg_hosthistory hh
                        WHERE hh.secondVIsitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.secondvisitrepid#">
                        AND  hh.studentid not in
                             (SELECT studentid
                              FROM smg_students
                              WHERE secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.secondvisitrepid#"> )
                           
                        UNION       
                             
                        SELECT
                            sht.studentid
                        FROM
                            smg_hostHistoryTracking sht
                        
                        WHERE 
                            fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.secondvisitrepid#">
                        AND 
                            fieldName = 'secondVisitRepID'
                        AND sht.studentid NOT IN 
                          (SELECT hh.studentid
                           FROM smg_hosthistory hh
                           WHERE hh.secondVIsitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.secondvisitrepid#">) 
          
			  </cfquery>

             
             
             
             <cfif previousKids.recordcount>
             	 <tr>
                        <td colspan=11><strong><font color=##2d5674>Previously Assigned</font></strong> </td>
                    </tr>
             </cfif>
            		 
                    <cfloop query="previousKids">
                   
                    <Cfquery name="reportInfo" datasource="#APPLICATION.DSN#">
                    select pr.pr_id, pr.fk_student,pr.pr_sr_approved_Date, pr.manual, fk_ra_user, pr.fk_host, pr_ra_approved_date, pr_rd_approved_date, pr_ny_approved_date,  s.studentid, pr_rejected_date, s.firstname, s.familylastname,
                    h.familylastname as hostLast, s.firstname, s.familylastname
                    from smg_students s
                    LEFT OUTER join progress_reports pr on  pr.fk_student = s.studentid
                    LEFT JOIN smg_hosts h on h.hostid = pr.fk_host
                    where pr.fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#previousKids.studentid#">
                    AND fk_secondvisitrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetResults.secondvisitrepid#">
                    AND pr.fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                    
                    </cfquery>
                    
                    <Cfif reportInfo.recordcount eq 0>
               
                    <Cfquery name="missingKid" datasource="#APPLICATION.DSN#">
                    select firstname, familylastname
                    from smg_students
                    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#previousKids.studentid#">                    
                    </Cfquery>
                    
                    <tr  bgcolor="#iif(previousKids.currentRow MOD 2 ,DE("eeeeee") ,DE("white") )#" >
                    	<Td></Td>
                        <Td>#missingKid.firstname# #missingkid.familylastname# (#previousKids.studentid#)</Td>
                        <td></td>
                        <td>#reportInfo.hostLast#</td>
                        <td>No</td>
                        <td>  <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                 
                                    <input type="hidden" name="studentid" value="#previousKids.studentid#">
                                    <input type="hidden" name="type_of_report" value="2">
                                    <input type="hidden" name="month_of_report" value="#CLIENT.pr_rmonth#">
                                    <input type="hidden" name="fk_host" value="" />
                                    <input type="hidden" name="fk_secondVisitRep" value="#qGetResults.secondVisitRepID#">
                                    <input name="Submit" type="image" src="pics/buttons/greenNew.png" alt="Add New Report" border=0>
                                </form>
                       </td>
                       <td colspan=5></td>
                    </tr>
                    <cfelse>
                    <Cfquery name="checkWelcome" datasource="#APPLICATION.DSN#">
                           select  distinct hh.hostID, hh.studentid, h.familylastname, isWelcomeFamily
                           from smg_hostHistory hh
                           LEFT JOIN smg_hosts h on h.hostid = hh.hostid
                           where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#reportInfo.studentid#">
                           and hh.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="#reportInfo.fk_host#"> 
                           and hh.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                       </cfquery>
                      <Cfquery name="welcomeCheck" dbtype="query">
                       select *
                       from checkWelcome
                       where hostid = #reportInfo.fk_host#
                       </cfquery>
                       <Cfif welcomeCheck.recordcount eq 1>
                       	<cfset isWelcomeFam3 = #welcomeCheck.isWelcomeFamily#>
                       <cfelse>
                       	 <Cfset isWelcomeFam3 = 0>
                       </Cfif>
                      <tr  <Cfif isWelcomeFam3 eq 1>bgcolor="##bed1fc"<cfelse> bgcolor="#iif(previousKids.currentRow MOD 2 ,DE("eeeeee") ,DE("white") )#"</cfif> >
                    	<Td></Td>
                        <Td>#reportInfo.firstname# #reportInfo.familylastname# (#reportInfo.studentid#)</Td>
                        <td></td>
                        <td>#reportInfo.hostlast#</td>
                        <td>Yes</td>
                        <td>  <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#reportInfo.pr_id#">
                                <img src="pics/buttons/greyedView.png" alt="Edit Report" border=0>
                              </a>
                       </td>
                       <td>#dateFormat(reportInfo.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                            <td>
                                <cfif reportInfo.fk_ra_user EQ ''>
                                   N/A
                                <cfelse>
                                    #dateFormat(reportInfo.pr_ra_approved_date, 'mm/dd/yyyy')#
                              </cfif>
                            </td>
                            <td>#dateFormat(reportInfo.pr_rd_approved_date, 'mm/dd/yyyy')#</td>
                            <td>#dateFormat(reportInfo.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                            <td>#dateFormat(reportInfo.pr_rejected_date, 'mm/dd/yyyy')#</td>
                    </tr>
                    </Cfif>
                    </cfloop>
                    <tr>
                    	<td>&nbsp;</td>
                    </tr>
              </cfoutput>
              
            </cfoutput>
    
    </table>

	<!----end of page---->
    <table width=100% bgcolor="#eeeeee" class="section">
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
             <td>
                <table>
                  <tr>
                    <td bgcolor="#bed1fc" width="15">&nbsp;</td>
                    <td>Welcome Family</td>
                  </tr>
                </table>
            </td>
        </tr>
    </table>
           
<cfelse>

    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
        <tr>
            <td align="center">No second visit reports matched your criteria.</td>
        </tr>
    </table>
    
</cfif>

<!--- Table Footer --->
<gui:tableFooter 
	width="100%"
/>