<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Test External Report	</title>
	<link rel="stylesheet" href="report.css" type="text/css">
<style type="text/css">
  .rdholder {
	height:auto;
	width:800px;
	margin-bottom: 5px;
	margin-right: auto;
	margin-left: auto;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	line-height: 18px;
 } 


 .rdholder .rdbox {
	border-left:1px solid #c6c6c6;
	border-right:1px solid #c6c6c6;
	padding:10px 15px;
	margin:0;
	display: block;
	min-height: 137px;
 } 

 .rdtop {
	width:auto;
	height:30px;
	/* -webkit for Safari and Google Chrome */

  -webkit-border-top-left-radius:15px;
	-webkit-border-top-right-radius:15px;
	/* -moz for Firefox, Flock and SeaMonkey  */

  -moz-border-radius-topright:15px;
	-moz-border-radius-topleft:15px;
	border-top-right-radius:15px;
	border-top-left-radius:15px;
	background-color: #FFF;
	color: #006699;
	background-image: linear-gradient(top, rgb(235,235,235) 22%, rgb(255,255,255) 64%);
	background-image: -o-linear-gradient(top, rgb(235,235,235) 22%, rgb(255,255,255) 64%);
	background-image: -moz-linear-gradient(top, rgb(235,235,235) 22%, rgb(255,255,255) 64%);
	background-image: -webkit-linear-gradient(top, rgb(235,235,235) 22%, rgb(255,255,255) 64%);
	background-image: -ms-linear-gradient(top, rgb(235,235,235) 22%, rgb(255,255,255) 64%);
	background-image: -webkit-gradient(
	linear,
	left top,
	left bottom,
	color-stop(0.22, rgb(235,235,235)),
	color-stop(0.64, rgb(255,255,255))
);
	border: 1px solid #c6c6c6;
 }
 

 .rdtop {
	 behavior: url(/css/border-radius.htc);
    border-radius-topright: 15px;
	border-radius-topleft: 15px;
	  }
 .rdtop .rdtitle {
	line-height:40px;
	font-family:Arial, Geneva, sans-serif;
	font-size:22px;
	padding-top: 10px;
	padding-right: 10px;
	padding-bottom: 0px;
	padding-left: 10px;
	color: #135EAB;
	text-align: center;
	margin-top: 0;
	margin-right: auto;
	margin-bottom: 0;
	margin-left: auto;
 }

 .rdbottom {

  width:auto;
  height:10px;
  border-bottom: 1px solid #c6c6c6;
  border-left:1px solid #c6c6c6;
  border-right:1px solid #c6c6c6;
   /* -webkit for Safari and Google Chrome */

  -webkit-border-bottom-left-radius:15px;
  -webkit-border-bottom-right-radius:15px;


 /* -moz for Firefox, Flock and SeaMonkey  */

  -moz-border-radius-bottomright:15x;
  -moz-border-radius-bottomleft:15px;
  border-bottom-right-radius:15px;
border-bottom-left-radius:15px; 
 
 }


 .rdbottom {
	 behavior: url(/css/border-radius.htc);
    border-radius-bottomright: 15px;
	border-radius-bottomleft: 15px;
	  }

    .rdholder .white {
	font-size: 14px;
	color: #FFF;
	padding-top: 5px;
	padding-bottom: 5px;
}
</style>
</style>
</head>

<body>
  <div class="rdholder"> 
				<div class="rdtop"><span class="rdtitle">Progress Report</span>
   </div> <!-- end top --> 
    
             <div class="rdbox">
            
<cfparam name=url.report default="">

<cfset url.report = 'C2C96BA8-5056-A020-CCF5046C70B0A3F'>

<cfquery name="get_report" datasource="mysql">
    select *
    from progress_reports
    where pr_uniqueid  = <cfqueryparam cfsqltype="varchar" value="#url.report#">
</cfquery>



<cfif url.report is '' OR len(url.report) neq 35 OR get_report.recordcount eq 0>
<div align="center">
<h2>Ooops!  The report ID provided does not  appear to be valid.   </h2>
</div>
</div>
  <div class="rdbottom"></div> <!-- end bottom --> 
    
<!--rdholder--->  </div>
<cfabort>
</cfif>

<cfset FORM.PR_ID = #get_report.pr_id#>

<cfset CLIENT.pr_rmonth = get_report.pr_month_of_report>


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

<cfset questionlist = ''>

<cfoutput>
<table>
<td width="200" rowspan=20><div style="width: 175px; align-text: center;"><img src="../nsmg/pics/logos/#get_student.companyid#.gif" align="left"></div></td>
 <tr>
    <th colspan="2" bgcolor="##135EAB" class="white">Program</th>
  </tr>
  <tr>
    <th width="209" align="right">Program Name:</th>
    <td width="343">#get_program.programname# (#get_program.programid#)</td>
  </tr>
  <tr>
    <th align="right">Placing Representative:</th>
    <td>#get_place_rep.firstname# #get_place_rep.lastname# (#get_place_rep.userid#)</td>
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

</table>
<br/>
<br/>
<table cellpadding="2" cellspacing="0" width="90%" align="center">
  <tr>
  
    <td bgcolor="##135EAB" colspan="2">
        <table cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <th class="white">Contact listed on last months report<font size=-1></font></th>
		
          </tr>
        </table>
    </td>
  </tr>


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

     <tr> <td bgcolor="##135EAB" colspan="2">
        <table cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <th class="white"> Contact for this Report</th>
		
          </tr>
        </table>
      </tr>
   
  <tr>
    <td colspan="2"><font size=-2>Each report must show monthly contact, including at least one bi-monthly In Person contact for both Host Family and Student.</font></td>
  </tr>

  <tr align="center">
    <td colspan="2">

	<cfif get_dates.recordCount EQ 0>
    	There are no contact dates yet.
    <cfelse>
        <table width="100%" cellpadding="3" cellspacing="0">
            <tr align="left">
                <th>Date</th>
                <th>Type</th>
                <th>Contact</th>
                <th>Comments</th>
            </tr>
        <cfloop query="get_dates">
        
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
    
    </td>
  </tr>
</table>
<br/>

<br/>
<table cellpadding="2" cellspacing="0"  width="90%" align="center">
  <tr>
    <th colspan="2" bgcolor="##135EAB" class="white">Questions</th>
  </tr>
  <tr align="center">
    <td colspan="2">

        <table cellpadding="2" width="100%">
        
        <cfloop query="get_questions">
        <cfset questionList = #ListAppend(questionList, #x_pr_question_id#)#>
          <tr>
           
            <th align="left">#get_questions.text#</th>
            
          </tr>
          <tr>
           
            <td colspan=2>
           
          
            #replaceList(x_pr_question_response, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
          
            </td>
          </tr>
         
		  <cfif currentRow NEQ RecordCount>
              <tr>
                <td colspan="2" height="25"><hr align="center" noshade="noshade" size="1" width="100%" color="##CCCCCC" /></td>
              </tr>
          </cfif>
        </cfloop>
      
        </table>

    </td>
  </tr>
</table>
</cfoutput>
</div>
  <div class="rdbottom"></div> <!-- end bottom --> 
    
<!--rdholder--->  </div>
</body>
</html>