<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="reports.css" type="text/css">
<title>Email Progress Report</title>
</head>

<body>

<cfif Isdefined('url.number')>
	<cfset form.number = '#url.number#'>
<cfelseif NOT IsDefined('form.number')>
	<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
		<tr><td bgcolor="ACB9CD">An error has ocurred. Please try again.</td></tr>
		<tr><td align="center" bgcolor="ACB9CD"><input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfabort>
</cfif>

<Cfquery name="progress_report" datasource="MySQL">
	SELECT *
	FROM smg_prquestion_details
	WHERE report_number = <cfqueryparam value="#form.number#" cfsqltype="cf_sql_integer">
</Cfquery>

<cfquery name="get_student_info" datasource="MySQL">
	SELECT s.studentid, s.firstname, s.familylastname, s.arearepid, s.hostid, s.companyid, s.regionassigned,
		p.programid, p.programname,
		intrep.businessname, intrep.email, intrep.userid as intrepid,
		h.fatherfirstname, h.motherfirstname, h.familylastname as hostlastname
	FROM smg_students s
	LEFT JOIN smg_programs p ON p.programid = s.programid
	LEFT JOIN smg_users intrep ON intrep.userid = s.intrep
	LEFT JOIN smg_hosts h ON h.hostid = s.hostid
	WHERE s.studentid = '#progress_report.stuid#'
</cfquery>

<cfquery name="tracking_info" datasource="mysql">
	SELECT * FROM smg_document_tracking
	WHERE report_number = <cfqueryparam value="#form.number#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="contact_dates" datasource="MySQL">
	SELECT *
	from smg_prdates WHERE 
	report_number = <cfqueryparam value="#form.number#" cfsqltype="cf_sql_integer">
</cfquery>


<!-----Company Information----->
<Cfquery name="companyshort" datasource="MySQL">
	SELECT *
	FROM smg_companies
	WHERE companyid = '#get_student_info.companyid#'
</Cfquery>

<cfquery name="get_current_user" datasource="MySql">
	SELECT email, firstname, lastname
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<!-----Regions----->


<!--- set progress report month --->
<cfif tracking_info.month_of_report EQ 10>
	<cfset prmonth = 'October'> 
<cfelseif tracking_info.month_of_report EQ 12>
	<cfset prmonth = 'December'> 
<cfelseif tracking_info.month_of_report EQ 2>
	<cfset prmonth = 'February'> 
<cfelseif tracking_info.month_of_report EQ 4>
	<cfset prmonth = 'April'> 
<cfelseif tracking_info.month_of_report EQ 6>
	<cfset prmonth = 'June'> 
<cfelseif tracking_info.month_of_report EQ 8>
	<cfset prmonth = 'August'> 
<cfelse>
	<cfset prmonth = ''>
</cfif>

<cfoutput>

<!--- FORM EMAIL --->
<cfif NOT IsDefined('form.send')>
	<cfform name="email" action="email_progress_report.cfm" method="post" onsubmit="return confirm ('Are you sure?')">
	<cfinput type="hidden" name="number" value="#form.number#">
	<cfinput type="hidden" name="send">
	<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0Email #prmonth# " cellpadding="3" cellspacing="1">
		<tr><td align="center"><span class="application_section_header">Progress Report</span></td></tr>
		<tr><td align="center">Progress Report for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</td></tr>
		<tr>
			<td>Please select at least one recipient you would like to email the report to: <br>
				<cfinput type="checkbox" name="self">#get_current_user.firstname# #get_current_user.lastname# <br>
				<cfinput type="checkbox" name="intrep">#get_student_info.businessname# <br>
			</td>
		</tr>
		<tr><td align="center" bgcolor="ACB9CD"><cfinput type="image" name="image" src="../pics/sendemail.gif" value="send email"></td></tr>
	</table>
	</cfform>

<!--- SEND E-MAIL --->
<cfelse>
	<CFSET ImgScrPath = "http://www.student-management.com">
	
	<cfif IsDefined('form.self') AND NOT IsDefined('form.intrep')>
		<cfset emails = '#get_current_user.email#'>
	<cfelseif IsDefined('form.intrep') AND NOT IsDefined('form.self')>
		<cfset emails = '#get_student_info.email#'>
	<cfelseif IsDefined('form.self') AND IsDefined('form.intrep')>
		<cfset emails = '#get_student_info.email#'&'; '&'#get_current_user.email#'>
	<cfelse>
		<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
			<tr><td bgcolor="ACB9CD">You must select at least one recipient. Please go back and try again.</td></tr>
			<tr><td align="center" bgcolor="ACB9CD"><input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()"></td></tr>
		</table>
		<cfabort>
	</cfif>
	<cfquery name="current_user_email" datasource="mysql">
	select email
	from smg_users
	where userid = #client.userid#
	</cfquery>

	<CFMAIL SUBJECT="#prmonth# Progress Report for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)"
	TO="#emails#" failto="#get_current_user.email#" FROM="""#companyshort.companyname#"" <#current_user_email.email#>" TYPE="HTML">
	<HTML>
	<HEAD></HEAD>
	<BODY>

	<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
		<tr><td align="right"><font size="-1">International Agent: &nbsp; <u><b>#get_student_info.businessname# (###get_student_info.intrepid#)</font></b></u></td></tr>
	</table>
	
	<table cellspacing="2" cellpadding="2" border="0" width="650" align="center" class="box">
		<tr>
			<td><img src="#ImgScrPath#/nsmg/pics/logos/#companyshort.companyid#.gif" alt="" border="0" align="left"></td>
			 <td  align="left">
				<font size="+3">Student Progress Report for #prmonth# <br></font><br>
				<font size="+1">Student Name: #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#) Program: #get_student_info.programname#</font>
			</td>
		</tr>
	</table>
	
	<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
		<hr>
	</table>
	
	<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
		<Tr>
			<td>Host Family: </td>
			<td><cfif get_student_info.fatherfirstname is not ''>#get_student_info.fatherfirstname#</cfif>
				<cfif get_student_info.motherfirstname is not '' and get_student_info.fatherfirstname is not ''>and #get_student_info.motherfirstname#</cfif> 
				<cfif get_student_info.motherfirstname is not '' and get_student_info.fatherfirstname is ''>#get_student_info.motherfirstname#</cfif> 
				#get_student_info.hostlastname# (###get_student_info.hostid#)
			</td>
		</Tr>

	</table><br>
	

	<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
	<Cfloop query="progress_Report">
		<cfquery name="questions" datasource="MySQL">
			SELECT * from smg_prquestions
			WHERE id = '#question_number#'
			ORDER BY id
		</cfquery>
		<TR>
			<TD width="75%"><div align="justify">#questions.text#</div></td>
			<td width="10%"></td>
			<td width="15%"><cfif progress_Report.yn is 'yes'>Yes</cfif><cfif progress_Report.yn is 'no'>No</cfif></td>
		</tr>
		<tr>
			<td colspan=3>Comments:</td>
		</tr>
			<tr>
			<td colspan=3><div align="justify">#progress_Report.response#</div></td>
		</tr>
		<tr>
			<td colspan=3 align="Center"><hr width=80%></td>
		</tr>
	</cfloop>
	</table><Br>

	</body>
	</html>
	</CFMAIL>

	<table width="650" align="center" class="nav_bar" bordercolor="C0C0C0" cellpadding="3" cellspacing="1">
		<tr><td align="center"><span class="application_section_header">#prmonth# Progress Report</span></td></tr>
		<tr><td align="center"><h2><u>Student : &nbsp; #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</u></h2></td></tr>
		<cfif IsDefined('form.self')>
		<tr align="center" bgcolor="ACB9CD"><td><span class="get_Attention">The Progress Report has been sent to #get_current_user.firstname# #get_current_user.lastname#</span></td></tr>
		<cfelse>
		<tr align="center" bgcolor="ACB9CD"><td><span class="get_Attention">The Progress Report has been sent to #get_student_info.businessname# at #get_student_info.email#.</span></td></tr>
		</cfif>
		<tr><td align="center" bgcolor="ACB9CD">
				<input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()">  &nbsp;  &nbsp;  &nbsp;  &nbsp;
				<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
		</td></tr>
	</table>
</cfif>	

</cfoutput>
</body>
</html>