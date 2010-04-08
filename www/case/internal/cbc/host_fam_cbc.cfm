<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="../smg.css">
<title>Host Family Members - Background Check</title>
</head>

<body onload="opener.location.reload()">

<cfif NOT IsDefined('url.hostid') OR url.hostid EQ ''>
	An error has ocurred. Please go back and try again.
	<cfabort>
</cfif>

<cfquery name="get_family" datasource="caseusa">
	SELECT hostid, familylastname, fatherlastname, fatherfirstname, fatherdob, fatherssn, motherlastname, motherfirstname, motherdob, motherssn
	FROM smg_hosts
	WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_family_members" datasource="caseusa">
	SELECT childid, hostid, membertype, name, middlename, lastname, sex, ssn, birthdate, (DATEDIFF(now( ) , birthdate)/365)
	FROM smg_host_children 
	WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
		AND (DATEDIFF(now( ) , birthdate)/365) > 17
	ORDER BY childid
</cfquery>

<cfquery name="user_compliance" datasource="caseusa">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>

<!----Regional & Company Information---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/family.gif"></td>
		<td background="../pics/header_background.gif"><h2>&nbsp; Host Family Members &nbsp; - &nbsp; Compliance </td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="qr_host_fam_cbc.cfm" method="post">
<cfinput type="hidden" name="count" value='#get_family_members.recordcount#'>
<cfinput type="hidden" name="hostid" value='#get_family.hostid#'>
<table width=100% cellpadding=2 cellspacing=0 border=0 class="section">
	<tr><th colspan="6" bgcolor="e2efc7">Host Family: #get_family.familylastname# (###get_family.hostid#)</th></tr>
	<tr><th>First Name</th><th>Middle Name</th><th>Last Name</th><th>Sex</th><th>DOB</th><th>SSN</th></tr>	
	<cfloop query="get_family_members">
		<cfinput type="hidden" name="childid#currentrow#" value="#childid#">
		<tr bgcolor="#iif(get_family_members.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
			<td valign="top" align="center"><cfinput type="text" name="name#currentrow#" size="11" value="#name#"></td>
			<td valign="top" align="center"><cfinput type="text" name="middlename#currentrow#" size="8" value="#middlename#"></td>
			<td valign="top" align="center"><cfinput type="text" name="lastname#currentrow#" size="11" value="#lastname#"></td>
			<td valign="top" align="center">
				<cfif sex is 'male'><cfinput type="radio" name="sex#currentrow#" value="male" checked="yes">M<cfelse><cfinput type="radio" name="sex#currentrow#" value="male">M</cfif>&nbsp; 
				<cfif sex is 'female'><cfinput type="radio" name="sex#currentrow#" value="female" checked="yes">F<cfelse><cfinput type="radio" name="sex#currentrow#" value="female">F</cfif>
			</td>
			<td valign="top" align="center"><cfinput type="text" name="birthdate#currentrow#" size="7" value="#DateFormat(birthdate,'mm-dd-yyyy')#" maxlength="10" validate="date"><br>mm-dd-yyyy</td>
			<td valign="top" align="center" width="10%">
				<!--- secure connection --->
				<cfif cgi.SERVER_PORT EQ 443 or client.userid eq 10459 or client.userid eq 510 or client.userid eq 11570 or client.userid EQ 1967 or client.userid EQ 1 or client.userid EQ 12151 or 1 eq 1>
					<cfif ssn EQ ''>
						<cfset DecryptedSSN = ssn>
					<cfelse>
						<cfset DecryptedSSN = decrypt(ssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
					</cfif>		
					<cfinput type="text" name="ssn#currentrow#" size=10 value="#DecryptedSSN#" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter a valid SSN for #name# in the following format xxx-xx-xxxx"><br>xxx-xx-xxxx			
				<!--- secure connection --->
				<cfelse>
					<cfif ssn EQ ''>
						<cfinput type="text" name="ssn#currentrow#" size=10 value="" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter a valid SSN for #name# in the following format xxx-xx-xxxx"><br>xxx-xx-xxxx			
					<cfelse>
						#ssn#
					</cfif>
				</cfif>
			</td>
		</tr>	
	</cfloop>
	<tr>
		<td colspan="6">
		<cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'> <!--- ONLY ADMINISTRATORS HAVE ACCESS TO IT --->
			<cfif cgi.SERVER_PORT EQ 443 or client.userid eq 10459 or client.userid eq 510 or client.userid eq 11570 or client.userid EQ 1967 or 1 eq 1>
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
