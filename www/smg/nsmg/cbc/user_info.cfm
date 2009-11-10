<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="../smg.css">
<title>USER - Background Check</title>
</head>

<body onload="opener.location.reload()">

<cfif NOT IsDefined('url.userid') OR url.userid EQ ''>
	An error has ocurred. Please go back and try again.
	<cfabort>
</cfif>

<cfquery name="get_user" datasource="MySql">
	SELECT userid, firstname, middlename, lastname, dob, ssn
	FROM smg_users
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="user_compliance" datasource="MySql">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput query="get_user">

<!----Regional & Company Information---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/user.gif"></td>
		<td background="../pics/header_background.gif"><h2>&nbsp; USER &nbsp; - &nbsp; Information to Submit CBC </td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="qr_user_info.cfm" method="post">
<cfinput type="hidden" name="userid" value='#userid#'>

<table width=100% cellpadding=2 cellspacing=0 border=0 class="section">
	<tr><th colspan="5" bgcolor="e2efc7">USER: #get_user.firstname# #get_user.lastname# (###get_user.userid#)</th></tr>
	<tr><td colspan="5">&nbsp;</td></tr>
	<tr><th>First Name</th><th>Middle Name</th><th>Last Name</th><th>DOB</th><th>SSN</th></tr>	
	<tr>
		<td valign="top" align="center"><cfinput type="text" name="firstname" size="14" value="#firstname#"></td>
		<td valign="top" align="center"><cfinput type="text" name="middlename" size="10" value="#middlename#"></td>
		<td valign="top" align="center"><cfinput type="text" name="lastname" size="14" value="#lastname#"></td>
		<td valign="top" align="center"><cfinput type="text" name="dob" size="8" value="#DateFormat(dob,'mm-dd-yyyy')#" maxlength="10" validate="date"><br>mm-dd-yyyy</td>
		<td valign="top" align="center" width="10%">
			<!--- secure connection --->
			<cfif cgi.SERVER_PORT EQ 443  or client.userid eq 10459 or client.userid eq 510 or client.userid eq 11570 or client.userid EQ 1967 or client.userid eq 12431 or client.userid eq 12868>
				<cfif ssn EQ ''>
					<cfset DecryptedSSN = ssn>
				<cfelse>
					<cfset DecryptedSSN = decrypt(ssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
				</cfif>		
				<cfinput type="text" name="ssn" size=12 value="#DecryptedSSN#" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter a valid SSN for host father in the following format xxx-xx-xxxx"><br>xxx-xx-xxxx			
			<!--- secure connection --->
			<cfelse>
				<cfif ssn EQ ''>
					<cfinput type="text" name="ssn" size=12 value="" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter a valid SSN for host father in the following format xxx-xx-xxxx"><br>xxx-xx-xxxx			
				<cfelse>
					#ssn#
				</cfif>
			</cfif>
		</td>
	</tr>	
	<tr><td colspan="5">&nbsp;</td></tr>
	<tr>
		<td colspan="6">
		<cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'> <!--- ONLY ADMINISTRATORS HAVE ACCESS TO IT --->
			<cfif cgi.SERVER_PORT EQ 443 or client.userid eq 10459 or client.userid eq 510 or client.userid eq 11570 or client.userid EQ 1967 or client.userid eq 12431 or client.userid eq 12868>
				<font size=-2>SSN is encrypted on secure connection, click <a href="http://#cgi.http_host##cgi.script_name#?#cgi.QUERY_STRING#">here</a> to view over unsecure.</font>
			<cfelse>
				<font size=-2><br>You must be using a secure connection to see SSN. Click <a href="https://#cgi.http_host##cgi.script_name#?#cgi.QUERY_STRING#">here</a> to decrypt SSN.</font>
			</cfif>
		</cfif>
		</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><a href="javascript:window.close()"><img src="../pics/close.gif" border="0" align="middle"></img></a></td>
		<td align="center"><cfinput name="Submit" type="image" src="../pics/update.gif" border=0></td>
	</tr>
</table>

</cfform>					
					
<!----footer of  regional table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>

</cfoutput>

</body>
</html>