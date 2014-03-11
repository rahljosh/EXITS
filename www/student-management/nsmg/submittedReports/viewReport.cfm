<cfif isDefined('form.saveAnswer')>

    <cfloop list = '#FORM.FinalQuestionList#' index='i'>
          
            <cfquery datasource="#application.dsn#">
                UPDATE 
                	smg_submitted_report_questions_from_report 
                SET
                	fk_answer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.response' & '#i#')#" >
                WHERE 
                	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(i)#">
            </cfquery>
            
			
        </cfloop>
        <cfquery datasource="#application.dsn#">
                UPDATE 
                	smg_submitted_report_question_tracking
                SET
                	fk_answer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.response' & '#i#')#" >
                WHERE 
                	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(i)#">
            </cfquery>
        <cflocation url="index.cfm?curdoc=qa_reports&lastReport=#url.studentid####url.studentid#">
</cfif>

<cfquery name="get_report" datasource="#application.dsn#">
    SELECT *
    FROM smg_submitted_report_tracking
    WHERE id =<cfqueryparam cfsqltype="cf_sql_integer" value="#url.report#">
</cfquery>


<cfquery name="qGetQuestions" datasource="#application.dsn#">
    SELECT smg_submitted_report_questions_from_report.reportID, 
           smg_submitted_report_questions_from_report.fk_questionID,
           smg_submitted_report_questions_from_report.id,  
           smg_submitted_report_questions_from_report.fk_answer,
           smg_submitted_report_questions.question
    
    FROM smg_submitted_report_questions_from_report
    LEFT JOIN smg_submitted_report_questions on smg_submitted_report_questions.id = smg_submitted_report_questions_from_report.fk_questionid
    WHERE smg_submitted_report_questions_from_report.reportid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.report#">
</cfquery>







 

<!--- view or print --->
<cfparam name="FORM.report_mode" default="view">

<cfif FORM.report_mode EQ 'print'>
	<link rel="stylesheet" href="smg.css" type="text/css">
</cfif>




<cfquery name="get_student" datasource="#application.dsn#">
	SELECT studentid, firstname, familylastname, companyid
	FROM smg_students
	WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_studentID)#">
</cfquery>

<cfquery name="get_program" datasource="#application.dsn#">
    SELECT programid, programname
    FROM smg_programs
    WHERE programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_programID)#">
</cfquery>

<cfquery name="get_rep" datasource="#application.dsn#">
    SELECT userid, firstname, lastname
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_arid)#">
</cfquery>



<cfif get_report.fk_raID NEQ ''>
	<cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
		SELECT userid, firstname, lastname
		FROM smg_users
		WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_raid)#">
	</cfquery>
</cfif>

<cfquery name="get_regional_director" datasource="#application.dsn#">
    SELECT userid, firstname, lastname
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_rdid)#">
</cfquery>
<!----
<cfquery name="get_facilitator" datasource="#application.dsn#">
    SELECT userid, firstname, lastname
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_ny_user)#">
</cfquery>
---->
<cfquery name="get_host_family" datasource="#application.dsn#">
    SELECT hostid, familylastname, fatherfirstname, motherfirstname, phone
    FROM smg_hosts
    WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_hostID)#">
</cfquery>
<!----
<cfquery name="get_international_rep" datasource="#application.dsn#">
    SELECT userid, businessname, email
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_intrep_user)#">
</cfquery>
---->

<cfoutput>

<cfif FORM.report_mode EQ 'view'>

	<!--- this table is so the form is not 100% width. --->
    <table align="center">
      <tr>
        <td>

	<!----header---->
    <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
        <tr height=24>
            <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
            <td background="pics/header_background.gif"><h2>QA Report<br /></h2></td> 
            <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=qa_reports&lastReport=#get_student.studentid####get_student.studentid#">Back to QA Reports</a>
      
            <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>

	
      
    <!----Sizing Table---->
    <table border=0 width=100% cellspacing=5 border=0 class="section">
    <tr>
    <td>

</cfif>

<center>
<br />


<h2>
	<cfif FORM.report_mode EQ 'print'>
        
		<!--- the image isn't working on the PDF so put company name instead of image. --->
        <cfif isDefined("FORM.pdf")>
            #CLIENT.companyname#<br />
        <cfelse>
            <img src="pics/logos/#get_student.companyid#.gif" align="left">
        </cfif>
        
		QA Report <br />
    </cfif>
    
    Student: #get_student.firstname# #get_student.familylastname# (#get_student.studentid#)<br>
    
    <font size=-1>Please answer all questions fully.</font>
</h2>

<br />

<table cellpadding="2" cellspacing="0">

  <tr>
    <th bgcolor="cccccc" colspan="2">Local Persons</th>
  </tr>
  <tr>
    <th align="right">Program Name:</th>
    <td>#get_program.programname# (#get_program.programid#)</td>
  </tr>
  <tr>
    <th align="right">Supervising Representative:</th>
    <td>#get_rep.firstname# #get_rep.lastname# (#get_rep.userid#)</td>
  </tr>
 
  <tr>
    <th align="right">Host Family:</th>
    <td>
    	#get_host_family.fatherfirstname#
        <cfif get_host_family.fatherfirstname NEQ '' and get_host_family.motherfirstname NEQ ''>&amp;</cfif>
    	#get_host_family.motherfirstname#
    	#get_host_family.familylastname# (#get_host_family.hostid#)
    </td>
  </tr>
 <tr>
    <th align="right">Host Phone:</th>
    <td>
    	#get_host_family.phone#
        
    </td>
  </tr>
</table>

<br />

<table cellpadding="2" width=80% cellspacing="0">
  <tr>
    <th bgcolor="cccccc" colspan="2">Questions</th>
  </tr>
  <tr align="center">
    <td colspan="2">
<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#&studentid=#get_student.studentid#" method="post" >
        <table cellpadding="2">
        <cfset questionList = ''>
        <cfloop query="qGetQuestions">
        
		<cfset questionList = #ListAppend(questionList, #id#)#>
          <tr>
            <td>
            	<cfif  FORM.report_mode EQ 'view'>
			        <!--- edit question.
                    <form action="index.cfm?curdoc=forms/pr_question_form" method="post">
                    <input type="hidden" name="x_pr_question_id" value="#x_pr_question_id#">
                    <input name="Submit" type="image" src="pics/edit.png" alt="Edit Question" border=0>
                    </form>
					 --->
                </cfif>
            </td>
            <th align="left">#qGetQuestions.question#</th>
            
          </tr>
          <tr>
            <td></td>
            <td colspan=2>
           
              <cfif 1 eq 1>
            
            <textarea cols=100 rows=5 name="response#id#" id="textInput#id#" class="input">#replaceList(fk_answer, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</textarea>
            <cfelse>
            #replaceList(fk_answer, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
            </cfif>
            </td>
          </tr>
        
		  <cfif currentRow NEQ RecordCount>
              <tr>
                <td colspan="2" height="25"><hr align="center" noshade="noshade" size="1" width="85%" /></td>
              </tr>
          </cfif>
        </cfloop>
        <input type="hidden" name="finalQuestionList" value="#questionList#" />

	</table>
		</td>
	</tr>
    <tr>
    	<Td align="center"><input type="submit" name="saveAnswer" value="Save Answers" class="basicOrangeButton"/></Td>
    </tr>
</table>
		</td>
	</tr>
</table>
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

</center>



</cfoutput>
