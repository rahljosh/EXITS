	
		<cfquery name="get_student_info" datasource="MySql">
		SELECT s.firstname, s.familylastname, s.studentid, s.uniqueid,
			u.businessname
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		WHERE s.uniqueid = "FA6A5B4A-E75B-4BBA-757A8FBEF1B9EAAB"
		<!----
		<cfqueryparam value="#form.uniqueid#" cfsqltype="cf_sql_integer">
		---->
	</cfquery>
	<!----
	<cfquery name="get_current_user" datasource="MySql">
		SELECT userid, firstname, lastname, email
		FROM smg_users
		WHERE userid = <cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer">
	</cfquery>
	---->
<cfmail to="josh@pokytrails.com" from="josh.rahl@exitgroup.org" subject="#get_Student_info.firstname# #get_student_info.familylastname# Application Received" type="html">
	<HTML>
	<HEAD>
	<style type="text/css">
		.thin-border{ border: 1px solid ##000000;}
	</style>
	</HEAD>
	<BODY>	
<table width=550 class="thin-border" cellspacing="3" cellpadding=0>
	<tr><td bgcolor=b5d66e><img src="http://#CLIENT.exits_url#/nsmg/student_app/pics/top-email2.gif" width=550 height=75></td></tr>
	<tr><td><br>#DateFormat(now(), 'mmmm d, yyyy')#<br><br></td></tr>
	<tr><td>The application for #get_Student_info.firstname# #get_student_info.familylastname# has been received.<br><br></td></tr>	
	<tr><td>
Please accept this notice as verification that that application for #get_Student_info.firstname# #get_student_info.familylastname# has been received in the Babylon offices of Student Management Group.  Our admissions staff will be reviewing the application for acceptance into the program as quickly as possible.
<br><br>
Please undertand that this notice is only to verify that the application has been received in the Babylon offices and will be reviewed for acceptance as soon as possible.  A request for further information and/or an acceptance letter will be issued upon the completion of our admissions team's review of the application.
<br><br>
The notice should not be interpreted as verification that the student has been accepted into the program and only confirms that the application has arrived, been received and is pending review for acceptance into the program.
<br><br>
Please note, If you use EXITS to manage your online applications, this application will now show under your current applications. As the application is processed by the admission team, more information will appear online.  Please do not contact SMG in regards to incomplete information available online until you receive notice that the application is approved. Until you receive notice that the application is approved or more information is needed, information will continue to be entered.
	</td></tr>	
	<tr><td>
 Sincerely,<br>
 Student Management Group<br><br>
	</td></tr>
	</table>

 </cfmail>
 <cfoutput>
 	<HTML>
	<HEAD>
	<style type="text/css">
		.thin-border{ border: 1px solid ##000000;}
	</style>
	</HEAD>
	<BODY>	
	
<table width=550 class="thin-border" cellspacing="3" cellpadding=0>
	<tr><td bgcolor=b5d66e><img src="#CLIENT.exits_url#/nsmg/student_app/pics/top-email2.gif" width=550 height=75></td></tr>
	<tr><td><br>#DateFormat(now(), 'mmmm d, yyyy')#<br><br></td></tr>
	<tr><td>The application for #get_Student_info.firstname# #get_student_info.familylastname# has been received.<br><br></td></tr>	
	<tr><td>
Please accept this notice as verification that that application for #get_Student_info.firstname# #get_student_info.familylastname# has been received in the Babylon offices of Student Management Group.  Our admissions staff will be reviewing the application for acceptance into the program as quickly as possible.
<br><br>
Please undertand that this notice is only to verify that the application has been received in the Babylon offices and will be reviewed for acceptance as soon as possible.  A request for further information and/or an acceptance letter will be issued upon the completion of our admissions team's review of the application.
<br><br>
The notice should not be interpreted as verification that the student has been accepted into the program and only confirms that the application has arrived, been received and is pending review for acceptance into the program.
<br><br>
Please note, If you use EXITS to manage your online applications, this application will now show under your current applications. As the application is processed by the admission team, more information will appear online.  Please do not contact SMG in regards to incomplete information available online until you receive notice that the application is approved. Until you receive notice that the application is approved or more information is needed, information will continue to be entered.
	</td></tr>	
	<tr><td>
 Sincerely,<br>
 Student Management Group<br><br>
	</td></tr>
	</table>
	</BODY>
	</HTML>
	</cfoutput>