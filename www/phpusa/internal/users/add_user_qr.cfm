<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Add User</title>
</head>

<body>

<cfquery name="check_email" datasource="MySql">
	SELECT userid, firstname, lastname
	FROM smg_users
	WHERE email = '#form.email#' 
</cfquery>

<cfquery name="check_username" datasource="MySql">
	SELECT userid, firstname, lastname
	FROM smg_users
	WHERE username = '#form.username#'
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

<cfset form.uniqueid = createuuid()>

<cfquery name="add_user" datasource="mysql">
	INSERT INTO smg_users 
		(uniqueid, companyid, usertype, firstname, lastname, dob, email, password, businessname, phone, phone_ext, work_phone, work_ext, cell_phone,
		fax, address, address2, city, state, country, zip, username, datecreated, whocreated)
	VALUES 
		('#form.uniqueid#', '#client.companyid#', '#form.usertype#', '#form.firstname#','#form.lastname#', 
		<cfif form.dob EQ ''>NULL<cfelse>#CreateODBCDate(dob)#</cfif>, '#form.email#','#form.password#',
		'#form.businessname#', '#form.phone#', '#form.phone_ext#', '#form.work_phone#', '#form.work_ext#','#form.cell_phone#', '#form.fax#',
		'#form.address#','#form.address2#','#form.city#',#form.state#,'#form.country#','#form.zip#','#form.username#',
		#now()#, '#client.userid#')
</cfquery>

<cfquery name="userid" datasource="mysql">
	SELECT max( userid ) AS userid
	FROM smg_users 	
</cfquery>

<!--- INSERT PHP ACCESS FOR OFFICE AND AREA REPS --->
<cfif form.usertype NEQ '8'>
	<cfquery name="insert_php_access" datasource="MySql">
		INSERT INTO user_access_rights
		 (userid, companyid, changedate, usertype) 
		VALUES ('#userid.userid#', '6', NOW( ) , '#form.usertype#');
	</cfquery>
</cfif>
	
<cfif form.usertype EQ '8'>
	<cflocation url="index.cfm?curdoc=users/user_info&userid=#userid.userid#" addtoken="no">
<cfelse>
	<cflocation url="index.cfm?curdoc=users/new_user_details&userid=#userid.userid#&new" addtoken="no">
</cfif>

</body>
</html>