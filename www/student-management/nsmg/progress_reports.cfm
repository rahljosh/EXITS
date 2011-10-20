<cfparam name="client.pr_regionid" default="#client.regionid#">
<cfparam name="client.pr_cancelled" default="0">
<cfparam name="client.reportType" default="1">
<Cfparam name="form.rmonth" default="#DatePart('m', '#now()#')#">
<Cfparam name="client.pr_rmonth" default="#DatePart('m', '#now()#')#">
<Cfparam name="resetMonth" default="0">
<cfparam name="startDate" default="">
<cfparam name="resetMonth" default="0">
<cfparam name="endDate" default="">
<cfparam name="repDUeDate" default="">
<Cfparam name="inCountry" default= 1>
<Cfparam name="PreviousReportApproved" default="0">


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
<cfset year=#DateFormat(now(), 'yyyy')#>


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
           
            
       <!----
            <cfswitch expression="#month(now())#">
                <cfcase value="8">
                    <!--- August --->
                    <cfset client.pr_rmonth = 8>
                    <Cfset startDate = DateAdd('d', -7, '#year#-08-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-08-01')>
                    <Cfset form.prevRepMonth = 7>
                    <cfset repReqDate = '#year#-08-31'>
                </cfcase>
                <cfcase value="9">
                    <!--- SEPT --->
                    <cfset client.pr_rmonth = 9>
                    <Cfset startDate = DateAdd('d', -7, '#year#-09-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-09-01')>
                    <Cfset form.prevRepMonth = 8>
                    <cfset repReqDate = '#year#-09-30'>
                </cfcase>
                <cfcase value="10">
                    <!--- OCT --->
                    <cfset client.pr_rmonth = 10>
                    <Cfset startDate = DateAdd('d', -7, '#year#-10-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-10-01')>
                    <Cfset form.prevRepMonth = 9>
                    <cfset repReqDate = '#year#-10-31'>
                </cfcase>
                <cfcase value="11">
                    <!--- NOV --->
                    <cfset client.pr_rmonth = 11>
                    <Cfset startDate = DateAdd('d', -7, '#year#-11-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-11-01')>
                    <Cfset form.prevRepMonth = 10>
                    <cfset repReqDate = '#year#-11-30'>
                </cfcase>
                <cfcase value="12">
                    <!--- DEC --->
                    <cfset client.pr_rmonth = 12>
                    <Cfset startDate = DateAdd('d', -7, '#year#-12-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-12-01')>
                    <Cfset form.prevRepMonth = 11>
                    <cfset repReqDate = '#year#-12-31'>
                </cfcase>
                 <cfcase value="1">
                    <!--- JAN --->
                    <cfset client.pr_rmonth = 1>
                    <Cfset startDate = DateAdd('d', -7, '#year#-01-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-01-01')>
                    <Cfset form.prevRepMonth = 12>
                    <cfset repReqDate = '#year#-01-31'>
                </cfcase>
                <cfcase value="2">
                    <!--- FEB --->
                    <cfset client.pr_rmonth = 2>
                    <Cfset startDate = DateAdd('d', -7, '#year#-02-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-02-01')>
                    <Cfset form.prevRepMonth = 1>
                    <cfset repReqDate = '#year#-02-28'>
                </cfcase>
                   <cfcase value="3">
                    <!--- MARCH --->
                    <cfset client.pr_rmonth = 3>
                    <Cfset startDate = DateAdd('d', -7, '#year#-03-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-03-01')>
                    <Cfset form.prevRepMonth = 2>
                    <cfset repReqDate = '#year#-03-31'>
                </cfcase>
                <cfcase value="4">
                    <!--- APRIL --->
                    <cfset client.pr_rmonth = 4>
                    <Cfset startDate = DateAdd('d', -7, '#year#-04-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-04-01')>
                    <Cfset form.prevRepMonth = 3>
                    <cfset repReqDate = '#year#-04-30'>
                </cfcase>
                <cfcase value="5">
                    <!--- MAY --->
                    <cfset client.pr_rmonth = 5>
                    <Cfset startDate = DateAdd('d', -7, '#year#-05-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-05-01')>
                    <Cfset form.prevRepMonth = 4>
                    <cfset repReqDate = '#year#-05-31'>
                </cfcase>
                <cfcase value="6">
                    <!--- JUNE --->
                    <cfset client.pr_rmonth = 6>
                    <Cfset startDate = DateAdd('d', -7, '#year#-06-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-06-01')>
                    <Cfset form.prevRepMonth = 5>
                    <cfset repReqDate = '#year#-06-30'>
                </cfcase>
                <cfcase value="7">
                    <!--- JULY --->
                    <cfset client.pr_rmonth = 7>
                    <Cfset startDate = DateAdd('d', -7, '#year#-07-01')>
                    <cfset endDate = DateAdd('d', 21, '#year#-07-01')>
                    <Cfset form.prevRepMonth = 6>
                    <cfset repReqDate = '#year#-07-31'>
                </cfcase>
            </cfswitch>
			---->
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
        <td background="pics/header_background.gif"><h2>Reports</h2></td>
        <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=forms/progress_report_list">Progress Reports submitted prior to 09/16/2009</a></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfform action="index.cfm?curdoc=progress_reports" method="post">
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
    
    <Cfif reportOptions.showPhase eq 1>
    	<Cfif client.reportType eq 1>
            <td>
                Phase<br />
                <select name="rmonth">
                  <option value="0"></option>
                  
                  <option value="9"  <cfif client.pr_rmonth EQ 9>selected</cfif>>Sep Report</option>
                  <option value="10" <cfif client.pr_rmonth EQ 10>selected</cfif>>Oct Report</option>
                  <option value="11" <cfif client.pr_rmonth EQ 11>selected</cfif>>Nov Report</option>
                  <option value="12" <cfif client.pr_rmonth EQ 12>selected</cfif>>Dec Report</option>
                  <option value="1"  <cfif client.pr_rmonth EQ 1>selected</cfif>>Jan Report</option>
                  <option value="2"  <cfif client.pr_rmonth EQ 2>selected</cfif>>Feb Report</option>
                  <option value="3"  <cfif client.pr_rmonth EQ 3>selected</cfif>>Mar Report</option>
                  <option value="4"  <cfif client.pr_rmonth EQ 4>selected</cfif>>Apr Report</option>
                  <option value="5"  <cfif client.pr_rmonth EQ 5>selected</cfif>>May Report</option>
                  <option value="6"  <cfif client.pr_rmonth EQ 6>selected</cfif>>Jun Report</option>
                  <option value="7"  <cfif client.pr_rmonth EQ 7>selected</cfif>>Jul Report</option>
                  <option value="8"  <cfif client.pr_rmonth EQ 8>selected</cfif>>Aug Report</option>
                </select>
                <input type="hidden" name="prevRepMonth" value="#form.prevRepMonth#" />
                </td>
        </Cfif>
        <!----
        <Cfif client.reportType eq 3>
            <td>
                Time Frame<br />
                <select name="rmonth">
                	<option value="0"></option>
                    <option value="9" <cfif client.pr_rmonth EQ 9>selected</cfif>>Student Update 1 - Due Sept 1</option>
                    <option value="11" <cfif client.pr_rmonth EQ 11>selected</cfif>>Student Update 2 - Due Nov 2</option>
                    <option value="1" <cfif client.pr_rmonth EQ 1>selected</cfif>>Student Update 3 - Due Jan 1</option>
                    <option value="3" <cfif client.pr_rmonth EQ 3>selected</cfif>>Student Update 4 - Due Mar 1</option>
                    <option value="5" <cfif client.pr_rmonth EQ 5 >selected</cfif>>Student Update 5 - Due May 1</option>
                    <option value="7" <cfif client.pr_rmonth EQ 7 >selected</cfif>>Student Update 6 - Due July 1</option>
                </select>            
            </td>
        </Cfif>
		---->
    </Cfif>
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


<cfset datelimit = DateFormat(DateAdd('m', -2, now()),'yyyy-mm-dd')>

<!--- the supervising rep (smg_students.arearepid) and the regional advisor (user_access_rights.advisorid) are normally the same as the ones in the report
(progress_reports.fk_sr_user & fk_ra_user) but since we want to display students without reports, we can't use the report fields here.
But in the output below we use the report fields where a report has been submitted, otherwise use the student and user fields. --->
<cfquery name="getResults" datasource="#application.dsn#">
    SELECT smg_students.studentid, smg_students.uniqueid, smg_students.firstname, smg_students.familylastname, smg_programs.type as programType,
        smg_students.arearepid, smg_students.secondVisitRepID, rep.firstname as rep_firstname, rep.lastname as rep_lastname,
        <!--- alias advisor.userid here instead of using user_access_rights.advisorid because the later can be 0 and we want null, and the 0 might be phased out later. --->
        advisor.userid AS advisorid, advisor.firstname as advisor_firstname, advisor.lastname as advisor_lastname, 
       
        smg_program_type.aug_report, smg_program_type.oct_report, smg_program_type.dec_report, smg_program_type.feb_report, smg_program_type.april_report, smg_program_type.june_report
    FROM smg_students
   
    <cfif client.reportType EQ 1 or client.reportType eq 3>
    INNER JOIN smg_users rep ON smg_students.arearepid = rep.userid
    <cfelse>
    INNER JOIN smg_users rep ON smg_students.secondVisitRepID = rep.userid
    </cfif>
    INNER JOIN user_access_rights ON (
    	<cfif client.reportType EQ 1 or client.reportType eq 3>
		smg_students.arearepid = user_access_rights.userid
        AND smg_students.regionassigned = user_access_rights.regionid
		<cfelse>
        smg_students.secondVisitRepID = user_access_rights.userid
        AND smg_students.regionassigned = user_access_rights.regionid
    	</cfif>
    )
    LEFT JOIN smg_users advisor ON user_access_rights.advisorid = advisor.userid
    INNER JOIN smg_programs ON smg_students.programid = smg_programs.programid
    INNER JOIN smg_program_type ON smg_programs.type = smg_program_type.programtypeid
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
    <!----Only Progress Reports have active and fieldviewable variables---->
    <cfif client.reportType EQ 1 OR client.reportType eq 3>
    AND smg_programs.progress_reports_active = 1
    AND smg_programs.fieldviewable = 1
    </cfif>
    <!--- regional advisor sees only their reps or their students. --->
    
		<cfif client.usertype EQ 6>
            AND (
                user_access_rights.advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                OR smg_students.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                <Cfif client.reportType eq 2>
                OR smg_students.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                </Cfif>
            )
        <!--- supervising reps sees only their students. --->
        <cfelseif client.usertype EQ 7>
        	<Cfif client.reportType eq 2>
             	AND smg_students.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
              <cfelse>
                AND smg_students.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        	</Cfif>
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
        <cfif client.reportType eq 1 or client.reportType eq 3>
        AND pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.pr_rmonth#">
        </cfif>
        AND fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.reportType#">
    </cfquery>
	
    <table width=100% class="section">
        <cfoutput query="getResults" group="advisorid">
      
            <cfif currentRow NEQ 1>
                <tr>
                    <td colspan=9 height="25">&nbsp;</td>
                </tr>
            </cfif>
            <tr>
                <td colspan=9 class="advisor">
                    <cfif advisorid EQ ''>
                        Reports Directly to Regional Director
                    <cfelse>
                        #advisor_firstname# #advisor_lastname# (#advisorid#)
                  </cfif>
                </td>
            </tr>
            <Cfif client.reportType eq 2>
            	<cfset groupBy = "secondVisitRepID">
            <cfelse>
                <cfset groupBy = "areaRepID">
            </Cfif>
            	<cfoutput group="#groupBy#">
          
            	
             
                <tr>
                    <td colspan=9 class="rep">#rep_firstname# #rep_lastname# <cfif client.reportType eq 1>(#arearepid#)<cfelse>(#secondVisitRepID#)</cfif></td>
                <tr>
                <tr align="left">
                    <th width="15">&nbsp;</th>
                    <th>Student</th>
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
                        AND fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.reportType#">
                    </cfquery>
                    <!----Get Flight info to make sure in states and decideif a report is needed for that student---->
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
                    
                    <cfquery name="departureInfo" datasource="#application.dsn#">
                    SELECT max(dep_date) as dep_date
                    FROM smg_flight_info
                    WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                    AND flight_type = 'departure'
                    </cfquery>
                    <!----If no departure info is on file, we set to July 1, the latest to make sure---->
                    <Cfif arrivalInfo.recordcount eq 0  or departureInfo.dep_date eq ''>
                    	<Cfset departureDate = '#DateRange.endDate#'>
                   	<cfelse>
                    	<cfset departureDate = '#departureInfo.dep_date#'>
                    </Cfif>
                   
						
					<Cfif client.reportType eq 1>
						 <!---Check if previous months report is approved---->
                        
                        <Cfquery name="checkPreviousReports" datasource="#application.dsn#">
                        select pr_rd_approved_date, pr_ny_approved_date, pr_sr_approved_date
                        FROM progress_reports
                        where fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                        AND fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.reportType#">
                        and fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                        and pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#prevRepMonth#">
                        </cfquery>
                        <!----check if this is the first report for this student---->
                        <Cfquery name="checkIfFirst" datasource="#application.dsn#">
                        select *
                        FROM progress_reports
                        where fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                        AND fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.reportType#">
                        and fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                        </cfquery>
                        <!---If null, previous report has NOT been approved---->
                        
                        <Cfif checkPreviousReports.pr_rd_approved_date is not '' or checkPreviousReports.pr_ny_approved_date is not '' or checkPreviousReports.pr_sr_approved_date is not ''>
                        	<Cfset PreviousReportApproved = 1>
                        </Cfif>
                      
                        
                        
                    <cfelse>
                    	<cfset PreviousReportApproved = 1>
                      
                    </Cfif>
                    <!----For Aug/Sep and June, we need to check if student is int he country.---->
                     <Cfif client.pr_rmonth eq 9>
                     
							<Cfif #datePart('m', '#arrivalDate#')# eq 8>
                         		<Cfset PreviousReportApproved = 1>
                     		</Cfif>
                     
                      <Cfelseif client.pr_rmonth eq 8>
                      
                            <Cfif #datePart('m', '#arrivalDate#')# gt 8>
                           		<Cfset inCountry = 0>
                            <Cfelse>
                                <Cfset PreviousReportApproved = 1>
                            </Cfif>
                        
					   <Cfelseif client.pr_rmonth eq 6>
							<Cfif #datePart('m', '#departureDate#')# lt #datePart('m', '#repReqDate#')#>
                           		<Cfset inCountry = 0>
                            </Cfif>
                       </Cfif>
                    
                    
                   <cfset mycurrentRow = mycurrentRow + 1>
                   <tr bgcolor="#iif(mycurrentRow MOD 2 ,DE("eeeeee") ,DE("white") )#">
                        <td>&nbsp;</td>
                        <td>
                        	<!--- put in red if user is the supervising rep for this student.  don't do for usertype 7 because they see only those students. --->
                            <a href="javascript:OpenLetter('reports/PlacementInfoSheet.cfm?uniqueID=#getResults.uniqueID#');">
							<cfif arearepid EQ client.userid and client.usertype NEQ 7>
                        		<font color="FF0000"><strong>#firstname# #familylastname# (#studentid#)</strong></font>
                            <cfelse>
                        		#firstname# #familylastname# (#studentid#)
                            </cfif>
                            </a>
                        </td>
                        <td>#yesNoFormat(get_report.recordCount)#</td>
                        <td>

                        <cfif get_report.recordCount>
                            	<!--- access is limited to: client.usertype LTE 4, second vist rep, supervising rep, regional advisor, regional director, and facilitator. --->
								<cfif client.usertype LTE 4 or listFind("#get_report.fk_secondVisitRep#,#get_report.fk_sr_user#,#get_report.fk_ra_user#,#get_report.fk_rd_user#,#get_report.fk_ny_user#, #get_report.fk_secondVisitRep#", client.userid)>
									<!--- restrict view of report until the supervising rep approves it. --->
                                    <!----check the type of report, use appropriate person to view---->
									<cfif client.reportType EQ 2>
                                        <cfset submittingRep = '#secondVisitRepID#'>
                                    <cfelse>
                                        <Cfset submittingRep = '#arearepid#'>
                                    </cfif>
                                    <cfif get_report.pr_sr_approved_date EQ '' and submittingRep NEQ client.userid>
                                        <!----allow office to view so can delete if needed---->
                                        <Cfif listfind('1,12313,13799,510', client.userid)>
                                        <form action="index.cfm?curdoc=progress_report_info" method="post" name="theForm_#get_report.pr_id#" id="theForm_#get_report.pr_id#">
                                        <input type="hidden" name="pr_id" value="#get_report.pr_id#">
                                        </form>
											<cfif client.reportType EQ 2>
                                            <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#get_report.pr_id#">
                                            <cfelse>
                                            <a href="javascript:document.theForm_#get_report.pr_id#.submit();">
                                            </cfif>
                                        </cfif>	
                                        Pending</a>
                                    	<!----end allow view to delete---->
                                    <cfelse>
                                        <form action="index.cfm?curdoc=progress_report_info" method="post" name="theForm_#get_report.pr_id#" id="theForm_#get_report.pr_id#">
                                        <input type="hidden" name="pr_id" value="#get_report.pr_id#">
                                        </form>
                                        <cfif client.reportType EQ 2>
                                        <a href="index.cfm?curdoc=forms/secondHomeVisitReport&reportID=#get_report.pr_id#">View</a>
                                        <cfelse>
                                        <a href="javascript:document.theForm_#get_report.pr_id#.submit();">View</a>
                                    	</cfif>
                                    </cfif>
                                <cfelse>
                                	N/A 
                                </cfif>
							<!--- add report link --->
                            <cfelse>
                            <!----check the type of report, use appropriate person to view---->
                            <cfif client.reportType EQ 2>
                            	<cfset submittingRep = '#secondVisitRepID#'>
                            <cfelse>
                            	<Cfset submittingRep = '#arearepid#'>
                            </cfif>
                        	
                            	<!--- to add a progress report, user must be the supervising rep, and the program has a report for this phase. --->
                          			<Cfif inCountry eq 0>
                                    Not in Country - No Report Required
									<cfelseif (#submittingRep# EQ client.userid and PreviousReportApproved eq 1) OR client.reportType EQ 2  >
                                
                                        <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                        <input type="hidden" name="studentid" value="#studentid#">
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
							<cfif advisorid EQ ''>
                               N/A
                            <cfelse>
                                #dateFormat(get_report.pr_ra_approved_date, 'mm/dd/yyyy')#
                          </cfif>
                        </td>
                        <td>#dateFormat(get_report.pr_rd_approved_date, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(get_report.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(get_report.pr_rejected_date, 'mm/dd/yyyy')#</td>
                    </tr>
                </cfoutput>
            </cfoutput>
        </cfoutput>
    </table>

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