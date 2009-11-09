<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<!--- <cftry> --->

<cfoutput>

<cftransaction action="begin" isolation="serializable">

	<cfset total_errors = 0>
	<cfloop from="1" to="2" index="i">
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
						<cfloop from="1" to="2" index="i">
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

	<cfquery name="check_user_access" datasource="MySql">
		SELECT userid, companyid, usertype
		FROM user_access_rights
		WHERE userid = '#form.userid#'
			AND companyid = '#form.companyid#'
	</cfquery>

	<cfif check_user_access.recordcount EQ 0>

		<cfquery name="user_access_rights" datasource="MySql">
			INSERT INTO user_access_rights
				(userid, companyid, usertype)
			VALUES
				('#form.userid#', '#form.companyid#', '#form.usertype#')
		</cfquery>
	
		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully granted access to this user. Thank You.");
			location.replace("?curdoc=user/users");
		-->
		</script>
		</head>
		</html> 	
	
	<!--- USER HAS ACCESS TO EXTRA --->
	<cfelse>	
		
		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("This user has already access to this Company in EXTRA.");
			location.replace("?curdoc=user/users");
		-->
		</script>
		</head>
		</html> 	

	</cfif>		

</cftransaction>

</cfoutput>	

<!--- <cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry> --->

</body>
</html>