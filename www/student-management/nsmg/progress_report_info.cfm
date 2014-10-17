<!--- ------------------------------------------------------------------------- ----
	
	File:		progress_report_info.cfm
	Author:		Marcus Melo
	Date:		July 5, 2012
	Desc:		

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- PS: Any changes made here should be also be made in the bulk progress report printing file --->

    <!--- Param LOCAL Variables --->
    <cfparam name="vSetStartDate" default="">
    <cfparam name="vSetEndDate" default="">
    <cfparam name="vSetDueDate" default="">

    <cfparam name="FORM.pr_action" default="">
    <cfparam name="FORM.pr_rmonth" default="">
    <cfparam name="CLIENT.pr_rmonth" default="">
    
    <cfparam name="URL.pr_id" default="0">
    <cfparam name="URL.pr_action" default="">
    
    <cfscript>
		if ( VAL(FORM.pr_rmonth) ) {
			CLIENT.pr_rmonth = FORM.pr_rmonth;
		}
		
		if ( VAL(URL.pr_id) ) {
			FORM.pr_id = URL.pr_id;
		}
		
		if ( LEN(URL.pr_action) ) {
			FORM.pr_action = URL.pr_action;	
		}
		
		questionList = '';
	</cfscript>

</cfsilent>

<!--- August to July Reports --->
<cfquery name="qGetSeasonDateRange" datasource="#APPLICATION.DSN#">
	SELECT 
		startDate, 
		DATE_ADD(endDate, INTERVAL 31 DAY) AS endDate <!--- add 1 month to include July dates --->
	FROM 
		smg_seasons
	WHERE 
		startdate <= CURRENT_DATE
	AND 
		DATE_ADD(endDate, INTERVAL 31 DAY) >= CURRENT_DATE
</cfquery>

<!--- Loop Through Months in a season | July needs to be included here --->
<cfloop from="#qGetSeasonDateRange.startDate#" to="#qGetSeasonDateRange.endDate#" index="i" step="#CreateTimeSpan(31,0,0,0)#">
	
	<cfif CLIENT.pr_rmonth EQ DatePart('m', i)>
		<cfset vSetStartDate =  DateAdd('m', -1, DatePart("yyyy", i) & '-' & DatePart("m", i) & '-01')>
		<cfset vSetEndDate = CreateDate(year(vSetStartDate), month(vSetStartDate), DaysInMonth(vSetStartDate))>
		<cfset vSetDueDate = CreateDate(DatePart("yyyy", i), DatePart("m", i), '01')>
	</cfif>
	 
</cfloop>

<cfswitch expression="#FORM.pr_action#">

	<!--- delete contact date. --->
    <cfcase value="delete_date">
    
        <cfquery datasource="#application.dsn#">
            DELETE FROM 
            	progress_report_dates
            WHERE 
            	prdate_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.prdate_id)#">
        </cfquery> 
        	
	</cfcase>

	<!----Save Report---->
    <cfcase value="save">
    
        <cfloop list = '#FORM.FinalQuestionList#' index='i'>
            <cfquery datasource="#application.dsn#">
                UPDATE 
                	x_pr_questions 
                SET
                	x_pr_question_response = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('FORM.x_pr_question_response' & '#i#')#" >
                WHERE 
                	x_pr_question_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(i)#">
            </cfquery>
        </cfloop>
        
    </cfcase>

	<!--- approve report --->
    <cfcase value="approve">
    
        <cfquery name="get_report" datasource="#application.dsn#">
            SELECT 
            	*
            FROM 
            	progress_reports
            WHERE 
            	pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_id)#">
        </cfquery>
        <cfquery name="get_international_rep" datasource="#application.dsn#">
            SELECT userid, businessname, email
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_intrep_user)#">
        </cfquery>
        <cfquery name="get_student" datasource="#application.dsn#">
            SELECT studentid, firstname, familylastname, companyid
            FROM smg_students
            WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_student)#">
        </cfquery>
        
        <cfset approve_field = ''>
        <cfset date_sent = ''>
        <!--- in case the user has multiple approval levels, check them in order and just do the first one. --->
        <!--- supervising rep --->
        <cfif CLIENT.userid EQ get_report.fk_sr_user and get_report.pr_sr_approved_date EQ ''>
            <cfset approve_field = 'pr_sr_approved_date'>
        <!--- regional advisor --->
        <cfelseif CLIENT.userid EQ get_report.fk_ra_user and get_report.pr_ra_approved_date EQ ''>
            <cfset approve_field = 'pr_ra_approved_date'>
        <!--- regional director --->
        <cfelseif CLIENT.userid EQ get_report.fk_rd_user and get_report.pr_rd_approved_date EQ ''>
            <cfset approve_field = 'pr_rd_approved_date'>
        <!--- facilitator OR any office user --->
        <cfelseif get_report.pr_ny_approved_date EQ '' AND (CLIENT.userid EQ get_report.fk_ny_user OR CLIENT.userType LTE 4)>
            <cfset approve_field = 'pr_ny_approved_date'>
            <cfif get_report.pr_month_of_report  mod 2 is 0>
            	<cfset date_sent = '#now()#'>
            <!----send email to Int Rep that report has been completed and available for review.---->    
            <cfoutput>
                <cfsavecontent variable="email_message">
                
                 A progress report has been submitted for #get_student.firstname# #get_student.familylastname#.  
                 <br /><br />
                 This report is available to view by clicking on this <a href="https://#client.companyshort#.exitsapplication.com/externalReports/progressReport.cfm?report=#get_report.pr_uniqueid#">link.</a><br /><br />
                 
                 If that link doesn't work, copy and paste this url into your browser:<Br /><br />
                 #client.exits_url#/externalReports/progressReport.cfm?report=#get_report.pr_uniqueid#
                 <br /><br />
                 
                 Regards-<br /><br />
                 #client.companyname#
                     
                     
                      
                </cfsavecontent>
                    </Cfoutput>			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#get_international_rep.email#">
                <cfinvokeargument name="email_subject" value="Progress Report for #get_student.firstname# #get_student.familylastname# ">
                <cfinvokeargument name="email_message" value="#email_message#">
        
                <cfinvokeargument name="email_from" value="#client.companyshort#-support@exitsapplication.com">
            </cfinvoke>
    		</cfif>
	        
        </cfif>
        
        
        
        
        <cfif approve_field NEQ ''>
        
            <cfquery datasource="#application.dsn#">
                UPDATE 
                	progress_reports 
                SET
                    #approve_field# = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    dateSentIntRep = <cfqueryparam cfsqltype="cf_sql_date" value="#date_sent#">,
                    pr_rejected_date = NULL
                WHERE 
                	pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_id)#">
            </cfquery>
            
        </cfif>
        
    </cfcase>
    
	<!--- delete report. --->
    <cfcase value="delete_report">
    
        <cfquery datasource="#application.dsn#">
            DELETE FROM 
            	progress_report_dates
            WHERE 
            	fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_id)#">
        </cfquery>
        
        <cfquery datasource="#application.dsn#">
            DELETE FROM 
            	x_pr_questions
            WHERE 
            	fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_id)#">
        </cfquery>
        
        <cfquery datasource="#application.dsn#">
            DELETE FROM 
            	progress_reports
            WHERE 
            	pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_id)#">
        </cfquery>
        
        <cflocation url="index.cfm?curdoc=progress_reports" addtoken="no">
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
<!----SpellCheck info---->
 <!-- 1. include jQuery ... naturally none of this works without jQuery 
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/jquery-1.4.2.js"></script>-->
 <!-- 2. load the atd.textarea.js -- this script makes it easy to attach AtD to a textarea -->
 <script src="spellCheck/scripts/jquery.atd.textarea.js"></script>
 <!-- 3. this script is a hack that allows cross-domain AJAX -->
 <script src="spellCheck/scripts/csshttprequest.js"></script>
<!-- 4. this CSS file contains the style information for highlighted errors -->
 <link rel="stylesheet" type="text/css" media="screen" href="spellCheck/css/atd.css" />

 

<!--- view or print --->
<cfparam name="FORM.report_mode" default="view">

<cfif FORM.report_mode EQ 'print'>
	<link rel="stylesheet" href="smg.css" type="text/css">
</cfif>

<cfparam name="FORM.pr_id" default="">
<cfif not isNumeric(FORM.pr_id)>
    a numeric pr_id is required to view a progress report.
    <cfabort>
</cfif>

<cfquery name="get_report" datasource="#application.dsn#">
    SELECT *
    FROM progress_reports
    WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_id)#">
</cfquery>

<cfif NOT VAL(CLIENT.pr_rmonth)>
	<cfset CLIENT.pr_rmonth = get_report.pr_month_of_report>
</cfif>

<cfquery name="get_dates" datasource="#application.dsn#">
    SELECT progress_report_dates.*, prdate_types.prdate_type_name, prdate_contacts.prdate_contact_name
    FROM progress_report_dates
    INNER JOIN prdate_types ON progress_report_dates.fk_prdate_type = prdate_types.prdate_type_id
    INNER JOIN prdate_contacts ON progress_report_dates.fk_prdate_contact = prdate_contacts.prdate_contact_id
    WHERE progress_report_dates.fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_id)#">
    ORDER BY progress_report_dates.prdate_date
</cfquery>

<Cfif get_report.pr_month_of_report eq 1>
	<cfset perviousMonthsReport = 12>
<cfelse>
	<cfset perviousMonthsReport = get_report.pr_month_of_report - 1>
</Cfif>

<cfquery name="get_previousDates" datasource="#application.dsn#">
    select pr.pr_id, pr.pr_month_of_report,progress_report_dates.*, prdate_types.prdate_type_name, prdate_contacts.prdate_contact_name
    from progress_reports pr
    left join progress_report_dates  on progress_report_dates.fk_progress_report = pr.pr_id
    INNER JOIN prdate_types ON progress_report_dates.fk_prdate_type = prdate_types.prdate_type_id
    INNER JOIN prdate_contacts ON progress_report_dates.fk_prdate_contact = prdate_contacts.prdate_contact_id
    where pr.fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_student)#"> 
    and pr_month_of_report = #perviousMonthsReport#
    ORDER BY progress_report_dates.prdate_date
</cfquery>

<cfquery name="get_questions" datasource="#application.dsn#">
    SELECT x_pr_questions.x_pr_question_id, x_pr_questions.x_pr_question_response, smg_prquestions.text, smg_prquestions.required
    FROM x_pr_questions
    INNER JOIN smg_prquestions ON x_pr_questions.fk_prquestion = smg_prquestions.id
    WHERE x_pr_questions.fk_progress_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.pr_id)#">
    ORDER BY smg_prquestions.id
</cfquery>

<cfquery name="get_student" datasource="#application.dsn#">
	SELECT studentid, firstname, familylastname, companyid
	FROM smg_students
	WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_student)#">
</cfquery>

<cfquery name="get_program" datasource="#application.dsn#">
    SELECT programid, programname
    FROM smg_programs
    WHERE programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_program)#">
</cfquery>

<cfquery name="get_rep" datasource="#application.dsn#">
    SELECT userid, firstname, lastname
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_sr_user)#">
</cfquery>

<cfif get_report.fk_pr_user NEQ ''>
    <cfquery name="get_place_rep" datasource="#application.dsn#">
        SELECT userid, firstname, lastname
        FROM smg_users
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_pr_user)#">
    </cfquery>
<cfelse> 
   	<cfset get_place_rep.firstname = 'Not Originally'>
    <cfset get_place_rep.lastname = 'Recorded'>
    <cfset get_place_rep.userid = ''>
</cfif>

<cfif get_report.fk_ra_user NEQ ''>
	<cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
		SELECT userid, firstname, lastname
		FROM smg_users
		WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_ra_user)#">
	</cfquery>
</cfif>

<cfquery name="get_regional_director" datasource="#application.dsn#">
    SELECT userid, firstname, lastname
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_rd_user)#">
</cfquery>

<cfquery name="get_facilitator" datasource="#application.dsn#">
    SELECT userid, firstname, lastname
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_ny_user)#">
</cfquery>

<cfquery name="get_host_family" datasource="#application.dsn#">
    SELECT hostid, familylastname, fatherfirstname, motherfirstname
    FROM smg_hosts
    WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_host)#">
</cfquery>

<cfquery name="get_international_rep" datasource="#application.dsn#">
    SELECT userid, businessname, email
    FROM smg_users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_intrep_user)#">
</cfquery>

<!--- set the edit/approve/reject/delete access. --->
<cfset allow_edit = 0>
<cfset allow_approve = 0>
<cfset allow_reject = 0>
<cfset allow_delete = 0>
<cfset allow_save = 0>
<cfset show_save = 0>

<!--- used to display the pending message for the supervising rep. --->
<cfset pending_msg = 0>

<!--- users are allowed access until they approve the report.  Also, if a higher level has already approved then they are not allowed access. --->
<!--- supervising rep --->
<cfif CLIENT.userid EQ get_report.fk_sr_user and get_report.pr_sr_approved_date EQ '' and get_report.pr_ra_approved_date EQ '' and get_report.pr_rd_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 0>
	<cfset allow_delete = 1>
	<cfset pending_msg = 1>
    <cfset allow_save = 1>
	<Cfset show_save = 1>
    
<!--- regional advisor --->
<cfelseif CLIENT.userid EQ get_report.fk_ra_user and get_report.pr_ra_approved_date EQ '' and get_report.pr_rd_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 1>
	<cfset allow_delete = 1>
    <cfset allow_save = 1>
	<Cfset show_save = 1>
<!--- regional director --->
<cfelseif CLIENT.userid EQ get_report.fk_rd_user and get_report.pr_rd_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 1>
	<cfset allow_delete = 1>
    <cfset allow_save = 1>
	<Cfset show_save = 1>
<!--- facilitator --->
<cfelseif CLIENT.userid EQ get_report.fk_ny_user and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 1>
	<cfset allow_delete = 1>
    <cfset allow_save = 1>
	<Cfset show_save = 1>
<!--- Program Manager - Office User - Gary request - 10/01/2010 - Managers should be able to approve progress reports --->
<cfelseif CLIENT.userType LTE 4 AND NOT LEN(get_report.pr_ny_approved_date)>
    <cfset allow_edit = 1>
	<cfset allow_approve = 1>
	<cfset allow_reject = 1>
    <cfset allow_delete = 1>
    <cfset allow_save = 1>
	<Cfset show_save = 1>
</cfif>
<!----toggle Edit/save function---->
<cfif FORM.pr_action is 'save'>
	<cfset allow_save = 0>

</cfif>
<!--- certain things are required for approval. --->
<cfset approve_error_msg = ''>

	
	<!--- contact dates: at least one In Person contact for both Host Family and Student or both. --->
    <cfset hostFamilyOK = 0>
    <cfset studentOK = 0>
    <cfset prevhostFamilyOK = 0>
    <cfset prevStudentOK = 0>
    <cfset currentStudentContact = 0>
    <cfset currentHostContact = 0>
    <!-------->
<Cfoutput>

</Cfoutput>
	<!---Check in Person over previous two months---->
    <!----If there are no current contact dates, throw error---->
    
    <cfif get_dates.recordcount eq 0>
		
        <cfset allow_approve = 0>
        <cfset approve_error_msg = listAppend(approve_error_msg, 'currentDate')>
    <cfelse>
    
    	<!----check previous dates---->
        <cfloop query="get_Previousdates">
        <!--- type = In Person --->
        <cfif fk_prdate_type EQ 1>
            <!--- Host Family --->
            <cfif fk_prdate_type EQ 1 and fk_prdate_contact  eq 1>
                <cfset prevhostFamilyOK = 1>
            <!--- Student --->
            <cfelseif fk_prdate_type EQ 1 and fk_prdate_contact  eq 2 >
                <cfset prevstudentOK = 1>
            <!--- Host Family & Student --->
            <cfelseif fk_prdate_type EQ 1 or fk_prdate_contact  eq 3>
                <cfset prevhostFamilyOK = 1>
                <cfset prevstudentOK = 1>
            </cfif>
        </cfif>
    	</cfloop>
        
 <Cfoutput>

</Cfoutput>
    
    	<!----check current dates---->
        <cfloop query="get_dates">
            	<!--- Host Family --->
                <cfif fk_prdate_type EQ 1 and fk_prdate_contact  eq 1>
                    <cfset hostFamilyOK = 1>
                    
                <!--- Student --->
                <cfelseif fk_prdate_type EQ 1 and fk_prdate_contact  eq 2 >
                    <cfset studentOK = 1>
                    
                <!--- Host Family & Student --->
                <cfelseif fk_prdate_type EQ 1 or fk_prdate_contact  eq 3>
                    <cfset hostFamilyOK = 1>
                    <cfset studentOK = 1>
                </cfif>
                <cfif fk_prdate_contact eq 2 or fk_prdate_contact eq 3 >
              	  <cfset currentStudentContact = 1>
                </cfif>
                 <cfif fk_prdate_contact eq 1 or fk_prdate_contact eq 3 >
              	  <cfset currentHostContact = 1>
                </cfif>
        </cfloop>
 <Cfoutput>

</Cfoutput>       
       <cfif not ((prevhostFamilyOK or hostFamilyOK) AND  (prevstudentOK or studentOK))>
        <cfset allow_approve = 0>
        <cfset approve_error_msg = 'date'>
    	</cfif> 
    
        <Cfif currentHostContact eq 0>
        	<cfset approve_error_msg = listAppend(approve_error_msg, 'noHostContact')>
            <cfset allow_approve = 0>
        </Cfif>
        <Cfif currentStudentContact eq 0>
        	<cfset approve_error_msg = listAppend(approve_error_msg, 'noStudentContact')>
            <cfset allow_approve = 0>
        </Cfif>
    </cfif>
    
    
	<!--- questions: all questions must be answered. --->
    <cfset questionsOK = 1>
    <cfloop query="get_questions">
		<cfif x_pr_question_response EQ ''  AND  required eq 1 >
		    <cfset questionsOK = 0>
        </cfif>
    </cfloop>
   
    
    <cfif not questionsOK>
        <cfset allow_approve = 0>
        <cfset approve_error_msg = listAppend(approve_error_msg, 'question')>
    </cfif>
     


<cfoutput>

<cfif FORM.report_mode EQ 'view'>
	<Cfif CLIENT.pr_rmonth eq 1>
        <cfset thisMonth = 12>
    <Cfelse>
        <Cfset thisMonth = CLIENT.pr_rmonth -1>
    </Cfif>
	<!--- this table is so the form is not 100% width. --->
    <table align="center">
      <tr>
        <td>

	<!----header---->
    <table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
        <tr height=24>
            <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
            <td width=26 background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
            <td background="pics/header_background.gif"><h2>#monthAsString(thisMonth)# Progress Report <br /></h2></td> 
            <td background="pics/header_background.gif" align="right"><a href="index.cfm?curdoc=progress_reports&lastReport=#get_student.studentid####get_student.studentid#">Back to Progress Reports</a>
      
            <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>

	<!--- pending message. --->
    <cfif pending_msg>
        <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
            <tr>
                <td><font color="FF0000" size="3">
                   	This report is in pending status, and will not be viewable by anyone else until you approve it.
                </font></td>
            </tr>
        </table>
    </cfif>
      
    <!----Sizing Table---->
    <table border=0 width=100% cellspacing=5 border=0 class="section">
    <tr>
    <td>

</cfif>

<center>
<br />


<h2>
	<cfif FORM.report_mode EQ 'print'>
        	<Cfif CLIENT.pr_rmonth eq 1>
        <cfset thisMonth = 12>
    <Cfelse>
        <Cfset thisMonth = CLIENT.pr_rmonth -1>
    </Cfif>
		<!--- the image isn't working on the PDF so put company name instead of image. --->
        <cfif isDefined("FORM.pdf")>
            #CLIENT.companyname#<br />
        <cfelse>
            <img src="pics/logos/#get_student.companyid#.gif" align="left">
        </cfif>
        
		#monthAsString(thisMonth)# Progress Report <br />
    </cfif>
    
    Student: #get_student.firstname# #get_student.familylastname# (#get_student.studentid#)<br>
    
    <font size=-1>Due #monthAsString(CLIENT.pr_rmonth)# 1st - includes information from #DateFormat(vSetStartDate, 'mmm d')# through #DateFormat(vSetEndDate, 'mmm d')#</font>
</h2>

<br />

<table cellpadding="2" cellspacing="0">

<cfif FORM.report_mode EQ 'view' and CLIENT.usertype lt 8>
      <tr>
        <th bgcolor="cccccc" colspan="2">Status</th>
      </tr>
      <tr>
        <th align="right">Report ID:</th>
        <td>#FORM.pr_id#</td>
      </tr>
      <tr>
        <th align="right">SR Approved:</th>
        <td>#DateFormat(get_report.pr_sr_approved_date, 'mm/dd/yyyy')#</td>
      </tr>
      <tr>
        <th align="right">RA Approved:</th>
        <td>
            <cfif get_report.fk_ra_user EQ ''>
                N/A
            <cfelse>
                #DateFormat(get_report.pr_ra_approved_date, 'mm/dd/yyyy')#
            </cfif>
        </td>
      </tr>
      <tr>
        <th align="right">RD Approved:</th>
        <td>#DateFormat(get_report.pr_rd_approved_date, 'mm/dd/yyyy')#</td>
      </tr>
      <tr>
        <th align="right">Facilitator Approved:</th>
        <td>#DateFormat(get_report.pr_ny_approved_date, 'mm/dd/yyyy')#</td>
      </tr>
    <cfif get_report.pr_rejected_date NEQ ''>
        <cfquery name="get_rejected_by" datasource="#application.dsn#">
            SELECT userid, firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_report.fk_rejected_by_user)#">
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

  <tr>
    <th bgcolor="cccccc" colspan="2">Program</th>
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
    <th align="right">Regional Advisor:</th>
    <td>
		<cfif get_report.fk_ra_user EQ ''>
            Reports Directly to Regional Director
        <cfelse>
            #get_advisor_for_rep.firstname# #get_advisor_for_rep.lastname# (#get_advisor_for_rep.userid#)
        </cfif>
    </td>
  </tr>
  <tr>
    <th align="right">Regional Director:</th>
    <td>#get_regional_director.firstname# #get_regional_director.lastname# (#get_regional_director.userid#)</td>
  </tr>
  <tr>
    <th align="right">Facilitator:</th>
    <td>#get_facilitator.firstname# #get_facilitator.lastname# (#get_facilitator.userid#)</td>
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
    <th align="right">International Agent:</th>
    <td>#get_international_rep.businessname# (#get_international_rep.userid#) </td>
  </tr>
  <Cfif get_report.dateSentIntRep is not ''>
  <tr>
  	<th align="right">Report Sent:</th><td> #DateFormat(get_report.dateSentIntRep, 'dd-MMM-yy')# to #get_international_rep.email# </td>
  </tr>  
  </Cfif>
</table>

<br />

<table cellpadding="2" cellspacing="0">
  <tr>
    <td bgcolor="cccccc" colspan="2">
        <table cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <th>Contact listed on last months report<font size=-1></font></th>
		
          </tr>
        </table>
    </td>
  </tr>

<cfif FORM.report_mode EQ 'view'>
  <tr>
    <td colspan="2"><font size=-2>Each report must show monthly contact, including at least one bi-monthly In Person contact for both Host Family and Student.</font></td>
  </tr>
</cfif>
 <tr align="center">
    <td colspan="2">

	<cfif get_previousDates.recordCount EQ 0>
    	There are no contact dates yet.
    <cfelse>
        <table width="100%" cellpadding="3" cellspacing="0">
            <tr align="left">
				
                <th>Date</th>
                <th>Type</th>
                <th>Contact</th>
                <th>Comments</th>
            </tr>
        <cfloop query="get_previousDates">
          <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
			
            <td>#dateFormat(prdate_date, 'mm/dd/yyyy')#</td>
            <!--- need nowrap for the PDF --->
            <td nowrap="nowrap">#prdate_type_name#</td>
            <td nowrap="nowrap">#prdate_contact_name#</td>
            <td><font size="1">#replaceList(prdate_comments, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</font></td>
          </tr>
        </cfloop>
        </table>        
	</cfif>
    </tr>
     <tr> <td bgcolor="cccccc" colspan="2">
        <table cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <th> Contact for this Report</th>
		<cfif allow_edit and FORM.report_mode EQ 'view'>
            <td width="1">
          
		        <!--- add contact date. --->
                <form action="index.cfm?curdoc=forms/pr_date_form" method="post">
                    <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                    <input type="hidden" name="pr_rmonth" value="#FORM.pr_rmonth#">
                    <input name="Submit" type="image" src="pics/buttons/new23x23.png" alt="Add Contact Date" border=0>
                </form>
            </td>
		</cfif>
          </tr>
        </table>
      </tr>
    <cfif FORM.report_mode EQ 'view'>
  <tr>
    <td colspan="2"><font size=-2>Each report must show monthly contact, including at least one bi-monthly In Person contact for both Host Family and Student.</font></td>
  </tr>
</cfif>
  <tr align="center">
    <td colspan="2">

	<cfif get_dates.recordCount EQ 0>
    	There are no contact dates yet.
    <cfelse>
        <table width="100%" cellpadding="3" cellspacing="0">
            <tr align="left">
				<cfif allow_edit and FORM.report_mode EQ 'view'>
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
			<cfif allow_edit and FORM.report_mode EQ 'view'>
                <td>
                	<!--- delete contact date. --->
                    <form action="index.cfm?curdoc=progress_report_info" method="post" onclick="return confirm('Are you sure you want to delete this Contact Date?')">
                    <input type="hidden" name="pr_action" value="delete_date">
                    <input type="hidden" name="prdate_id" value="#prdate_id#">
                    <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                    <input name="Submit" type="image" src="pics/buttons/trash23x23.png" alt="Delete Contact Date" border=0>
                    </form>
                </td>
                <td>
                	<!--- edit contact date. --->
                    <form action="index.cfm?curdoc=forms/pr_date_form" method="post">
                    <input type="hidden" name="prdate_id" value="#prdate_id#">
                    <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                    <input type="hidden" name="pr_rmonth" value="#FORM.pr_rmonth#">
                    <input name="Submit" type="image" src="pics/buttons/pencilBlue23x29.png" alt="Edit Contact Date" border=0>
                    </form>
                </td>
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

<table cellpadding="2" width=80% cellspacing="0">
  <tr>
    <th bgcolor="cccccc" colspan="2">Questions</th>
  </tr>
  <tr align="center">
    <td colspan="2">
<form action="index.cfm?curdoc=progress_report_info" id="submitReport" method="post" onSubmit="return confirm('Your report is being saved.  If ready to submit to the next level, click on Approve.')">
        <table cellpadding="2">
        
        <cfloop query="get_questions">
        <cfset questionList = #ListAppend(questionList, #x_pr_question_id#)#>
          <tr>
            <td>
            	<cfif allow_edit and FORM.report_mode EQ 'view'>
			        <!--- edit question.
                    <form action="index.cfm?curdoc=forms/pr_question_form" method="post">
                    <input type="hidden" name="x_pr_question_id" value="#x_pr_question_id#">
                    <input name="Submit" type="image" src="pics/edit.png" alt="Edit Question" border=0>
                    </form>
					 --->
                </cfif>
            </td>
            <th align="left">#get_questions.text#</th>
            
          </tr>
          <tr>
            <td></td>
            <td colspan=2>
           
            <cfif allow_save>
            <Cfset funcName = 'function check#get_questions.currentrow#()'>
			<script>
			function check#get_questions.currentrow#()
			 {
				AtD.checkTextAreaCrossAJAX('textInput#get_questions.currentrow#', 'checkLink#get_questions.currentrow#', 'Edit Text');
				
			 }
			 </script>
            
            <textarea cols=100 rows=5 name="x_pr_question_response#x_pr_question_id#" id="textInput#get_questions.currentrow#" class="input">#replaceList(x_pr_question_response, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</textarea>
            <cfelse>
            #replaceList(x_pr_question_response, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
            </cfif>
            </td>
          </tr>
          <cfif allow_save>
          <tr>
          <td align="right" colspan=4><a href="javascript:check#get_questions.currentrow#()" id="checkLink#get_questions.currentrow#">Check Spelling & Grammar</a></td>
          </tr>
          </cfif>
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
</table>

</center>

<cfif FORM.report_mode EQ 'view'>

	<!----End of Sizing Table---->
    </td>
    </tr>
    </table>

	<!--- approve error messages. --->
    <cfif approve_error_msg NEQ ''>
        <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
            <tr>
                <td><font color="FF0000">
                   	Approval is not allowed until the following missing information is entered:
                    <ul>
                    <!--- contact dates error message. --->
					<cfif listFind(approve_error_msg, 'date')>
                        <p><li>Contact Dates: at least one In Person contact for both Host Family and Student must be entered in a two month period.</li></p>
                    </cfif>
                	<!--- contact dates error message. --->
					<cfif listFind(approve_error_msg, 'currentDate')>
                        <p><li>Contact Dates: at least once contact with both the student & host in current month required.</li></p>
                    </cfif>
                    <!--- contact dates error message. --->
					<cfif listFind(approve_error_msg, 'noHostContact')>
                        <p><li>Contact Dates: there is no current contact with the host family listed for the current report.</li></p>
                    </cfif>
                    <!--- contact dates error message. --->
					<cfif listFind(approve_error_msg, 'noStudentContact')>
                        <p><li>Contact Dates: there is no contact with the student listed for the current report.</li></p>
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
        <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
            <tr>
                <td><font color="FF0000">
                   	This report has been rejected.  Approval will "unreject" this report.
                </font></td>
            </tr>
        </table>
    </cfif>
    
    <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
        <tr>
            <td align="center">
    
        <table border=0 align="center">
        <tr>
        
         <td>
        	<cfif show_save>
				<!--- save --->
                <cfif allow_save>
                    
                    <input type="hidden" name="pr_action" value="save">
                    <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                    <input name="Submit" type="image" src="pics/buttons/save50x58.png" alt="Approve Report" border=0>
                    
                <cfelse>
                    <img src="pics/buttons/save50x58BW.png" alt="Save Report" border=0>
                </cfif>
            <cfelse>
            		<img src="pics/buttons/save50x58BW.png" alt="Save Report" border=0>
            </cfif>
            </form>
          </td>
          <td width=10></td>
          <td>
          <cfif show_save>
          	<!--- edit --->
            <cfif not allow_save>
                <form action="index.cfm?curdoc=progress_report_info" method="post" >
                <input type="hidden" name="pr_action" value="edit">
                <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                <input name="Submit" type="image" src="pics/buttons/edit50x50.png" alt="Approve Report" border=0>
                
            <cfelse>
            	<img src="pics/buttons/edit50x50bw.png" alt="Edit Report" border=0>
            </cfif>
            </form>
            <cfelse>
            		<img src="pics/buttons/edit50x50bw.png" alt="Edit Report" border=0>
            </cfif>
          </td>
          
          
          <td width=30>&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td>
          	<!--- approve --->
            
           <cfif not allow_save>
            <cfif allow_approve>
                <form action="index.cfm?curdoc=progress_report_info" method="post" onclick="return confirm('Are you sure you want to approve this report?  You will no longer be able to edit this report after approval.')">
                <input type="hidden" name="pr_action" value="approve">
                <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                <input name="Submit" type="image" src="pics/buttons/approve50x50.png" alt="Approve Report" border=0>
                </form>
            <cfelse>
            	<img src="pics/buttons/approvebw50.png" alt="Approve Report" border=0>
            </cfif>
           <cfelse>
           		<img src="pics/buttons/approvebw50.png" alt="Approve Report" border=0>
           </cfif>
          </td>
          <td >&nbsp;&nbsp;</td>
          <td>
          	<!--- reject --->
            <cfif not allow_save>
				<cfif allow_reject>
                    <form action="index.cfm?curdoc=forms/pr_reject" method="post">
                    <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                    <input name="Submit" type="image" src="pics/buttons/reject50x50.png" alt="Reject Report" border=0>
                    </form>
                <cfelse>
                    <img src="pics/buttons/reject50x50bw.png" alt="Reject" border=0>
                </cfif>
          	<cfelse>
            	<img src="pics/buttons/reject50x50bw.png" alt="Reject" border=0>    
            </cfif>
            
          </td>
         <td>&nbsp;&nbsp;</td>
         <td>
          	<!--- delete --->
            <cfif allow_delete>
                <form action="index.cfm?curdoc=progress_report_info" method="post" onclick="return confirm('Are you sure you want to delete this report?')">
                <input type="hidden" name="pr_action" value="delete_report">
                <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                <input name="Submit" type="image" src="pics/buttons/deleteFolder50x55.png" alt="Delete Report" border=0>
                </form>
            <cfelse>
            	<img src="pics/buttons/deleteFolder50x55bw.png" alt="Delete Report"  border=0>
            </cfif>
          </td>
          
		<!--- disable print and email for rejected reports. --->
        <cfif get_report.pr_rejected_date EQ ''>
              <td width="30">&nbsp;</td>
              <td>
                <!--- print --->
                <form action="progress_report_info.cfm" method="post" target="_blank">
                <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                <input type="hidden" name="report_mode" value="print">
                <input name="Submit" type="image" src="pics/buttons/Print50x50.png" alt="Print Report" border=0>
                </form>
                <!---<A href="progress_report_info.cfm?pr_id=#FORM.pr_id#&report_mode=print" title="Print Report" target="_blank"><img src="pics/printer.gif" border=0 align="absmiddle"> Print</A>--->
              </td>
            <cfif CLIENT.usertype LTE 4>
                
                <td>
                    <!--- email --->
                    <form action="index.cfm?curdoc=forms/pr_email" method="post">
                    <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                    <input name="Submit" type="image" src="pics/buttons/email50x50.png" alt="Email Report" border=0>
                    </form>
                    <!---<a href="javascript:OpenLetter('../nsmg/reports/email_progress_report.cfm?number=#FORM.pr_id#');" title="Email Progress Report"><img src="pics/email.gif" border="0" align="absmiddle"> Email</a>--->
                </td>
            </cfif>
        </cfif>
        </tr>
      </table>
      <br /><br />
      <a href="index.cfm?curdoc=progress_reports&lastReport=#get_student.studentid####get_student.studentid#">Back to Progress Reports</a>
                
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
  
</cfif>

</cfoutput>
