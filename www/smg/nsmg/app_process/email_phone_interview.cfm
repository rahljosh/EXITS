<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Phone Interview</title>
</head>

<body>

<cfif IsDefined('url.studentid')>
	<cfset form.studentid = url.studentid>
</cfif>

<cfif NOT IsDefined('form.studentid')>
	<table width=100% cellpadding=0 cellspacing=0 border="0" height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Phone Intervie Notification</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width="100%" border="0" cellpadding=4 cellspacing=2 align="center" class="section">
		<tr><td align="center">An error has ocurred. Please go back and try again.</td></tr>
		<tr><td align="center"><input name="back" type="image" src="pics/back.gif" border="0" onClick="javascript:history.back()"></td></tr>
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
<cfelse>
	<cfset client.studentid = form.studentid>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_int_agent" datasource="MySQL">
	SELECT companyid, businessname, fax, email
	FROM smg_users 
	WHERE userid = '#get_student_info.intrep#'
</cfquery>

<cfquery name="get_current_user" datasource="MySql">
	SELECT userid, firstname, lastname, email
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<cfoutput>

<cfif NOT IsValid("email", get_int_agent.email)>
	<script language="JavaScript">
	<!-- 
	alert("The phone interview notification could not be sent because there is no email / or an invalid email address on file for #get_int_agent.businessname#.");
		location.replace("index.cfm?curdoc=app_process/apps_received&status=hold");
	-->
	</script>
	<cfabort>
</cfif>

<cfif NOT IsValid("email", get_current_user.email)>
	<script language="JavaScript">
	<!-- 
	alert("The phone interview notification could not be sent because there is no email or a valid email address on file for #get_current_user.firstname# #get_current_user.lastname#.");
		location.replace("index.cfm?curdoc=app_process/apps_received&status=hold");
	-->
	</script>
	<cfabort>
</cfif>

<CFMAIL SUBJECT="Phone Interview Notification for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)"
	TO="#get_int_agent.email#"
	bcc="#get_current_user.email#"
	FROM="""#companyshort.companyshort# Support"" <#client.support_email#>"
	Replyto="""#get_current_user.firstname# #get_current_user.lastname# - #companyshort.companyshort#"" <#get_current_user.email#>"
	failto="#client.support_email#"
	TYPE="HTML">
		
	<HTML>
	<HEAD>
	<style type="text/css">
	<!--
	.application_section_header{
		border-bottom: 1px dashed Gray;
		text-transform: uppercase;
		letter-spacing: 5px;
		width:100%;
		text-align:center;
		background;
		background: DCDCDC;
		font-size: small;
	}
	.acceptance_letter_header {
		border-bottom: 1px dashed Gray;
		text-transform: capitalize;
		letter-spacing: normal;
		width:100%;
		text-align:left;
	}
	
	-->
	</style>
	</HEAD>
	<BODY>
		
	<!--- Page Header --->
	<table width="650" border="0" bgcolor="FFFFFF"> 
		<tr>
			<td align="left"><img src="http://www.student-management.com/nsmg/pics/logos/#companyshort.companyid#.gif"  alt="" border="0" align="left"></td>
			<td align="left" valign="top">
				<b>#companyshort.companyname#</b><br>
				#companyshort.address#<br>
				#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
			</td>
			<td align="right" valign="top">
				<cfif companyshort.phone NEQ ''>Phone: #companyshort.phone#<br></cfif>
				<cfif companyshort.toll_free NEQ ''>Toll Free: #companyshort.toll_free#<br></cfif>
				<cfif companyshort.fax NEQ ''>Fax: #companyshort.fax#<br></cfif>
			</td>
		</tr>
	</table>
	
	<table width="650" border="0" bgcolor="FFFFFF">
		<hr width=100%>
	</table><br>
	
	<table width="650" border="0" bgcolor="FFFFFF" cellpadding="3">
		<tr><td colspan="2"><span class="application_section_header"><font size=+1><b><u>PHONE INTERVIEW NOTIFICATION</u></b></font></span><br><br><br></td></tr>
		<tr>
			<td width="10%">TO:</td><td>#get_int_agent.businessname#</td>
		</tr>
		<tr>
			<td>FROM:</td><td>#companyshort.companyname# &nbsp; / &nbsp; #get_current_user.firstname# #get_current_user.lastname#</td>
		</tr>
		<tr>
			<td>DATE:</td><td>#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td>
		</tr>
		<tr><td>RE: </td><td><b>#get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</b></td></tr>
	</table><br>
	
	<table width="650" border="0" bgcolor="FFFFFF" cellpadding="3">
		<tr>
			<td>
				<div align="justify">
				The above student's application has been placed on hold due to an apparent lack of English 
				proficiency. SMG needs to verify that this student will be able to successfully complete
				our program. To ensure the student's success we are requiring that the student must call
				our office for a phone interview. We hope this phone call will provide us with an accurate
				assessment of his/her English skills. If the student does not call within one week of the 
				suggested date listed below, the student's application will be rejected automatically. 
				The student whom we are requesting to call <b><i><u>MUST</u></i></b> be the person with whom
				we speak.<br>
				</div>
			</td>
		</tr>
		<tr><td>Suggested Date: &nbsp; <b>#DateFormat(get_student_info.onhold_interview_date, 'mm/dd/yyyy')#</b> &nbsp; (mm/dd/yyyy)</td></tr>
		<tr><td>Suggested Time: &nbsp; <b>#TimeFormat(get_student_info.onhold_interview_time, 'hh:mm tt')#</b> &nbsp; (New York)</td></tr>
		<cfif get_student_info.onhold_notes NEQ ''>
			<tr><td colspan="2"><b>PS: #get_student_info.onhold_notes#</b></td></tr>
		</cfif>
		<tr><td><br>Thank you,</td></tr>
		<tr><td>#get_current_user.firstname# #get_current_user.lastname#</td></tr>
		<tr><td>#companyshort.companyname#</td></tr>
	</table>
	</body>
	</html>
</CFMAIL>

<cfif NOT IsDefined('url.studentid')>
	<script language="JavaScript">
	<!-- 
	alert("This student application is on hold. \n The phone interview notification has been emailed to #get_int_agent.businessname# at #get_int_agent.email#. \n A copy has been sent to #get_current_user.email#.");
		location.replace("index.cfm?curdoc=app_process/apps_received&status=hold");
	-->
	</script>
<cfelse>
	<script language="JavaScript">
	<!-- 
	alert("The phone interview notification has been emailed to #get_int_agent.businessname# at #get_int_agent.email#. \n A copy has been sent to #get_current_user.email#.");
		location.replace("index.cfm?curdoc=app_process/app_onhold_info&studentid=#url.studentid#");
	-->
	</script>
</cfif>

</cfoutput>