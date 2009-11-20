<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Assign Users</title>
</head>

<body>
<!----Set Default Usertype---->
<cfif isDefined('url.usertype')>
	<cfset url.usertype = '#url.usertype#'>
<cfelse>
	<cfset url.usertype = 'us'>
</cfif> 

<!----Set default Order by---->

<cfif isDefined('url.order')>
	<cfset order = '#url.order#'>
<cfelse>
	<cfset order = 'lastname'>
</cfif> 

<cfquery name="users" datasource="mysql">
	SELECT DISTINCT u.firstname, u.businessname, u.lastname, u.phone, u.city, u.state, u.zip, u.email, u.userid, 
		smg_states.state as st
	FROM smg_users u
	INNER JOIN user_access_rights uar ON uar.userid = u.userid
	LEFT JOIN smg_states ON smg_states.id = u.state  
	WHERE uar.usertype = '7' 
		AND uar.companyid = '#client.companyid#'
	ORDER BY #order#
</cfquery>

<Cfoutput>
<form method="post" action="querys/asign_user.cfm?sc=#url.sc#">

<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		
		<td bgcolor="##e9ecf1"><h2 align="left">&nbsp;&nbsp;A s s i g n&nbsp;&nbsp;U s e r s</h2></td>
		<td bgcolor="##e9ecf1" align="right">
			</td></td>
		
	</tr><tr>
		<td>Click on Add or Remove to manage the local contacts for a school. When done, click on Back to School.</td>
	</tr>
</table>
<table  align="center" bgcolor="##e9ecf1" border=0 cellpadding=0 cellspacing =0 width="90%">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="10" background="images/back_menu2.gif"></td>
		<th width="40" align="left" background="images/back_menu2.gif">Add</td>
		<th width="150" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&order=firstname">First Name</a></td>
		<th width="120" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&order=lastname">Last Name</a></td>
		<th width="80" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&order=city">City</td>
		<th width="50" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&order=state">State</td>
		<th width="130" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&order=phone">Phone</td>
		<th width="100" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&order=email">School</td>
		<td width="10" background="images/back_menu2.gif"></td>
	</tr>
	<tr><td colspan="9">&nbsp;</td></tr>
	<cfif #users.recordcount# eq 0>
	<Tr>
		<td colspan="9" align="center">There are no users in the system that match the criteria specified.</td>
	</tr>
	<cfelse>
	<cfloop query="users">
	<!----Schools associated with local contact---->
		<cfquery name="schools" datasource="mysql">
			SELECT DISTINCT php_schools.schoolid, php_schools.schoolname, php_schools.manager
			FROM php_school_contacts
			INNER JOIN php_schools ON php_schools.schoolid = php_school_contacts.schoolid
			WHERE php_school_contacts.userid = '#userid#'
		</cfquery>
		
		<cfquery name="check_already" datasource="mysql">
			select recordid from php_school_contacts 
			where userid = #userid# and schoolid = #url.sc#
		</cfquery>
		
		<cfif users.currentrow mod 2>
			<tr bgcolor=##ffffff>
		<cfelse>
			<tr>
		</cfif>
		<td valign="top"></td>
		
		<cfif check_already.recordcount gt 0>
			<td valign="top"><a href="querys/assign_user.cfm?curdoc=users/assign_user&userid=#userid#&sc=#url.sc#&action=r">Remove</td>
		<cfelse>
			<td valign="top"><a href="querys/assign_user.cfm?curdoc=users/assign_user&userid=#userid#&sc=#url.sc#&action=a">ADD</a></td>
		</cfif>
		<td valign="top"><a href="?curdoc=users/user_info&userid=#userid#">#firstname#</a></td>
		<td valign="top"><a href="?curdoc=users/user_info&userid=#userid#">#lastname#</a></td>
		<td valign="top">#city#</td>
		<td valign="top">#st#</td>
		<td valign="top">#phone#</td>
		
		<td valign="top"><Cfif schools.recordcount gt 1><cfloop query="schools"><a href="?curdoc=forms/view_school&sc=#schools.schoolid#">#schools.schoolname#</a>,</cfloop><cfelse><a href="?curdoc=forms/view_school&sc=#schools.schoolid#">#schools.schoolname#</a></Cfif></td></td>
		
		<td valign="top"></td>
	</tr>
	</cfloop>
	</cfif>
	
	<tr>
	  <td colspan="9" align="center"><br>
		<a href="?curdoc=forms/view_school&sc=#url.sc#">Back to School</a>
            <br>
            <br>
			</td>
			

		<td align="center"></td>
	</tr>
</table>
</table>

</form>
</cfoutput>

</body>
</html>
