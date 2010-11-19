<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Resend Branch Login Information</title>
</head>

<body>

<cftry>

	<cfoutput>

	<cfif not IsDefined('url.branchid')>
		<cfinclude template="../forms/error_message.cfm">
		<cfabort>
	</cfif>

	<cfquery name="get_branch" datasource="MySql">
		SELECT userid, intrepid, firstname, username, password, email, businessname
		FROM smg_users
		WHERE userid = <cfqueryparam value="#url.branchid#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif client.usertype EQ '8' AND client.userid NEQ get_branch.intrepid>
		<cfinclude template="../forms/error_message.cfm">
		<cfabort>
	</cfif>
	
	<cfif client.usertype EQ '11' AND client.userid NEQ url.branchid>
		<cfinclude template="../forms/error_message.cfm">
		<cfabort>
	</cfif>
	
	<cfquery name="agent_info" datasource="MySQL">
		SELECT businessname, phone, email 
		FROM smg_users 
		WHERE userid = '#get_branch.intrepid#'
	</cfquery>
	
	<cfmail to="#get_branch.email#" from="#client.support_email#" Subject="EXITS - #get_branch.businessname# Login Information" type="html">
	<style type="text/css">
	.thin-border{ border: 1px solid ##000000;}
	</style>
	<table width=550 class="thin-border" cellspacing="5" cellpadding=0>
		<tr>
			<td bgcolor=b5d66e><img src="#CLIENT.exits_url#/nsmg/student_app/pics/#client.app_menu_comp#_top-email.gif" width=550 heignt=75></td>
		</tr>
		<tr>
			<td>
			<div align="justify">
			#get_branch.firstname# -
			<br><br>
			An account has been created for you on the #client.companyname# EXITS system by #agent_info.businessname#.  
			Using EXITS you will be able to create online student application accounts and view the status of your applicants as they are processed.<br><br>
			
			To activate your account, simply click on the EXITS Login Portal at #client.site_url# and login with the username and 
			password provided below. <br><br>		
			
			*username: #get_branch.username# <br>
			*password: #get_branch.password# <br>
			<br><br>
			
			If you have any questions about the application or the information you need to submit, please contact the main office of your international representative:
			<br><br>
			#agent_info.businessname#<br>
			#agent_info.phone#<br>
			#agent_info.email#<br><br>
			
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
			<font color="##CCCCCC"><font size=-1>Please add #client.support_email# to your whitelist to ensure it isn't marked as spam. #client.companyshort_nocolor# will
				not sell your address or use it for unsolicited emails.  This email was sent on behalf of #client.companyname# from an International Agent, listed above.  If you received this email as an unsolicited contact 
				about #client.companyshort_nocolor# or #client.companyshort_nocolor# subsidiaries, please contact #client.support_email#  </font></font>
			</Td>
		</tr>
	</cfmail>
		
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully resent the login information for #get_branch.businessname#. Thank You.");
		location.replace("?curdoc=branch/branch_info&branchid=#get_branch.userid#&sent");
	-->
	</script>
	</head>
	</html> 		
	
	</cfoutput>
	
<cfcatch type="any">
	<cfinclude template="../forms/error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>