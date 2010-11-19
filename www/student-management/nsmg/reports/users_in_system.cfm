<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Users in System</title>
</head>

<!--- STATISTICS REPORT --->
<style type="text/css">
	table.nav_bar { font-size: 10px; background-color: #ffffe6; border: 1px solid e2efc7; }
</style>

<body>

<cfinclude template="../querys/get_regions.cfm">

<!--- shor form --->
<cfif NOT IsDefined('form.usertype') AND NOT IsDefined('form.regionid')>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Users Privileges</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>

	<table border=0 cellpadding=8 cellspacing=2 width=100% class="section">
	<tr><td>
		<table width="96%" align="center" cellpadding=6 cellspacing="0">
		<tr>
			<td width="50%" valign="top">
			<cfform action="?curdoc=reports/users_in_system" method="POST">
				<Table class="nav_bar" align="center" cellpadding=6 cellspacing="0" width="100%">
					<tr><th colspan="2" bgcolor="e2efc7">Users In System (All Companies)</th></tr>
					<tr>
						<td>Usertype(s) :</td>
						<td><select name="usertype">
								<option value="1">Office</option>
								<option value="2">All Field</option>
								<!--- <option value="3">Intl. Reps.</option> --->
							</select>
						</td>
					</tr>
					<tr>
						<td>Region(s) :</td>
						<td><select name="regionid">
								<option value="0">All</option>
								<cfoutput query="get_regions">
									<option value="#regionid#">#regionname#</option>
								</cfoutput>
							</select>
						</td>
					</tr>					
					<tr>
						<td colspan="2" align="center" bgcolor="e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td>
					</tr>
				</table>
			</cfform>
			</td>
			<td width="50%" valign="top">
			</td>
		</tr>
		</table><br>
	
	</td></tr>
	</table>
	<cfinclude template="../table_footer.cfm">

<!--- show report --->
<cfelse>
	<cfquery name="users" datasource="MySQL">
	select smg_users.firstname, smg_users.lastname, smg_users.email, smg_users.lastlogin, smg_users.username,
	 smg_users.userid, smg_regions.regionname, user_access_rights.regionid, 
	 user_access_rights.usertype, user_access_rights.companyid, smg_companies.companyshort, smg_usertype.usertype as ut
	from smg_users
	LEFT JOIN user_access_rights ON user_access_rights.userid = smg_users.userid
	LEFT JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
	LEFT JOIN smg_usertype ON smg_usertype.usertypeid = user_access_rights.usertype
	LEFT JOIN smg_companies ON smg_companies.companyid = user_access_rights.companyid
	WHERE smg_users.active = 1 
	<cfif form.usertype EQ 1>
		AND (smg_users.usertype <= 4)
	<cfelseif form.usertype EQ 2>
		AND (smg_users.usertype >= '5' AND smg_users.usertype <= '7' OR  smg_users.usertype = '9')  
	</cfif>
	<cfif form.regionid NEQ '0'>
		AND smg_regions.regionid = '#form.regionid#'
	</cfif>
	ORDER BY lastname, firstname, companyshort
	</cfquery>
	
	<cfoutput>
	<Table width=100% cellspacing="0" cellpadding="2">
		<tr><td colspan="9">Active Users<cfif form.regionid NEQ '0'> assigned to #users.regionname#</cfif>.</td></tr>
		<tr>
			<td>ID</td><td>Last Name</td><td>First Name</td><td>Username</td><td>Company</td><td>Region Access</td><td>Access Level</td><td>Email</td><td>Last Login</td>
		</tr>
	<cfloop query="users">
	<tr  <cfif users.currentrow mod 2>bgcolor="##CCCCCC"</cfif>>
		<td>#userid#</td><td>#lastname#</td><td>#firstname#</td><td>#username#</td><td>#companyshort#</td><td>#regionname#</td><td>#ut#</td><td>#email#</td><Td>#DateFormat(lastlogin, 'mm/dd/yyyy')#</Td>
	</tr>
	</cfloop>
	</cfoutput>
	</Table>

</cfif>

</body>
</html>