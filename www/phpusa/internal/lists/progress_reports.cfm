<cfif not client.usertype LTE 7>
	You do not have access to this page.
    <cfabort>
</cfif>

<cfparam name="client.pr_programid" default="">
<cfparam name="client.pr_cancelled" default="0">

<cfif NOT isDefined('client.pr_rmonth')>
    <cfswitch expression="#month(now())#">
    <cfcase value="7,8,9">
		<!--- SEPT --->
        <cfset client.pr_rmonth = 9>
    </cfcase>
    <cfcase value="10,11,12">
		<!--- DEC --->
        <cfset client.pr_rmonth = 12>
    </cfcase>
    <cfcase value="1,2">
		<!--- FEB --->
        <cfset client.pr_rmonth = 2>
    </cfcase>
    <cfcase value="3,4">
		<!--- APRIL --->
        <cfset client.pr_rmonth = 4>
    </cfcase>
    <cfcase value="5,6">
		<!--- JUNE --->
        <cfset client.pr_rmonth = 6>
    </cfcase>
    </cfswitch>
</cfif>

<!--- save the submitted values. --->
<cfif isDefined("form.submitted")>
	<cfset client.pr_programid = form.programid>
	<cfset client.pr_cancelled = form.cancelled>
	<cfset client.pr_rmonth = form.rmonth>
</cfif>

<!--- set the corresponding database field used in the output. --->
<cfswitch expression="#client.pr_rmonth#">
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

<cfset datelimit = DateFormat(DateAdd('m', -2, now()),'yyyy-mm-dd')>

<!--- the student supervising rep (php_students_in_program.arearepid) and the school supervising rep (php_schools.supervising_rep) are normally the same
as the ones in the report (progress_reports.fk_sr_user & fk_ssr_user) but since we want to display students without reports, we can't use the report fields here.
But in the output below we use the report fields where a report has been submitted, otherwise use the student and user fields. --->
<cfquery name="main_query" datasource="#application.dsn#">
    SELECT smg_students.studentid, smg_students.firstname, smg_students.familylastname, php_students_in_program.assignedid,
        php_students_in_program.arearepid, rep.firstname AS rep_firstname, rep.lastname AS rep_lastname,
        school_rep.userid AS school_rep_id, school_rep.firstname AS school_rep_firstname, school_rep.lastname AS school_rep_lastname,
        smg_programs.programid, smg_programs.programname, smg_programs.startdate,
        smg_program_type.sept_report, smg_program_type.dec_report, smg_program_type.feb_report, smg_program_type.april_report, smg_program_type.june_report
    FROM smg_students
    INNER JOIN php_students_in_program ON smg_students.studentid = php_students_in_program.studentid
    INNER JOIN smg_users rep ON php_students_in_program.arearepid = rep.userid
    INNER JOIN php_schools ON php_students_in_program.schoolid = php_schools.schoolid
    LEFT JOIN smg_users school_rep ON php_schools.supervising_rep = school_rep.userid
    INNER JOIN smg_programs ON php_students_in_program.programid = smg_programs.programid
    INNER JOIN smg_program_type ON smg_programs.type = smg_program_type.programtypeid
    WHERE php_students_in_program.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    AND smg_programs.progress_reports_active = 1
    AND smg_programs.fieldviewable = 1
    <cfif client.pr_cancelled EQ 0>
        AND php_students_in_program.active = 1
    <cfelse>
        AND php_students_in_program.canceldate >= '#datelimit#'
    </cfif>
    <!--- these users see only students who they are the supervising rep of, or school supervising rep. --->
    <cfif client.usertype GT 4>
        AND (
        	php_students_in_program.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        	OR php_schools.supervising_rep = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
		)
    </cfif>
    <!--- include the school_rep_id and arearepid because we're grouping by those in the output, just in case two have the same first and last name. --->
    ORDER BY school_rep_lastname, school_rep_firstname, school_rep_id, rep_lastname, rep_firstname, php_students_in_program.arearepid, smg_students.familylastname, smg_students.firstname, smg_programs.startdate DESC
</cfquery>

<!--- we're doing a query of query here so we can use the main query also for the program query. --->
<cfquery name="getResults" dbtype="query">
    SELECT *
    FROM main_query
    WHERE 0=0
    <cfif client.pr_programid NEQ ''>
    	AND programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.pr_programid#">
    </cfif>
</cfquery>

<table width="95%" align="center">
  <tr>
    <td>

<table width=100% cellpadding=0 cellspacing=0 border=0>
    <tr>
        <td><font size="4"><strong>Progress Reports</strong></font></td>
        <td align="right"><a href="index.cfm?curdoc=lists/agent_approve_list">Progress Reports submitted prior to 09/16/2009</a></td>
    </tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100%>
<cfform action="index.cfm?curdoc=lists/progress_reports" method="post">
<input name="submitted" type="hidden" value="1">
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
        <td>
            <!---<cfquery name="get_programs" datasource="#application.dsn#">
                SELECT programid, programname
                FROM smg_programs
                WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                AND active = 1
                ORDER BY startdate DESC
            </cfquery>--->
            <cfquery name="get_programs" dbtype="query">
                SELECT DISTINCT programid, programname
                FROM main_query
                ORDER BY startdate DESC
            </cfquery>
            Program<br />
            <cfselect name="programid" query="get_programs" value="programid" display="programname" selected="#client.pr_programid#" queryPosition="below">
                <option value="">All</option>
            </cfselect>
        </td>
        <td>
            Month<br />
			<select name="rmonth">
				<option value="9" <cfif client.pr_rmonth EQ 9>selected</cfif>>September</option>
				<option value="12" <cfif client.pr_rmonth EQ 12>selected</cfif>>December</option>
				<option value="2" <cfif client.pr_rmonth EQ 2>selected</cfif>>February</option>
				<option value="4" <cfif client.pr_rmonth EQ 4>selected</cfif>>April</option>
				<option value="6" <cfif client.pr_rmonth EQ 6>selected</cfif>>June</option>
			</select>            
        </td>
        <td>
            Status<br />
			<select name="cancelled">
				<option value="0" <cfif client.pr_cancelled EQ 0>selected</cfif>>Active</option>
				<option value="1" <cfif client.pr_cancelled EQ 1>selected</cfif>>Cancelled</option>
			</select>            
        </td>
    </tr>
</cfform>
</table>

<cfif getResults.recordCount GT 0>

	<!--- get the reports, used in a query of query below, because LEFT JOIN is too slow in mySQL. --->
    <cfquery name="get_reports" datasource="#application.dsn#">
        SELECT *
        FROM progress_reports
        WHERE fk_student IN (#valueList(getResults.studentid)#)
        AND pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.pr_rmonth#">
    </cfquery>

    <table width=100% cellspacing="0">
        <cfoutput query="getResults" group="school_rep_id">
            <cfif currentRow NEQ 1>
                <tr>
                    <td colspan=9 height="25">&nbsp;</td>
                </tr>
            </cfif>
            <tr>
                <td colspan=9 class="school_rep">
                    <cfif school_rep_id EQ ''>
                        &nbsp;Reports Directly to NY
                    <cfelse>
                        &nbsp;#school_rep_firstname# #school_rep_lastname# (#school_rep_id#)
                    </cfif>
                </td>
            </tr>
            <cfoutput group="arearepid">
                <tr>
                    <th colspan=9 align="left" bgcolor="CCCCCC">&nbsp;#rep_firstname# #rep_lastname# (#arearepid#)</th>
                <tr>
                <tr align="left">
                    <th width="15">&nbsp;</th>
                    <th>Student</th>
                    <th>Program</th>
                    <th>Submitted</th>
                    <th>Action</th>
                    <th>SR Approved</th>
                    <th>SSR Approved</th>
                    <th>NY Approved</th>
                    <th>Rejected</th>
                </tr>
                <cfset mycurrentRow = 0>
                <cfoutput>
                    <cfquery name="get_report" dbtype="query">
                        SELECT *
                        FROM get_reports
                        WHERE fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentid#">
                        AND fk_program = <cfqueryparam cfsqltype="cf_sql_integer" value="#programid#">
                    </cfquery>
                    <cfset mycurrentRow = mycurrentRow + 1>
                   <tr <cfif mycurrentRow MOD 2>bgcolor="ffffff"</cfif>>
                        <td>&nbsp;</td>
                        <td>
                        	<!--- put in red if user is the supervising rep for this student. --->
                            <cfif arearepid EQ client.userid>
                        		<font color="FF0000"><strong>#firstname# #familylastname# (#studentid#)</strong></font>
                            <cfelse>
                        		#firstname# #familylastname# (#studentid#)
                            </cfif>
                        </td>
                        <td>#programname#</td>
                        <td>#yesNoFormat(get_report.recordCount)#</td>
                        <!--- these <td>'s are separate because the add form needs to be outside them. --->
						<cfif get_report.recordCount>
							<!--- access is limited to: client.usertype LTE 4, supervising rep, school supervising rep, and NY. --->
                            <cfif client.usertype LTE 4 or listFind("#get_report.fk_sr_user#,#get_report.fk_ssr_user#,#get_report.fk_ny_user#", client.userid)>
                                <!--- restrict view of report until the supervising rep approves it. --->
                                <cfif get_report.pr_sr_approved_date EQ '' and get_report.fk_sr_user NEQ client.userid>
                                    <td>Pending</td>
                                <cfelse>
                                    <form action="index.cfm?curdoc=lists/progress_report_info" method="post" name="theForm_#get_report.pr_id#" id="theForm_#get_report.pr_id#">
                                    <input type="hidden" name="pr_id" value="#get_report.pr_id#">
                                    </form>
                                    <td><a href="javascript:document.theForm_#get_report.pr_id#.submit();">View</a></td>
                                </cfif>
                            <cfelse>
                               <td>N/A</td>
                            </cfif>
                        <!--- add report link --->
                        <cfelse>
                            <!--- to add a progress report, user must be the supervising rep, and the program has a report for this phase. --->
                            <cfif arearepid EQ client.userid and evaluate(dbfield)>
                                <form action="index.cfm?curdoc=forms/pr_add" method="post">
                            	<td>
                                <input type="hidden" name="assignedid" value="#assignedid#">
                                <input type="hidden" name="month_of_report" value="#client.pr_rmonth#">
                                <input name="Submit" type="image" src="pics/new.gif" alt="Add New Report" border=0>
                                </td>
                                </form>
                            <cfelse>
                                <td>N/A</td>
                            </cfif>
                        </cfif>
                        <td>#dateFormat(get_report.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                        <td>
							<cfif school_rep_id EQ ''>
                               N/A
                            <cfelse>
                                #dateFormat(get_report.pr_ssr_approved_date, 'mm/dd/yyyy')#
                            </cfif>
                        </td>
                        <td>#dateFormat(get_report.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                        <td>#dateFormat(get_report.pr_rejected_date, 'mm/dd/yyyy')#</td>
                    </tr>
                </cfoutput>
            </cfoutput>
        </cfoutput>
    </table>
	<br />
    <table width=100%>
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
    <table border=0 cellpadding=4 cellspacing=0 width=100%>
        <tr>
            <td><h3>No progress reports matched your criteria.</h3></td>
        </tr>
    </table>
</cfif>
    
    </td>
  </tr>
</table>
