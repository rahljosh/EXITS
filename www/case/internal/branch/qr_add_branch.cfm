<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>New Branch</title>
</head>
<body>

<cftry>

	<cfset form.username = #Replace(form.username, '"', "", "all")#>
	<cfset form.password = #Replace(form.password, '"', "", "all")#>
	<cfset form.username = #Replace(form.username, "'", "", "all")#>
	<cfset form.password = #Replace(form.password, "'", "", "all")#>
	
	<cfquery name="check_username" datasource="caseusa">
		SELECT username
		FROM smg_users
		WHERE username = '#form.username#'
	</cfquery>
	
	<cfif check_username.recordcount NEQ '0'>
		<br><br>
		<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
		<tr>
			<td width="100%">
				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
					<tr valign=middle height=24>
						<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
						<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
						<td background="pics/header_background.gif"><h2>Branch Information</h2> </td>
						<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
					</tr>
				</table>
				<div class="section"><br>
				<cfoutput>
				<table width=670 cellpadding=0 cellspacing=0 border=0 align="center">
					<tr><td><h2>Sorry, the username provided <b>#form.username#</b> has been registered with another account.</h2><br></td></tr>
					<tr><td><h2>Please click on the "back" button below and enter a new e-mail address.</h2><br><br><br>
							<div align="center"><input name="back" type="image" src="pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br><br></td></tr>
				</table>
				</cfoutput>
				</div>
				<!--- FOOTER OF TABLE --->
				<table width=100% cellpadding=0 cellspacing=0 border=0>
					<tr valign=bottom >
						<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
						<td width=100% background="pics/header_background_footer.gif"></td>
						<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
					</tr>
				</table><br>
			</td>
		</tr>
		</table>
		<cfabort>
	</cfif>

	<cftransaction action="begin" isolation="serializable">
		<cfquery name="insert_branch" datasource="caseusa">
			INSERT INTO smg_users
				(intrepid, usertype, businessname, firstname, lastname, sex, address, address2, city, state, country, zip, phone, fax, email, username,
				 password, datecreated,studentcontactemail)
			VALUES 
				('#form.intrepid#', '#form.usertype#', '#form.businessname#', '#form.firstname#', '#form.lastname#', 
				<cfif IsDefined('form.sex')>'#form.sex#'<cfelse>''</cfif>,  '#form.address#', '#form.address2#', 
				'#form.city#', '#form.state#', '#form.country#', '#form.zip#', '#form.phone#', '#form.fax#', 
				'#form.email#', '#form.username#', '#form.password#', #CreateODBCDate(now())#,'#form.studentcontactemail#')
		</cfquery>
			
		<cfoutput>
			
		<cfquery name="agent_info" datasource="caseusa">
			SELECT businessname, phone, email 
			FROM smg_users 
			WHERE userid = '#form.intrepid#'
		</cfquery>
		<cfmail to="#form.email#" from="support@student-management.com" Subject="SMG Exchange Application" type="html">
		<style type="text/css">
		.thin-border{ border: 1px solid ##000000;}
		</style>
		<table width=550 class="thin-border" cellspacing="5" cellpadding=0>
			<tr>
				<td bgcolor=b5d66e><img src="http://www.student-management.com/nsmg/student_app/pics/top-email.gif" width=550 heignt=75></td>
			</tr>
			<tr>
				<td>
				<div align="justify">
				#form.firstname# -
				<br><br>
				An account has been created for you on the Student Management Group EXITS system by #agent_info.businessname#.  
				Using EXITS you will be able to create online student application accounts and view the status of your applicants as they are processed.<br><br>
				
				To activate your account, simply click on the EXITS Login Portal at www.student-management.com and login with the username and 
				password provided below. <br><br>		
				
				*username: #form.username# <br>
				*password: #form.password# <br>
				* Postal Code <br>
				* Last 4 digits of your phone number<br><br>
				
				If you have any questions about the application or the information you need to submit, please contact the main office of your international representative:
				<br><br>
				#agent_info.businessname#<br>
				#agent_info.phone#<br>
				#agent_info.email#<br>
				
				For technical issues with EXITS, submit questions to the support staff via the EXITS system.<br><br>
				
				Sincerely, <br>
				EXITS Support
				</div>
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
		</cfmail>
		</cfoutput>
			
		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully added a new branch. Thank You.");
			location.replace("?curdoc=branch/branches");
		-->
		</script>
		</head>
		</html> 		

	</cftransaction>

<cfcatch type="any">
	<cfinclude template="../forms/error_message.cfm">
</cfcatch>
</cftry>