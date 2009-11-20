<cfinclude template="../querys/get_local.cfm">
<cfinclude template="../querys/family_info.cfm">

<cfform action="?curdoc=querys/insert_community_info_pis" method="post">
<cfoutput query="local">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>Community Information</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="80%" valign="top">
		<table border=0 cellpadding=4 cellspacing=0 align="left" width="100%">
			<tr><td colspan="2"><h3>#city# #state#, #zip#</h3></td></tr>
			<tr><Td width="20%" align="right">Region:</Td>
				<td> 
				<cfif client.usertype gte 5>
					<cfinclude template="../querys/get_regions.cfm">
					<select name="region">
					<Cfloop query="get_regions">
						<option value="#regionid#">#regionname#</option>
					</cfloop>
					</select>
				<cfelse>
					<cfinclude template="../querys/get_regions.cfm">
					<select name="region">
					<option value=0>No Region Assigned</option>
					<cfloop query="get_regions">
					<option value=#regionid# <cfif #family_info.regionid# is #regionid#>selected</cfif>>#regionname#</option>
					</cfloop>
				</cfif>
				</td>
			</tr>
			<tr><td colspan="2">Would you describe the community as:</td></tr>
			<tr><td colspan="2">
				<cfif #family_info.community# is 'Urban'><cfinput type="radio" name="community" value="Urban" checked><cfelse><cfinput type="radio" name="community" value="Urban"> </cfif>Urban
				<cfif #family_info.community# is 'suburban'><cfinput type="radio" name="community" value="suburban" checked><cfelse><cfinput type="radio" name="community" value="suburban"></cfif>Suburban
				<cfif #family_info.community# is 'small'><cfinput type="radio" name="community" value="small" checked><cfelse><cfinput type="radio" name="community" value="small"></cfif>Small Town
				<cfif #family_info.community# is 'rural'><cfinput type="radio" name="community" value="rural" checked><cfelse><cfinput type="radio" name="community" value="rural"></cfif>Rural
				</td></tr>
			<tr><td class="label">Closest City:</td><td class="form_text"><cfinput type="text" name="near_city" size=20 value="#family_info.nearbigcity#"></td></tr>
			<tr><td class="label">Distance:</td><td class="form_text"> <cfinput name="near_city_dist" size=3 type="text" value="#family_info.near_City_dist#">miles</td></tr>
			<tr><td class="label">Arrival Airport Code:</td><td class="form_text"><cfinput type="text" name="major_air_code" size=3 value="#family_info.major_air_code#" onchange="javascript:this.value=this.value.toUpperCase();"></td></tr>
			<tr><td class="label">Arrival Airport City: </td><td class="form_text"><cfinput type="text" name="airport_city" size="20" value="#family_info.airport_city#"></td></tr>
			<tr><td class="label" >Arrival Airport State: </td><td width=10>
				<cfinclude template="../querys/states.cfm">
				<select name="airport_state">
				<option>
					<cfloop query = states>
						<option value="#state#" <Cfif family_info.airport_state is #state#>selected</cfif>>#State#</option>
					</cfloop>
				</select></td></tr>
			<tr bgcolor="e2efc7"><td colspan="2">Points of interest in the community:</td></tr>
			<tr bgcolor="e2efc7"><td colspan="2"><textarea cols="60" rows="4" name="pert_info" wrap="VIRTUAL"><cfoutput>#family_info.pert_info#</cfoutput></textarea></td></tr>					
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
</cfoutput>
</cfform>