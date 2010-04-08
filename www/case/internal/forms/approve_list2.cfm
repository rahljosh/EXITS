<link rel="stylesheet" href="../smg.css" type="text/css">

<cfsetting requesttimeout="500">

<cfdump var=#client#>

<!--- get company region --->
<cfquery name="get_region" datasource="caseusa">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid is 0><cfelse>AND regionid = '#client.regionid#'</cfif>
	ORDER BY regionname
</cfquery>

<cfloop query="get_region">

<cfset region = '#get_region.regionid#'>

<cfquery name="hierarchy" datasource="caseusa">
	select regionid, regionname, regionfacilitator
	from smg_regions
	where regionid = #region#
</cfquery>

<cfquery name="facilitator" datasource="caseusa">
	select firstname, lastname, userid, address, address2, city, state, zip, phone, email, fax
	from smg_users
	where userid = #hierarchy.regionfacilitator#
</cfquery>

<Cfquery name="rep_count" datasource="caseusa">
	select userid
	from user_access_rights
	where regionid = #region# and usertype BETWEEN 5 and 7
</Cfquery>

<cfquery name="regional_director" datasource="caseusa">
	SELECT smg_users.firstname, smg_users.lastname, smg_users.userid, smg_users.address, smg_users.address2, smg_users.city, smg_users.state, smg_users.zip, smg_users.phone, smg_users.email, smg_users.fax,
			user_access_rights.userid, user_Access_rights.usertype, user_Access_rights.companyid, user_access_rights.regionid
	FROM smg_users 
	INNER JOIN user_Access_rights on smg_users.userid = user_Access_rights.userid
	WHERE user_access_rights.regionid = #region# and user_access_rights.usertype = 5 AND smg_users.active = '1'
</cfquery>

<cfoutput>
<!--- <div id="pagecell_reports"> --->




<Table width=90% align="center" frame=below cellpadding=2 cellspacing="0" border=0>
	<tr><td colspan="5"><font size=-1>Sorted By: <b>#Ucase(form.orderby)#</b></font></td></tr>
	<tr>
		<td width=5></td><td width=5></td><td><u>Representative</td><td><u>Address</td><td><u>Email</td><td><u>Phone</td><td><u>Fax</td>
	<tr>
		<th bgcolor="##CCCCCC" colspan=7 align="left"><span class="get_attention"><b>></b></span>Reps that report directly to <Cfoutput>#regional_director.firstname# #regional_director.lastname#:</Cfoutput></td>
	</tr>
		<cfif isDefined('form.students') AND regional_director.userid NEQ ''>
			<Cfquery name="get_Students" datasource="caseusa">
				SELECT smg_students.familylastname as stu_last, smg_students.firstname, smg_students.hostid, smg_students.dateplaced, smg_hosts.hostid, smg_hosts.familylastname
				FROM smg_students INNER JOIN smg_hosts on (smg_students.hostid = smg_hosts.hostid)
				WHERE smg_students.arearepid = #regional_director.userid# and smg_students.active = 1
			</Cfquery>
			<cfif get_students.recordcount eq 0>
			<tr bgcolor='##FFFFcc'>
				<td width=5 bgcolor='##ededed'></td><td width=5  bgcolor='##FFFFcc'></td><td colspan=5>Not supervising any students.</td>
			</tr>
			<cfelse>
			<tr bgcolor='##FFFFCC'>
				<td width=5 bgcolor='##ededed'></td><td width=5  bgcolor='##FFFF66'></td><td><u>Student</u></td><td><u>Host Family</u></td><Td><u>Date Placed</u></Td><td></td><td></td>
			</tr>
			<cfloop query="get_Students">
				<Tr bgcolor='##FFFF66'>
					<td width=5 bgcolor='##ededed'></td><td bgcolor='##FFFF66'></td><td>#firstname# #stu_last#</td><td>#familylastname#</td><td>#DateFormat(dateplaced, 'mm/dd/yyyy')#</td><td>&nbsp;</td><td></td>
				</Tr>
			</cfloop>
		</cfif>
	</cfif>

	<!--- Advisors and Areas Under Manager --->
	<cfquery name="userinfo" datasource="caseusa">
		SELECT smg_users.firstname, smg_users.lastname, smg_users.userid, smg_users.address, smg_users.address2, smg_users.city, smg_users.state, 
				smg_users.zip, smg_users.phone, smg_users.email, smg_users.fax, user_access_rights.userid, user_Access_rights.usertype, user_Access_rights.companyid, user_access_rights.regionid
		FROM smg_users 
		INNER JOIN user_Access_rights ON smg_users.userid = user_Access_rights.userid
		WHERE user_access_rights.regionid = #region# AND user_access_rights.usertype BETWEEN 6 and 7 
			  AND user_Access_rights.advisorid = 0 AND smg_users.active = '1'
			and (datecreated between #CreateODBCDateTime(form.beg_date)# and #CreateODBCDateTime(form.end_date)#)
		ORDER BY #form.orderby#
	</cfquery>
	
	<cfloop query="userinfo">
			<tr <cfif isDefined('form.students')> bgcolor="ededed"><cfelse>bgcolor="#iif(userinfo.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" ></cfif>
				<td width=5></td><td width=5></td><td><Cfif #form.orderby# is 'firstname'><b>#userinfo.firstname# 1</b><cfelse>#userinfo.firstname#</Cfif> <Cfif #form.orderby# is 'lastname'><b>#userinfo.lastname#</b><cfelse>#userinfo.lastname#</Cfif><Cfif #form.orderby# is 'userid'><b>(#userinfo.userid#)</b><cfelse>(#userinfo.userid#)</Cfif> </td><td>#userinfo.address# <cfif #userinfo.address2# is ''><cfelse>#userinfo.address2#</cfif><Cfif #form.orderby# is 'city'><b>#userinfo.city#</b><Cfelse>#userinfo.city#</Cfif>  <Cfif #form.orderby# is 'state'><b>#userinfo.state#</b><Cfelse>#userinfo.state#</Cfif> #userinfo.zip#</td><td><a href="mailto:#userinfo.email#"><cfif #form.orderby# is 'email'><b><font color="black">#userinfo.email#</font></b><Cfelse><font color="black">#userinfo.email#</font></cfif></a></td><td><Cfif #form.orderby# is 'phone'><b>#userinfo.phone#</b><cfelse>#userinfo.phone#</Cfif></td><td><cfif #form.orderby# is 'fax'><b>#userinfo.fax#</b><cfelse>#userinfo.fax#</cfif></td>
			</tr>
			<cfif isDefined('form.students')>
			<Cfquery name="get_Students" datasource="caseusa">
				select smg_students.familylastname as stu_last, smg_students.firstname, smg_students.hostid, smg_students.dateplaced, smg_hosts.hostid, smg_hosts.familylastname
				from smg_students right join smg_hosts on (smg_students.hostid = smg_hosts.hostid)
				where smg_students.arearepid = #userid# and smg_students.active = 1
			</Cfquery>
			<cfif get_students.recordcount eq 0>
					<tr bgcolor='##FFFFcc'>
						<td width=5 bgcolor='##ededed'></td><td width=5  bgcolor='##FFFFcc'></td><td colspan=5>Not supervising any students.</td>
					</tr>
			<cfelse>
					<tr bgcolor='##FFFFCC'>
						<td width=5 bgcolor='##ededed'></td><td width=5  bgcolor='##FFFF66'></td><td><u>Student</u></td><td><u>Host Family</u></td><Td><u>Date Placed</u></Td><td></td><td></td>
					</tr>
				<cfloop query="get_Students">
					<Tr bgcolor='##FFFF66'>
						<td width=5 bgcolor='##ededed'></td><td bgcolor='##FFFF66'></td><td>#firstname# #stu_last#</td><td>#familylastname#</td><td>#DateFormat(dateplaced, 'mm/dd/yyyy')#</td><td>&nbsp;</td><td></td>
					</Tr>
				</cfloop>
				</cfif>
			</cfif>
	</cfloop>
	</tr>
	<cfquery name="get_ra" datasource="caseusa">
		SELECT smg_users.firstname, smg_users.lastname, smg_users.userid, user_access_rights.regionid, user_access_rights.usertype 
		FROM smg_users 
		INNER JOIN user_access_rights ON smg_users.userid = user_access_rights.userid 
		WHERE user_access_rights.usertype = 6 and regionid = #region# AND smg_users.active = '1'
		ORDER BY #form.orderby#
	</cfquery>
<cfloop query="get_ra" >
<tr>
	<td bgcolor="CCCCCC" colspan=7 align="left"><span class="get_attention"><b>></span> Regional Advisor:  #get_ra.firstname# #get_ra.lastname#</td>
</tr>
		<cfif isDefined('form.students')>
			<Cfquery name="get_Students" datasource="caseusa">
			select smg_students.familylastname as stu_last, smg_students.firstname, smg_students.hostid, smg_students.dateplaced, smg_hosts.hostid, smg_hosts.familylastname
			from smg_students right join smg_hosts on (smg_students.hostid = smg_hosts.hostid)
			where smg_students.arearepid = #get_ra.userid#
			</Cfquery>
			<cfif get_students.recordcount eq 0>
					<tr bgcolor='##FFFFcc'>
						<td width=5 bgcolor='##ededed'></td><td width=5  bgcolor='##FFFFcc'></td><td colspan=5>Not supervising any students.</td>
					</tr>
			<cfelse>
					<tr bgcolor='##FFFFCC'>
						<td width=5 bgcolor='##ededed'></td><td width=5  bgcolor='##FFFF66'></td><td><u>Student</u></td><td><u>Host Family</u></td><Td><u>Date Placed</u></Td><td></td><td></td>
					</tr>
				<cfloop query="get_Students">
					<Tr bgcolor='##FFFF66'>
						<td width=5 bgcolor='##ededed'></td><td bgcolor='##FFFF66'></td><td>#firstname# #stu_last#</td><td>#familylastname#</td><td>#DateFormat(dateplaced, 'mm/dd/yyyy')#</td><td>&nbsp;</td><td></td>
					</Tr>
				</cfloop>
				</cfif>
		</cfif>
		<!--- Get Area Reps under Advisors --->
		<cfquery name="get_ar" datasource="caseusa">
			SELECT uar.regionid, uar.usertype,
				u.firstname, u.lastname, u.userid, u.address, u.address2, u.city, u.state, u.zip, u.phone, u.fax, u.email, u.datecreated  
			FROM smg_users u
			INNER JOIN user_access_rights uar ON u.userid = uar.userid 
			WHERE uar.advisorid = '#get_ra.userid#' AND uar.regionid = '#region#' AND uar.usertype = '7' AND u.active = '1'
			and (datecreated between #CreateODBCDateTime(form.beg_date)# and #CreateODBCDateTime(form.end_date)#)
			ORDER BY #form.orderby#				
		</cfquery>
		
		<cfif get_ar.recordcount eq 0><tr>
			<td width=5 bgcolor='##ededed'></td><td width=5></td><td>No reps report to this advisor.</td>
			</tr>
		<cfelse>
			<cfloop query="get_ar">
			<tr <cfif isDefined('form.students')> bgcolor="ededed"><cfelse>bgcolor="#iif(userinfo.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" ></cfif>
				<td width=5 bgcolor='##ededed'></td><td width=5></td><td><Cfif #form.orderby# is 'firstname'><b>#firstname# </b><cfelse>#firstname#</Cfif> <Cfif #form.orderby# is 'lastname'><b>#lastname# </b><cfelse>#lastname#</Cfif><Cfif #form.orderby# is 'userid'><b>(#userid#)</b><cfelse>(#userid#)</Cfif> </td><td>#address# <cfif #address2# is ''><cfelse>#address2#</cfif><Cfif #form.orderby# is 'city'><b>#city#</b><Cfelse>#city#</Cfif>  <Cfif #form.orderby# is 'state'><b>#state#</b><Cfelse>#state#</Cfif> #zip#</td><td><a href="mailto:#email#"><cfif #form.orderby# is 'email'><b><font color="black">#email#</font></b><Cfelse><font color="black">#email#</font></cfif></a></td><td><Cfif #form.orderby# is 'phone'><b>#phone#</b><cfelse>#phone#</Cfif></td><td><cfif #form.orderby# is 'fax'><b>#fax#</b><cfelse>#fax#</cfif></td>
			</tr>
			<cfif isDefined('form.students')>
			<Cfquery name="get_Students" datasource="caseusa">
			select smg_students.familylastname as stu_last, smg_students.firstname, smg_students.hostid, smg_students.dateplaced, smg_hosts.hostid, smg_hosts.familylastname
			from smg_students right join smg_hosts on (smg_students.hostid = smg_hosts.hostid)
			where smg_students.arearepid = #get_ar.userid# and smg_students.active = 1
			</Cfquery>
			<cfif get_students.recordcount eq 0>
					<tr bgcolor='##FFFFcc'>
						<td width=5 bgcolor='##ededed'></td><td width=5  bgcolor='##FFFFcc'></td><td colspan=5>Not supervising any students.</td>
					</tr>
			<cfelse>
					<tr bgcolor='##FFFFCC'>
						<td width=5 bgcolor='##ededed'></td><td width=5  bgcolor='##FFFF66'></td><td><u>Student</u></td><td><u>Host Family</u></td><Td><u>Date Placed</u></Td><td></td><td></td>
					</tr>
				<cfloop query="get_Students">
					<Tr bgcolor='##FFFF66'>
						<td width=5 bgcolor='##ededed'></td><td bgcolor='##FFFF66'></td><td>#firstname# #stu_last#</td><td>#familylastname#</td><td>#DateFormat(dateplaced, 'mm/dd/yyyy')#</td><td>&nbsp;</td><td></td>
					</Tr>
				</cfloop>
				</cfif>
			</cfif>
		</cfloop>
		</cfif>
</cfloop>
<cfif isDefined('form.viewonly')>

<tr>
	<td bgcolor="CCCCCC" colspan=7 align="left"><span class="get_attention"><b>></span>Users that have View Privileges in this Region:</td>
</tr>
<cfquery name="users_with_view" datasource="caseusa">
select user_access_rights.userid, smg_users.userid, smg_users.firstname, smg_users.lastname,
	smg_users.address, smg_users.address2, smg_users.email, smg_users.phone, smg_users.fax, smg_users.city, smg_users.state, smg_users.zip
from user_access_rights right join smg_users on user_access_rights.userid = smg_users.userid
where user_access_rights.usertype = 9 and user_access_rights.regionid = #region#
</cfquery>
	
	<cfloop query="users_with_view">
			<tr bgcolor="#iif(users_with_view.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" >
				<td width=5></td><td width=5></td><td><Cfif #form.orderby# is 'firstname'><b>#users_with_view.firstname# 1</b><cfelse>#users_with_view.firstname#</Cfif> <Cfif #form.orderby# is 'lastname'><b>#users_with_view.lastname#</b><cfelse>#users_with_view.lastname#</Cfif><Cfif #form.orderby# is 'userid'><b>(#users_with_view.userid#)</b><cfelse>(#users_with_view.userid#)</Cfif> </td><td>#users_with_view.address# <cfif #users_with_view.address2# is ''><cfelse>#users_with_view.address2#</cfif><Cfif #form.orderby# is 'city'><b>#users_with_view.city#</b><Cfelse>#users_with_view.city#</Cfif>  <Cfif #form.orderby# is 'state'><b>#users_with_view.state#</b><Cfelse>#users_with_view.state#</Cfif> #users_with_view.zip#</td><td><a href="mailto:#userinfo.email#"><cfif #form.orderby# is 'email'><b><font color="black">#users_with_view.email#</font></b><Cfelse><font color="black">#users_with_view.email#</font></cfif></a></td><td><Cfif #form.orderby# is 'phone'><b>#users_with_view.phone#</b><cfelse>#users_with_view.phone#</Cfif>
				</td> <td><cfif #form.orderby# is 'fax'><b>#users_with_view.fax#</b><cfelse>#users_with_view.fax#</cfif></td>
			</tr>
	</cfloop>

</cfif>
</Table><br>
</div>

</cfoutput>

</cfloop>