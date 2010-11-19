<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Branch Information</title>
</head>
<body>

<cfset form.username = #Replace(form.username, '"', "", "all")#>
<cfset form.password = #Replace(form.password, '"', "", "all")#>
<cfset form.username = #Replace(form.username, "'", "", "all")#>
<cfset form.password = #Replace(form.password, "'", "", "all")#>

<cfquery name="check_username" datasource="MySql">
	SELECT username
	FROM smg_users
	WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_char"> 
		AND userid != <cfqueryparam value="#form.branchid#" cfsqltype="cf_sql_integer">
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
 	<cftry>
	
		<cfquery name="update_branch" datasource="MySql">
			UPDATE smg_users
			SET	businessname = '#form.businessname#',
				firstname = '#form.firstname#',
				lastname = '#form.lastname#',	
				sex = <cfif IsDefined('form.sex')>'#form.sex#'<cfelse>''</cfif>,
				address = '#form.address#',
				address2 = '#form.address2#',
				city = '#form.city#', 
				state = '#form.state#',
				country = '#form.country#',
				zip = '#form.zip#',
				phone = '#form.phone#',
				fax = '#form.fax#',
				email = '#form.email#',
				studentcontactemail = '#form.studentcontactemail#',
				username = '#form.username#',
				password = '#form.password#'
			WHERE userid = <cfqueryparam value="#form.branchid#" cfsqltype="cf_sql_integer">
			LIMIT 1
		</cfquery>
			
		<html>
		<head>
		<cfoutput>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully updated this page. Thank You.");
			location.replace("?curdoc=branch/branch_info&branchid=#form.branchid#");
		-->
		</script>
		</cfoutput>
		</head>
		</html> 		
		
  	<cfcatch type="any">
		<cfinclude template="../forms/error_message.cfm">
	</cfcatch>
	</cftry>
</cftransaction>