<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Update User</title>
</head>

<body>

<cfquery name="check_email" datasource="MySql">
	SELECT userid, firstname, lastname
	FROM smg_users
	WHERE email = '#form.email#' 
		AND userid != '#form.userid#'		
</cfquery>

<cfquery name="check_username" datasource="MySql">
	SELECT userid, firstname, lastname
	FROM smg_users
	WHERE username = '#form.username#'
		AND userid != '#form.userid#'
</cfquery>

<cfset total_errors = 0>
<cfloop from="1" to="4" index="i">
	<cfset form["error" & i] = ''>
</cfloop>

<cfoutput>

	<!--- BLANK USERNAME --->
	<cfif IsDefined('form.username') AND form.username EQ ''>  
		<cfset form.error1 = '<b>Username</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- BLANK PASSWORD --->
	<cfif IsDefined('form.password') AND form.password EQ ''>  
		<cfset form.error2 = '<b>Password</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- EMAIL IN USE --->
	<cfif check_email.recordcount>  
		<cfset form.error3 = 'Email <b>#form.email#</b> is current in use by account <b>#check_email.firstname# #check_email.lastname# ###check_email.userid#</b>. You must change it in order to continue.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- USERNAME IN USE --->
	<cfif IsDefined('form.username') AND check_username.recordcount>  
		<cfset form.error4 = 'Username <b>#form.username#</b> is current in use by account <b>#check_username.firstname# #check_username.lastname# ###check_username.userid#</b>. You must change it in order to continue.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	
	<cfif total_errors GT 0>
		<br />
		<table  bgcolor="FFFFFF" bordercolor="CCCCCC" border="1" height="100%" width="80%" align="center">
			<tr bordercolor="FFFFFF">
				<td>
					<table width=100% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
					<tr bgcolor="E4E4E4">
						<td class="title1">&nbsp; &nbsp; Edit User</td>
					</tr>
					</table><br>
					<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
						<tr><th class="style1">PHP - Input Error</th></tr>
						<tr><td class="style1">Total of #total_errors# error(s) &nbsp; -  &nbsp; Please see list below.</td></tr>
						<cfloop from="1" to="4" index="i">
							<cfif form["error" & i] NEQ ''>
								<tr><td class="style1">#form["error" & i]#</td></tr>
							</cfif>
						</cfloop>
						<tr><td align="center" class="style1"><input type="image" value="back" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>		
					</table><br />
				</td>
			</tr>
		</table><br />		
		<cfabort>	
	</cfif>
</cfoutput>

<cfquery name="update_users" datasource="MySql">
	UPDATE smg_users
	SET	firstname = '#form.firstname#',
		lastname = '#form.lastname#',
		address = '#form.address#',
		address2 = '#form.address2#',
		city = '#form.city#',
		<cfif IsDefined('form.country')>country = '#form.country#',</cfif>
		<cfif IsDefined('form.state')>state = '#form.state#',</cfif>
		zip = '#form.zip#',
		dob = <cfif form.dob EQ ''>NULL<cfelse>#CreateODBCDate(dob)#</cfif>,
		phone = '#form.phone#',
		phone_ext = '#form.phone_ext#',
		work_phone = '#form.work_phone#',
		work_ext = '#form.work_ext#',
		cell_phone = '#form.cell_phone#',
		fax = '#form.fax#',
		emergency_contact = '#form.emergency_contact#',
		emergency_phone = '#form.emergency_phone#',
		businessname = '#form.businessname#',
		
		<cfif IsDefined('form.php_contact_name')>
			php_contact_name = '#form.php_contact_name#',
			php_contact_phone = '#form.php_contact_phone#',
			php_contact_email = '#form.php_contact_email#',			
		</cfif>
		
		<cfif isDefined('form.billing_company')>
			billing_company = '#form.billing_company#',
			billing_address = '#form.billing_address#',
			billing_address2 = '#form.billing_address2#',
			billing_city = '#form.billing_city#',
			billing_country = #form.billing_country#,
			billing_zip = '#form.billing_zip#',
			billing_phone = '#form.billing_phone#',
			billing_fax = '#form.billing_fax#',
			billing_contact = '#form.billing_contact#',
			billing_email = '#form.billing_email#',
		</cfif>
		
		<cfif IsDefined('form.password') AND form.password NEQ ''>password = '#form.password#',</cfif>
		username = '#form.username#',
		email = '#form.email#'
	WHERE userid = '#form.userid#'
	LIMIT 1
</cfquery>

<cflocation url="?curdoc=users/user_info&id=#form.userid#" addtoken="no">

</body>
</html>