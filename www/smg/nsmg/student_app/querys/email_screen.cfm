	<cfquery name="agent_info" datasource="MySQL">
		SELECT businessname, phone,email 
		FROM smg_users 
		WHERE userid = 19
	</cfquery>
	<cfset uniqueid = createuuid()>
	<cfset randid = #RandRange(111111,999999)#>
	<cfset form.firstname = 'Patricia'>
	<cfoutput>
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
			Your application will remain active as long as you access it at least once every 30 days.
			The application process will have to be restarted after this period of time expires.
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
			<a href="http://www.student-management.com/exits/student_app/?s=#uniqueid#">http://www.student-management.com/exits/student_app/?s=#uniqueid#</a>
			<br><br>
			You will need the following information to verify your account:<br>
			*email address<br>
			*this ID: #randid#
			<br><br>
			If you have any questions about the application or the information you need to submit, please contact your international representative:
			<br><br>
			#agent_info.businessname#<br>
			#agent_info.phone#<br>
			#agent_info.email#<br><br>
			
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
	</table>
	</cfoutput>