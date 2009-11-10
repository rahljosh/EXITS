<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>User Information</title>
</head>

<script language="JavaScript"> 	
<!--//
// opens letters in a defined format
function OpenWindow(url) {
	newwindow=window.open(url, 'Application', 'height=300, width=720, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>

<body>

<cfif not IsDefined('url.userid')>
	Sorry, an error has ocurred. Please go back and try again.
	<cfabort>
</cfif>

<cfquery name="get_companies" datasource="MySql">
	SELECT companyshort, companyid
	FROM smg_companies
	ORDER BY companyshort
</cfquery>

<cfquery name="get_user" datasource="MySql">
	SELECT userid, firstname, lastname, dob, ssn
	FROM smg_users
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_cbc_user" datasource="MySql">
	SELECT cbcid, userid, smg_users_cbc.companyid, requestid, date_authorized , date_sent, date_received, flagcbc, smg_users_cbc.seasonid, 
		smg_seasons.season,
		c.companyshort
	FROM smg_users_cbc
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_users_cbc.seasonid
	LEFT JOIN smg_companies c ON c.companyid = smg_users_cbc.companyid
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer"> 
		AND familyid = '0'
	ORDER BY smg_seasons.season
</cfquery>

<cfset season_list = ValueList(get_cbc_user.seasonid)>

<cfquery name="get_seasons" datasource="MySql">
	SELECT seasonid, season, active
	FROM smg_seasons
	WHERE active = '1'
	<!--- get remaining seasons --->
	<cfif get_cbc_user.recordcount GT '0'>		
		AND ( <cfloop list="#season_list#" index='cbc_seasons'>
			 seasonid != '#cbc_seasons#'
			 <cfif cbc_seasons EQ #ListLast(season_list)#><Cfelse>AND</cfif>
		  </cfloop> )
	</cfif>
	ORDER BY season
</cfquery>

<cfquery name="get_family_members" datasource="MySql">
	SELECT id, firstname, lastname, (DATEDIFF(now( ) , dob)/365)
	FROM smg_user_family 
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer">
		AND (DATEDIFF(now( ) , dob)/365) > 18
	ORDER BY id
</cfquery>

<cfoutput>
<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
	<td background="pics/header_background.gif"><h2>Criminal Background Check</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="?curdoc=cbc/qr_users_cbc" method="post">
<cfinput type="hidden" name="userid" value="#url.userid#">
<cfinput type="hidden" name="family" value="#get_family_members.recordcount#">

<!--- list cbcs --->
<cfset user_cbcid = ValueList(get_cbc_user.cbcid)>
<cfinput type="hidden" name="user_cbcid" value="#user_cbcid#">

<cfset membersid = ValueList(get_family_members.id)>
<cfinput type="hidden" name="membersid" value="#membersid#">

<table border=0 cellpadding=4 cellspacing=0 width="100%" class="section">
	<tr><td colspan="6">&nbsp;</td></tr>
	<tr><th colspan="6" bgcolor="e2efc7">#get_user.firstname# #get_user.lastname# (###get_user.userid#)</th><th bgcolor="e2efc7"><a href="javascript:OpenWindow('cbc/user_info.cfm?userid=#url.userid#');">Edit User Info</a></th></tr>
	<tr>
		<th valign="top">Company</th>
		<th valign="top">Season</th>		
		<th valign="top">Authorization Received <br><font size="-2">mm/dd/yyyy</font></th>		
		<th valign="top">CBC Sent <br><font size="-2">mm/dd/yyyy</font></th>		
		<th valign="top">CBC Received <br><font size="-2">mm/dd/yyyy</font></th>
		<th valign="top">Request ID</th>
		<th valign="top">Flag CBC</th>
		<td width="20%">&nbsp;</td>
	</tr>
	<cfinput type="hidden" name="count" value="#get_cbc_user.recordcount#">
	<!--- UPDATE --->
	<cfif get_cbc_user.recordcount NEQ '0'>
		<cfloop query="get_cbc_user">
		<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
			<td align="center">
				<cfif date_sent EQ ''>
					<cfselect name="companyid#currentrow#" required="yes" message="You must select a company">
						<option value="0"></option>
						<cfloop query="get_companies">
						<option value="#companyid#" <cfif get_companies.companyid EQ get_cbc_user.companyid>selected</cfif>>#companyshort#</option>
						</cfloop>
					</cfselect>
				<cfelse>
					#companyshort#
					<cfinput type="hidden" name="companyid#currentrow#" value="#companyid#">
				</cfif>
			</td>
			<td align="center"><b>#season#</b> <cfinput type="hidden" name="cbcid#currentrow#" value="#cbcid#"></td>
			<td align="center">
				<cfif date_sent EQ ''>
					<cfinput type="Text" name="date_authorized#currentrow#" size="8" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#" validate="date" maxlength="10">
				<cfelse>
					#DateFormat(date_authorized, 'mm/dd/yyyy')#
					<cfinput type="hidden" name="date_authorized#currentrow#" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#">
				</cfif>
			</td>
			<td align="center"><cfif date_sent EQ ''>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
			<td align="center"><cfif date_received EQ ''>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
			<td align="center">#requestid#</td>
			<td align="center"><input type="checkbox" name="flagcbc_#cbcid#" <cfif flagcbc EQ 1>checked="checked"</cfif>></td>
			<td width="20%">&nbsp;</td>
		</tr>
		</cfloop>
	</cfif>
	<!--- NEW CBC --->
	<cfif get_seasons.recordcount GT '0'>
		<cfif get_user.dob EQ ''>
			<tr><td colspan="6">Date of birth cannot be blank. Please check the DOB before you continue.</td></tr>
			<cfinput type="hidden" name="seasonid" value="0">
		<cfelseif get_user.ssn EQ ''>
			<tr><td colspan="6">SSN cannot be blank. Please check the SSN before you continue.</td></tr>
			<cfinput type="hidden" name="seasonid" value="0">
		<cfelse>
			<tr>
				<td align="center">
					<cfselect name="companyid" required="yes" message="You must select a company">
						<cfloop query="get_companies">
						<option value="#companyid#" <cfif get_companies.companyid EQ client.companyid>selected</cfif>>#companyshort#</option>
						</cfloop>
					</cfselect>
				</td>		
				<td align="center">
					<cfselect name="seasonid" required="yes" message="You must select a season">
						<option value="0">Select a Season</option>
						<cfloop query="get_seasons">
						<option value="#seasonid#">#season#</option>
						</cfloop>
					</cfselect>
				</td>
				<td align="center"><cfinput type="Text" name="date_authorized" size="8" value="" validate="date" maxlength="10"></td>
				<td align="center">n/a</td>
				<td align="center">n/a</td>
				<td align="center">n/a</td>
				<td width="20%">&nbsp;</td>
			</tr>
			<tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
		</cfif>
	<cfelse>
		<cfinput type="hidden" name="seasonid" value="0">
	</cfif>
	<tr><td colspan="6">&nbsp; <br><br></td></tr>

	<!--- OTHER FAMILY MEMBERS --->
	<tr><th colspan="6" bgcolor="e2efc7">Other Family Members 18 years old and older</th><th bgcolor="e2efc7"><a href="javascript:OpenWindow('cbc/user_member_info.cfm?userid=#url.userid#');">Edit Member(s) Info</a></th></tr>
	<tr><td colspan="6">&nbsp;</td></tr>
	<cfif get_family_members.recordcount EQ '0'>
	<tr><td colspan="6" align="center">There are no family members.</td></tr>
	<tr><td colspan="6">&nbsp;</td></tr>
	<cfelse>	
		<cfloop query="get_family_members">
			<cfset family_id = '#get_family_members.id#'>	
			<cfquery name="get_cbc_family" datasource="MySql">
				SELECT cbcid, smg_users_cbc.companyid, date_authorized, requestid, date_sent, date_received, smg_users_cbc.seasonid, 
					smg_seasons.season,
					c.companyshort
				FROM smg_users_cbc
				LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_users_cbc.seasonid
				LEFT JOIN smg_companies c ON c.companyid = smg_users_cbc.companyid
				WHERE familyid = <cfqueryparam value="#family_id#" cfsqltype="cf_sql_integer"> 
				ORDER BY smg_seasons.season
			</cfquery>
			<cfset season_list = ''>
			<cfset season_list = ValueList(get_cbc_family.seasonid)>
			<cfquery name="get_fam_seasons" datasource="MySql">
				SELECT seasonid, season, active
				FROM smg_seasons
				WHERE active = '1'
				<!--- get remaining seasons --->
				<cfif get_cbc_family.recordcount GT '0'>		
					AND ( <cfloop list="#season_list#" index='cbc_seasons'>
						 seasonid != '#cbc_seasons#'
						 <cfif cbc_seasons EQ #ListLast(season_list)#><Cfelse>AND</cfif>
					  </cfloop> )
				</cfif>
				ORDER BY season
			</cfquery>
			<tr><th colspan="6" bgcolor="e2efc7">#firstname# #lastname#</th><th bgcolor="e2efc7"></th></tr>
			<tr>
				<td align="center" valign="top"><b>Company</b></td>
				<td align="center" valign="top"><b>Season</b></td>		
				<td align="center" valign="top"><b>Authorization Received</b> <br><font size="-2">mm/dd/yyyy</font></td>		
				<td align="center" valign="top"><b>CBC Sent</b> <br><font size="-2">mm/dd/yyyy</font></td>		
				<td align="center" valign="top"><b>CBC Received</b> <br><font size="-2">mm/dd/yyyy</font></td>
				<td align="center" valign="top"><b>Request ID</b></td>
				<td width="20%">&nbsp;</td>
			</tr>
			<cfinput type="hidden" name="#family_id#count" value="#get_cbc_family.recordcount#">
			<!--- UPDATE DATE RECEIVED --->
			<cfif get_cbc_family.recordcount NEQ '0'>
				<cfloop query="get_cbc_family">
				<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
					<td align="center">
						<cfif date_sent EQ ''>
							<cfselect name="#family_id#companyid#currentrow#" required="yes" message="You must select a company">
								<option value="0"></option>
								<cfloop query="get_companies">
								<option value="#companyid#" <cfif get_companies.companyid EQ get_cbc_family.companyid>selected</cfif>>#companyshort#</option>
								</cfloop>
							</cfselect>
						<cfelse>
							#companyshort#
							<cfinput type="hidden" name="#family_id#companyid#currentrow#" value="#companyid#">
						</cfif>
					</td>
					<td align="center"><b>#season#</b> <cfinput type="hidden" name="#family_id#cbcid#currentrow#" value="#cbcid#"></td>
					<td align="center">
						<cfif date_sent EQ ''>
							<cfinput type="Text" name="#family_id#date_authorized#currentrow#" size="8" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#" validate="date" maxlength="10">
						<cfelse>
							#DateFormat(date_authorized, 'mm/dd/yyyy')#
							<cfinput type="hidden" name="#family_id#date_authorized#currentrow#" value="#DateFormat(date_authorized, 'mm/dd/yyyy')#">
						</cfif>
					</td>
					<td align="center"><cfif date_sent EQ ''>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
					<td align="center"><cfif date_received EQ ''>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
					<td align="center">#requestid#</td>
					<td width="20%">&nbsp;</td>
				</tr>
				</cfloop>
			</cfif>
			<!--- NEW CBC --->
			<cfif get_fam_seasons.recordcount GT '0'>
			<tr>
				<td align="center">
					<cfselect name="#family_id#companyid" required="yes" message="You must select a company">
						<cfloop query="get_companies">
						<option value="#companyid#" <cfif get_companies.companyid EQ client.companyid>selected</cfif>>#companyshort#</option>
						</cfloop>
					</cfselect>
				</td>						
				<td align="center">
					<cfselect name="#family_id#seasonid" required="yes" message="You must select a season">
						<option value="0">Select a Season</option>
						<cfloop query="get_fam_seasons">
						<option value="#seasonid#">#season#</option>
						</cfloop>
					</cfselect>
				</td>
				<td align="center"><cfinput type="Text" name="#family_id#date_authorized" size="8" value="" validate="date" maxlength="10"></td>
				<td align="center">n/a</td>
				<td align="center">n/a</td>
				<td align="center">n/a</td>
				<td width="20%">&nbsp;</td>
			</tr>
			<tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
			<cfelse>
				<cfinput type="hidden" name="#family_id#seasonid" value="0">
			</cfif>
		<tr><td colspan="6">&nbsp; <br><br></td></tr>			
		</cfloop>
	</cfif>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center">
			<a href="?curdoc=user_info&userid=#url.userid#"><img src="pics/back.gif" border="0"></a> &nbsp;  &nbsp;  &nbsp;  &nbsp; &nbsp;  &nbsp;
			<input name="Submit" type="image" src="pics/update.gif" border=0 alt="submit">
		</td>
	<td width="20%">&nbsp;</td></tr>
</table>
</cfform>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>

</body>
</html>