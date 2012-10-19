<cfinclude template="get_local.cfm">

<cfquery name="get_host_school" datasource="MySQL">
	select hostid, smg_hosts.schoolid 
	from smg_hosts
	LEFT JOIN smg_schools s ON s.schoolid = smg_hosts.schoolid
	where hostid = '#client.hostid#'
</cfquery>

<cfquery name="get_schools" datasource="MySQL">
	select schoolid, schoolname from smg_schools
	where (state = "#local.state#")
	order by Schoolname
</cfquery>
<cfoutput>
<cfform action="?curdoc=forms/qr_insert_school&hostid=#url.hostid#" method="post" name=frmPhone>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif">&nbsp;</td>
		<td background="pics/header_background.gif"><h2>Your School Information</h2></td>
		<td align="right" background="pics/header_background.gif"></td>
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
						<option value=0>School Not in List
						<cfloop query="get_schools">
						<cfif get_host_school.recordcount is 0>
							<option value=#schoolid# >#schoolname#
						<cfelse>
							<cfif get_host_school.schoolid is #schoolid#>
								<option value=#schoolid# selected>#schoolname#
							<cfelse><option value=#schoolid#>#schoolname#
							</cfif>
						</cfif>
						</cfloop>						
					</select></td>
			</tr>
			</cfif>
		</table>
	</td>
	<td width="20%" align="right" valign="top">
		
	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><input name="Submit" type="image" src="../pics/next.gif" align="middle" border=0></td></tr>
</table>


</cfform>
</cfoutput>