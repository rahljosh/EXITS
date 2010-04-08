<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Host Family CBC Management</title>
</head>

<script language="JavaScript"> 	
<!--//
// opens letters in a defined format
function OpenWindow(url) {
	newwindow=window.open(url, 'Application', 'height=300, width=720, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script> 	<!--// [ end ] custom JavaScript //-->

<body>

<cfif not IsDefined('url.hostid')>
	Sorry, an error has ocurred. Please go back and try again.
	<cfabort>
</cfif>

<cfquery name="get_companies" datasource="caseusa">
	SELECT companyshort, companyid
	FROM smg_companies
	ORDER BY companyshort
</cfquery>

<cfquery name="get_family" datasource="caseusa">
	SELECT hostid, familylastname, fatherlastname, fatherfirstname, fatherdob, fatherssn, motherlastname, motherfirstname, motherdob, motherssn
	FROM smg_hosts
	WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
</cfquery>

<!---- HOST MOTHER --->
<cfquery name="get_cbc_mother" datasource="caseusa">
	SELECT cbcfamid, hostid, date_authorized , date_sent, date_received, requestid, flagcbc,
		smg_hosts_cbc.seasonid, smg_seasons.season,
		c.companyshort
	FROM smg_hosts_cbc
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_hosts_cbc.seasonid
	LEFT JOIN smg_companies c ON c.companyid = smg_hosts_cbc.companyid
	WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer"> 
		AND familyid = '0'
		AND cbc_type = 'mother'
	ORDER BY smg_seasons.season
</cfquery>
<cfset season_list = ValueList(get_cbc_mother.seasonid)>
<cfquery name="get_mother_season" datasource="caseusa">
	SELECT seasonid, season, active
	FROM smg_seasons
	WHERE active = '1'
	<!--- get remaining seasons --->
	<cfif get_cbc_mother.recordcount GT '0'>		
		AND ( <cfloop list="#season_list#" index='cbc_seasons'>
			 seasonid != '#cbc_seasons#'
			 <cfif cbc_seasons EQ #ListLast(season_list)#><Cfelse>AND</cfif>
		  </cfloop> )
	</cfif>
	ORDER BY season
</cfquery>

<!---- HOST FATHER --->
<cfquery name="get_cbc_father" datasource="caseusa">
	SELECT cbcfamid, hostid, date_authorized , date_sent, date_received, requestid, flagcbc, 
		smg_hosts_cbc.seasonid, smg_seasons.season,
		c.companyshort
	FROM smg_hosts_cbc
	LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_hosts_cbc.seasonid
	LEFT JOIN smg_companies c ON c.companyid = smg_hosts_cbc.companyid
	WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer"> 
		AND familyid = '0'
		AND cbc_type = 'father'
	ORDER BY smg_seasons.season
</cfquery>
<cfset season_father_list = ValueList(get_cbc_father.seasonid)>
<cfquery name="get_father_season" datasource="caseusa">
	SELECT seasonid, season, active
	FROM smg_seasons
	WHERE active = '1'
	<!--- get remaining seasons --->
	<cfif get_cbc_father.recordcount GT '0'>		
		AND ( <cfloop list="#season_father_list#" index='cbc_seasons'>
			 seasonid != '#cbc_seasons#'
			 <cfif cbc_seasons EQ #ListLast(season_father_list)#><Cfelse>AND</cfif>
		  </cfloop> )
	</cfif>
	ORDER BY season
</cfquery>

<cfquery name="get_family_members" datasource="caseusa">
	SELECT childid, hostid, membertype, name, middlename, lastname, ssn, birthdate, (DATEDIFF(now( ) , birthdate)/365)
	FROM smg_host_children 
	WHERE hostid = <cfqueryparam value="#url.hostid#" cfsqltype="cf_sql_integer">
		AND (DATEDIFF(now( ) , birthdate)/365) > 17
	ORDER BY childid
</cfquery>

<cfoutput>
<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
	<td background="pics/header_background.gif"><h2>Criminal Background Check - Host Family and Members</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="?curdoc=cbc/qr_hosts_cbc" method="post">

<cfinput type="hidden" name="hostid" value="#url.hostid#">
<cfinput type="hidden" name="totalmembers" value="#get_family_members.recordcount#">

<!--- list cbcs --->
<cfset mother_cbcfamid = ValueList(get_cbc_mother.cbcfamid)>
<cfinput type="hidden" name="mother_cbcfamid" value="#mother_cbcfamid#">

<cfset father_cbcfamid = ValueList(get_cbc_father.cbcfamid)>
<cfinput type="hidden" name="father_cbcfamid" value="#father_cbcfamid#">

<cfset membersid = ValueList(get_family_members.childid)>
<cfinput type="hidden" name="membersid" value="#membersid#">

<table border=0 cellpadding=4 cellspacing=0 width="100%" class="section">
	<tr><td valign="center"> <img src="student_app/pics/delete.gif"><td colspan="5"> If you are running a second rouund of reports,  delete the current CBC records. This will remove CBC's associatd with ALL family members.</td></tr>
	<tr><th colspan="6" bgcolor="e2efc7">H O S T &nbsp; P A R E N T S</th><th bgcolor="e2efc7"><a href="javascript:OpenWindow('cbc/host_parents_info.cfm?hostid=#url.hostid#');">Edit Host Parents Info</a></th></tr>
	<tr><td colspan="6">&nbsp;</td></tr>
	
	<!--- HOST MOTHER --->
	<cfif get_family.motherfirstname NEQ '' AND get_family.motherlastname NEQ ''>
	<tr><td colspan="6" bgcolor="e2efc7"><b>Host Mother - #get_family.motherfirstname# #get_family.motherlastname#</b></td><th bgcolor="e2efc7"></th></tr>
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
	<cfloop query="get_cbc_mother">
		<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
			<td align="center">#companyshort#</td>
			<td align="center"><b>#season#</b></td>
			<td align="center">#DateFormat(date_authorized, 'mm/dd/yyyy')#</td>
			<td align="center"><cfif date_sent EQ ''>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
			<td align="center"><cfif date_received EQ ''>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
			<td align="center">#requestid#</td>
			<td align="center"><input type="checkbox" name="moflagcbc_#cbcfamid#" <cfif flagcbc EQ 1>checked="checked"</cfif>></td>
			<td width="20%">&nbsp;</td>
		</tr>
	</cfloop>
	<!--- NEW CBC --->
	<!--- HOST MOTHER --->
	<cfif get_mother_season.recordcount GT '0'>
		<cfif get_family.motherssn EQ ''>
			<tr><td colspan="6">PS: Mother's SSN is missing.</td></tr>
		</cfif>
		<cfif get_family.motherdob EQ ''>
			<tr><td colspan="6">Mother's date of birth cannot be blank. Please check the DOB before you continue.</td></tr>
		<cfelse>
			<tr>
				<td align="center">
					<cfselect name="mothercompanyid" required="yes" message="You must select a company">
						<cfloop query="get_companies">
						<option value="#companyid#" <cfif get_companies.companyid EQ client.companyid>selected</cfif>>#companyshort#</option>
						</cfloop>
					</cfselect>
				</td>		
				<td align="center">
					<cfselect name="motherseasonid" required="yes" message="You must select a season">
						<option value="0">Select a Season</option>
						<cfloop query="get_mother_season"><option value="#seasonid#">#season#</option></cfloop>
					</cfselect>
				</td>
				<td align="center"><cfinput type="Text" name="motherdate_authorized" size="8" value="" validate="date" maxlength="10"></td>
				<td align="center">n/a</td>
				<td align="center">n/a</td>
				<td align="center">n/a</td>
				<td width="20%">&nbsp;</td>
			</tr>
			<tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
		</cfif>
	<cfelse>
		<cfinput type="hidden" name="motherseasonid" value="0">
	</cfif>
	<tr><td colspan="6">&nbsp; <br></td></tr>
	</cfif>
	
	<!--- HOST FATHER --->
	<cfif get_family.fatherfirstname NEQ '' AND get_family.fatherlastname NEQ ''>
	<tr><td colspan="6" bgcolor="e2efc7"><b>Host Father - #get_family.fatherfirstname# #get_family.fatherlastname#</b></td><th bgcolor="e2efc7"></th></tr>
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
	<cfloop query="get_cbc_father">
	<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
		<td align="center">#companyshort#</td>
		<td align="center"><b>#season#</b></td>
		<td align="center">#DateFormat(date_authorized, 'mm/dd/yyyy')#</td>
		<td align="center"><cfif date_sent EQ ''>in process<cfelse>#DateFormat(date_sent, 'mm/dd/yyyy')#</cfif></td>
		<td align="center"><cfif date_received EQ ''>in process<cfelse>#DateFormat(date_received, 'mm/dd/yyyy')#</cfif></td>
		<td align="center">#requestid#</td>
		<td align="center"><input type="checkbox" name="faflagcbc_#cbcfamid#" <cfif flagcbc EQ 1>checked="checked"</cfif>></td>
		<td width="20%">&nbsp;</td>
	</tr>
	</cfloop>
	<!--- NEW CBC --->
	<cfif get_father_season.recordcount GT '0'>
		<cfif get_family.fatherssn EQ ''>
			<tr><td colspan="6">PS: Father's SSN is missing.</td></tr>
		</cfif>
		<cfif get_family.fatherdob EQ ''>
			<tr><td colspan="6">Father's date of birth cannot be blank. Please check the DOB before you continue.</td></tr>
		<cfelse>
			<tr>
				<td align="center">
					<cfselect name="fathercompanyid" required="yes" message="You must select a company">
						<cfloop query="get_companies">
						<option value="#companyid#" <cfif get_companies.companyid EQ client.companyid>selected</cfif>>#companyshort#</option>
						</cfloop>
					</cfselect>
				</td>		
				<td align="center">
					<cfselect name="fatherseasonid" required="yes" message="You must select a season">
						<option value="0">Select a Season</option>
						<cfloop query="get_father_season"><option value="#seasonid#">#season#</option></cfloop>
					</cfselect>
				</td>
				<td align="center"><cfinput type="Text" name="fatherdate_authorized" size="8" value="" validate="date" maxlength="10"></td>
				<td align="center">n/a</td>
				<td align="center">n/a</td>
				<td align="center">n/a</td>
				<td width="20%">&nbsp;</td>
			</tr>
			<tr><td colspan="4"><font size="-2" color="000099">* Season must be selected.</font></td></tr>
		</cfif>
	<cfelse>
		<cfinput type="hidden" name="fatherseasonid" value="0">
	</cfif>
	<tr><td colspan="6">&nbsp; <br></td></tr>
	</cfif>
	
	<!--- OTHER FAMILY MEMBERS ---> 	
	<tr><th colspan="6" bgcolor="e2efc7">O T H E R &nbsp; F A M I L Y &nbsp; M E M B E R S &nbsp; +17 &nbsp; Y E A R S &nbsp; OLD</th><th bgcolor="e2efc7"><a href="javascript:OpenWindow('cbc/host_fam_cbc.cfm?hostid=#url.hostid#');">Edit Family Members Info</a></th></tr>
	<tr><td colspan="6">&nbsp;</td></tr>
	<cfif get_family_members.recordcount EQ '0'>
	<tr><td colspan="6" align="center">There are no family members.</td></tr>
	<tr><td colspan="6">&nbsp;</td></tr>
	<cfelse>	
		<cfloop query="get_family_members">
			<cfset family_id = '#get_family_members.childid#'>	
			<cfquery name="get_cbc_family" datasource="caseusa">
				SELECT distinct smg_hosts_cbc.seasonid, cbcfamid, smg_hosts_cbc.companyid, date_authorized, requestid, date_sent, date_received,  
					smg_seasons.season,
					c.companyshort
				FROM smg_hosts_cbc
				LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_hosts_cbc.seasonid
				LEFT JOIN smg_companies c ON c.companyid = smg_hosts_cbc.companyid
				WHERE familyid = <cfqueryparam value="#family_id#" cfsqltype="cf_sql_integer"> 
				ORDER BY smg_seasons.season
			</cfquery>
			<cfset season_list = ''>
			<cfset season_list = ValueList(get_cbc_family.seasonid)>
			<cfquery name="get_fam_seasons" datasource="caseusa">
				SELECT  seasonid, season, active
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
			<tr><td colspan="6" bgcolor="e2efc7"><b>#name# #lastname#</b></td><th bgcolor="e2efc7"></th></tr>
			<tr>
				<th valign="top">Company</th>
				<th valign="top">Season</th>		
				<th valign="top">Authorization Received <br><font size="-2">mm/dd/yyyy</font></th>		
				<th valign="top">CBC Sent <br><font size="-2">mm/dd/yyyy</font></th>		
				<th valign="top">CBC Received <br><font size="-2">mm/dd/yyyy</font></th>
				<th valign="top">Request ID</th>
				<td width="20%">&nbsp;</td>
			</tr>
			<cfinput type="hidden" name="#family_id#count" value="#get_cbc_family.recordcount#">
			<!--- UPDATE DATE RECEIVED --->
			<cfif get_cbc_family.recordcount NEQ '0'>
				<cfloop query="get_cbc_family">
					<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("ffffe6") )#"> 
						<td align="center">#companyshort#</td>
						<td align="center"><b>#season#</b></td>
						<td align="center">#DateFormat(date_authorized, 'mm/dd/yyyy')#</td>
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
			<a href="?curdoc=host_fam_info&hostid=#url.hostid#"><img src="pics/back.gif" border="0"></a> &nbsp;  &nbsp;  &nbsp;  &nbsp; &nbsp;  &nbsp;
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