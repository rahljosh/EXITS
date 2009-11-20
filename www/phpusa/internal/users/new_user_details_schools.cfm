<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cfif not IsDefined('url.order')>
	<cfset url.order = 'schoolid'>
</cfif>
<cfif not isDefined('url.boarding')>
<cfset boarding = 2>
</cfif>


<cfquery name="schools" datasource="mysql">
	SELECT php_schools.schoolid, schoolname, address, city, zip, email, phone, fax,
		website, contact, boarding_school,
		smg_states.state as us_state
	FROM php_schools
	LEFT JOIN smg_states ON smg_states.id = php_schools.state
	LEFT JOIN php_school_tuition ON php_school_tuition.schoolid = php_schools.schoolid
	<cfif boarding neq 2>
		WHERE boarding_school = #boarding#
	</cfif>
	<cfif not isDefined('url.all')>
		WHERE smg_states.state = '#user_info.state#'
	</cfif>
	ORDER BY #url.order#
</cfquery>

<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr>
		
		<td align="left">
		Viewing: <cfif not isDefined('url.all')>Viewing schools in #user_info.firstname#<cfif right(user_info.firstname, 1) is 's'>'<cfelse>'s</cfif> state. [ <A href="?curdoc=users/new_user_details&userid=#url.userid#&all">view all</A> ]<cfelse>Viewing schools from all states [ <A href="?curdoc=users/new_user_details&userid=#url.userid#">view #user_info.firstname#<cfif right(user_info.firstname, 1) is 's'>'<cfelse>'s</cfif>  state</a> ]</cfif><br>
		</td>
		<td align="right">
		Filter: <a href="">All</a> | <a href="">Boarding</a> | <a href="">Day</a> | <a href="">Not Specified</a>
			<!----<a href="reports/marketing_list.cfm" target="_blank">School Marketing List</a> &nbsp; | &nbsp;
			<a href="reports/school_list.cfm" target="_blank">School Contact List</a> &nbsp; | &nbsp;
			<a href="reports/school_labels.cfm" target="_blank">School Labels - Avery 5160</a>---->
		</td>
		
	</tr>
</table>
</cfoutput>
<table width=100% align="center" cellpadding="1"  border=0 cellpadding=0 cellspacing =0>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="10" background="images/back_menu2.gif"></td>
		<th width="26" background="images/back_menu2.gif" align="left"><a href="">ID</a></td>
		<th width="200" background="images/back_menu2.gif" align="left"><a href="">School Name</a></td>
		<th width="100" background="images/back_menu2.gif" align="left"><a href="">City</a></td>
		<th width="50" background="images/back_menu2.gif" align="left"><a href="">State</a></td>
		
		<th width="200" background="images/back_menu2.gif" align="left"><a href="">Contact</a></td>
		<th width="70" background="images/back_menu2.gif" align="left"><a href="">Boarding?</a></Td>
		<td width="10" background="images/back_menu2.gif"></td>
	</tr>
	<tr><td colspan="9">&nbsp;</td></tr>
	<cfif #schools.recordcount# eq 0>
	<Tr>
		<td colspan="9" align="center">No schools have been entered into the system or match the criteria you have specified.</td>
	</tr>
	<cfelse>
	<cfoutput>
	<tr><td colspan=10 align=left valign="top">
	<img src="pics/arrow_left_down.gif" align="left">Select all schools this user should have acces to. Schools can be added later as well. </tr>
	</td>
	</tr>
	<cfloop query="schools">
	<tr bgcolor="#iif(schools.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
		<td valign="top"><input type="checkbox" value=#schoolid# name="assignschool"></td>
		<td valign="top" class="style1">#schoolid# </td>
		<td valign="top" class="style1"><a href="">#schoolname#</a></td>
		<td valign="top" class="style1">#city#</td>
		<td valign="top" class="style1">#us_state#</td>
		
		<td valign="top" class="style1">#contact#</td>
		<td valign="top" class="style1"><cfif boarding_school eq 1>Yes<cfelseif boarding_school eq 0>No<cfelseif boarding_school eq 2>Both<cfelse>Not Specified</cfif></td>
		<td valign="top"></td>
	</tr>
	</cfloop>
	</cfoutput>
	</cfif>

</table>

</body>
</html>
