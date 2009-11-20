<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
							<td background="pics/header_background.gif"><h2>Email Welcome Message</td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					



<table cellpadding="0" cellspacing="0" bgcolor="#ffffe6" width=100% class="section">
	<tr>
		<td colspan=5>The welcome email is sent to students who are going to fill out the application themselves.</td>
	</tr>
		<tr>
		<td bgcolor="#e2efc7" colspan=6><span class="get_attention"><b>::</b></span> The following email is sent to students when a new account is created for them to start the online application. </td>
	</tr>
	<tr>
		<td><br>
<div align="center">Please fill out the form below to add your own personal message.<br>
Plase note that this message will go out for all branch offices as well.<br>
<cfif isDefined('url.us')><br><h2><font color="green">Message succesfully updated.</font></h2><br></cfif></div>
	<table width=550 class="thin-border" cellspacing="0" cellpadding=0 bgcolor="white" align="center">
		<tr>
			<td bgcolor=b5d66e><img src="http://www.student-management.com/nsmg/student_app/pics/top-email.gif" width=550 heignt=75></td>
		</tr>
		<tr>
			<td>
			<i>Students First Name</i>-
			<br><br>
			An account has been created for you on the Student Management Groups EXITS system.  
			Using EXITS you will be able to apply for your exchange program and view the status of your application as it is processed. 
			<br><br>
			You can start your application at any time and do not need to complete it all at once.
			You can save your work at any time and return to the application when convenient.  
			The first time you access EXITS you will create a password that will allow you to work 
			on your application at any time. 
			<br><br>
			Your application will remain active until <strong><i>expiration_date</i></strong>.
			You will need to contact <i>Branch/Head Office</i> to re-activate your application if your application expires.
			<br><br>
			The completed application will be reviewed by your international representative and sent to the SMG Headquarters in New York.
			The status of your application can be viewed by logging into the Exits Login Portal. 
			After your placement has been made, you will also be able to access your host family profile.
			<br><br>
			You are taking the first step in what will become one of the greatest experiences in your life!
			<br><br>
			Click the link below to start your application process.  
			<br><br>
			http://www.student-management.com/nsmg/student_app/?s=E180CA2F-1320-17E0-361BAD89F91C6FDBD</a>
			<br><br>
			You will need the following information to verify your account:<br>
			*email address<br>
			*this ID: <i>System Generated 6 digit Number</i>
			<br><br>
			If you have any questions about the application or the information you need to submit, please contact your international representative:
			<br><br>
			<I>Branch/Head Office Name</I><br>
			<i>Branch/Head Office Contact Number</i><br>
			<i>Branch/Head Office Email</i><br><br>
			Message from <I>Branch/Head Office Contact Name</I>:
			<cfquery name="get_message" datasource="MySQL">
			select message
			from smg_student_app_intagent_message
			where emailid =1 and agentid = #client.parentcompany#
			</cfquery>
			
			<form method="post" action="intrep/insert_email_message.cfm">
			<cfoutput>
			<input type="hidden" name="msgexist" value=#get_message.recordcount#>
			
			<textarea cols="70" rows="10" name="message">#get_message.message#</textarea>
			</cfoutput>
			<input type="submit" value="submit">
			</form>
			
			
			For technical issues with EXITS, submit questions to the support staff via the EXITS system.
			</td>
		</tr>
		
		
		<tr>
			<td align="center">__________________________________________</td>
		</tr>
		<tr>
			<Td align="center">
			<font color="#CCCCCC"><font size=-1>Please add support@student-management.com to your whitelist to ensure it isn't marked as spam. SMG will
			not sell your address or use it for unsolicited emails.  This email was sent on behalf of Student Management Group from an International Agent, listed above.  If you received this email as an unsolicited contact 
			about SMG or SMG subsidiaries, please contact support@student-management.com  </font></font>
			</Td>
		</tr>
</table>

</td>
	</tr>
		
	<tr>
		<td bgcolor="#e2efc7" colspan=6><span class="get_attention"><b>::</b></span> The following email is sent when the students appliation is approved by SMG. </td>
	</tr>
	<tr>
		<td colspan=5>
		<cfquery name="check_congrats" datasource="mysql">
		select congrats_email from smg_users where userid = #client.userid#
		</cfquery>
		<cfoutput>
		<!----congrats_email variable: 0 is both, 1 is agent only---->
		
		Send congratulations email to: <form method="post" action="intrep/congrats_email.cfm"><input type="radio" name="congrats_email" value=0 <cfif check_congrats.congrats_email eq 0>checked</cfif> >Student and Myself <input type="radio" name="congrats_email" value=1<cfif check_congrats.congrats_email eq 1>checked</cfif>> Myself Only - <input type="submit" value="Update"></form> <cfif isDefined('url.ce')><font color="##009933">Updated</font></cfif></td>
		</cfoutput>
	</tr>
	<tr>
		<td><br>
		
			<table width=550 class="thin-border" cellspacing="0" cellpadding=0 bgcolor="white" align="center">
		<tr>
			<td bgcolor=b5d66e><img src="http://www.student-management.com/nsmg/student_app/pics/top-email.gif" width=550 heignt=75></td>
		</tr>
		<tr>
			<td>
			<i>Students First Name</i>-
			<br><br>
			This email is to inform you that your application has been accepted and approved by Student Management Group in New York.
			<br><br>
			<i>What does this mean to you and what are the next steps?</i><br>
			Your are now listed as available for placement in the United States and the region or state you chose if applicable. Students are placed on a daily basis all over the county. All you have to do is wait to hear from us. You will receive an email and acceptance letter once you have been placed with a host family. You will also be able to see your host family profile when you log into www.student-manageement.com after you have been placed. 
			<br><br>			
			For technical issues with EXITS, submit questions to the support staff via the EXITS system.
			</td>
		</tr>
		
		
		<tr>
			<td align="center">__________________________________________</td>
		</tr>
		<tr>
			<Td align="center">
			<font color="#CCCCCC"><font size=-1>Please add support@student-management.com to your whitelist to ensure it isn't marked as spam. SMG will
			not sell your address or use it for unsolicited emails.  This email was sent on behalf of Student Management Group from an International Agent, listed above.  If you received this email as an unsolicited contact 
			about SMG or SMG subsidiaries, please contact support@student-management.com  </font></font>
			</Td>
		</tr>
</table>
		
		
		</td>
	</tr>
	</table>
	<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>		