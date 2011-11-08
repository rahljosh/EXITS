<cfparam name="client.pr_regionid" default="#client.regionid#">
<cfparam name="client.pr_cancelled" default="0">
<cfparam name="client.reportType" default="2">
<cfparam name="form.reportType" default="2">
<Cfparam name="form.rmonth" default="#DatePart('m', '#now()#')#">
<Cfparam name="client.pr_rmonth" default="#DatePart('m', '#now()#')#">
<Cfparam name="resetMonth" default="0">
<cfparam name="startDate" default="">
<cfparam name="resetMonth" default="0">
<cfparam name="endDate" default="">
<cfparam name="repDUeDate" default="">
<Cfparam name="inCountry" default= 1>
<Cfparam name="PreviousReportApproved" default="0">


<Cfif client.usertype lte 4 and form.reportType eq 1>
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

<Cfif isDefined('form.reportType')>
	<cfif form.reportType neq client.ReportType>
    	<Cfset resetMonth = 1>
	</cfif>
	<cfset client.reportType = #form.reportType#>
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

<Cfif #form.rmonth# neq 0 AND resetMonth eq 0>
	<Cfset client.pr_rmonth = #form.rmonth#>
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

<!--- save the submitted values. --->
<cfif isDefined("form.submitted")>
	<cfif isDefined("form.regionid")>
		<cfset client.pr_regionid = form.regionid>
    </cfif>
    <cfset client.pr_cancelled = form.cancelled>
    <!----
	<cfset client.pr_rmonth = form.rmonth> 
	---->
	
</cfif>

<!--- set the corresponding database field used in the output. --->
<cfswitch expression="#client.pr_rmonth#">
<cfcase value="9">
	<cfset dbfield = 'sept_report'>
</cfcase>
<cfcase value="10">
	<cfset dbfield = 'oct_report'>
</cfcase>
<cfcase value="11">
	<cfset dbfield = 'nov_report'>
</cfcase>
<cfcase value="12">
	<cfset dbfield = 'dec_report'>
</cfcase>
<cfcase value="1">
	<cfset dbfield = 'jan_report'>
</cfcase>
<cfcase value="2">
	<cfset dbfield = 'feb_report'>
</cfcase>
<cfcase value="3">
	<cfset dbfield = 'march_report'>
</cfcase>
<cfcase value="4">
	<cfset dbfield = 'april_report'>
</cfcase>
<cfcase value="5">
	<cfset dbfield = 'may_report'>
</cfcase>
<cfcase value="6">
	<cfset dbfield = 'june_report'>
</cfcase>
<cfcase value="7">
	<cfset dbfield = 'july_report'>
</cfcase>
<cfcase value="8">
	<cfset dbfield = 'aug_report'>
</cfcase>
</cfswitch>

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
    
	
    <table width=100% class="section">
        <cfoutput query="getResults" group="advisorid">
      
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
          		<Cfset subSetOfKids = ''>
			    <tr>
                    <td colspan=11 class="rep">#rep_firstname# #rep_lastname# (#secondVisitRepID#)</td>
                <tr>
                <tr align="left">
                    <th width="15">&nbsp;</th>
                    <th>Student</th>
                    <th>Days Placed</th>
                    <th>Host</th>
                    <th>Submitted</th>
                    <th>Action</th>
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
                    </cfquery>
                    
				<!----Figure out how long they have been placed with this host family and host family info---->
                <Cfquery name="hostHistory" datasource="#application.dsn#">
                SELECT isWelcomeFamily, isRelocation, original_place,  welcome_family, relocation, h.familyLastName as hostLastName
                FROM smg_hosthistory
                LEFT JOIN smg_hosts h on h.hostid = smg_hosthistory.hostid
                WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                AND smg_hostHistory.hostid = #getResults.hostid#
                </cfquery> 
                <Cfif hostHistory.original_place is 'yes'>
                	<cfquery name="arrivalInfo" datasource="#application.dsn#">
                    SELECT max(dep_date) as dep_date
                    FROM smg_flight_info
                    WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
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
         	
               
                
       
                <!----display info for the current report---->
                  <cfset mycurrentRow = mycurrentRow + 1>
                   <tr <Cfif hostHistory.welcome_family eq 1>bgcolor="##bed1fc"<cfelse> bgcolor="#iif(mycurrentRow MOD 2 ,DE("eeeeee") ,DE("white") )#"</cfif>>
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
                        <td>#hostHistory.hostlastname# (#hostid#)</td>
                      
                        <td>#yesNoFormat(get_report.recordCount)#</td>
                        <td>

                        <cfif get_report.recordCount>
                            	<!--- access is limited to: client.usertype LTE 4, second vist rep, supervising rep, regional advisor, regional director, and facilitator. --->
								<cfif client.usertype LTE 4 or listFind("#get_report.fk_secondVisitRep#,#get_report.fk_sr_user#,#get_report.fk_ra_user#,#get_report.fk_rd_user#,#get_report.fk_ny_user#, #get_report.fk_secondVisitRep#", client.userid)>
									<!--- restrict view of report until the supervising rep approves it. --->
                                    <!----check the type of report, use appropriate person to view---->
								
                                        <cfset submittingRep = '#secondVisitRepID#'>
                                    
                                    <cfif get_report.pr_sr_approved_date EQ '' and submittingRep NEQ client.userid>
                                        <!----allow office to view so can delete if needed---->
                                        <Cfif listfind('1,12313,13799,510', client.userid)>
                                       
                                            <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#get_report.pr_id#">
                                           
                                        </cfif>	
                                        Pending</a>
                                    	<!----end allow view to delete---->
                                    <cfelse>
                                        
                                        <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#get_report.pr_id#">View</a>
                                       
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
                                
                                        <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                        <input type="hidden" name="studentid" value="#getResults.studentid#">
                                        <input type="hidden" name="type_of_report" value="#client.reportType#">
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
                    </tr>    
                <cfset subSetOfKids = listAppend(subSetOfKids, #studentid#)>
        		
				</cfoutput>
                
                <!----Display previous kids assigned to this rep and any reports that might have been filled out---->
                
                <cfset secondMyCurrentRow = 1>
                <cfquery name="previousKids" datasource="#application.dsn#">
                SELECT *, smg_students.firstname, smg_students.familylastname, smg_students.uniqueid, smg_students.hostid as currentHostID, smg_hosts.familylastname as hostlastname
                FROM progress_reports
                LEFT JOIN smg_students on smg_students.studentid = fk_student
                LEFT JOIN smg_hosts on smg_hosts.hostid = fk_host
                WHERE fk_secondVisitRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#secondVisitRepID#">
                AND fk_student NOT IN (#subSetOfKids#)
                AND fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                order by smg_students.familylastname
                </cfquery>
                
				<cfif previousKids.recordcount gt 0>
                
                <Cfquery name="hostHistory" datasource="#application.dsn#">
                SELECT isWelcomeFamily, isRelocation, original_place,  welcome_family, relocation, h.familyLastName as hostLastName
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
                <!----
                <cfquery name="secondHostHistory" datasource="#application.dsn#">
                select *
                from smg_hosthistory
                where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#previousKids.fk_student#">
                and hostid !=<cfqueryparam cfsqltype="cf_sql_integer" value="#previousKids.currentHostID#">
                and relocation = 'yes'
                </cfquery>
				<cfif secondHostHistory.recordcount gt 0>
                <Cfdump var="#secondHostHistory#">
                </cfif>
				---->
                    <tr>
                        <td colspan=11><strong><font color=##2d5674>Previously Assigned</font></strong> </td>
                    </tr>
                   
                    <!----
                    <tr align="left">
                        <th width="15">&nbsp;</th>
                        <th>Student</th>
                        <th>Days Placed</th>
                        <th>Host</th>
                        <th>Submitted</th>
                        <th>Action</th>
                        <th>SR Approved</th>
                        <th>RA Approved</th>
                        <th>RD Approved</th>
                        <th>Facilitator Approved</th>
                        <th>Rejected</th>
                    </tr>
					<Cfif hostHistory.welcome_family eq 1>bgcolor="##bed1fc"<cfelse></cfif>
					---->
                    <cfloop query="previousKids">
                     <tr  bgcolor="#iif(secondMyCurrentRow MOD 2 ,DE("eeeeee") ,DE("white") )#">
                        <td width="15">&nbsp;</td>
                        <td><a href="javascript:OpenLetter('reports/PlacementInfoSheet.cfm?uniqueID=#previousKids.uniqueID#');">#firstname# #familylastname# (#fk_student#)</a></td>
                        <td>#daysPlaced#</td>
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
		<!--- don't do for usertype 7 because they see only students they're supervising. --->
        <cfif client.usertype NEQ 7>
            <td><font color="FF0000"><strong>Students that you're supervising</strong></font></td>
        </cfif>
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