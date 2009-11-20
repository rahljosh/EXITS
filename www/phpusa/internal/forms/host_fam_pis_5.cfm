<cfinclude template="../querys/get_local.cfm">

<cfquery name="get_host_school" datasource="mysql">
	select hostid, hosts.schoolid 
	from smg_hosts hosts
	LEFT JOIN php_schools s ON s.schoolid = hosts.schoolid
	where hostid = '#client.hostid#'
</cfquery>

<cfquery name="get_schools" datasource="mysql">
	select schoolid, schoolname from php_schools
	where state = #local.id#
	order by schoolname
</cfquery>

<cfform action="?curdoc=forms/host_fam_pis_5_1" method="post" name=frmPhone>

<h2>&nbsp;&nbsp;&nbsp;&nbsp;S t u d e n t &nbsp;&nbsp;&nbsp;  I n f o r m a t i o n <font size=-2>[ <cfoutput><a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a></cfoutput> ] </font></h2>

<table width="90%" border=0 align="center" cellpadding=4 cellspacing=0 class="box">
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

<table width=90% border=0 align="center" cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" alt="next" align="middle" border=0></td></tr>
</table>


</cfform>