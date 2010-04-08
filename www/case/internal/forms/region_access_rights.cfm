<script>
<!-- Begin
function areYouSure() { 
   if(confirm("You are about to delete this access level. Click OK to continue")) { 
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
<Cfquery name="session_usertype" datasource="caseusa">
	SELECT usertype
	FROM user_access_rights 
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer"> 
		  AND companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
	GROUP BY usertype
	ORDER BY usertype DESC 
</Cfquery>

<cfquery name="default_usertype" datasource="caseusa">
	select usertype 
	from smg_users
	where userid = #client.userid#
</cfquery>

<Cfif default_usertype.usertype EQ 1>
	<cfquery name="new_company_regions" datasource="caseusa">
		SELECT smg_regions.regionname, smg_regions.regionid
		FROM smg_regions
		WHERE company = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
		ORDER BY regionname
	</cfquery>
<Cfelseif client.usertype GTE 5 and client.userid neq 12703>
	<!--- GET USERS REGION --->
	<cfquery name="new_company_regions" datasource="caseusa"> 
		SELECT user_access_rights.regionid, smg_regions.regionname
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' AND user_access_rights.companyid = '#client.companyid#'
		ORDER BY default_region DESC, regionname
	</cfquery>
<cfelse>	
	<cfquery name="new_company_regions" datasource="caseusa">
		SELECT smg_regions.regionname, smg_regions.regionid
		FROM smg_regions
		WHERE company = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
		ORDER BY regionname 
	</cfquery>
</cfif>

<Cfquery name="rep_name" datasource="caseusa">
	SELECT firstname, lastname, userid, usertype
	FROM smg_users 
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer">
</Cfquery>

<cfquery name="usertypes" datasource="caseusa">
	SELECT usertype, usertypeid
	FROM smg_usertype
	WHERE active = 1 
		AND usertypeid >= '#client.usertype#'
		<!--- if it's an INTL. Rep do not give other options --->
		<cfif rep_name.usertype EQ '8'>
			AND usertypeid =  '#rep_name.usertype#'
		</cfif>
		<!--- Field Options --->
		<cfif client.usertype GTE '5'>
			AND usertypeid != '8' 
			AND usertypeid < '10'
		</cfif>
		<cfif client.usertype EQ '5' or client.usertype EQ '6'>
			AND usertypeid > '#client.usertype#'
			AND usertypeid < '10'
		</cfif>
		<!--- OFFICE --->
		<cfif client.usertype GTE '3' AND client.usertype LTE '4'>
			AND usertypeid > '2'
			AND usertypeid < '10'
		</cfif>		
</cfquery>	

<!----Regional & Company Information---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/usa.gif"></td>
		<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Company & Regional Access </td><td background="pics/header_background.gif" width=16></td>
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
		<form method="post" action="querys/update_access_info.cfm?userid=#url.userid#">
		<cfelse>
		<form method="post" action="querys/check_new_access.cfm?userid=#url.userid#">
		</Cfif>
		<input type="hidden" name="userid" value="#url.userid#">
	</cfoutput>
	
	You can set the access level per region for this user here.  Once all access level are set correctly, click Next.<br />
	<b>Facilitator level and up only need one region access per company. You can set the facilitator for a region under tools->region.</b>
	<br><br>

	<table width=80% align="center" cellpadding=4 cellspacing="0">
		<Tr>
			<td><b>Company</b></td><td><b>Region (ID)</b></td><td><b>Access Level</b></td><td><b>Reports to:</b></td><td></td><td></td>
		</Tr>			
			<cfoutput>
			
			<Cfquery name="region_company_access" datasource="caseusa">
				SELECT uar.companyid, uar.regionid, uar.usertype, uar.id, uar.advisorid,
					   r.regionname,
					   c.companyshort,
					   ut.usertype as usertypename, ut.usertypeid,
					   adv.firstname, adv.lastname
				FROM user_access_rights uar
				INNER JOIN smg_regions r ON r.regionid = uar.regionid
				INNER JOIN smg_companies c ON c.companyid = uar.companyid
				INNER JOIN smg_usertype ut ON ut.usertypeid = uar.usertype
				LEFT JOIN smg_users adv ON adv.userid = uar.advisorid
				WHERE uar.userid = '#url.userid#'
				ORDER BY c.companyshort, r.regionname
			</Cfquery>
						
			<cfloop query="region_company_access">
	
				<cfif #usertypeid# is 5>
					<cfquery name="check_manager_assignment" datasource="caseusa">
						SELECT user_access_rights.userid, user_access_rights.usertype, smg_users.firstname, smg_users.lastname
						FROM user_access_rights 
						INNER JOIN smg_users ON user_access_rights.userid = smg_users.userid
						WHERE user_access_rights.usertype = 5 AND regionid = #regionid# AND smg_users.userid <> #url.userid#
					</cfquery>
				</cfif>	
				<cfif #usertypeid# is 4>
					<cfquery name="check_facilitator_assignment" datasource="caseusa">
						select user_access_rights.userid, user_access_rights.usertype, smg_users.firstname, smg_users.lastname
						from user_access_rights 
						INNER JOIN smg_users on user_access_rights.userid = smg_users.userid
						where user_access_rights.usertype = 4 and regionid = #regionid# and smg_users.userid <> #url.userid#
					</cfquery>
				</cfif>	
				
				<tr <cfif usertypeid is 5><Cfif check_manager_assignment.recordcount gt 0>bgcolor="##FFC5C4"</cfif></cfif>
				    <cfif usertypeid is 4><Cfif check_facilitator_assignment.recordcount gt 0>bgcolor="##FFC5C4"</cfif></cfif>>
					<td>#companyshort#</Td>  
					<td>#regionname# (#regionid#)</td>
					<td><Cfif url.edit is #regionid#>	
							<select name="new_user_type">
							<cfloop query="usertypes">
								<option value='#usertypes.usertypeid#' <cfif usertypes.usertypeid eq url.usertypeid>selected</cfif>>#usertype#</option> 
							</cfloop>
							</select>
							<input type="hidden" name="id" value="#region_company_access.id#">
							<cfelse>#usertypename# </cfif></td>
					<td><Cfif url.edit is #regionid#>
						<cfquery name="get_advisors" datasource="caseusa">
							SELECT uar.regionid, uar.usertype, u.userid, u.firstname, u.lastname
							FROM user_access_rights uar
							INNER JOIN smg_users u ON uar.userid = u.userid
							WHERE uar.usertype = '6' and regionid = '#url.edit#'
							ORDER BY firstname
						</cfquery>					
						<select name="advisorid">
						<option value="0">Directly to Director</option>
						<cfif url.usertypeid GT '6'>
							<cfloop query="get_advisors">
							<option value="#userid#" <cfif url.advisorid is userid>selected</cfif>>#firstname# #lastname#</option>
							</cfloop>
						</cfif>
						</select>			
						<cfelse>
							<cfif advisorid is '0'>Directly to Director<cfelse>#firstname# #lastname#</cfif>
						</cfif></td>
					<Td><cfif isDefined('url.edit')>
							<cfif url.edit eq #regionid#><input name="submit" type="image" src="pics/arrow.gif" border=0><cfelse><a href="?curdoc=forms/region_access_rights&edit=#regionid#&userid=#url.userid#&usertypeid=#usertypeid#&advisorid=#advisorid#"><img src="pics/edit.png" border=0></a></cfif>
						<cfelse><a href="?curdoc=forms/region_access_rights&edit=#regionid#&usertypeid=#usertypeid#&advisorid=#advisorid#"><img src="pics/edit.png" border=0></a></cfif></Td>
					<td><a href="querys/delete_access_level.cfm?regionid=#regionid#&userid=#url.userid#" onClick="return areYouSure(this);"><img src="pics/delete.png" border=0></a></td> 
				</tr>
				
				<cfif #usertypeid# is 5>
					<Cfif check_manager_assignment.recordcount gt 0>
					<tr bgcolor="##FFC5C4">
						<td colspan=6><span class="get_attention">#check_manager_assignment.firstname#  #check_manager_assignment.lastname# is also assigned as a Regional Manager for this region. </span></td>
					</tr>
					</Cfif>
				</cfif>
				<cfif #usertypeid# is 4>
					<Cfif check_facilitator_assignment.recordcount gt 0>
					<tr bgcolor="##FFC5C4">
						<td colspan=6><span class="get_attention">#check_facilitator_assignment.firstname#  #check_facilitator_assignment.lastname# is also assigned as a Facilitator for this region. </span></td>
					</tr>
					</Cfif>
				</cfif>
			</cfloop>
			
			<Cfif isDefined('url.error') or isDefined('url.error1')>
			<tr>
				<td colspan=5>
				<table align="center" frame="box">
				<tr><td valign="top"><img src="pics/error.gif"></td>
					<td valign="middle"><font color="##CC3300"><cfif isDefined('url.error2')>Access level for this region already exists.<br>Click <img src="pics/edit.png" border=0> above to change the access.<cfelse>Please indicate both a region and an access level.</cfif></td></tr>
				</table>
				</td>
			</tr>
			</Cfif>
			<tr>
				<td>#original_company_info.companyshort#</td>
				<td><select name="new_access_region">
					<option value="0" selected></option>
					<cfloop query="new_company_regions">
					<option value="#new_company_regions.regionid#"<Cfif isDefined('url.error')><cfif url.error eq #regionid#>selected</cfif></Cfif>>#regionname#</option> 
					</cfloop>
					</select> 
				</td>
				<td><select name="new_access_type">
					<option value="0" selected></option>
					<cfloop query="usertypes">
					<option value="#usertypes.usertypeid#" <Cfif isDefined('url.error1')><cfif url.error1 eq #usertypes.usertypeid#>selected</cfif></Cfif>>#usertype#</option> 
					</cfloop>
					</select>														
				</td>
				<td><!--- <select name="new_advisorid">
					<option value="0">Directly to Director</option>
					</select> --->
				</td>
				<td colspan=2></Td>
				</tr>
		</cfoutput>
	</table>
	<br><br>
	<cfif url.edit eq 00>
	<cfoutput>
	<div class="button"><a href="?curdoc=user_info&userid=#url.userid#">Back to Users Info</a> &nbsp; &nbsp; &nbsp; &nbsp; <input name="submit" type="image" src="pics/next.gif" align="right" border=0></div>
	</cfoutput>
	<cfelse>
	</cfif> 
	</form>
	</td>
</tr>	
</table>
					
<!----footer of  regional table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
