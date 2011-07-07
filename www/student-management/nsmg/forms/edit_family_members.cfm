<script>
<!-- Begin
function areYouSure() { 
   if(confirm("You are about to delete this household member. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
// End -->
</SCRIPT>

<!--- CHECK RIGHTS --->
<cfinclude template="../check_rights.cfm">

<!--- gets the current user trying to edit / add new regions --->
<Cfquery name="family_members" datasource="MySQL">
	select firstname, lastname, middlename, dob, relationship, no_members, ssn, id, drivers_license,auth_received, auth_received_type
	from smg_user_family
	where userid = #url.userid#
</Cfquery>

<Cfquery name="rep_name" datasource="MySQL">
	SELECT firstname, lastname, userid, usertype
	FROM smg_users 
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer">
</Cfquery>

<!----Regional & Company Information---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Family Members </td><td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfif not isDefined('url.edit')><cfset url.edit = 00></cfif>
		
<table width=100% cellpadding=10 cellspacing=0 border=0 class="section" >
<tr>
	<td style="line-height:20px;" valign="top">
	<cfoutput>
		<h2>#rep_name.firstname# #rep_name.lastname# (#userid#)</h2>
		<Cfif url.edit neq 00>
		<form method="post" action="querys/update_member_info.cfm?userid=#url.userid#">
		<cfelse>
		<form method="post" action="querys/check_new_family.cfm?userid=#url.userid#">
		</Cfif>
		<input type="hidden" name="userid" value="#url.userid#">
		
	</cfoutput>
	
	Please keep the list of people who are living with this rep current.<br><br>

	<table width=100% align="center" cellpadding=4 cellspacing="0">
		<Tr>
			<td><b>First Name</b></td><td><b>Middle Name</b></td><td><b>Last Name</b></td><td><b>Relationship</b></td><td><b>Birthdate</b></td><td></td><td></td>
		</Tr>			
			<cfoutput query="family_members">
			<cfif no_members eq 1>
			<tr>
				<TD colspan=5>It is currently recoreded that no one else lives in this household. If this has changed, enter the details below.</TD>
			</tr>
			<cfelse>
			<tr>
				
				<td><cfif url.edit eq #id#><input type="hidden" name=edit value= #url.edit#><input type="text" name="firstname" size=16 value=#firstname#>
				<cfelse>#firstname#</cfif></td>
				<td><cfif url.edit eq #id#><input type="text" name="middlename" size=16 value="#middlename#">
				<cfelse>#middlename#</cfif></td>				
				<td><cfif url.edit eq #id#><input type="text" name="lastname" size=16 value=#lastname#>
				<cfelse>#lastname#</cfif></td>				
				<td><cfif url.edit eq #id#><input type="text" name="relationship" size=16 value=#relationship#>
				<cfelse>#relationship#</cfif></td>
				<td><cfif url.edit eq #id#><input type="text" name="dob" size=8 value=#DateFormat(dob, 'mm/dd/yyyy')#>
				<cfelse>#DateFormat(dob, 'mm/dd/yyyy')# - (#DateDiff('yyyy', dob, now() )# yrs.)</cfif></td>
				<Td><cfif isDefined('url.edit')>
							<cfif url.edit eq #id#><input name="submit" type="image" src="pics/arrow.gif" border=0><cfelse>
							<a href="?curdoc=forms/edit_family_members&edit=#id#&userid=#url.userid#">
							<img src="pics/edit.png" border=0></a></cfif>
						<cfelse><a href="?curdoc=forms/region_access_rights"><img src="pics/edit.png" border=0></a></cfif></Td>
					<td><a href="querys/delete_family_member.cfm?id=#id#&userid=#url.userid#" onClick="return areYouSure(this);"><img src="pics/delete.png" border=0></a></td> 
			</tr>
			</cfif>
			</cfoutput>
			<tr>
				<td><input type="text" name="firstname" size=16></td>
				<td><input type="text" name="middlename" size=16></td>
				<td><input type="text" name="lastname" size=16></td>
				<td><input type="text" name="relationship" size=16></td>
				<td><input type="text" name="dob" size=8></td>
			</tr>	
			<cfif family_members.recordcount eq 0>
			<tr>
				<TD colspan=2><input type="checkbox" name=no_members value=1>No one else lives in this household.</TD>
			</tr>
			</cfif>
		
	</table>
	<br><br>
	<cfif url.edit eq 00>
	<cfoutput>
	<div class="button"><a href="?curdoc=user_info&userid=#url.userid#">Back to Users Info</a> &nbsp; &nbsp; &nbsp; &nbsp; <input name="submit" type="image" src="pics/next.gif" align="right" border=0 alt="next"></div>
	</cfoutput>
	<cfelse>
	</cfif> 
	</form>
	</td>
</tr>	
</table>
					
<!---- footer of  regional table ---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>