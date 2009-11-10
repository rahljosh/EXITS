<cfif not client.usertype LTE 7>
	You do not have access to this page.
    <cfabort>
</cfif>

<cfparam name="client.pr_regionid" default="#client.regionid#">
<cfparam name="client.pr_cancelled" default="0">

<cfif NOT isDefined('client.pr_rmonth')>
    <cfswitch expression="#month(now())#">
    <cfcase value="9,10">
		<!--- OCT --->
        <cfset client.pr_rmonth = 10>
    </cfcase>
    <cfcase value="11,12">
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
    <cfcase value="7,8">
		<!--- August --->
        <cfset client.pr_rmonth = 8>
    </cfcase>
    </cfswitch>
</cfif>

<!--- save the submitted values. --->
<cfif isDefined("form.submitted")>
	<cfif isDefined("form.regionid")>
		<cfset client.pr_regionid = form.regionid>
    </cfif>
	<cfset client.pr_cancelled = form.cancelled>
	<cfset client.pr_rmonth = form.rmonth>
</cfif>

<!--- set the corresponding database field used in the output. --->
<cfswitch expression="#client.pr_rmonth#">
<cfcase value="10">
	<cfset dbfield = 'oct_report'>
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
        <td background="pics/header_background.gif"><h2>Progress Reports</h2></td>
        <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=forms/progress_report_list">Progress Reports submitted prior to 09/16/2009</a></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<cfform action="index.cfm?curdoc=progress_reports" method="post">
<input name="submitted" type="hidden" value="1">
<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
    <tr>
        <td><input name="send" type="submit" value="Submit" /></td>
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
            Phase<br />
			<select name="rmonth">
				<option value="10" <cfif client.pr_rmonth EQ 10>selected</cfif>>Phase 1 - Due Oct 1</option>
				<option value="12" <cfif client.pr_rmonth EQ 12>selected</cfif>>Phase 2 - Due Dec 2</option>
				<option value="2" <cfif client.pr_rmonth EQ 2>selected</cfif>>Phase 3 - Due Feb 1</option>
				<option value="4" <cfif client.pr_rmonth EQ 4>selected</cfif>>Phase 4 - Due Apr 1</option>
				<option value="6" <cfif client.pr_rmonth EQ 6>selected</cfif>>Phase 5 - Due Jun 1</option>
				<option value="8" <cfif client.pr_rmonth EQ 8>selected</cfif>>Phase 6 - Due Aug 1</option>
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
</table>
</cfform>


<cfset datelimit = DateFormat(DateAdd('m', -2, now()),'yyyy-mm-dd')>

<!--- the supervising rep (smg_students.arearepid) and the regional advisor (user_access_rights.advisorid) are normally the same as the ones in the report
(progress_reports.fk_sr_user & fk_ra_user) but since we want to display students without reports, we can't use the report fields here.
But in the output below we use the report fields where a report has been submitted, otherwise use the student and user fields. --->
<cfquery name="getResults" datasource="#application.dsn#">
    SELECT smg_students.studentid, smg_students.firstname, smg_students.familylastname,
        smg_students.arearepid, rep.firstname as rep_firstname, rep.lastname as rep_lastname,
        <!--- alias advisor.userid here instead of using user_access_rights.advisorid because the later can be 0 and we want null, and the 0 might be phased out later. --->
        advisor.userid AS advisorid, advisor.firstname as advisor_firstname, advisor.lastname as advisor_lastname,
        smg_program_type.aug_report, smg_program_type.oct_report, smg_program_type.dec_report, smg_program_type.feb_report, smg_program_type.april_report, smg_program_type.june_report
    FROM smg_students
    INNER JOIN smg_users rep ON smg_students.arearepid = rep.userid
    INNER JOIN user_access_rights ON (
        smg_students.arearepid = user_access_rights.userid
        AND smg_students.regionassigned = user_access_rights.regionid
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
    AND smg_programs.progress_reports_active = 1
    AND smg_programs.fieldviewable = 1
    <!--- regional advisor sees only their reps or their students. --->
    <cfif client.usertype EQ 6>
        AND (
        	user_access_rights.advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        	OR smg_students.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
		)
    <!--- supervising reps sees only their students. --->
    <cfelseif client.usertype EQ 7>
        AND smg_students.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
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
        AND pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.pr_rmonth#">
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
            <cfoutput group="arearepid">
                <tr>
                    <td colspan=9 class="rep">#rep_firstname# #rep_lastname# (#arearepid#)</td>
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
                    </cfquery>
                    <cfset mycurrentRow = mycurrentRow + 1>
                   <tr bgcolor="#iif(mycurrentRow MOD 2 ,DE("eeeeee") ,DE("white") )#">
                        <td>&nbsp;</td>
                        <td>
                        	<!--- put in red if user is the supervising rep for this student.  don't do for usertype 7 because they see only those students. --->
                            <cfif arearepid EQ client.userid and client.usertype NEQ 7>
                        		<font color="FF0000"><strong>#firstname# #familylastname# (#studentid#)</strong></font>
                            <cfelse>
                        		#firstname# #familylastname# (#studentid#)
                            </cfif>
                        </td>
                        <td>#yesNoFormat(get_report.recordCount)#</td>
                        <td>
                        	<cfif get_report.recordCount>
                            	<!--- access is limited to: client.usertype LTE 4, supervising rep, regional advisor, regional director, and facilitator. --->
								<cfif client.usertype LTE 4 or listFind("#get_report.fk_sr_user#,#get_report.fk_ra_user#,#get_report.fk_rd_user#,#get_report.fk_ny_user#", client.userid)>
									<!--- restrict view of report until the supervising rep approves it. --->
                                    <cfif get_report.pr_sr_approved_date EQ '' and get_report.fk_sr_user NEQ client.userid>
                                        Pending
                                    <cfelse>
                                        <form action="index.cfm?curdoc=progress_report_info" method="post" name="theForm_#get_report.pr_id#" id="theForm_#get_report.pr_id#">
                                        <input type="hidden" name="pr_id" value="#get_report.pr_id#">
                                        </form>
                                        <a href="javascript:document.theForm_#get_report.pr_id#.submit();">View</a>
                                    </cfif>
                                <cfelse>
                                	N/A
                                </cfif>
							<!--- add report link --->
                            <cfelse>
                            	<!--- to add a progress report, user must be the supervising rep, and the program has a report for this phase. --->
                                <cfif arearepid EQ client.userid and evaluate(dbfield)>
                                    <form action="index.cfm?curdoc=forms/pr_add" method="post">
                                    <input type="hidden" name="studentid" value="#studentid#">
                                    <input type="hidden" name="month_of_report" value="#client.pr_rmonth#">
                                    <input name="Submit" type="image" src="pics/new.gif" alt="Add New Report" border=0>
                                    </form>
                                <cfelse>
                                	N/A
                                </cfif>
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