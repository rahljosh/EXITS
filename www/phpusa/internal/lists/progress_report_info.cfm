<!--- Import CustomTag --->
<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

<cfparam name="URL.pr_id" default="0">
<cfparam name="URL.report_mode" default="">
<cfparam name="FORM.pr_action" default="">
<cfparam name="FORM.printReport" default="0">
<cfparam name="FORM.emailReport" default="0">

<cfif VAL(URL.pr_id)>
	<cfset FORM.pr_id = URL.pr_id>
</cfif>
<cfif LEN(URL.report_mode)>
	<cfset FORM.report_mode = URL.report_mode>
</cfif>

<cfswitch expression="#form.pr_action#">
<!--- delete contact date. --->
<cfcase value="delete_date">
    <cfquery datasource="#application.dsn#">
        DELETE FROM progress_report_dates
        WHERE prdate_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.prdate_id#">
    </cfquery>
</cfcase>
<!--- approve report --->
<cfcase value="approve">
    <cfquery name="get_report" datasource="#application.dsn#">
        SELECT *
        FROM progress_reports
        WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
    </cfquery>
    <cfset approve_field = ''>
	<!--- in case the user has multiple approval levels, check them in order and just do the first one. --->
	<!--- supervising rep --->
	<cfif client.userid EQ get_report.fk_sr_user and get_report.pr_sr_approved_date EQ ''>
    	<cfset approve_field = 'pr_sr_approved_date'>
    <!--- school supervising rep --->
    <cfelseif client.userid EQ get_report.fk_ssr_user and get_report.pr_ssr_approved_date EQ ''>
    	<cfset approve_field = 'pr_ssr_approved_date'>
    <!--- NY --->
    <cfelseif client.userid EQ get_report.fk_ny_user and get_report.pr_ny_approved_date EQ ''>
    	<cfset approve_field = 'pr_ny_approved_date'>
    </cfif>
    <!--- if user was none of the above but usertype LTE 4 approve NY. --->
    <cfif approve_field EQ '' and client.usertype LTE 4>
    	<cfset approve_field = 'pr_ny_approved_date'>
    </cfif>
    <cfif approve_field NEQ ''>
        <cfquery datasource="#application.dsn#">
            UPDATE progress_reports SET
            #approve_field# = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
            pr_rejected_date = NULL
            WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
        </cfquery>
        <cfquery name="get_student_id_pr" datasource="#application.dsn#">
            select fk_student 
            from progress_reports 
            where pr_id = #form.pr_id#
        </cfquery>
        <cfquery datasource="#application.dsn#">
        	update php_students_in_program
            set doc_evaluation#get_report.pr_month_of_report# = #now()#
            where studentid = '#get_student_id_pr.fk_student#'
        </cfquery>
        <!--- print report if box is checked --->
		<cfif FORM.printReport EQ 1>
        	<script type="text/javascript">
				//window.open("<cfoutput>lists/progress_report_info.cfm?pr_id=#FORM.pr_id#&report_mode=print</cfoutput>","Print");
				$(document).ready(function() {$("#printReportForm").submit();});
			</script>
        </cfif>
        <!--- email report if box is checked --->
        <cfif FORM.emailReport EQ 1>
        	<script type="text/javascript">
				window.open("<cfoutput>forms/pr_email.cfm?pr_id=#FORM.pr_id#&automatic=1</cfoutput>","Email");
			</script>
        </cfif>
    </cfif>
</cfcase>
<!--- delete report. --->
<cfcase value="delete_report">
    <cfquery datasource="#application.dsn#">
        DELETE FROM progress_report_dates
        WHERE fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
    </cfquery>
    <cfquery datasource="#application.dsn#">
        DELETE FROM x_pr_questions
        WHERE fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
    </cfquery>
    <cfquery datasource="#application.dsn#">
        DELETE FROM progress_reports
        WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
    </cfquery>
    <cflocation url="index.cfm?curdoc=lists/progress_reports" addtoken="no">
</cfcase>
</cfswitch>

<SCRIPT>
<!--
// opens letters in a defined format
function OpenLetter(url) {
	newwindow=window.open(url, 'Application', 'height=280, width=700, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>

<!--- view or print --->
<cfparam name="form.report_mode" default="view">
<cfparam name="form.email" default="">
<cfif form.report_mode EQ 'print' OR CLIENT.userType EQ 8>
	<link rel="stylesheet" href="../phpusa.css" type="text/css">
    <!--- override the blue background color on the style sheet with white. --->
	<style type="text/css">
    <!--
    body {
        background: #ffffff;
    }
    -->
    </style>
</cfif>

<style type="text/css">
span.mainSpan {
		color:white; 
		font-weight:bold;
		font-size:12px;
	}
</style>

<cfparam name="form.pr_id" default="">
<cfif not isNumeric(form.pr_id)>
    a numeric pr_id is required to view a progress report.
    <cfabort>
</cfif>

<cfquery name="get_report" datasource="#application.dsn#">
    SELECT *
    FROM progress_reports
    WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
</cfquery>
<cfquery name="get_dates" datasource="#application.dsn#">
    SELECT progress_report_dates.*, prdate_types.prdate_type_name, prdate_contacts.prdate_contact_name
    FROM progress_report_dates
    INNER JOIN prdate_types ON progress_report_dates.fk_prdate_type = prdate_types.prdate_type_id
    INNER JOIN prdate_contacts ON progress_report_dates.fk_prdate_contact = prdate_contacts.prdate_contact_id
    WHERE progress_report_dates.fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
    ORDER BY progress_report_dates.prdate_date
</cfquery>
<cfquery name="get_questions" datasource="#application.dsn#">
    SELECT x_pr_questions.x_pr_question_id, x_pr_questions.x_pr_question_response, smg_prquestions.text
    FROM x_pr_questions
    INNER JOIN smg_prquestions ON x_pr_questions.fk_prquestion = smg_prquestions.id
    WHERE x_pr_questions.fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
    ORDER BY smg_prquestions.id
</cfquery>
<cfquery name="get_student" datasource="#application.dsn#">
	SELECT studentid, firstname, familylastname, companyid
	FROM smg_students
	WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_student#">
</cfquery>
<cfquery name="get_program" datasource="#application.dsn#">
    SELECT programid, programname
    FROM smg_programs
    WHERE programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_program#">
</cfquery>
<cfquery name="get_rep" datasource="#application.dsn#">
    SELECT userid, firstname, lastname
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_sr_user#">
</cfquery>
<cfif get_report.fk_ssr_user NEQ ''>
	<cfquery name="get_school_rep" datasource="#application.dsn#">
		SELECT userid, firstname, lastname
		FROM smg_users
		WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_ssr_user#">
	</cfquery>
</cfif>
<cfquery name="get_ny" datasource="#application.dsn#">
    SELECT userid, firstname, lastname
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_ny_user#">
</cfquery>
<cfif get_report.fk_host NEQ ''>
    <cfquery name="get_host_family" datasource="#application.dsn#">
        SELECT hostid, familylastname, fatherfirstname, motherfirstname
        FROM smg_hosts
        WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_host#">
    </cfquery>
</cfif>
<cfquery name="get_international_rep" datasource="#application.dsn#">
    SELECT userid, businessname
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_intrep_user#">
</cfquery>

<!--- set the edit/approve/reject/delete access. --->
<cfset allow_edit = 0>
<cfset allow_approve = 0>
<cfset allow_reject = 0>
<cfset allow_delete = 0>

<!--- used to display the pending message for the supervising rep. --->
<cfset pending_msg = 0>

<!--- these users always have access. --->
<cfif client.usertype LTE 4>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
    <cfset allow_reject = 1>
    <cfset allow_delete = 1>
</cfif>

<!--- users are allowed access until they approve the report.  Also, if a higher level has already approved then they are not allowed access. --->
<!--- supervising rep --->
<cfif client.userid EQ get_report.fk_sr_user and get_report.pr_sr_approved_date EQ '' and get_report.pr_ssr_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 1>
	<cfset allow_delete = 1>
	<cfset pending_msg = 1>
<!--- school supervising rep --->
<cfelseif client.userid EQ get_report.fk_ssr_user and get_report.pr_ssr_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 1>
	<cfset allow_delete = 1>
<!--- NY --->
<cfelseif client.userid EQ get_report.fk_ny_user and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 1>
	<cfset allow_delete = 1>
</cfif>

<!--- certain things are required for approval. --->
<cfset approve_error_msg = ''>
<cfif allow_approve>

	<!--- contact dates: at least one In Person contact for both Host Family and Student or both. --->
    <cfset hostFamilyOK = 0>
    <cfset studentOK = 0>
    <cfloop query="get_dates">
		<!--- Host Family --->
        <cfif fk_prdate_contact EQ 1>
            <cfset hostFamilyOK = 1>
        <!--- Student --->
        <cfelseif fk_prdate_contact EQ 2>
            <cfset studentOK = 1>
        <!--- Host Family & Student --->
        <cfelseif fk_prdate_contact EQ 3>
            <cfset hostFamilyOK = 1>
            <cfset studentOK = 1>
        </cfif>
    </cfloop>
    <cfif not (hostFamilyOK and studentOK)>
        <cfset allow_approve = 0>
        <cfset approve_error_msg = 'date'>
    </cfif>
     
	<!--- questions: all questions must be answered. --->
    <cfset questionsOK = 1>
    <cfloop query="get_questions">
		<cfif x_pr_question_response EQ ''>
		    <cfset questionsOK = 0>
        </cfif>
    </cfloop>
    <cfif not questionsOK>
        <cfset allow_approve = 0>
        <cfset approve_error_msg = listAppend(approve_error_msg, 'question')>
    </cfif>
     
</cfif>

<cfoutput>

	<center>
    <br />
    <!--- outside table --->
    <table width="45%" cellpadding="5" align="center" bgcolor="ffffff" style="border-style:solid; border-width:thin;">
    	<tr>
        	<td align="center">
            	<cfif form.report_mode EQ 'print' OR CLIENT.userType EQ 8>
					<!--- the image isn't working on the PDF so put company name instead of image. --->
                    <cfif isDefined("form.pdf")>
                        <cfquery name="get_company" datasource="#application.dsn#">
                            SELECT companyname
                            FROM smg_companies
                            WHERE companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student.companyid#">
                        </cfquery>
                        #get_company.companyname#<br />
                    <cfelse>
                        <img src="../../images/#CLIENT.companyID#_short_profile_header.jpg" width="790" height="170" />
                    </cfif>
               	</cfif>
            </td>
      	</tr>
        <tr>
            <td align="center">
            	<span>Progress Report for </span>
            	<span style="font-weight:bold; font-size:18px;">#get_student.firstname# #get_student.familylastname# (#get_student.studentid#)<br>#monthasstring(get_report.pr_month_of_report)#</span>
          	</td>
        </tr>
        <tr>
            <td>

	<!--- pending message. --->
    <cfif pending_msg>
        <table border=0 cellpadding=4 cellspacing=0 width=100%>
            <tr>
                <td><font color="FF0000" size="3">
                   	This report is in pending status, and will not be viewable by anyone else until you approve it.
                </font></td>
            </tr>
        </table>
    </cfif>

<br />

<table cellpadding="2" cellspacing="0" width="100%">

<cfif form.report_mode EQ 'view'>
      <tr align="center" height="25">
      	<td colspan="2">
        	<img src=<cfif (NOT isDefined(form.email)) AND (form.report_mode EQ 'print' OR CLIENT.usertype EQ 8)>"../pics/pisStatus.png"<cfelse>"pics/pisStatus.png"</cfif> />
      	</td>
      </tr>
      <tr>
        <th align="right">SR Approved:</th>
        <td>#DateFormat(get_report.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
      </tr>
      <tr>
        <th align="right">SSR Approved:</th>
        <td>
            <cfif get_report.fk_ssr_user EQ ''>
                N/A
            <cfelse>
                #DateFormat(get_report.pr_ssr_approved_date, 'mm/dd/yyyy')#
            </cfif>
        </td>
      </tr>
      <tr>
        <th align="right">NY Approved:</th>
        <td>#DateFormat(get_report.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
      </tr>
    <cfif get_report.pr_rejected_date NEQ ''>
        <cfquery name="get_rejected_by" datasource="#application.dsn#">
            SELECT userid, firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_rejected_by_user#">
        </cfquery>
      <tr>
        <th align="right">Rejected:</th>
        <td>#DateFormat(get_report.pr_rejected_date, 'mm/dd/yyyy')#</td>
      </tr>
      <tr>
        <th align="right">Rejected By:</th>
        <td>#get_rejected_by.firstname# #get_rejected_by.lastname# (#get_rejected_by.userid#)</td>
      </tr>
      <tr>
        <th colspan="2">Rejection Reason:</th>
      </tr>
      <tr>
        <td colspan="2">#replaceList(get_report.pr_rejection_reason, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</td>
      </tr>
    </cfif>
      <tr>
        <td colspan="2">&nbsp;</td>
      </tr>
</cfif>

  <tr width="100%" height="25" align="center">
    <td colspan="2"><img src=<cfif (NOT isDefined(form.email)) AND (form.report_mode EQ 'print' OR CLIENT.usertype EQ 8)>"../pics/pisProgram.png"<cfelse>"pics/pisProgram.png"</cfif> /></td>
  </tr>
  <tr>
    <th align="right">Program Name:</th>
    <td>#get_program.programname# (#get_program.programid#)</td>
  </tr>
  <tr>
    <th align="right">Supervising Rep:</th>
    <td>#get_rep.firstname# #get_rep.lastname# (#get_rep.userid#)</td>
  </tr>
  <tr>
    <th align="right">School Supervising Rep:</th>
    <td>
		<cfif get_report.fk_ssr_user EQ ''>
            Reports Directly to NY
        <cfelse>
            #get_school_rep.firstname# #get_school_rep.lastname# (#get_school_rep.userid#)
        </cfif>
    </td>
  </tr>
  <tr>
    <th align="right">NY:</th>
    <td>#get_ny.firstname# #get_ny.lastname# (#get_ny.userid#)</td>
  </tr>
  <tr>
    <th align="right">Host Family:</th>
    <td>
		<cfif get_report.fk_host EQ ''>
            N/A
        <cfelse>
            #get_host_family.fatherfirstname#
            <cfif get_host_family.fatherfirstname NEQ '' and get_host_family.motherfirstname NEQ ''>&amp;</cfif>
            #get_host_family.motherfirstname#
            #get_host_family.familylastname# (#get_host_family.hostid#)
        </cfif>
    </td>
  </tr>
</table>

<br />

<cfif form.report_mode EQ 'print' OR CLIENT.userType EQ 8>
	<table cellpadding="2" cellspacing="0" width="100%">
   		<tr>
        	<td colspan="2">
            	<table cellpadding="0" cellspacing="0" width="100%">
              		<tr align="center">
                		<td colspan="2"><img src=<cfif isDefined(form.email)>"pics/pisContactDates.png"<cfelse>"../pics/pisContactDates.png"</cfif> /></td>
          			</tr>
        		</table>
    		</td>
  		</tr>
<cfelse>
    <table cellpadding="2" cellspacing="0" width="100%">
      <tr>
        <td bgcolor="1E2456" colspan="2">
            <table cellpadding="0" cellspacing="0" width="100%">
              <tr align="center">
                <td colspan="2"><span class="mainSpan">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CONTACT DATES</span></td>
            <cfif allow_edit and form.report_mode EQ 'view'>
                <!--- add contact date. --->
                <form action="index.cfm?curdoc=forms/pr_date_form" method="post">
                <td width="1">
                    <input type="hidden" name="pr_id" value="#form.pr_id#">
                    <input name="Submit" type="image" src="pics/new.gif" alt="Add Contact Date" border=0>
                </td>
                </form>
            </cfif>
              </tr>
            </table>
        </td>
      </tr>
</cfif>
<cfif form.report_mode EQ 'view'>
  <tr>
    <td colspan="2"><font size=-2>Each report must show monthly contact, including at least one contact for both Host Family and Student.</font></td>
  </tr>
</cfif>
  <tr align="center">
    <td colspan="2">

	<cfif get_dates.recordCount EQ 0>
    	<strong>There are no contact dates yet.</strong>
    <cfelse>
        <table width="100%" cellpadding="3" cellspacing="0">
            <tr align="left">
				<cfif allow_edit and form.report_mode EQ 'view'>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                </cfif>
                <th>Date</th>
                <th>Type</th>
                <th>Contact</th>
                <th>Comments</th>
            </tr>
        <cfloop query="get_dates">
          <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
			<cfif allow_edit and form.report_mode EQ 'view'>
				<!--- delete contact date. --->
                <form action="index.cfm?curdoc=lists/progress_report_info" method="post" onclick="return confirm('Are you sure you want to delete this Contact Date?')">
                <td>
                    <input type="hidden" name="pr_action" value="delete_date">
                    <input type="hidden" name="prdate_id" value="#prdate_id#">
                    <input type="hidden" name="pr_id" value="#form.pr_id#">
                    <input name="Submit" type="image" src="pics/deletex.gif" alt="Delete Contact Date" border=0>
                </td>
                </form>
				<!--- edit contact date. --->
                <form action="index.cfm?curdoc=forms/pr_date_form" method="post">
                <td>
                    <input type="hidden" name="prdate_id" value="#prdate_id#">
                    <input name="Submit" type="image" src="pics/edit.png" alt="Edit Contact Date" border=0>
                </td>
                </form>
			</cfif>
            <td>#dateFormat(prdate_date, 'mm/dd/yyyy')#</td>
            <!--- need nowrap for the PDF --->
            <td nowrap="nowrap">#prdate_type_name#</td>
            <td nowrap="nowrap">#prdate_contact_name#</td>
            <td><font size="1">#replaceList(prdate_comments, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</font></td>
          </tr>
        </cfloop>
        </table>        
	</cfif>
    
    </td>
  </tr>
</table>

<br />

<table cellpadding="2" cellspacing="0" width="100%">
  <tr align="center" height="25">
    <td colspan="2"><img src=<cfif (NOT isDefined(form.email)) AND (form.report_mode EQ 'print' OR CLIENT.usertype EQ 8)>"../pics/pisQuestions.png"<cfelse>"pics/pisQuestions.png"</cfif> /></td>
  </tr>
  <tr align="center">
    <td colspan="2">

        <table cellpadding="2">
        <cfloop query="get_questions">
          <tr>
		<cfif allow_edit and form.report_mode EQ 'view'>
            <!--- edit question. --->
            <form action="index.cfm?curdoc=forms/pr_question_form" method="post">
            <td>
            <input type="hidden" name="x_pr_question_id" value="#x_pr_question_id#">
            <input name="Submit" type="image" src="pics/edit.png" alt="Edit Question" border=0>
            </td>
            </form>
        <cfelse>
            <td></td>
        </cfif>
            <th align="left">#get_questions.text#</th>
          </tr>
          <tr>
            <td></td>
            <td>#replaceList(x_pr_question_response, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</td>
          </tr>
          <cfif currentRow NEQ RecordCount>
              <tr>
                <td colspan="2" height="25"><hr align="center" noshade="noshade" size="1" width="85%" /></td>
              </tr>
          </cfif>
        </cfloop>
        </table>

    </td>
  </tr>
</table>

<!--- outside table --->
<cfif FORM.report_mode NEQ 'view'>
    </td>
    </tr>
    </table>
    <br />
</cfif>

<cfif form.report_mode EQ 'view'>

	<br />

    <table align="center" width="100%">
      <tr align="center" height="25">
        <td colspan="2"><img src=<cfif (NOT isDefined(form.email)) AND (form.report_mode EQ 'print' OR CLIENT.usertype EQ 8)>"../pics/pisOptions.png"<cfelse>"pics/pisOptions.png"</cfif> /></td>
      </tr>
    </table>

	<!--- approve error messages. --->
    <cfif approve_error_msg NEQ ''>
        <table border=0 cellpadding=4 cellspacing=0 width=100%>
            <tr>
                <td><font color="FF0000">
                   	Approval is not allowed until the following missing information is entered:
                    <ul>
                	<!--- contact dates error message. --->
					<cfif listFind(approve_error_msg, 'date')>
                        <p><li>Contact Dates: at least one contact for both Host Family and Student must be entered.</li></p>
                    </cfif>
                	<!--- questions error message. --->
					<cfif listFind(approve_error_msg, 'question')>
                        <p><li>Questions: all questions must be answered.</li></p>
                    </cfif>
                    </ul>
                </font></td>
            </tr>
        </table>
    </cfif>

    <cfif allow_approve and get_report.pr_rejected_date NEQ ''>
        <table border=0 cellpadding=4 cellspacing=0 width=100%>
            <tr>
                <td>
                	<font color="FF0000">
                   		This report has been rejected. Approval will "unreject" this report.
                	</font>
              	</td>
            </tr>
        </table>
    </cfif>
    
        <table border=0 align="center">
        <tr valign="top">
          <td style="vertical-align:bottom; border:1px solid black">
          	<!--- approve --->
            <cfif allow_approve>
                <form 
                	action="index.cfm?curdoc=lists/progress_report_info" 
                    method="post" 
                    onSubmit="return confirm('Are you sure you want to approve this report?  You will no longer be able to edit this report after approval.')">
                    <input type="hidden" name="pr_action" value="approve">
                    <input type="hidden" name="pr_id" value="#form.pr_id#">
                    <cfif CLIENT.userType LTE 4>
                        <label style="vertical-align:top;">
                            <input type="checkbox" name="printReport" id="printReport" value="1" style="vertical-align:top;" <cfif VAL(FORM.printReport)>checked="checked"</cfif> />Print
                        </label>
                        <label style="vertical-align:top;">
                            <input type="checkbox" name="emailReport" id="emailReport" value="1" style="vertical-align:top;" <cfif VAL(FORM.emailReport)>checked="checked"</cfif> />Email
                        </label>
                	</cfif>
                    <input name="Submit" type="image" src="pics/approve.gif" alt="Approve Report" border=0>
                </form>
            <cfelseif CLIENT.usertype NEQ 8>
            	<img src="pics/no_approve.jpg" alt="Approve Report" border=0>
            </cfif>
          </td>
          <td width="15">&nbsp;</td>
          <td style="vertical-align:bottom">
          	<!--- reject --->
            <cfif allow_reject>
                <form action="index.cfm?curdoc=forms/pr_reject" method="post">
                <input type="hidden" name="pr_id" value="#form.pr_id#">
                <input name="Submit" type="image" src="pics/reject.gif" alt="Reject Report" border=0>
                </form>
            <cfelseif CLIENT.usertype NEQ 8>
            	<img src="pics/no_reject.jpg" alt="Reject" border=0>
            </cfif>
          </td>
          <td width="15">&nbsp;</td>
          <td style="vertical-align:bottom">
          	<!--- delete --->
            <cfif allow_delete>
                <form action="index.cfm?curdoc=lists/progress_report_info" method="post" onclick="return confirm('Are you sure you want to delete this report?')">
                <input type="hidden" name="pr_action" value="delete_report">
                <input type="hidden" name="pr_id" value="#form.pr_id#">
                <input name="Submit" type="image" src="pics/delete.gif" alt="Delete Report" border=0>
                </form>
            <cfelseif CLIENT.usertype NEQ 8>
            	<img src="pics/no_delete.jpg" alt="Delete Report"  border=0>
            </cfif>
          </td>
		<!--- disable print and email for rejected reports. --->
        <cfif get_report.pr_rejected_date EQ ''>
              <td width="15">&nbsp;</td>
              <td style="vertical-align:bottom">
                <!--- print --->
                <cfif CLIENT.usertype EQ 8>
                	<form id="printReportForm" action="progress_report_info.cfm" method="post" target="_blank">
                    <input type="hidden" name="pr_id" value="#form.pr_id#">
                    <input type="hidden" name="report_mode" value="print">
                    <input name="Submit" type="image" src="../pics/printer.gif" alt="Print Report" border=0>
                    </form>
                <cfelse>
                	<form id="printReportForm" action="lists/progress_report_info.cfm" method="post" target="_blank">
                    <input type="hidden" name="pr_id" value="#form.pr_id#">
                    <input type="hidden" name="report_mode" value="print">
                    <input name="Submit" type="image" src="pics/printer.gif" alt="Print Report" border=0>
                    </form>
               	</cfif>
                
              </td>
            <cfif client.usertype LTE 4>
                <td width="15">&nbsp;</td>
                <td style="vertical-align:bottom">
                    <!--- email --->
                    <form action="index.cfm?curdoc=forms/pr_email" method="post">
                    <input type="hidden" name="pr_id" value="#form.pr_id#">
                    <input name="Submit" type="image" src="pics/email.gif" alt="Email Report" border=0>
                    </form>
                </td>
            </cfif>
        </cfif>
        </tr>
      </table>
      <cfif client.usertype NEQ 8>
      	<a href="index.cfm?curdoc=lists/progress_reports">Back to Progress Reports</a>
      </cfif>  
        </td>
      </tr>
    </table>
    <!--- outside table --->
    <br />
  
</cfif>

</cfoutput>

</center>