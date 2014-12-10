<!----Set Default Usertype---->
<cfif NOT isDefined('url.usertype')>
	<cfset url.usertype = 'office'>
</cfif> 

<!----Set default Order by---->
<cfif NOT isDefined('url.order')>
	<cfif url.usertype EQ 'intagent'>
		<cfset url.order = 'businessname'>
	<cfelse>
		<cfset url.order = 'lastname'>
	</cfif>
</cfif> 

<cfif NOT isDefined('url.active')>
	<cfset url.active = 1>
</cfif> 

<cfquery name="users" datasource="mysql">
	SELECT users.firstname, users.businessname, users.lastname, users.phone, users.php_contact_phone, users.city, users.state, users.zip, users.country,
		users.email, users.userid, smg_countrylist.countryname, smg_states.state as st
	FROM smg_users users
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = users.country  
	LEFT JOIN smg_states ON smg_states.id = users.state  
	LEFT JOIN user_access_rights ON users.userid = user_access_rights.userid
	WHERE  	<cfif url.usertype is 'office'> 
				user_access_rights.usertype <= 4 AND user_access_rights.companyid = '#client.companyid#'
			<cfelseif url.usertype is 'intagent'> 
				user_access_rights.usertype = '8'
			<cfelseif url.usertype is 'reps'> 
				(user_access_rights.usertype = '7' AND user_access_rights.companyid = '#client.companyid#')
			</cfif>
	AND <cfif url.active is '1'>users.active = '1'<cfelse>users.active = '0'</cfif>
	GROUP BY users.userid
	ORDER BY #url.order#
</cfquery>

<cfoutput>

<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		<td bgcolor="e9ecf1"><h2 align="left">&nbsp;&nbsp;U s e r s</h2></td>
		<td bgcolor="e9ecf1" align="right">
			Filter:&nbsp; 
			<a href="?curdoc=lists/users&usertype=office"><cfif usertype is 'office'><font color="CC0000"></cfif>Office</font></a> &nbsp; | &nbsp;
			<a href="?curdoc=lists/users&usertype=intagent"><cfif usertype is 'intagent'><font color="CC0000"></cfif>International Partners</font></a> &nbsp; | &nbsp;
			<a href="?curdoc=lists/users&usertype=reps"><cfif usertype is 'reps'><font color="CC0000"></cfif>Local Reps</font></a> &nbsp; 
		</td></td>
	</tr>
</table><br />

<table align="center" bgcolor="e9ecf1" border=0 cellpadding=2 cellspacing=0 width="90%">
	<cfif url.usertype EQ 'intagent'>
	<tr>
		<td width="10" background="images/back_menu2.gif"></td>
		<th width="40" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=userid">ID</a></th>
		<th width="150" align="left"  background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=businessname">Business Name</a></th>
		<th width="150" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=firstname">First Name</a></th>
		<th width="120" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=lastname">Last Name</a></th>
		<th width="80" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=city">City</a></th>
		<th width="50" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=countryname">Country</a></th>
		<th width="130" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=phone">Phone</a></th>
		<td width="10" background="images/back_menu2.gif"></td>
	</tr>
	<cfelse>
	<tr>
		<td width="10" background="images/back_menu2.gif"></td>
		<th width="40" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=userid">ID</a></th>
		<th width="150" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=firstname">First Name</a></th>
		<th width="120" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=lastname">Last Name</a></th>
		<th width="80" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=city">City</a></th>
		<th width="50" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=state">State</a></th>
		<th width="130" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=phone">Phone</a></th>
		<th width="150" align="left" background="images/back_menu2.gif"><a href="?curdoc=lists/users&usertype=#url.usertype#&order=email">School(s)</a></th>
		<td width="10" background="images/back_menu2.gif"></td>
	</tr>
	</cfif>
	<tr><td colspan="9">&nbsp;</td></tr>
	
	<cfif #users.recordcount# eq 0>
		<Tr><td colspan="9" align="center">There are no users in the system that match the criteria specified.</td></tr>
	<cfelse>
	<cfloop query="users">
		<!----Schools associated with local contact---->
		<cfquery name="schools" datasource="mysql">
			select php_schools.schoolid, php_schools.schoolname
			from php_school_contacts, php_schools
			where php_school_contacts.schoolid = php_schools.schoolid
			and php_school_contacts.userid = #userid#
		</cfquery>
	
		<cfif url.usertype EQ 'intagent'>
		<tr <cfif users.currentrow mod 2>bgcolor="##ffffff"</cfif>>
			<td valign="top"></td>
			<td valign="top"><a href="?curdoc=users/user_info&userid=#userid#">#userid#</a> &nbsp;</td>
			<td width="100" align="left"><a href="?curdoc=users/user_info&userid=#userid#">#businessname#</a></td>
			<td valign="top"><a href="?curdoc=users/user_info&userid=#userid#">#firstname#</a></td>
			<td valign="top"><a href="?curdoc=users/user_info&userid=#userid#">#lastname#</a></td>
			<td valign="top">#city#</td>
			<td valign="top">#countryname#</td>
			<td valign="top"><cfif url.usertype EQ 'intagent'>#php_contact_phone#<cfelse>#phone#</cfif></td>
			<td valign="top"></td>
		</tr>
		<cfelse>
		<!--- <tr bgcolor="#iif(users.currentrow MOD 2 ,DE("ffffff") ,DE("white") )#"> --->
		<tr <cfif users.currentrow mod 2>bgcolor="##ffffff"</cfif>>
			<td valign="top"></td>
			<td valign="top"><a href="?curdoc=users/user_info&userid=#userid#">#userid#</a> &nbsp;</td>
			<td valign="top"><a href="?curdoc=users/user_info&userid=#userid#">#firstname#</a></td>
			<td valign="top"><a href="?curdoc=users/user_info&userid=#userid#">#lastname#</a></td>
			<td valign="top">#city#</td>
			<td valign="top">#st#</td>
			<td valign="top">#phone#</td>
			<td valign="top"><cfloop query="schools"><a href="?curdoc=forms/view_school&sc=#schools.schoolid#">#schools.schoolname#</a>,</cfloop></td></td>
			<td valign="top"></td>
		</tr>
		</cfif>
	</cfloop>
	</cfif>
	<tr>
	  <td colspan="9" align="center"><br>
	 	 <a href="index.cfm?curdoc=users/user_assign_question"><img src="pics/add-user.gif" border="0"></a>
		 <br><br>
		</td>
		<td align="center"></td>
	</tr>
</table>
</cfoutput>