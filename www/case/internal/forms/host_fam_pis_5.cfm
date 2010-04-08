<cfinclude template="../querys/get_local.cfm">

<cfquery name="get_host_school" datasource="caseusa">
	select hostid, smg_hosts.schoolid 
	from smg_hosts
	LEFT JOIN smg_schools s ON s.schoolid = smg_hosts.schoolid
	where hostid = '#client.hostid#'
</cfquery>

<cfquery name="get_schools" datasource="caseusa">
	select schoolid, schoolname from smg_Schools
	where (state = "#local.state#")
	order by Schoolname
</cfquery>

<cfform action="?curdoc=forms/host_fam_pis_5_1" method="post" name=frmPhone>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
		<td background="pics/header_background.gif"><h2>School Information</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <cfoutput><a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a></cfoutput> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%" valign="top">
		<table border=0 cellpadding=4 cellspacing=0 align="left">
			<tr><td colspan="2"> 
			<cfif get_Schools.recordcount is '0'>
				We do not have any schools in <Cfoutput>#local.city# #local.state#</Cfoutput> in our database.  
				Please add the following information for the school that the student will be attending to, just click on next.</td></tr>
			<cfelse>
				The following schools are in your state, if the student will be attending a school from the list, please select it.  
				If the school is not found, please select new school (first option) then click on next.</td></tr>
			<tr><td class="label">School:</td>
				<td class="form_text">
					<select name="school">					
						<option value=0>New School
						<cfoutput query="get_schools">
						<cfif get_host_school.recordcount is 0>
							<option value=#schoolid# >#schoolname#
						<cfelse>
							<cfif get_host_school.schoolid is #schoolid#>
								<option value=#schoolid# selected>#schoolname#
							<cfelse><option value=#schoolid#>#schoolname#
							</cfif>
						</cfif>
						</cfoutput>						
					</select></td>
			</tr>
			</cfif>
		</table>
	</td>
	<td width="20%" align="right" valign="top">
		<table border=0 cellpadding=4 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" align="middle" border=0></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfform>