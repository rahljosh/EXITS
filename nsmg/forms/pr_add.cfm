<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

    <cflock timeout="30">
        <cfquery datasource="#application.dsn#">
            INSERT INTO progress_reports (fk_student, pr_uniqueid, pr_month_of_report, fk_program, fk_sr_user, fk_ra_user, fk_rd_user, fk_ny_user, fk_host, fk_intrep_user)
            VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.studentid#">,
            <cfqueryparam cfsqltype="cf_sql_idstamp" value="#createuuid()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.month_of_report#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_sr_user#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ra_user#" null="#yesNoFormat(trim(form.fk_ra_user) EQ '')#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_rd_user#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ny_user#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_host#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_intrep_user#">
            )  
        </cfquery>
        <cfquery name="get_id" datasource="#application.dsn#">
            SELECT MAX(pr_id) AS pr_id
            FROM progress_reports
        </cfquery>
    </cflock>
    <cfquery name="get_questions" datasource="#application.dsn#">
        SELECT id
        FROM smg_prquestions
        WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.companyid#"> 
        AND active = 1
        AND month = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.month_of_report#">
    </cfquery>
    <cfloop query="get_questions">
        <cfquery datasource="#application.dsn#">
            INSERT INTO x_pr_questions (fk_progress_report, fk_prquestion)
            VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_id.pr_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_questions.id#">
            )
        </cfquery>
    </cfloop>
    <form action="index.cfm?curdoc=progress_report_info" method="post" name="theForm" id="theForm">
    <input type="hidden" name="pr_id" value="<cfoutput>#get_id.pr_id#</cfoutput>">
    </form>
    <script>
    document.theForm.submit();
    </script>

<!--- add --->
<cfelse>

	<cfparam name="form.studentid" default="">
	<cfif not isNumeric(form.studentid)>
        a numeric studentid is required to add a new progress report.
        <cfabort>
	</cfif>

	<cfparam name="form.month_of_report" default="">
	<cfif not isNumeric(form.month_of_report)>
        a numeric month is required to add a new progress report.
        <cfabort>
	</cfif>

    <cfquery name="get_student" datasource="#application.dsn#">
        SELECT arearepid, intrep, regionassigned, hostid, programid, companyid
        FROM smg_students
        WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.studentid#">
    </cfquery>
    
    <cfset form.companyid = get_student.companyid>
    <cfset form.fk_sr_user = get_student.arearepid>
    
    <cfset form.programid = get_student.programid>
    <cfif form.programid EQ 0 or form.programid EQ ''>
    	Program is missing.  Report may not be added.
        <cfabort>
    </cfif>
    
    <cfset form.fk_host = get_student.hostid>
    <cfif form.fk_host EQ 0 or form.fk_host EQ ''>
    	Host Family is missing.  Report may not be added.
        <cfabort>
    </cfif>
    
    <cfset form.fk_intrep_user = get_student.intrep>
    <cfif form.fk_intrep_user EQ 0 or form.fk_intrep_user EQ ''>
    	International Agent is missing.  Report may not be added.
        <cfabort>
    </cfif>
    
    <cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
        SELECT advisorid
        FROM user_access_rights
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student.arearepid#">
        AND regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student.regionassigned#">
    </cfquery>
    <cfset form.fk_ra_user = get_advisor_for_rep.advisorid>
	<!--- advisorid can be 0 and we want null, and the 0 might be phased out later. --->
	<cfif form.fk_ra_user EQ 0>
	    <cfset form.fk_ra_user = ''>
    </cfif>
	
    <cfquery name="get_regional_director" datasource="#application.dsn#">
        SELECT smg_users.userid
        FROM smg_users
        INNER JOIN user_access_rights on smg_users.userid = user_access_rights.userid
        WHERE user_access_rights.usertype = 5
        AND user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student.regionassigned#">
        AND smg_users.active = 1
    </cfquery>
    <cfset form.fk_rd_user = get_regional_director.userid>
    <cfif form.fk_rd_user EQ ''>
    	Regional Director is missing.  Report may not be added.
        <cfabort>
    </cfif>

    <cfquery name="get_facilitator" datasource="#application.dsn#">
        SELECT regionfacilitator
        FROM smg_regions
        WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student.regionassigned#">
    </cfquery>
    <cfset form.fk_ny_user = get_facilitator.regionfacilitator>
    <cfif form.fk_ny_user EQ 0 or form.fk_ny_user EQ ''>
    	Facilitator is missing.  Report may not be added.
        <cfabort>
    </cfif>

</cfif>

<!--- this table is so the form is not 100% width. --->
<table align="center">
  <tr>
    <td>

<!----Header Format Table---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
		<td background="pics/header_background.gif"><h2>Add Progress Report</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr align="center"><td>

<cfform action="index.cfm?curdoc=forms/pr_add" method="POST"> 
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="studentid" value="#form.studentid#">
<cfinput type="hidden" name="month_of_report" value="#form.month_of_report#">
<cfinput type="hidden" name="companyid" value="#form.companyid#">
<cfinput type="hidden" name="programid" value="#form.programid#">
<cfinput type="hidden" name="fk_sr_user" value="#form.fk_sr_user#">
<cfinput type="hidden" name="fk_ra_user" value="#form.fk_ra_user#">
<cfinput type="hidden" name="fk_rd_user" value="#form.fk_rd_user#">
<cfinput type="hidden" name="fk_ny_user" value="#form.fk_ny_user#">
<cfinput type="hidden" name="fk_host" value="#form.fk_host#">
<cfinput type="hidden" name="fk_intrep_user" value="#form.fk_intrep_user#">

<cfquery name="get_student" datasource="#application.dsn#">
    SELECT firstname, familylastname
    FROM smg_students
    WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.studentid#">
</cfquery>

<cfoutput>
<h2>Student: #get_student.firstname# #get_student.familylastname# (#form.studentid#)
<br />
<cfswitch expression="#form.month_of_report#">
<cfcase value="10">
    Phase 1<br>
    <font size=-1>Due Oct 1st - includes information from Aug 1 through Oct 1</font>
</cfcase>
<cfcase value="12">
    Phase 2<br>
    <font size=-1>Due Dec 1st - includes information from Oct 1 through Dec 1</font>
</cfcase>
<cfcase value="2">
    Phase 3<br>
    <font size=-1>Due Feb 1st - includes information from Dec 1 through Feb 1st</font>
</cfcase>
<cfcase value="4">
    Phase 4<br>
    <font size=-1>Due April 1st - includes information from Feb 1st through April 1st</font>
</cfcase>
<cfcase value="6">
    Phase 5<br>
    <font size=-1>Due June 1st - includes information from April 1st through June  1st</font>
</cfcase>
<cfcase value="8">
    Phase 6<br>
    <font size=-1>Due August 1st - includes information from June 1st through August 1st</font>
</cfcase>
</cfswitch>
</h2>
<br />
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<th bgcolor="cccccc">Program</th>
    </tr>
    <tr align="center">
        <td>

        <cfquery name="get_program" datasource="#application.dsn#">
            SELECT programname
            FROM smg_programs
            WHERE programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#">
        </cfquery>
        <cfquery name="get_rep" datasource="#application.dsn#">
            SELECT firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_sr_user#">
        </cfquery>
        <cfquery name="get_regional_director" datasource="#application.dsn#">
            SELECT firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_rd_user#">
        </cfquery>
        <cfquery name="get_facilitator" datasource="#application.dsn#">
            SELECT firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ny_user#">
        </cfquery>
        <cfquery name="get_host_family" datasource="#application.dsn#">
            SELECT familylastname, fatherfirstname, motherfirstname
            FROM smg_hosts
            WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_host#">
        </cfquery>
        <cfquery name="get_international_rep" datasource="#application.dsn#">
            SELECT businessname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_intrep_user#">
        </cfquery>
        
        <table>
          <tr>
            <th align="right">Program Name:</th>
            <td>#get_program.programname# (#form.programid#)</td>
          </tr>
          <tr>
            <th align="right">Supervising Representative:</th>
            <td>#get_rep.firstname# #get_rep.lastname# (#form.fk_sr_user#)</td>
          </tr>
          <tr>
            <th align="right">Regional Advisor:</th>
            <td>
                <cfif form.fk_ra_user EQ ''>
                    Reports Directly to Regional Director
                <cfelse>
                    <cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
                        SELECT firstname, lastname
                        FROM smg_users
                        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ra_user#">
                    </cfquery>
                    #get_advisor_for_rep.firstname# #get_advisor_for_rep.lastname# (#form.fk_ra_user#)
                </cfif>
            </td>
          </tr>
          <tr>
            <th align="right">Regional Director:</th>
            <td>#get_regional_director.firstname# #get_regional_director.lastname# (#form.fk_rd_user#)</td>
          </tr>
          <tr>
            <th align="right">Facilitator:</th>
            <td>#get_facilitator.firstname# #get_facilitator.lastname# (#form.fk_ny_user#)</td>
          </tr>
          <tr>
            <th align="right">Host Family:</th>
            <td>
                #get_host_family.fatherfirstname#
                <cfif get_host_family.fatherfirstname NEQ '' and get_host_family.motherfirstname NEQ ''>&amp;</cfif>
                #get_host_family.motherfirstname#
                #get_host_family.familylastname# (#form.fk_host#)
            </td>
          </tr>
          <tr>
            <th align="right">International Agent:</th>
            <td>#get_international_rep.businessname# (#form.fk_intrep_user#)</td>
          </tr>
        </table>

        </td>
    </tr>
</table>
</cfoutput>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/continue.gif" border=0></td>
	</tr>
</table>

</cfform>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

    </td>
  </tr>
</table>
<!--- this table is so the form is not 100% width. --->
