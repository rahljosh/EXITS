<Cfif isDefined('FORM.hideReport')>
	
    <Cfquery datasource="#application.dsn#">
    INSERT INTO smg_hide_reports (fk_student, fk_host, fk_secondVisitRep, fk_userid, dateChanged)
    					VALUES (#FORM.fk_student#, #FORM.fk_host#, #FORM.fk_secondVisitRep#, #client.userid#, #now()#)
    </Cfquery>
	
</Cfif>

<Cfif isDefined('FORM.unHideReport')>
	
    <Cfquery datasource="#application.dsn#">
    delete from smg_hide_reports where id = #FORM.unHideReport#

    </Cfquery>
	
</Cfif>
<cfparam name="FORM.pr_action" default="">

<cfswitch expression="#FORM.pr_action#">
	<cfcase value="delete_report">
    <cfquery datasource="#application.dsn#">
        DELETE FROM progress_report_dates
        WHERE fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
    </cfquery>
    <cfquery datasource="#application.dsn#">
        DELETE FROM x_pr_questions
        WHERE fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
    </cfquery>
    <cfquery datasource="#application.dsn#">
        DELETE FROM progress_reports
        WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
    </cfquery>
    <cflocation url="index.cfm?curdoc=secondVisitReports" addtoken="no">
    </cfcase>
</cfswitch>

<cfparam name="client.pr_regionid" default="#client.regionid#">
<cfparam name="client.pr_cancelled" default="0">
<cfparam name="client.reportType" default="2">
<Cfparam name="client.pr_rmonth" default="#DatePart('m', '#now()#')#">

<cfparam name="FORM.submitted" default="0">
<cfparam name="FORM.reportType" default="2">
<cfparam name="FORM.regionID" default="0">
<Cfparam name="FORM.rmonth" default="#DatePart('m', '#now()#')#">
<cfparam name="FORM.cancelled" default="0">

<Cfparam name="resetMonth" default="0">
<cfparam name="startDate" default="">
<cfparam name="resetMonth" default="0">
<cfparam name="endDate" default="">
<cfparam name="repDUeDate" default="">
<Cfparam name="inCountry" default= 1>
<Cfparam name="PreviousReportApproved" default="0">
<cfparam name="FORM.selectedProgram" default="">

<cfscript>
	// This page will always display second visit reports
	// CLIENT.reportType = 2;
	
	// save the submitted values
	if ( VAL(FORM.submitted) ) {
	
		// Set CLIENT Variable
		CLIENT.pr_regionID = FORM.regionID;
		CLIENT.pr_cancelled = FORM.cancelled;
		CLIENT.selectedProgram = FORM.selectedProgram;
	
	} else {
		
		// Set CLIENT Default Values 	
		CLIENT.pr_regionID = CLIENT.regionID;
		CLIENT.pr_cancelled = 0;
		CLIENT.selectedProgram = '';
	
	}
</cfscript>

<Cfset client.selectedProgram = FORM.selectedProgram>

<Cfif FORM.reportType eq 1>
	<cflocation url="index.cfm?curdoc=progress_reports" addtoken="no">
</Cfif>

<SCRIPT>
<!--
// opens letters in a defined format
function OpenLetter(url) {
	newwindow=window.open(url, 'Application', 'height=700, width=850, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>

<Cfscript>
	//Check if paperwork is complete for season
	qGetPrograms = APPLICATION.CFC.program.getPrograms(isActive=1);
</cfscript>

<cfscript>
    //by creating the function inside of a cfscript, it should be able to work in CF5.
    
    function isBetween(compVal, loVal, hiVal) {
       var myRetVal = false; 
       //I prefer to set a return variable. It?s part of one of the old coding
       //practices I learned years ago, always have one entry and one exit.
       
       //Here we check to see if our range was properly created i.e. 1..5 or
       //?10/01/2003? to ?10/31/2003? 
       if(loVal LTE hiVal) {
           //If it is, compare our value with the range and set the return
           //value if it is in the range.
           if(compVal GTE loVal AND compVal LTE hiVal)
                myRetVal = true; 
           } 
           else {
                //If loVal is greater than hiVal, reverse the compare.
                //Then set the return variable if our value is in the reversed
                //range. Sometimes we have to protect ourselves from common
                //mistakes.
                if(compVal GTE hiVal AND compVal LTE loVal)
                    myRetVal = true; 
            }

        //And finally our single exit point.
        return myRetVal;
     }
</cfscript>
<!---_Set the current year so when can set the correct start and end dates to figure if a report should be filled out---->
<cfset year=#DateFormat(now(), 'yyyy')#><title>Second Visit Reports</title>


<cfif not client.usertype LTE 7>
	<cfif client.usertype EQ 15>
    <cfelse>
	You do not have access to this page.
    <cfabort>
    </cfif>
</cfif>

<Cfif isDefined('FORM.reportType')>
	<cfif FORM.reportType neq client.ReportType>
    	<Cfset resetMonth = 1>
	</cfif>
	<cfset client.reportType = #FORM.reportType#>
</Cfif>
<Cfif client.usertype EQ 15>
	<cfset client.reportType = 2>
	<Cfset enableReports = 'No'>
<cfelse>
	<cfset enableReports = 'Yes'>
</Cfif>

       <Cfquery name="DateRange" datasource="mysql">
        SELECT seasonid, startDate, endDate
        FROM smg_seasons
        WHERE #now()# >= startdate and #now()# <= endDate
        </cfquery>

<!----If a month is passed in from the form, use it for the month if its works with the current report type---->

<Cfif #FORM.rmonth# neq 0 AND resetMonth eq 0>
	<Cfset client.pr_rmonth = #FORM.rmonth#>

      <Cfloop from="#DateRange.startDate#" to="#DateRange.endDate#" index=i step="#CreateTimeSpan(31,0,0,0)#">
                <Cfif client.pr_rmonth eq "#DatePart('m', '#i#')#">
                    <Cfset client.pr_rmonth = '#DatePart('m', '#i#')#'>
                    <Cfset startDate = '#DateAdd("d", "-7", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                    <Cfset endDate = '#DateAdd("d", "21", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                    <cfset prevRepMonth = "#DatePart('m','#startDate#')#">
                    <cfset repReqDate = '#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01'>
                    <Cfset repDueDate = '#DateAdd("m", "0", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
               </Cfif>
           </Cfloop>
   
	
<!----If no month is passed in, we need to set to the current month---->
<Cfelse>

    <!---
    <cfif NOT isDefined('client.pr_rmonth') or client.pr_rmonth eq 0>
        ---->
 

        
        
		<cfif client.reportType eq 1>
        
         <Cfif client.userid eq 16316>
         <Cfoutput>
         Output #DateRange.startDate# #DateRange.endDate#
         </Cfoutput>
         </Cfif>
            <Cfloop from="#DateRange.startDate#" to="#DateRange.endDate#" index=i step="#CreateTimeSpan(31,0,0,0)#">
                <Cfif client.pr_rmonth eq "#DatePart('m', '#i#')#">
                    <Cfset client.pr_rmonth = '#DatePart('m', '#i#')#'>
                    <Cfset startDate = '#DateAdd("d", "-7", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                    <Cfset endDate = '#DateAdd("d", "21", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                    <cfset prevRepMonth = "#DatePart('m','#startDate#')#">
                    <cfset repReqDate = '#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01'>
                    <Cfset repDueDate = '#DateAdd("m", "1", "#DatePart("yyyy", "#i#")#-#DatePart("m", "#i#")#-01")#"'>
                 </Cfif>
                
           </Cfloop>
        </cfif>
 </cfif>

<!----All available Reports---->
<cfquery name="reportTypes" datasource="#application.dsn#">
select *
from reportTrackingType
where isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
<cfif client.companyid eq 14>
and esi = 14
</cfif>
</cfquery>

<!----get Menu options for seleted report---->
<cfquery name="reportOptions" dbtype="query">
select *
from reportTypes
where reportTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.reportType#">
</cfquery>

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

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
  <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
        <td background="pics/header_background.gif"><h2>Second Visit Reports</h2></td>
        <td background="pics/header_background.gif" align="right"></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfform action="index.cfm?curdoc=secondVisitReports" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
	<Tr>
    	<td></td>
    	
    </Tr>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
    
        <td>Reports Available<br />
        <Cfif client.usertype NEQ 15>
              	 <cfselect 
                  name="reportType" 
                  id="reportType" multiple="no"
                  query="reportTypes"
                  value="reportTypeID"
                  display="Description"
                  selected="#client.reportType#"/>
       	<Cfelse>
    	Second Host Family Visit    
        </Cfif>
        </td>
       
        <td>
        Programs <br />

              <cfoutput>
 				<select name="selectedProgram" size="5" multiple="multiple">
               	   <cfloop query="qGetPrograms">
                    	<option value="#programID#" <Cfif ListFind(#client.selectedprogram#,#programID#)> selected </cfif> >#programName#</option>
                    </cfloop>
				</select>
    		</cfoutput> 	
                
      		
      </td>
    
	<cfif client.usertype LTE 4>
       <td>
			<!--- GET ALL REGIONS --->
            <cfquery name="list_regions" datasource="#application.dsn#">
                SELECT regionid, regionname
                FROM smg_regions
                WHERE company = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                AND subofregion = 0
                ORDER BY regionname
            </cfquery>
            Region<br />
			<cfselect NAME="regionid" query="list_regions" value="regionid" display="regionname" selected="#client.pr_regionid#" />
        </td>
	</cfif>
    

        <td>
            Status<br />
			<select name="cancelled">
				<option value="0" <cfif client.pr_cancelled EQ 0>selected</cfif>>Active</option>
				<option value="1" <cfif client.pr_cancelled EQ 1>selected</cfif>>Cancelled</option>
			</select>            
        </td>
    </tr>
    <tr>
    	<Td colspan=5 align="Center">
		<cfif client.reportType neq 2>
			<cfoutput>The #DateFormat('#endDate#', 'mmmm')# report is for contact durring the month of #DateFormat('#startDate#', 'mmmm')# and <Br />
			due on  #DateFormat('#repDueDate#','mmm. d, yyyy')#. </cfoutput>
        </cfif>
        </Td>
    </tr>
</table>
</cfform>

<!---Get the current reports.  Old reports are retrieved below---->
<cfquery name="getResults" datasource="#application.dsn#">
    SELECT smg_students.studentid, smg_students.uniqueid, smg_students.firstname, smg_students.familylastname, smg_programs.type as programType, smg_students.hostid,
     		 smg_students.date_host_fam_approved, smg_students.arearepid, smg_students.secondVisitRepID, rep.firstname as rep_firstname, rep.lastname as rep_lastname,
        <!--- alias advisor.userid here instead of using user_access_rights.advisorid because the later can be 0 and we want null, and the 0 might be phased out later. --->
        advisor.userid AS advisorid, advisor.firstname as advisor_firstname, advisor.lastname as advisor_lastname
  
    FROM smg_students
    INNER JOIN smg_users rep ON smg_students.secondVisitRepID = rep.userid
    INNER JOIN user_access_rights ON (
    	
        smg_students.secondVisitRepID = user_access_rights.userid
        AND smg_students.regionassigned = user_access_rights.regionid
    	
    )
    LEFT JOIN smg_users advisor ON user_access_rights.advisorid = advisor.userid
    INNER JOIN smg_programs ON smg_students.programid = smg_programs.programid
    WHERE smg_students.regionassigned =
    <cfif client.usertype LTE 4>
    	<cfqueryparam cfsqltype="cf_sql_integer" value="#client.pr_regionid#">
    <!--- don't use client.pr_regionid because if they change access level this is not reset. --->
    <cfelse>
    	<cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
    </cfif>
    <cfif client.pr_cancelled eq 0>
        AND smg_students.active = 1
    <cfelse>
        AND smg_students.canceldate >= '#datelimit#'
    </cfif>
    <Cfif client.selectedProgram gt 0>
    	AND
      	 smg_students.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#client.selectedprogram#" list="yes"> )
    	
       
    </Cfif>

    <!--- regional advisor sees only their reps or their students. --->
    
		<cfif client.usertype EQ 6>
            AND (
                user_access_rights.advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                OR smg_students.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                OR smg_students.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
               
            )
        <!--- supervising reps sees only their students. --->
        <cfelseif client.usertype EQ 7>
        	AND smg_students.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    	<cfelseif client.usertype eq 15>
        	AND smg_students.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfif>
	
    <!--- include the advisorid and arearepid because we're grouping by those in the output, just in case two have the same first and last name. --->
    ORDER BY advisor_lastname, advisor_firstname, user_access_rights.advisorid, rep_lastname, rep_firstname, smg_students.arearepid, smg_students.familylastname, smg_students.firstname
</cfquery>


<cfif getResults.recordCount GT 0>

	<!--- get the reports, used in a query of query below, because LEFT JOIN is too slow in mySQL. --->
    <cfquery name="get_reports" datasource="#application.dsn#">
       SELECT *
        FROM progress_reports
        WHERE fk_student IN (#valueList(getResults.studentid)#)
        AND fk_reportType = 2
    </cfquery>
    
	
    <table width=100% class="section" cellpadding=4 cellspacing="0" border=0>
        <cfoutput query="getResults" group="advisorid">
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
            	
            	<cfset groupBy = "secondVisitRepID">
            	<cfoutput group="#groupBy#">
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
                <Cfquery name="hostHistory" datasource="#application.dsn#">
                SELECT original_place,  isWelcomeFamily, isRelocation, datePlaced
                FROM smg_hosthistory
                LEFT JOIN smg_hosts h on h.hostid = smg_hosthistory.hostid
                WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                AND smg_hostHistory.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(getResults.hostid)#">
                </cfquery> 
                <cfquery name="checkHostHistoryOriginal" datasource="#application.dsn#">
                select hostid
                from smg_hosthistory
                where original_place = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
                and studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                </cfquery>
                <cfquery name="hostName" datasource="#application.dsn#">
                select familyLastName, hostid
                from smg_hosts
                where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.hostid#">
                </cfquery>
               		<cfset isWithOriginal = 'no'>
			   <cfif (checkHostHistoryOriginal.hostID eq hostName.hostid)>
               		<cfset isWithOriginal = 'yes'>
               </cfif>
               <Cfif isWithOriginal is 'no' and hostHistory.datePlaced lt #dateRange.startdate#>
               		<cfset isWithOriginal = 'yes'>
               </Cfif>
			   
                <Cfif isWithOriginal is 'yes' >
                	<cfquery name="arrivalInfo" datasource="#application.dsn#">
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
         		<Cfquery name="checkBlock" datasource="#application.dsn#">
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
                            <a href="javascript:OpenLetter('reports/PlacementInfoSheet.cfm?uniqueID=#getResults.uniqueID#');">
							<cfif getResults.arearepid EQ client.userid and client.usertype NEQ 7>
                        		<font color="FF0000"><strong>#getResults.firstname# #getResults.familylastname# (#getResults.studentid#)</strong></font>
                            <cfelse>
                        		#getResults.firstname# #getResults.familylastname# (#getResults.studentid#)
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
                            	<!--- access is limited to: client.usertype LTE 4, second vist rep, supervising rep, regional advisor, regional director, and facilitator. --->
								<cfif client.usertype LTE 4 or listFind("#get_report.fk_secondVisitRep#,#get_report.fk_sr_user#,#get_report.fk_ra_user#,#get_report.fk_rd_user#,#get_report.fk_ny_user#, #get_report.fk_secondVisitRep#", client.userid)>
									<!--- restrict view of report until the supervising rep approves it. --->
                                    <!----check the type of report, use appropriate person to view---->
								
                                        <cfset submittingRep = '#secondVisitRepID#'>
                                    
                                    <cfif get_report.pr_sr_approved_date EQ '' and submittingRep NEQ client.userid>
                                        <!----allow office to view so can delete if needed---->
                                        <Cfif listfind('1,12313,13799,510,12431,16652,12389', client.userid)>
                                       
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
                            <cfif client.reportType EQ 2>
                            	<cfset submittingRep = '#getResults.secondVisitRepID#'>
                            <cfelse>
                            	<Cfset submittingRep = '#getResults.arearepid#'>
                            </cfif>
                            <Cfif client.pr_rmonth eq 10>
                        		<Cfset PreviousReportApproved = 1>
                            </Cfif>
                            	<!--- to add a progress report, user must be the supervising rep, and the program has a report for this phase. --->
                          			<Cfif inCountry eq 0>
                                    Not in Country - No Report Required
									<cfelseif (#submittingRep# EQ client.userid and PreviousReportApproved eq 1) OR client.reportType EQ 2  >
                                    	<Cfif checkBlock.recordcount gt 0>
                                           <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                                <input type="hidden" name="unHideReport" value="#checkBlock.id#" />
                                                <input type="hidden" name="selectedProgram" value="#client.selectedProgram#" />
                                                <input name="Submit" type="image" src="pics/plus.png" height="20" alt="Add New Report" border=0>
                                            </form>
                                        <cfelse>
                                            <table>
                                                <Tr>
                                                    <Td>
                                                   
                                                <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                                <input type="hidden" name="studentid" value="#getResults.studentid#">
                                                <input type="hidden" name="type_of_report" value="#client.reportType#">
                                                <input type="hidden" name="month_of_report" value="#client.pr_rmonth#">
                                                <input type="hidden" name="fk_host" value="#hostid#">
                                                <input name="Submit" type="image" src="pics/buttons/greenNew.png" alt="Add New Report" height="20"  border=0>
                                               </form>
                                                    </Td>
                                                    <td>
                                                   <cfif client.userid eq 8731 or 
												   		 client.userid eq 1 or 
														 client.userid eq 510 or
														 client.userid eq 12431 or 
														 client.userid eq 12313 or
														 client.userid eq 12389 or
														 client.userid eq 16652 or
														 client.userid eq 8743 or
														 client.userid eq 11364 or
														 client.userid eq 13799
														 >
                                                     <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                                        <input type="hidden" name="hideReport" />
                                                        <input type="hidden" name="fk_student" value="#studentid#">
                                                        <input type="hidden" name="fk_host" value="#hostid#">
                                                        <input type="hidden" name="fk_secondVisitRep" value="#secondVisitRepID#">
                                                        <input type="hidden" name="selectedProgram" value="#client.selectedProgram#" />
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
                                <cfif getResults.advisorid EQ ''>
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
               <Cfquery name="getPrevHosts" datasource="#application.dsn#">
               select  distinct hh.hostID, hh.studentid, h.familylastname
               from smg_hostHistory hh
               LEFT JOIN smg_hosts h on h.hostid = hh.hostid
               where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
               and hh.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="#hostid#"> 
               and hh.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
               
			   </cfquery>
              
               <cfif getPrevHosts.recordcount gt 0>
                       <Cfquery name="checkWelcome" datasource="#application.dsn#">
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
                        <cfquery name="indReports" datasource="#application.dsn#">
                        select *, u.firstname as svFirst, u.lastname as svLast
                        from progress_reports
                        left join smg_users u on u.userid = progress_reports.fk_secondvisitrep
                        where fk_student = #studentid#
                        and fk_host = #hostid# 
                        and fk_reportType = 2
                        
                        </cfquery>
                      
                        <!----check if block on report should be in place---->
                        <Cfquery name="checkBlock2" datasource="#application.dsn#">
                        SELECT hr.id, hr.dateChanged, u.firstname, u.lastname
                        FROM smg_hide_reports hr
                        LEFT JOIN smg_users u on u.userid = hr.fk_userid
                        WHERE hr.fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPrevHosts.studentid#">
                        AND hr.fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPrevHosts.hostid#">
                        <!----
                        AND hr.fk_secondVisitRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.secondVisitRepID#">
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
                                        <cfif client.userid eq 8731 or 
												   		 client.userid eq 1 or 
														 client.userid eq 510 or
														 client.userid eq 12431 or 
														 client.userid eq 12313 or
														 client.userid eq 12389 or
														 client.userid eq 16652 or
														 client.userid eq 8743 or
														 client.userid eq 11364 or
														 client.userid eq 13799
														 >
                                        <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                                <input type="hidden" name="unHideReport" value="#checkBlock2.id#" />
                                                <input type="hidden" name="selectedProgram" value="#client.selectedProgram#" />
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
                                    <input type="hidden" name="month_of_report" value="#client.pr_rmonth#">
                                    <input type="hidden" name="fk_host" value="#hostid#" />
                                    <input type="hidden" name="fk_secondVisitRep" value="#getResults.secondVisitRepID#">
                                    <input name="Submit" type="image" src="pics/buttons/greenNew.png" alt="Add New Report" border=0>
                                </form>
                                        </TD>
                                        <Td>
                                        <Cfif client.usertype lte 4>
                                <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                    <input type="hidden" name="hideReport" />
                                    <input type="hidden" name="fk_student" value="#studentid#">
                                    <input type="hidden" name="fk_host" value="#hostid#">
                                    <input type="hidden" name="fk_secondVisitRep" value="#getResults.secondVisitRepID#">
                                    <input type="hidden" name="selectedProgram" value="#client.selectedProgram#" />
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
                                    <cfif getResults.secondvisitrepid neq indReports.fk_secondvisitrep>
                                 	<tr  ><td colspan=2>
                                    <cfelse>
                              		<td>
                                    
                                    </cfif>
									
									
									
                                    <cfif getResults.secondvisitrepid neq fk_secondvisitrep>
                                     <Cfif client.usertype lte 4><a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#indReports.pr_id#"></Cfif>
                                     <font size=-1><em> #svFirst# #svLast# (#fk_secondvisitrep#)
                                      <Cfif client.usertype lte 4>
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
                                        <cfif client.usertype lte 4>
                                        <form action="index.cfm?curdoc=secondVisitReports" method="post">
                                                <input type="hidden" name="unHideReport" value="#checkBlock.id#" />
                                                <input type="hidden" name="selectedProgram" value="#client.selectedProgram#" />
                                                <input name="Submit" type="image" src="pics/plus.png" height="20" alt="Add New Report" border=0>
                                            </form>
                                        </cfif>
                                                    </td>
                                                 </tr>
                                              </table>			
                                        
                                        </Td>
                                       </tr>
                                   <Cfelse>
                                        <cfif getResults.secondvisitrepid eq fk_secondvisitrep>
                                            <tr  ><td>
                                             <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#pr_id#"><img src="pics/buttons/greyedView.png" border=0 /></a>
                                            </td>
                                       </cfif>
                                         <td>#dateFormat(indReports.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                                        <td>
                                            <cfif getResults.advisorid EQ ''>
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
                    <Cfquery name="checkManual" datasource="#application.dsn#">
                    select *, h.familylastname
                    from progress_reports
                    left join smg_hosts h on h.hostid = progress_reports.fk_host
                    where fk_student =  <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                    and manual = 1
                    </cfquery>
                     <Cfif checkManual.recordcount gt 0>
                     <Cfquery name="checkWelcome" datasource="#application.dsn#">
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
                    
                      <Cfquery name="kidsMissingReportsNoLongerAssigned" datasource="#application.dsn#">
                      SELECT distinct hh.studentid, s.firstname, s.familylastname
                      FROM smg_hosthistory hh
                      LEFT JOIN smg_students s on s.studentid = hh.studentid 
                      WHERE hh.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#secondVisitRepID#">
                      AND (s.hostid NOT IN (#subSetOfHosts#) AND s.hostid NOT IN (#prevHostsWithReport#))
                      <cfif client.selectedProgram neq 0>
                      	AND s.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.selectedProgram#">
                      </cfif>
                      </cfquery>    
                
                 
                 <Cfif kidsMissingReportsNoLongerAssigned.recordcount gt 0>  
                 	<Cfquery name="checkWelcomeFamily" datasource="#application.dsn#">
                    	SELECT hh.isWelcomeFamily, hh.original_place, hh.hostid, hh.dateofchange, h.familylastname as hostlast
                        FROM smg_hosthistory hh
                        LEFT JOIN smg_hosts h on h.hostid = hh.hostid
                        WHERE hh.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value=" #studentid#">
                        AND hh.hostid not in (#prevHostsWithReport#)
                    </cfquery>
                    <!----Check if original place and use arrival date for placed date---->
                   <Cfif checkWelcomeFamily.original_place is 'yes'>   
                    <cfquery name="arrivalInfo" datasource="#application.dsn#">
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
                	<cfset daysPlaced = #DateDiff('d','#date_host_fam_approved#','#now()#')#>
                	
            	</Cfif>
                   
                      <cfloop query="kidsMissingReportsNoLongerAssigned">
                      	<Cfquery name="checkBlock" datasource="#application.dsn#">
                        SELECT hr.id, hr.dateChanged, u.firstname, u.lastname
                        FROM smg_hide_reports hr
                        LEFT JOIN smg_users u on u.userid = hr.fk_userid
                        WHERE hr.fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                        AND hr.fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkWelcomeFamily.hostid#">
                        AND hr.fk_secondVisitRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.secondVisitRepID#">
                        </cfquery>
                        
                      
                        
                         <tr <Cfif checkWelcomeFamily.isWelcomeFamily eq 1>bgcolor="##bed1fc"<cfelse> bgcolor="#iif(secondMyCurrentRow MOD 2 ,DE("eeeeee") ,DE("white") )#" </cfif>>
                        <td width="15">&nbsp;</td>
                        <td><a href="javascript:OpenLetter('reports/PlacementInfoSheet.cfm?uniqueID=#previousKids.uniqueID#');">#firstname# #familylastname# (#studentid#)</a></td>
                        <td>#daysPlaced#</td>
                        <td>#checkWelcomeFamily.hostlast# (#checkWelcomeFamily.hostid#)</td>
                        <td><cfif previousKids.pr_sr_approved_date is ''>No<cfelse>Yes</cfif></td>
                        <cfif checkBlock.recordcount gt 0>
                        <Td colspan=6>
                        	<table>
                            	<tr>
                                	<td>
                        <em>#checkBlock.firstname# #checkBlock.lastname# determined that this report was not required on #dateFormat(checkBlock.dateChanged, 'mm/dd/yyyy')#</em> 									</td>
                        			<td>
						<cfif client.usertype lte 4>
                        <form action="index.cfm?curdoc=secondVisitReports2" method="post">
                            	<input type="hidden" name="unHideReport" value="#checkBlock.id#" />
                            	<input type="hidden" name="selectedProgram" value="#client.selectedProgram#" />
                                <input name="Submit" type="image" src="pics/plus.png" height="20" alt="Add New Report" border=0>
                            </form>
                        </cfif>
                        			</td>
                                 </tr>
                              </table>			
                        
                        </Td>
                        <Cfelse>
                        <td>
                        	<Table cellspacing="0" cellpadding="2">
                            	<Tr>
                                	<TD>
                                   
                            <form action="index.cfm?curdoc=forms/pr_add" method="post">
                             
                                <input type="hidden" name="studentid" value="#studentid#">
                                <input type="hidden" name="type_of_report" value="2">
                                <input type="hidden" name="month_of_report" value="#client.pr_rmonth#">
                                <input type="hidden" name="fk_host" value="#checkWelcomeFamily.hostid#" />
                                <input type="hidden" name="fk_secondVisitRep" value="#getResults.secondVisitRepID#">
                                <input name="Submit" type="image" src="pics/new.gif" alt="Add New Report" border=0>
                            </form>
                            		</TD>
                                    <Td>
                            <form action="index.cfm?curdoc=secondVisitReports2" method="post">
                            	<input type="hidden" name="hideReport" />
                            	<input type="hidden" name="fk_student" value="#studentid#">
                                <input type="hidden" name="fk_host" value="#checkWelcomeFamily.hostid#">
                                <input type="hidden" name="fk_secondVisitRep" value="#getResults.secondVisitRepID#">
                                <input type="hidden" name="selectedProgram" value="#client.selectedProgram#" />
                                <input name="Submit" type="image" src="pics/smallDelete.png" height="20" alt="Add New Report" border=0>
                            </form>
                            		</Td>
                                 </Tr>
                              </Table>
                        </td>
						<td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                      </cfif>
                    </tr>
                    <Cfset secondMyCurrentRow = #secondMyCurrentRow# +1>
              </cfloop>  
          </cfif>
				<cfif previousKids.recordcount gt 0>
               
                  
               <!----This is for Displaying kids with reports---->   
                <Cfquery name="hostHistory" datasource="#application.dsn#">
                SELECT original_place,  isWelcomeFamily, isRelocation, h.familyLastName as hostLastName
                FROM smg_hosthistory
                LEFT JOIN smg_hosts h on h.hostid = smg_hosthistory.hostid
                WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#previousKids.fk_student#">
                AND smg_hostHistory.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#previousKids.fk_host#">
                </cfquery> 
                
                <Cfif hostHistory.original_place is 'yes'>
                	<cfquery name="arrivalInfo" datasource="#application.dsn#">
                    SELECT max(dep_date) as dep_date
                    FROM smg_flight_info
                    WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#previousKids.fk_student#">
                    AND flight_type = 'arrival'
                    </cfquery>
                    <!----If no arrival info is on file, we set to August 1, the earliest to make sure---->
					<Cfif arrivalInfo.recordcount eq 0 or arrivalInfo.dep_date eq ''>
                    	<Cfset arrivalDate = '#DateRange.startDate#'>
                   	<cfelse>
                    	<cfset arrivalDate = '#arrivalInfo.dep_Date#'>
                    </Cfif>
                 	<cfset daysPlaced = #DateDiff('d','#arrivaldate#','#now()#')#>
                <Cfelse>
                
                	<cfset daysPlaced = #DateDiff('d','#date_host_fam_approved#','#now()#')#>
                	
            	</Cfif>
         ---->
        	 
                   
                   
             <!----
			 Display the pervious kids WITH reports that were assigned to this person
			 ---->
             <!----Kids from old Placement Management---->
			 <Cfquery name="previousKids" datasource="#application.dsn#">
               <!----  SELECT hh.studentid
                 FROM smg_hosthistory hh
                 WHERE hh.secondVIsitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.secondvisitrepid#"> 
                 AND  hh.studentid not in
                     (SELECT studentid
                      FROM smg_students
                      WHERE secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.secondvisitrepid#"> )
                      ---->
                      SELECT hh.studentid
                        FROM smg_hosthistory hh
                        WHERE hh.secondVIsitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.secondvisitrepid#">
                        AND  hh.studentid not in
                             (SELECT studentid
                              FROM smg_students
                              WHERE secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.secondvisitrepid#"> )
                           
                        UNION       
                             
                        SELECT
                            sht.studentid
                        FROM
                            smg_hostHistoryTracking sht
                        
                        WHERE 
                            fieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.secondvisitrepid#">
                        AND 
                            fieldName = 'secondVisitRepID'
                        AND sht.studentid NOT IN 
                          (SELECT hh.studentid
                           FROM smg_hosthistory hh
                           WHERE hh.secondVIsitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.secondvisitrepid#">) 
          
			  </cfquery>

             
             
             
             <cfif previousKids.recordcount>
             	 <tr>
                        <td colspan=11><strong><font color=##2d5674>Previously Assigned</font></strong> </td>
                    </tr>
             </cfif>
            		 
                    <cfloop query="previousKids">
                   
                    <Cfquery name="reportInfo" datasource="#application.dsn#">
                    select pr.pr_id, pr.fk_student,pr.pr_sr_approved_Date, pr.manual, fk_ra_user, pr.fk_host, pr_ra_approved_date, pr_rd_approved_date, pr_ny_approved_date,  s.studentid, pr_rejected_date, s.firstname, s.familylastname,
                    h.familylastname as hostLast, s.firstname, s.familylastname
                    from smg_students s
                    LEFT OUTER join progress_reports pr on  pr.fk_student = s.studentid
                    LEFT JOIN smg_hosts h on h.hostid = pr.fk_host
                    where pr.fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#previousKids.studentid#">
                    AND fk_secondvisitrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#getResults.secondvisitrepid#">
                    AND pr.fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                    
                    </cfquery>
                    
                    <Cfif reportInfo.recordcount eq 0>
               
                    <Cfquery name="missingKid" datasource="#application.dsn#">
                    select firstname, familylastname
                    from smg_students
                    where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#previousKids.studentid#">                    
                    </Cfquery>
                    <tr  bgcolor="#iif(previousKids.currentRow MOD 2 ,DE("eeeeee") ,DE("white") )#" >
                    	<Td></Td>
                        <Td>#missingKid.firstname# #missingkid.familylastname# (#previousKids.studentid#)</Td>
                        <td></td>
                        <td>Host Fam</td>
                        <td>No</td>
                        <td>  <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                 
                                    <input type="hidden" name="studentid" value="#previousKids.studentid#">
                                    <input type="hidden" name="type_of_report" value="2">
                                    <input type="hidden" name="month_of_report" value="#client.pr_rmonth#">
                                    <input type="hidden" name="fk_host" value="" />
                                    <input type="hidden" name="fk_secondVisitRep" value="#getResults.secondVisitRepID#">
                                    <input name="Submit" type="image" src="pics/buttons/greenNew.png" alt="Add New Report" border=0>
                                </form>
                       </td>
                       <td colspan=5></td>
                    </tr>
                    <cfelse>
                    <Cfquery name="checkWelcome" datasource="#application.dsn#">
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
                    <!----
                     <tr <Cfif hostHistory.isWelcomeFamily eq 1>bgcolor="##bed1fc"<cfelse> bgcolor="#iif(secondMyCurrentRow MOD 2 ,DE("eeeeee") ,DE("white") )#" </cfif>>
                        <td width="15">&nbsp;</td>
                        <td><a href="javascript:OpenLetter('reports/PlacementInfoSheet.cfm?uniqueID=#previousKids.uniqueID#');">#firstname# #familylastname# (#fk_student#)</a></td>
                        <td></td>
                        <td>#hostlastname# (#fk_host#)</td>
                        <td><cfif previousKids.pr_sr_approved_date is ''>No<cfelse>Yes</cfif></td>
                        <td>
                        <cfif previousKids.recordCount>
                            	<!--- access is limited to: client.usertype LTE 4, second vist rep, supervising rep, regional advisor, regional director, and facilitator. --->
								<cfif client.usertype LTE 4 or listFind("#get_report.fk_secondVisitRep#,#get_report.fk_sr_user#,#get_report.fk_ra_user#,#get_report.fk_rd_user#,#get_report.fk_ny_user#, #get_report.fk_secondVisitRep#", client.userid)>
									<!--- restrict view of report until the supervising rep approves it. --->
                                    <!----check the type of report, use appropriate person to view---->
								
                                        <cfset submittingRep = '#previousKids.fk_secondVisitRep#'>
                                        
                                    
                                    <cfif pr_sr_approved_date EQ '' and submittingRep NEQ client.userid>
                                        <!----allow office to view so can delete if needed---->
                                        <Cfif listfind('1,12313,13799,510', client.userid)>
                                            <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#pr_id#">
                                        </cfif>	
                                        Pending</a>
                                    	<!----end allow view to delete---->
                                    <cfelse>
                                                                              
                                        <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#pr_id#">View</a>
                                        
                                    </cfif>
                                <cfelse>
                                	N/A 
                                </cfif>
							<!--- add report link --->
                        <cfelse>
                            <!----check the type of report, use appropriate person to view---->
                            
                            	<cfset submittingRep = '#secondVisitRepID#'>
                            
                            <Cfif client.pr_rmonth eq 10>
                        		<Cfset PreviousReportApproved = 1>
                            </Cfif>
                            	<!--- to add a progress report, user must be the supervising rep, and the program has a report for this phase. --->
                          			<Cfif inCountry eq 0>
                                    Not in Country - No Report Required
									<cfelseif (#submittingRep# EQ client.userid and PreviousReportApproved eq 1) OR client.reportType EQ 2  >

                                
                                        <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                        <input type="hidden" name="studentid" value="#studentid#">
                                        <input type="hidden" name="type_of_report" value="2">
                                        <input type="hidden" name="month_of_report" value="#client.pr_rmonth#">
                                        <input name="Submit" type="image" src="pics/new.gif" alt="Add New Report" border=0>
                                        </form>
                                    <cfelseif PreviousReportApproved eq 0>
                                       Waiting on Previous Report Approval 
                                    <Cfelse>
                                    	Report Not Submitted
                                     </cfif>
                                    
                                 <Cfset PreviousReportApproved = 0> 
                                 <cfset inCountry = 1>
                        </cfif>
                        
                        </td>
						<td>#dateFormat(previousKids.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                        <td>
							<cfif getResults.advisorid EQ ''>
                               N/A
                            <cfelse>
                                #dateFormat(previousKids.pr_ra_approved_date, 'mm/dd/yyyy')#
                          </cfif>
                        </td>
                        <td>#dateFormat(previousKids.pr_rd_approved_date, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(previousKids.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(previousKids.pr_rejected_date, 'mm/dd/yyyy')#</td>
                    </tr>
                    <Cfset secondMyCurrentRow = #secondMyCurrentRow# +1>
                  
                    </cfloop>
                                   
              	</cfif>
             ---->
              
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
		<!--- don't do for usertype 7 because they see only students they're supervising. 
        <cfif client.usertype NEQ 7>
            <td><font color="FF0000"><strong>Students that you're supervising</strong></font></td>
        </cfif>
		--->
        </tr>
    </table>
           
<cfelse>
    <table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
        <tr>
            <td>No progress reports matched your criteria.</td>
        </tr>
    </table>
</cfif>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>                 

</body>
</html>