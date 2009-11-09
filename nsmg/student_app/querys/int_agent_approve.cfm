<meta http-equiv="refresh" content="3;url=close_window.cfm">
<body onload="opener.location.reload()"> 
<cfquery name="approve_appliation" datasource="MySQL">
	insert into smg_student_app_status (studentid, status, reason, date)
							values (#client.studentid#, 5, 'Application Approved by International Rep', #now()#)
	</cfquery>
	
	<table align="center">
		<tr>
			<td><img src="../pics/top-email.gif"></td>
		</tr>
		<tr>
			<td>This application has been approved.  This window should close automatically.</td>
		</tr>
	</table>