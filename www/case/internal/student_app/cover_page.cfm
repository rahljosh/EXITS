<cftry>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>SMG - EXITS Online Application</title>
</head>
<body onLoad="print()">

<cfif isDefined('url.unqid')>
	<!----Get student id  for office folks linking into the student app---->
	<cfquery name="get_student_id" datasource="caseusa">
	select studentid from smg_students
	where uniqueid = '#url.unqid#'
	</cfquery>
	<cfset client.studentid = #get_student_id.studentid#>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_intl_rep" datasource="caseusa">
	SELECT businessname
	FROM smg_users
	WHERE userid = <cfqueryparam value="#get_student_info.intrep#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="app_programs" datasource="caseusa">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_programid = '#get_student_info.app_indicated_program#'
</cfquery>
 
<cfquery name="app_other_programs" datasource="caseusa">
	SELECT app_programid, app_program 
	FROM smg_student_app_programs
	WHERE app_programid = '#get_student_info.app_additional_program#'
</cfquery> 

<cfquery name="check_guarantee" datasource="caseusa">
	SELECT app_region_guarantee
	FROM smg_students
	WHERE studentid = '#get_student_info.studentid#'
</cfquery>

<cfquery name="states_requested" datasource="caseusa">
	SELECT state1, sta1.statename as statename1, state2, sta2.statename as statename2, state3, sta3.statename as statename3
	FROM smg_student_app_state_requested 
	LEFT JOIN smg_states sta1 ON sta1.id = state1
	LEFT JOIN smg_states sta2 ON sta2.id = state2
	LEFT JOIN smg_states sta3 ON sta3.id = state3
	WHERE studentid = '#get_student_info.studentid#'
</cfquery>

<cfquery name="private_school" datasource="caseusa">
	SELECT privateschoolid, privateschoolprice, type
	FROM smg_private_schools
	WHERE privateschoolid = '#get_student_info.privateschool#'
</cfquery>

<cfquery name="get_status_history" datasource="caseusa">
	SELECT status, reason, date, u.firstname, u.lastname
	FROM smg_student_app_status sta
	INNER JOIN smg_students s ON sta.studentid = s.studentid
	LEFT JOIN smg_users u ON sta.approvedby = u.userid
	WHERE s.studentid = '#get_student_info.studentid#'
		AND sta.status = '9'
</cfquery>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>CASE - EXITS Online Application</h2></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfoutput query="get_student_info">

<div class="section"><br>

<table width="660" border=0 cellpadding=4 cellspacing=2 align="center">	
	<tr><td colspan="2" align="center"><img src="pics/top-email.gif"></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td width="100">Date Received: </td><td width="560"> <b>#DateFormat(app_sent_student, 'mm/dd/yyyy')#</b></td></tr> 
	<tr><td width="100">Student's Name: </td><td width="560"> <b>#firstname# #familylastname# (###studentid#)</b></td></tr> 
	<tr><td>International Agent: </td><td><b>#get_intl_rep.businessname#</b></td></tr>
	<tr><td>Program Information: </td><td><b>#app_programs.app_program#</b></td></tr>
	<tr><td>Additional Program: </td><td><b>#app_other_programs.app_program#</b></td></tr>
	<tr><td valign="top">J-1 Private School: </td>
		<td><b>
			<cfif private_school.recordcount>
				Tuition Range: #private_school.privateschoolprice#
			<cfelse>
				n/a	
			</cfif>
		</td>
	</tr>	
	<tr><td valign="top">Region Guarantee: </td>
		<td><b>
			<cfif check_guarantee.app_region_guarantee EQ '0'> n/a 
			<cfelseif check_guarantee.app_region_guarantee EQ '1'>Region 1 - East
			<cfelseif check_guarantee.app_region_guarantee EQ '2'>Region 2 - South
			<cfelseif check_guarantee.app_region_guarantee EQ '3'>Region 3 - Central
			<cfelseif check_guarantee.app_region_guarantee EQ '4'>Region 4 - Rocky Mountain
			<cfelseif check_guarantee.app_region_guarantee EQ '5'>Region 5 - West
			</cfif></b>
		</td>
	</tr>
	<tr><td valign="top">State Guarantee: </td>
		<td><b>
			<cfif states_requested.state1 EQ '0' OR states_requested.recordcount EQ '0'>
				n/a
			<cfelse>
				1st Choice: #states_requested.statename1# <br>
				2nd Choice: #states_requested.statename2#<br>
				3rd Choice: #states_requested.statename3#<br>
			</cfif></b>
		</td>
	</tr>
	<tr><td colspan="2">Comments from #get_intl_rep.businessname#.</td></tr>
	<tr><td colspan="2"><div align="justify"><cfif app_intl_comments EQ ''>n/a<cfelse>#app_intl_comments#</cfif></div></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	
	<!--- APP PREVIOUSLY DENIED --->
	<cfif get_status_history.recordcount>
	<tr>
	  <td colspan="2"><b>This application has been denied by CASE. Please see information below.</b></td>
	</tr>
	<cfloop query="get_status_history">
	<tr><td colspan="2">Application denied on #DateFormat(date, 'mm/dd/yyyy')# by #firstname# #lastname#. Reason: #reason#.</td></tr>
	</cfloop>
	<tr><td colspan="2">&nbsp;</td></tr>
	</cfif>
	<!--- APP PREVIOUSLY DENIED --->
	
	<tr><td colspan="2"><b>Please read carefully the instructions below:</b></td></tr>
	<tr><td colspan="2"><div align="justify">
			This student's application has already been submitted through EXITS, so 
			you will not need to input the application as a new application.  You 
			must first review the application according to your normal application 
			reviewing procedures; creating and filing the application review 
			checklist accordingly.  If the application is accepted, please simply 
			fill out an Online Student Application Assignment Sheet (Student's name 
			and company) and give it to Stacy Brewer. Stacy will then assign this 
			student to your company in EXITS.<br>
			<br>
			
			As soon as the student is assigned to the requested company, the student's
			record will show up on your unplaced students list.  Once the student's 
			application appears on your unplaced students list, you must complete 
			the information listed in the Student Information Screen since this is 
			only recorded after the student's application has been assigned to your 
			company.  This includes assigning a program, a region, a region 
			guarantee or a state guarantee.<br><br>
			
			Please also remember to send out acceptance letters and to fill out the 
			missing documents page as you do for all paper applications.<br><br>
			
			Regional Managers will have access to the complete online student 
			application through the Student's Info page of EXITS.<br><br>
			
			Sincerely,<br>
			EXITS<br><br>
			</div>
		</td>
	</tr>
</table>

</cfoutput>

</div>

<!--- FOOTER OF TABLE --->
<cfinclude template="footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>