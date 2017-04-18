<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New International Representative</title>
</head>

<body>

<cftry>

<cfparam name="FORM.hostCompanyID" default="0">

<cfoutput>

<cftransaction action="begin" isolation="serializable">

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
	<cfloop from="1" to="6" index="i">
		<cfset form["error" & i] = ''>
	</cfloop>
	
	<!--- BLANK COMPANYID --->
	<cfif form.companyid EQ 0>  
		<cfset form.error1 = '<b>Company Access Level</b> is required. Please go back and select a company.'>
		<cfset total_errors = total_errors + 1>
	</cfif>	
	<!--- BLANK USERTYPE --->
	<cfif form.usertype EQ 0> 
		<cfset form.error2 = '<b>Usertype Access Level</b> is required. Please go back and select an usertype.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- BLANK USERNAME --->
	<cfif form.username EQ ''>  
		<cfset form.error3 = '<b>Username</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- BLANK PASSWORD --->
	<cfif form.password EQ ''>  
		<cfset form.error4 = '<b>Password</b> is required. Please go back and fill it out.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- EMAIL IN USE --->
	<cfif check_email.recordcount>  
		<cfset form.error5 = 'Email <b>#form.email#</b> is current in use by account <b>#check_email.firstname# #check_email.lastname# ###check_email.userid#</b>. You must change it in order to continue.'>
		<cfset total_errors = total_errors + 1>
	</cfif>
	<!--- USERNAME IN USE --->
	<cfif check_username.recordcount>  
		<cfset form.error6 = 'Username <b>#form.username#</b> is current in use by account <b>#check_username.firstname# #check_username.lastname# ###check_username.userid#</b>. You must change it in order to continue.'>
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
						<cfloop from="1" to="6" index="i">
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
	
	<cfset form.comments = #Replace(form.comments,"#chr(10)#","<br>","all")#>
        
	<cfquery name="new_user" datasource="MySql">
		INSERT INTO smg_users
			(uniqueid, companyid, datecreated, firstname, middlename, lastname, sex, dob, drivers_license, address, city, state,
			country, zip, occupation, businessname, work_phone, phone, cell_phone, fax, email, email2, usertype, username, password,
			comments)
		VALUES
			('#form.uniqueid#', '#form.companyid#', #CreateODBCDate(now())#, '#form.firstname#', '#form.middlename#', '#form.lastname#', 
			<cfif IsDefined('form.sex')>'#form.sex#'<cfelse>''</cfif>, 
			<cfif form.dob EQ ''>NULL<cfelse>#CreateODBCDate(dob)#</cfif>,
			'#form.drivers_license#', '#TRIM(form.address)#', '#TRIM(form.city)#', '#TRIM(form.state)#', '#TRIM(form.country)#', '#TRIM(form.zip)#', '#form.occupation#',
			'#form.businessname#', '#form.work_phone#', '#form.phone#', '#form.cell_phone#', '#form.fax#', '#form.email#', '#form.email2#',
			'#form.usertype#', '#form.username#', '#form.password#', 
			<cfqueryparam value = "#form.comments#" cfsqltype="cf_sql_longvarchar">)
	</cfquery>

	<cfquery name="get_user" datasource="MySql">
		SELECT max(userid) as userid
		FROM smg_users
	</cfquery>

	<cfloop list="#FORM.hostCompanyID#" index="hostCompanyID">
		<cfif hostCompanyID GT 0>
		    <cfquery name="user_access_rights" datasource="MySql">
			INSERT INTO user_access_rights
				(userid, companyid, usertype, default_region, hostCompanyID)
			VALUES
				('#get_user.userid#', '#form.companyid#', '#form.usertype#', '1', '#hostCompanyID#')
		</cfquery>
		</cfif>
	</cfloop>
	

	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully created user #form.firstname# #form.lastname# ##(#get_user.userid#). Thank You.");
		location.replace("?curdoc=user/users");
	-->
	</script>
	</head>
	</html> 	

</cftransaction>

</cfoutput>	

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>
