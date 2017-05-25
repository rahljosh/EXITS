<cfquery name="qGetHostInfo" datasource="#APPLICATION.DSN#">
	SELECT h.*, a.city AS airportCity, a.state AS airportState
    FROM smg_hosts h
    LEFT JOIN smg_airports a ON a.airCode = h.major_air_code
    WHERE h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.hostid)#">
</cfquery>

<cfquery name="qGetAirportList" datasource="#APPLICATION.DSN#">
    SELECT *
    FROM smg_airports
</cfquery>
    <cfscript>
        // Get User Regions
        qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(
            companyID=CLIENT.companyID,
            userID=CLIENT.userID,
            userType=CLIENT.userType
        );

     
    </cfscript>
<cfoutput query="qGetHostInfo">

<cfform action="?curdoc=querys/insert_community_info_pis&hostID=#URL.hostID#" method="post">
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
			<tr><td colspan="2"><h3>#qGetHostInfo.city# #qGetHostInfo.state#, #qGetHostInfo.zip#</h3></td></tr>
			<tr>
			
				  <Td width="20%" align="right">Region: </Td>
                       <td>
                        <select name="region" id="region">
                          
                            <cfloop query="qGetRegionList">
                                <option value="#regionID#" <cfif regionID EQ qGetHostInfo.regionid>selected="selected"</cfif>>#companyshort# - #regionName#</option>
                            </cfloop>
                        </select>
                    </td>
			</tr>
			<tr><td colspan="2">Would you describe the community as:</td></tr>
			<tr><td colspan="2">
				<cfif qGetHostInfo.community is 'Urban'><cfinput type="radio" name="community" value="Urban" checked><cfelse><cfinput type="radio" name="community" value="Urban"> </cfif>Urban
				<cfif qGetHostInfo.community is 'suburban'><cfinput type="radio" name="community" value="suburban" checked><cfelse><cfinput type="radio" name="community" value="suburban"></cfif>Suburban
				<cfif qGetHostInfo.community is 'small'><cfinput type="radio" name="community" value="small" checked><cfelse><cfinput type="radio" name="community" value="small"></cfif>Small Town
				<cfif qGetHostInfo.community is 'rural'><cfinput type="radio" name="community" value="rural" checked><cfelse><cfinput type="radio" name="community" value="rural"></cfif>Rural
				</td></tr>
			<tr><td class="label">Closest City:</td><td class="form_text"><cfinput type="text" name="near_city" size=20 value="#qGetHostInfo.nearbigcity#"></td></tr>
			<tr><td class="label">Distance:</td><td class="form_text"> <cfinput name="near_city_dist" size=3 type="text" value="#qGetHostInfo.near_City_dist#">miles</td></tr>
			<tr><td class="label">Arrival Airport:</td><td class="form_text">
            	<select name="major_air_code" data-placeholder="Enter City, Airport or Airport Code" class="chzn-select xxxLargeField" tabindex="2">
                    <option value=""></option>
                    <cfloop query="qGetAirportList">
                        <option value="#airCode#" <cfif qGetHostInfo.major_air_code eq airCode>selected</cfif>>#aircode# - #airportName# - #city#, #state#</option>
                    </cfloop>
                </select>
          	</td></tr>
			<tr bgcolor="e2efc7"><td colspan="2">Points of interest in the community:</td></tr>
			<tr bgcolor="e2efc7"><td colspan="2"><textarea cols="60" rows="4" name="point_interest" wrap="VIRTUAL"><cfoutput>#qGetHostInfo.point_interest#</cfoutput></textarea></td></tr>					
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
</cfoutput>