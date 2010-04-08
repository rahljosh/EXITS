<style type="text/css">
body {font:Arial, Helvetica, sans-serif;}
.thin-border{ border: 1px solid #000000;
			  font:Arial, Helvetica, sans-serif;}
.dashed-border {border: 1px dashed #FF9933;}
</style>

<cfquery name="get_name" datasource="caseusa">
	select email, firstname, familylastname, password, app_current_status, application_expires
	from smg_students
	where studentid = '#client.studentid#'
</cfquery>

<!--- DO NOT UPDATE STATUS IF STATUS IS BIGGER THAN 1 --->
<cfif get_name.app_current_status LTE 1>
	<cfquery name="assign_student_pass" datasource="caseusa">
		update smg_students
		set password = '#form.password1#',
		app_current_status = 2
		WHERE studentid = '#client.studentid#'
	</cfquery>
	
	<cfquery name="update_status" datasource="caseusa">
		INSERT INTO smg_student_app_status (status, studentid)
				values ('2', '#client.studentid#')
	</cfquery>
</cfif>

<cfoutput query="get_name">
<cfmail to='#get_name.email#' from='support@student-management.com' subject='Your Account Information' type="html">
<style type="text/css">

.thin-border{ border: 1px solid ##000000;}

    </style>
<table width=550 class="thin-border" >
	<tr>
		<td bgcolor=b5d66e><img src="http://www.student-management.com/nsmg/student_app/pics/top-email.gif"></td>
	</tr>
	<tr>
		<td>
		#firstname# #familylastname#-
		<br><br>
		Your account has been succesfully created. Below is your login information for your records.
		<br><br>
		Login ID (User ID) : #email#<br>
		Password: #password1#
		<br><br>
		You can log in and out of the EXITS Online Application System at any time using this login information.
		To login to the EXITS Online Application, go to the EXITS Login Portal at www.student-management.com
		<br><br>
		Please remember that if your application will expire on #DateFormat(application_expires, 'mmm dd, yyyy')# at #TimeFormat(application_expires, 'h:mm tt')# MST.  
		<br><br>
		Sincerely-<br>
		Student Management Group / EXITS Support
		</td>
	</tr>
</table>
</cfmail>

<table align="center" width=550 class=thin-border>
			<tr>
				<td colspan=2><img src="pics/top-email.gif"></td>
			</tr>
			<tr>
				<td align="center" colspan=2><h1>Account Verification</h1></td>
			</tr>
			<tr>
				<td colspan=2>
				<h2>Your account has been activated!</h2>
				You will receive an email shortly that has your account information in it for future reference. <br><Br>
				Here are a few things to keep in mind:
				<ul>
				<li>Your application will expire on #DateFormat(application_expires, 'mmm dd, yyyy')# at #TimeFormat(application_expires, 'h:mm tt')# MST
				<li>You can check on the current status of your application at any time by logging into EXITS through the EXITS Login Portal at <a href="http://www.student-management.com">www.student-management.com</a>
				<li>If you forget your password, you can click on the "Forgot your login?" link on the EXITS Login Portal to retrieve your account information.
				<li>If you are having problems with the EXITS system, please contact support via the Support link on the student application.
				
				<li>If you are having problems with the application, or do not understand what the applicatiion is asking for, please contact your international representative.  Your representatives contact information is located at the 
				top of your application.
				</ul>
				Click the Start Application Process button if you are ready to start your application.<br><br><div align="center">
				<form method=post action="../loginprocess.cfm"><input type="hidden" value=#email# name="username"><input type="hidden" name="password" value="#password1#"><input type="image" src="pics/start-application.gif" border=0 alt="Start Application"></div></form>
				</td>
			</tr>
</table>
</cfoutput>