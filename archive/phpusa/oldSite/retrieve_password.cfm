<cfquery name="get_pass" datasource=upi>
select email, password, firstname, lastname
from users
where email = '#form.email#'
</cfquery>
<BODY bgcolor="#B5B5BF">

<br>
<br>
<br>

<Table bgcolor="#e9ecf1" ALIGN="CENTER" width=60%>
	<tr>
		<td><img src="images/logo-upi.gif" width="196" height="180"></td>
		<td>
		
		<cfif #get_pass.recordcount# eq 0>
		<cfform action="retrieve_password.cfm" method=post>
		That email address is not registerd on our system. You can try a different email address.<br><br>
		Email Address: <cfinput type="text" size=20 name=email> <input type="submit" value="submit">
		<br><br>
		To gain access to the UPI system, you will need a username and password.  Please contact  <a href="mailto:support@universalprograms.com">support@universalprograms.com</a>. <br>
		<font size=-1>Please include your first & last name, street address and  phone number.</td>
		</cfform>
		 <cfelse>
		 <cfmail to="#get_pass.email#" from="support@universalprograms.com" subject="" type="html">
		
						<Table width=60%>
					<tr>
						<td><img src="http://www.universalprograms.com/images/logo-upi.gif" width="196" height="180"></td>
						<td>
						You recently requested your username and password from www.universalprograms.com<br>
						<br>
						Your username is: #get_pass.email#<br>
						Your password is: #get_pass.password#<br><br>
						You can log in at any time at http://www.universalprograms.com/<br><br>
						<font size=-2>
						Requested #now()#<br>
						#cgi.remote_addr#
						</font>
					</tr>
				</Table>
		
		
		
		
		 </cfmail>
		 Your username and password have been sent to the email address on record.<br><br>If you do not receive it with in 20 minutes, please contact <a href="mailto:support@universalprograms.com">support@universalprograms.com</a>.<br> Add support@universalprograms.com to your whitelist to make sure 
		 messages from UPI are not sent to your spam folder.<br><br>
		 <a href="http://www.universalprograms.com">www.universalprograms.com</a>
		</cfif>
	</tr>
</Table>


