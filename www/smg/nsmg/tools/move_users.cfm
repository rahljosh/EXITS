<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Move users</title>
</head>

<body>
<cfoutput>
<cfquery name="get_division" datasource="mysql">
select *
from smg_companies
where companyid < 5
</cfquery>

<h2>Use the tools below to reassign users / students to different companies.</h2>
<form method="post" action="move_users.cfm">
Move the reps of user id <input name="userid" type="text" size=5 /> to the following divison: 
<select name"division"> 
<cfloop query="get_division">
	<option value=#get_division.companyid#>#team_id#</option>
</cfloop>
</select><br />


<br />
<input type="submit" value="Submit" />
</form>
<br /><br />

<cfif isDefined('form.userid')>

<cfquery name="get_user" datasource="mysql">
select firstname, lastname, city, userid
from smg_users
where userid = #form.userid#
</cfquery>
<cfquery name="get_rights" datasource="mysql">
select *, smg_regions.regionname, smg_usertype.usertype as ut, smg_companies.companyshort, smg_companies.team_id
from user_access_rights
LEFT JOIN smg_regions on smg_regions.regionid = user_access_rights.regionid
LEFT JOIN smg_usertype on smg_usertype.usertypeid = user_access_rights.usertype
LEFT JOIN smg_companies on smg_companies.companyid = user_access_rights.companyid
where userid = #form.userid#
</cfquery>
<cfif get_user.recordcount eq 0>
Invalid User Entered. Try again.
<cfabort>
</cfif>
The following information was found:<br />
<strong>#get_user.firstname# #get_user.lastname# (#get_user.userid#) from #get_user.city#</strong> <br />
The user is assigned to the following divisions and regions:<br />
<table width = 600>
	<tr>
		<td></td><td>Company /Div</td><td>Region</td><td>Access</td>
	</tr>
<cfloop query="get_rights">
	<tr>
		<td><input type="radio" value="#id#" name="region_to_reassign" <cfif get_rights.recordcount eq 1>selected</cfif>></td><td>#companyshort# - #team_id#</td><td> #regionname#</td><td> #ut#</td>
	</tr>
</cfloop>
</table>
<br />
Depending on the selection above the following users will also be transfered underneath this user. If  you want to assign the user to a new region, create the region through the Regions tool.  You can't add a region using this tool under the appropriate division.

<cfquery name="get_rights2" datasource="mysql">
select *, smg_regions.regionname, smg_usertype.usertype as ut, smg_companies.companyshort, smg_companies.team_id,
smg_users.firstname, smg_users.lastname
from user_access_rights
LEFT JOIN smg_regions on smg_regions.regionid = user_access_rights.regionid
LEFT JOIN smg_usertype on smg_usertype.usertypeid = user_access_rights.usertype
LEFT JOIN smg_companies on smg_companies.companyid = user_access_rights.companyid
LEFT JOIN smg_users on user_access_rights.userid = smg_users.userid
where advisorid = #form.userid#
order by user_access_rights.companyid
</cfquery>

<table width = 600>
	<tr>
		<td></td><td></td><td>Company /Div</td>Name<td>Region</td><td>Access</td>
	</tr>
<cfloop query="get_rights2">
	<tr>
		<td><input type="radio" value="#id#" name="region_to_reassign" <cfif get_rights.recordcount eq 1>selected</cfif>></td><Td>#firstname# #lastname#</Td><td>#companyshort# - #team_id#</td><td> #regionname#</td><td> #ut#</td>
	</tr>
</cfloop>
</table>


</cfif>

</cfoutput>
</body>
</html>
