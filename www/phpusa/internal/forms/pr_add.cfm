<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

    <cflock timeout="30">
        <cfquery datasource="#application.dsn#">
            INSERT INTO progress_reports (fk_student, pr_uniqueid, pr_month_of_report, fk_program, fk_sr_user, fk_ssr_user, fk_ny_user, fk_host, fk_intrep_user)
            VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.studentid#">,
            <cfqueryparam cfsqltype="cf_sql_idstamp" value="#createuuid()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.month_of_report#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_sr_user#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ssr_user#" null="#yesNoFormat(trim(form.fk_ssr_user) EQ '')#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ny_user#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_host#" null="#yesNoFormat(trim(form.fk_host) EQ '')#">,
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
    <form action="index.cfm?curdoc=lists/progress_report_info" method="post" name="theForm" id="theForm">
    <input type="hidden" name="pr_id" value="<cfoutput>#get_id.pr_id#</cfoutput>">
    </form>
    <script>
    document.theForm.submit();
    </script>

<!--- add --->
<cfelse>

	<cfparam name="form.assignedid" default="">
	<cfif not isNumeric(form.assignedid)>
        <h3>a numeric assignedid is required to add a new progress report.</h3>
        <cfabort>
	</cfif>

	<cfparam name="form.month_of_report" default="">
	<cfif not isNumeric(form.month_of_report)>
        <h3>a numeric month is required to add a new progress report.</h3>
        <cfabort>
	</cfif>

    <cfquery name="get_student_program" datasource="#application.dsn#">
        SELECT studentid, arearepid, hostid, programid, companyid, schoolid
        FROM php_students_in_program
        WHERE assignedid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.assignedid#">
    </cfquery>
    
    <cfset form.studentid = get_student_program.studentid>
    <cfset form.companyid = get_student_program.companyid>
    <cfset form.fk_sr_user = get_student_program.arearepid>
    
	<cfset form.fk_host = get_student_program.hostid>
    <cfif form.fk_host EQ 0>
		<cfset form.fk_host = ''>
    </cfif>

	<!--- international rep is in the smg_students table instead of php_students_in_program. --->
    <cfquery name="get_student" datasource="#application.dsn#">
        SELECT intrep
        FROM smg_students
        WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.studentid#">
    </cfquery>

    <cfset form.fk_intrep_user = get_student.intrep>
    <cfif form.fk_intrep_user EQ 0 or form.fk_intrep_user EQ ''>
    	<h3>International Agent is missing.  Report may not be added.</h3>
        <cfabort>
    </cfif>
    
    <cfset form.programid = get_student_program.programid>
    <cfif form.programid EQ 0 or form.programid EQ ''>
    	<h3>Program is missing.  Report may not be added.</h3>
        <cfabort>
    </cfif>
        
    <cfquery name="get_school" datasource="#application.dsn#">
        SELECT supervising_rep, fk_ny_user
        FROM php_schools
        WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_program.schoolid#">
    </cfquery>
    <cfset form.fk_ssr_user = get_school.supervising_rep>
    <cfset form.fk_ny_user = get_school.fk_ny_user>

</cfif>

<cfform action="index.cfm?curdoc=forms/pr_add" method="POST"> 

<br />
<!--- outside table --->
<table cellpadding="5" align="center" bgcolor="#ffffff" class="box">
    <tr bgcolor="#C2D1EF">
        <td><span class="get_attention"><b>::</b> Add Progress Report</span></td>
    </tr>
    <tr align="center">
        <td>

<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="studentid" value="#form.studentid#">
<cfinput type="hidden" name="month_of_report" value="#form.month_of_report#">
<cfinput type="hidden" name="companyid" value="#form.companyid#">
<cfinput type="hidden" name="programid" value="#form.programid#">
<cfinput type="hidden" name="fk_sr_user" value="#form.fk_sr_user#">
<cfinput type="hidden" name="fk_ssr_user" value="#form.fk_ssr_user#">
<cfinput type="hidden" name="fk_ny_user" value="#form.fk_ny_user#">
<cfinput type="hidden" name="fk_host" value="#form.fk_host#">
<cfinput type="hidden" name="fk_intrep_user" value="#form.fk_intrep_user#">

<cfquery name="get_student" datasource="#application.dsn#">
    SELECT firstname, familylastname
    FROM smg_students
    WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.studentid#">
</cfquery>

<cfoutput>
<font size="2"><strong>
Student: #get_student.firstname# #get_student.familylastname# (#form.studentid#)<br />
#monthasstring(form.month_of_report)#
</strong></font>
<br /><br />
<table border=0 cellpadding=4 cellspacing=0>
    <tr align="center">
    	<td bgcolor="C2D1EF"><span class="get_attention">Program</span></td>
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
        <cfquery name="get_ny" datasource="#application.dsn#">
            SELECT firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ny_user#">
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
            <th align="right">Supervising Rep:</th>
            <td>#get_rep.firstname# #get_rep.lastname# (#form.fk_sr_user#)</td>
          </tr>
          <tr>
            <th align="right">School Supervising Rep:</th>
            <td>
                <cfif form.fk_ssr_user EQ ''>
                    Reports Directly to NY
                <cfelse>
                    <cfquery name="get_school_rep" datasource="#application.dsn#">
                        SELECT firstname, lastname
                        FROM smg_users
                        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ssr_user#">
                    </cfquery>
                    #get_school_rep.firstname# #get_school_rep.lastname# (#form.fk_ssr_user#)
                </cfif>
            </td>
          </tr>
          <tr>
            <th align="right">NY:</th>
            <td>#get_ny.firstname# #get_ny.lastname# (#form.fk_ny_user#)</td>
          </tr>
          <tr>
            <th align="right">Host Family:</th>
            <td>
                <cfif form.fk_host EQ ''>
                    N/A
                <cfelse>
                    <cfquery name="get_host_family" datasource="#application.dsn#">
                        SELECT familylastname, fatherfirstname, motherfirstname
                        FROM smg_hosts
                        WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_host#">
                    </cfquery>
                    #get_host_family.fatherfirstname#
                    <cfif get_host_family.fatherfirstname NEQ '' and get_host_family.motherfirstname NEQ ''>&amp;</cfif>
                    #get_host_family.motherfirstname#
                    #get_host_family.familylastname# (#form.fk_host#)
                </cfif>
            </td>
          </tr>
          <!---<tr>
            <th align="right">International Agent:</th>
            <td>#get_international_rep.businessname# (#form.fk_intrep_user#)</td>
          </tr>--->
        </table>

        </td>
    </tr>
</table>
</cfoutput>

<table border=0 cellpadding=4 cellspacing=0 width=100%>
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/continue.gif" border=0></td>
	</tr>
</table>

    </td>
  </tr>
</table>
<!--- outside table --->

</cfform>
