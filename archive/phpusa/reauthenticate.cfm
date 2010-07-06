<BODY bgcolor="#B5B5BF">

<br>
<br>
<br>

<Table width=60% ALIGN="CENTER" cellpadding="10" bordercolor="#666666" bgcolor="#e9ecf1">
	<tr>
		<td width="200" height="100" bgcolor="#FFFFFF"><div align="center"><img src="http://www.student-management.com/nsmg/pics/logos/php_clear.gif" align="absmiddle"></div></td>
		<td>
		<cfform action="retrieve_password.cfm" method=post>
		Usernames are set to your email address by default. <br>
		To retrieve your login info, please enter you address below. <br><br>

		Email Address: <cfinput type="text" name="email" size=20 message="Please enter your email address." required="yes" > <input type="submit" value="submit">
		<br><br>
		If you no longer have access to that email account, please contact <a href="mailto:support@universalprograms.com">support@universalprograms.com</a>. <br>
		<font size=-1>Please include your first & last name, street address, phone number and old username or email address, </td>
		</cfform>
	</tr>
</Table>