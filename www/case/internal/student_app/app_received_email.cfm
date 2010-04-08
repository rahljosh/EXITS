<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Application Received Email</title>
</head>

<body>

<cfif get_student.intrepemail NEQ ''>
	<cfmail to="#get_student.intrepemail#" from="support@case-usa.org" subject="Application Received - #get_student.firstname# #get_student.familylastname# (###get_student.studentid#)" type="html" failto="support@case-usa.org">
		<style type="text/css">
		.thin-border{ border: 1px solid ##000000;}
		</style>
		<table width=550 class="thin-border" cellspacing="2" cellpadding=2>
			<tr><td bgcolor="b5d66e"><img src="http://www.student-management.com/nsmg/student_app/pics/t_op-email.gif" width=550 heignt=75></td></tr>
			<tr>
				<td>
					<div align="justify">
					<br><br>
					#DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br><br>
					
					Dear #get_student.businessname#,<br><br>
					
					Please accept this notice as verification that the <cfif get_student.randid EQ 0>paper<cfelse>online</cfif>
					application for #get_student.firstname# #get_student.familylastname# (###get_student.studentid#) has been received in the New Jersey offices 
					of CASE. <br><br>
					
					Our admissions staff will be reviewing the application for acceptance into the #get_student.app_program# program as quickly
					as possible. <br><br>
					
					Please understand that this notice is only to verify that the application has been received in the New Jersey offices
					and will be reviewed for acceptance as soon as possible. A request for further information and/or an acceptance letter
					will be issued upon the completion of our admissions team's review of the application.<br><br> 
					
					This notice should not be interpreted as verification that the student has been accepted into the program and only confirms
					that the application <cfif get_student.randid EQ 0>has arrived<cfelse>has been received</cfif> and is pending review for acceptance into the program.<br><br>
					
					Please note, if you use EXITS to manage your online applicatiosn, this application will now show under your current applications in received status.<br><br>
					
					Sincerely, <br><br>
					
					Cultural Academic Student Exchange<br><br>
					</div>
				</td>
			</tr>
			<tr><td align="center">______________________________________________</td></tr>
			<tr>
				<Td align="center">
					<font color="##CCCCCC" size=-1>Please add support@case-usa.org to your whitelist to ensure it isn't marked as spam. 
						CASE will not sell your address or use it for unsolicited emails. This email was sent on behalf of Cultural Academic Student Exchange
						from an International Agent, listed above. If you received this email as an unsolicited contact about CASE or CASE 
						subsidiaries, please contact support@case-usa.org  
					</font>
				</Td>
			</tr>
		</table>
	</cfmail>
</cfif>

</body>
</html>