<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../app.css">
	<title>CREATE AN ONLINE STUDENT APPLICATION</title>
</head>
<body>
	
<cftry>

<cfset uniqueid = createuuid()>
<cfset randid = #RandRange(111111,999999)#>

<!----set fields that arn't used for rep to fill out app to null---->
<cfif url.r is 'y'>
	<cfset form.email1 = ''>
	<cfset form.phone = ''>
</cfif>

<!--- MAIN OFFICE ---->
<cfif client.usertype EQ '8'>
	<cfif url.r is 'y'> 
		<cfset cs = 5> <!--- INTL. REP. FILLING OUT APPLICATION --->
	<cfelse>
		<cfset cs = 1>  <!--- STUDENT FILLING OUT APPLICATION --->
	</cfif>
	<cfset get_intrepid = '#client.userid#'>
	<cfset get_branchid = '0'>
<!--- BRANCH --->
<cfelseif client.usertype EQ '11'>
	<cfif url.r is 'y'>
		<cfset cs = '3'> <!--- BRANCH FILLING OUT APPLICATION --->
	<cfelse>
		<cfset cs = '1'> <!--- STUDENT FILLING OUT APPLICATION --->
	</cfif>
	<cfquery name="get_main_office" datasource="MySql">
		SELECT userid, intrepid
		FROM smg_users
		WHERE userid = '#client.userid#'
	</cfquery>
	<cfset get_intrepid = '#get_main_office.intrepid#'>
	<cfset get_branchid = '#client.userid#'>		
</cfif>

<!--- CHECK DATA --->
<cfif form.firstname EQ '' OR form.familylastname EQ ''>
	<br><br>
	<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr>
		<td width="100%">
			<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
				<tr valign=middle height=24>
					<td height=24 width=13 background="../../pics/header_leftcap.gif">&nbsp;</td>
					<td width=26 background="../../pics/header_background.gif"><img src="../../pics/news.gif"></td>
					<td background="../../pics/header_background.gif"><h2>Applicant Information</td>
					<td background="../../pics/header_background.gif" width=16></td>
					<td width=17 background="../../pics/header_rightcap.gif">&nbsp;</td>
				</tr>
			</table>
			<div class="section"><br>
			<cfoutput>
			<table width=670 cellpadding=0 cellspacing=0 border=0 align="center">
				<tr><td><h2>Sorry, this student account could not be created.</h2><br></td></tr>
				<tr><td>
					<b>You must fill out both student's first name and last name in order to create an account.</b><br><br>
					<div align="center"><input name="back" type="image" src="../../pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br><br>
				</td></tr>
			</table>
			</cfoutput>
			</div>
			<!----footer of table---->
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="../../pics/footer_leftcap.gif" ></td>
					<td width=100% background="../../pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="../../pics/footer_rightcap.gif"></td>
				</tr>
			</table>		
		</td>
	</tr>
	</table>
	<cfabort>
</cfif>	

<!--- check e-mail address ---->
<cfif url.r NEQ 'y'>
	<cfquery name="check_username" datasource="MySql">
		SELECT email
		FROM smg_students
		WHERE email = '#form.email1#'
	</cfquery>
	<cfif check_username.recordcount NEQ '0'>
		<br><br>
		<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
		<tr>
			<td width="100%">
				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
					<tr valign=middle height=24>
						<td height=24 width=13 background="../../pics/header_leftcap.gif">&nbsp;</td>
						<td width=26 background="../../pics/header_background.gif"><img src="../../pics/news.gif"></td>
						<td background="../../pics/header_background.gif"><h2>Applicant Information</td>
						<td background="../../pics/header_background.gif" width=16></td>
						<td width=17 background="../../pics/header_rightcap.gif">&nbsp;</td>
					</tr>
				</table>
				<div class="section"><br>
				<cfoutput>
				<table width=670 cellpadding=0 cellspacing=0 border=0 align="center">
					<tr><td><h2>Sorry, this student account could not be created.</h2><br></td></tr>
					<tr><td>
						<b>Student's name: #form.firstname# #form.familylastname#</b><br><br>
						The email address <b>#form.email1#</b> has been in use by another student account.<br><br>
						You <b>must</b> enter a different e-mail address in order to create an account for your student.<br><br>
						Please click on the back button below, change the e-mail address and try again.<br><br><br><br>
						<div align="center"><input name="back" type="image" src="../../pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br><br>
					</td></tr>
				</table>
				</cfoutput>
				</div>
				<!----footer of table---->
				<table width=100% cellpadding=0 cellspacing=0 border=0>
					<tr valign=bottom >
						<td width=9 valign="top" height=12><img src="../../pics/footer_leftcap.gif" ></td>
						<td width=100% background="../../pics/header_background_footer.gif"></td>
						<td width=9 valign="top"><img src="../../pics/footer_rightcap.gif"></td>
					</tr>
				</table>		
			</td>
		</tr>
		</table>
		<cfabort>
	</cfif>
</cfif>
<cfset expiration_date = '#DateFormat(DateAdd('d','#extdeadline#','#form.expiration_date#'), 'yyyy-mm-dd')# #TimeFormat(DateAdd('d','#extdeadline#','#form.expiration_date#'), 'HH:mm:ss')#'>

<!----Insert basic student info into student table---->
<cfquery name="start_student" datasource="MySQL">
	INSERT INTO smg_students 
		(uniqueid, familylastname, firstname, middlename, email, phone, app_indicated_program, app_additional_program, randid, intrep, branchid,  
		app_sent_student, app_current_status, application_expires)
	VALUES ('#uniqueid#','#form.familylastname#', '#form.firstname#', '#form.middlename#', '#form.email1#', '#form.phone#',
			'#form.program#', '#form.add_program#', '#randid#', '#get_intrepid#', '#get_branchid#', #CreateODBCDate(now())#, '#cs#', '#expiration_date#')
</cfquery>

<!----Retrieve the students ID number---->
<cfquery name="get_student_id" datasource="MySQL">
	SELECT studentid, branchid, intrep
	FROM smg_students 
	WHERE uniqueid = '#uniqueid#'
</cfquery>

<cfif url.r is 'n'>
	<!----set the app status to just begnining---->
	<cfquery name="start_app_status" datasource="MySQL">
		INSERT INTO smg_student_app_status (studentid)
		VALUES ('#get_student_id.studentid#')
	</cfquery>
</cfif>

<!----if rep is filling out, update status to reps status---->
<cfif url.r is 'y'>
	<cfif client.usertype EQ '8'>
		<cfquery name="start_app_status" datasource="MySQL">
			INSERT INTO smg_student_app_status 
				(studentid, status, date, reason)
			VALUES 
				('#get_student_id.studentid#', '5', #CreateODBCDate(now())#, 'Intl. Rep. filling out application')
		</cfquery>
	<cfelseif client.usertype EQ '11'>
		<cfquery name="start_app_status" datasource="MySQL">
			INSERT INTO smg_student_app_status 
				(studentid, status, date, reason)
			VALUES 
				('#get_student_id.studentid#', '3', #CreateODBCDate(now())#, 'Branch filling out application')
		</cfquery>
	</cfif>
	<cfset client.studentid = #get_student_id.studentid#>
<cfelse>
	<cfquery name="agent_info" datasource="MySQL">
		SELECT businessname, phone,email,studentcontactemail
		FROM smg_users 
		WHERE userid = 
		<cfif get_student_id.branchid eq 0>
		#get_student_id.intrep#
		<cfelse>
		#get_student_id.branchid#
		</cfif>
		
	</cfquery>

	<cfoutput>
	<cfmail to="#Form.email1#" from="support@student-management.com" Subject="SMG Exchange Application" type="html">
	<style type="text/css">
	.thin-border{ border: 1px solid ##000000;}
	</style>
	<table width=550 class="thin-border" cellspacing="0" cellpadding=0>
		<tr>
			<td bgcolor=b5d66e><img src="http://www.student-management.com/nsmg/student_app/pics/top-email.gif" width=550 heignt=75></td>
		</tr>
		<tr>
			<td>
			#form.firstname#-
			<br><br>
			An account has been created for you on the Student Management Groups EXITS system.  
			Using EXITS you will be able to apply for your exchange program and view the status of your application as it is processed. 
			<br><br>
			You can start your application at any time and do not need to complete it all at once.
			You can save your work at any time and return to the application when convenient.  
			The first time you access EXITS you will create a username and password that will allow you to work 
			on your application at any time. 
			<br><br>
			Your application will remain active until <strong>#expiration_date#</strong>.
			You will need to contact #agent_info.businessname# to re-activate your application if your application expires.
			<br><br>
			Please provide the information requested by the application and press the submit button when it is complete.
			Once submitted, the application can no longer be edited.  
			The completed application will be reviewed by your international representative and sent to the SMG Headquarters in New York.
			The status of your application can be viewed by logging into the Exits Login Portal. 
			After your placement has been made, you will also be able to access your host family profile.
			<br><br>
			You are taking the first step in what will become one of the greatest experiences in your life!
			<br><br>
			Click the link below to start your application process.  
			<br><br>
			<a href="http://www.student-management.com/nsmg/student_app/?s=#uniqueid#">http://www.student-management.com/nsmg/student_app/?s=#uniqueid#</a>
			<br><br>
			You will need the following information to verify your account:<br>
			*email address<br>
			*this ID: #randid#
			<br><br>
			If you have any questions about the application or the information you need to submit, please contact your international representative:
			<br><br>
			#agent_info.businessname#<br>
			#agent_info.phone#<br>
			#agent_info.studentcontactemail#<br><br>
			
			For technical issues with EXITS, submit questions to the support staff via the EXITS system.
			</td>
		</tr>
		<tr>
			<td align="center">__________________________________________</td>
		</tr>
		<tr>
			<Td align="center">
			<font color="##CCCCCC"><font size=-1>Please add support@student-management.com to your whitelist to ensure it isn't marked as spam. SMG will
			not sell your address or use it for unsolicited emails.  This email was sent on behalf of Student Management Group from an International Agent, listed above.  If you received this email as an unsolicited contact 
			about SMG or SMG subsidiaries, please contact support@student-management.com  </font></font>
			</Td>
		</tr>
	</cfmail>
	</cfoutput>
</cfif>

<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully created this account for #form.firstname# #form.familylastname#. Thank You.");
<cfif url.r is 'y'>
	location.replace("../rep_start_app.cfm");
<cfelse>
	location.replace("../../index.cfm?curdoc=initial_welcome");
</cfif>
-->
</script>
</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>