<link href="style.css" rel="stylesheet" type="text/css" />

<br>
<br>
<br>

<Table bgcolor="#FFFFFF" ALIGN="CENTER" width=60%>
<cfform action="retrieve_password.cfm" method=post>
	<tr>
		<td width="33%" bgcolor="#FFFFFF" class="style1"><div align="center"><img src="images/extra-logo.jpg" width="160" height="219"></div></td>
		<td width="63%" bgcolor="#FFFFFF" class="style1">
		
		Usernames are set to your email address by default. <br>
		To retrieve your login info, please enter you address below. <br><br>

		Email Address: <cfinput type="text" name="email" size=20 message="Please enter your email address." required="yes" > <input type="submit" value="submit">
		<br><br>
		If you no longer have access to that email account, please contact <a href="mailto:support@universalprograms.com">support@universalprograms.com</a>. <br></td>
	</tr>
	</cfform>
</Table>