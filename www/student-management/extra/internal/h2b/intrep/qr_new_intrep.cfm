<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New International Representative</title>
</head>

<body>
<!----
<cftry>
----->
<cfoutput>

<cftransaction action="begin" isolation="serializable">

	<cfquery name="check_email" datasource="MySql">
		SELECT userid, firstname, lastname, businessname
		FROM smg_users
		WHERE email = '#form.email#'
	</cfquery>

	<cfquery name="check_username" datasource="MySql">
		SELECT userid, firstname, lastname
		FROM smg_users
		WHERE username = '#form.username#'
	</cfquery>

	<cfset total_errors = 0>
	<cfloop from="1" to="5" index="i">
		<cfset form["error" & i] = ''>
	</cfloop>
	
	<!--- BLANK BUSINESS NAME --->
	<cfif form.businessname EQ ''>
		<cfset form.error1 = '<b>Business Name</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- BLANK USERNAME --->
	<cfif form.username EQ ''>  
		<cfset form.error2 = '<b>Username</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- BLANK PASSWORD --->
	<cfif form.password EQ ''>  
		<cfset form.error3 = '<b>Password</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- EMAIL IN USE --->
	<cfif check_email.recordcount>  
		<cfset form.error4 = 'Email <b>#form.email#</b> is current in use by account <b>#check_email.businessname# ###check_email.userid#</b>. You must change it in order to continue.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- USERNAME IN USE --->
	<cfif check_username.recordcount>  
		<cfset form.error5 = 'Username <b>#form.username#</b> is current in use by account <b>#check_username.businessname# ###check_username.userid#</b>. You must change it in order to continue.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	
	<cfif total_errors GT 0>
		<table  bgcolor="FFFFFF" bordercolor="CCCCCC" border="1" height="100%" width="100%">
			<tr bordercolor="FFFFFF">
				<td>
					<table width=100% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
					<tr bgcolor="E4E4E4">
						<td class="title1">&nbsp; &nbsp; New User</td>
					</tr>
					</table><br>
					<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
						<tr><th class="style1">EXTRA - Input Error</th></tr>
						<tr><td class="style1">Total of #total_errors# error(s) &nbsp; -  &nbsp; Please see list below.</td></tr>
						<cfloop from="1" to="5" index="i">
							<cfif form["error" & i] NEQ ''>
								<tr><td class="style1">#form["error" & i]#</td></tr>
							</cfif>
						</cfloop>
						<tr><td align="center" class="style1"><input type="image" value="back" src="../pics/goback.gif" onClick="javascript:history.back()"></td></tr>		
					</table><br />
				</td>
			</tr>
		</table>		
		<cfabort>	
	</cfif>

	<cfset form.uniqueid = '#createuuid()#'>
		
	<cfquery name="new_intrep" datasource="MySql">
		INSERT INTO smg_users
			(uniqueid, usertype, datecreated, businessname, address, city, country, zip, phone, fax, usebilling, billing_company, 
			billing_contact, billing_email, billing_address, billing_address2, billing_city, billing_country, billing_zip, billing_phone, 
			billing_fax, firstname, middlename, lastname, dob, sex, email, email2, username, password)
		VALUES
			('#form.uniqueid#', '#form.usertype#', #CreateODBCDate(now())#,  '#form.businessname#', '#form.address#', '#form.city#', 
			'#form.country#', '#form.zip#', '#form.phone#', '#form.fax#', 
			<cfif IsDefined('form.usebilling')>'1'<cfelse>'0'</cfif>, 
			'#form.billing_company#', '#form.billing_contact#', '#form.billing_email#', '#form.billing_address#', '#form.billing_address2#',
			'#form.billing_city#', '#form.billing_country#', '#form.billing_zip#', '#form.billing_phone#', '#form.billing_fax#',
			'#form.firstname#', '#form.middlename#', '#form.lastname#', 
			<cfif form.dob EQ ''>NULL<cfelse>#CreateODBCDate(dob)#</cfif>,
			<cfif IsDefined('form.sex')>'#form.sex#'<cfelse>''</cfif>, 
			'#form.email#', '#form.email2#', '#form.username#', '#form.password#')
	</cfquery>

	<cfquery name="get_user" datasource="MySql">
		SELECT max(userid) as userid
		FROM smg_users
	</cfquery>

	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully created #form.businessname#. Thank You.");
		//location.replace("?curdoc=candidate/candidate_form2&unqid=#uniqueid#");
		location.replace("?curdoc=intrep/intreps");
	-->
	</script>
	</head>
	</html> 		

</cftransaction>

</cfoutput>
<!----
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>
---->
</body>
</html>
