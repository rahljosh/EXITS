<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Email Update</title>
</head>

<body>

<cfoutput>

<cfif NOT IsDefined('form.studentid') OR form.email_address EQ ''>
	<cfinclude template="error_message.cfm">
</cfif>

<cftry>

	<cfquery name="get_student_info" datasource="caseusa">
		SELECT s.firstname, s.familylastname, s.studentid, s.uniqueid,
			u.businessname
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery name="get_current_user" datasource="caseusa">
		SELECT userid, firstname, lastname, email
		FROM smg_users
		WHERE userid = <cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<CFMAIL SUBJECT="CASE EXITS Online Application for #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)"
	TO="#form.email_address#"
	FROM="support@case-usa.org"
	TYPE="HTML">
	
	<HTML>
	<HEAD>
	<style type="text/css">
		.thin-border{ border: 1px solid ##000000;}
	</style>
	</HEAD>
	<BODY>	
	
<table width=550 class="thin-border" cellspacing="3" cellpadding=0>
	<tr><td bgcolor=b5d66e><img src="http://www.case-usa.org/internal/pics/top-email.gif" width=550 height=75></td></tr>
	<tr><td><br>Dear Friend,<br><br></td></tr>
	<tr><td>A new EXITS online student has been sent to you from #get_current_user.firstname# #get_current_user.lastname#.<br><br></td></tr>	
	<tr><td>
		<b>Student: #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</b><br><br>
		
		Additional Comments:<br>
		<cfif form.comments EQ ''>n/a<cfelse>#form.comments#</cfif><br><br>
		Please click
		<a href="http://www.case-usa.org/exits_app.cfm?unqid=#get_student_info.uniqueid#">here</a>
		to see the student's online application.<br><br>

		Please keep in mind that this application might take a few minutes to load completely. The loading time will depend on your internet connection.<br><br>	
	</td></tr>	
	<tr><td>
		 Sincerely,<br>
		 Cultural Academic Student Exchange<br><br>
	</td></tr>
	</table>
	
	
	</body>
	</html>
	</CFMAIL>
	
	<script language="JavaScript">
	<!-- 
		alert("You have successfully sent this application. This window will be closed automatically. Thank You.");
		setTimeout(window.close(), 5)
		//window.close();
	-->
	</script>

	<cfcatch type="any">
		<script language="JavaScript">
		<!-- 
		alert("Sorry, an error has ocurred and the student application could not be sent. Please verify the e-mail address and try again. Thank You.");
			location.replace("email_form.cfm?unqid=#get_student_info.uniqueid#");
		-->
		</script>
	</cfcatch>

</cftry>

</cfoutput>

</body>
</html>