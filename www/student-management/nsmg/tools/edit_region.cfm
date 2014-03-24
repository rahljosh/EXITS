<cfquery name="get_Region_info" datasource="MySQL">
	SELECT * 
	from smg_regions 
	where regionid = #url.id#
</cfquery>

<cfquery name="facilitators" datasource="MySQL">
	SELECT DISTINCT u.userid, u.firstname, u.lastname
	FROM user_access_rights uar 
	INNER JOIN smg_users u ON u.userid = uar.userid
	WHERE uar.usertype = '4' AND u.active = '1' 
		AND uar.companyid = '#client.companyid#'
	ORDER BY u.lastname
</cfquery>
	
<cfoutput>
<form action="querys/update_regions.cfm" method="post">
<input type="hidden" name="regionid" value="#url.id#"></input>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><!--- <img src="pics/helpdesk.gif"> ---></td>
		<td background="pics/header_background.gif"><h2>Region Maintenance </h2></td>
		<td background="pics/header_background.gif" align="right">&nbsp; &nbsp; &nbsp; <a href="index.cfm?curdoc=tools/regions">Regions List</a></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><h2>#get_region_info.regionname#</h2></td></tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td>
    <table border=0 cellpadding=4 cellspacing=0>
    	<Tr>
        	<td>
    <h3>Facilitator: </h3></td><td>
		<select name="facilitator">
		<option value=0>None Assigned</option>
			<cfloop query="facilitators">
				<option value="#userid#" <cfif get_region_info.regionfacilitator EQ userid>selected</cfif>>#firstname# #lastname#</option>
			</cfloop>
		</select></td>
	</tr>
	<tr>
		<td><h3>Status: </h3></td><td>
			<cfif get_Region_info.active is '1'><input type="radio" name="status" value="1" checked>Active<cfelse><input type="radio" name="status" value="1">Active</cfif>&nbsp; &nbsp;
			<cfif get_Region_info.active is '0'><input type="radio" name="status" value="0" checked>Inactive<cfelse><input type="radio" name="status" value="0">Inactive</cfif>
		</h3></td>
	</tr>
    <tr>
		<td><h3>Website: </h3></td><td>
			<input type="text" size=25 name="website" value="#get_Region_info.url#" />.iseusa.org
            </h3>
		</td>
	</tr>
      <tr>
		<td><h3>Email: </h3></td><td>
			<input type="text" size=25 name="email" value="#get_Region_info.regionalEmail#" />@iseusa.org
            </h3>
		</td>
	</tr>
    <tr>
		<td><h3>Facebook: </h3></td><td>
			<input type="text" size=25 name="facebook" value="#get_Region_info.facebook #"/>
            </h3>
		</td>
	</tr>
    <tr>
		<td><h3>Twitter:</h3></td><td>
			<input type="text" size=25 name="twitter" value="#get_Region_info.twitter#"/>
            </h3>
		</td>
	</tr>
        <tr>
		<td><h3>Pintrest:</h3></td><td>
			<input type="text" size=25 name="pintrest" value="#get_Region_info.pintrest#" />
            </h3>
		</td>
	</tr>
    <tr>
		<td><h3>Youtube: </h3></td><td>
			<input type="text" size=25 name="youtube" value="#get_Region_info.youtube#" />
            </h3>
		</td>
	</tr>
            <tr>
		<td><h3>Tumblr: </h3></td><td>
			<input type="text" size=25 name="tumblr" value="#get_Region_info.tumblr#"/>
            </h3>
		</td>
	</tr>
    <tr>
		<td><h3>Goolge +:</h3></td><td>
			<input type="text" size=25 name="googleplus"  value="#get_Region_info.googleplus#"/>
            </h3>
		</td>
	</tr>
  </table>
  <table  border=0 cellpadding=4 cellspacing=0>
	<Tr>
		<td colspan=2><h3>Current Regional Guarantees:</h3>
		<cfquery name="sub_regions" datasource="mysql">
			select * 
			from smg_regions 
			where subofregion = #url.id#
		</cfquery>
		<cfif sub_regions.recordcount is 0>
		No regional Preference regions defined, use form below to add regions.
		<cfelse>
		<cfloop query="sub_regions">
		-- #regionname#
		</cfloop>
		</cfif><br><br></td>
	</Tr>
	<tr>
		<td colspan=2>
		<h3>Add Regional Guarantees:</h3>
		You can add as many sub-regions as you would like, seperate each with a comma (,)<br>
		<textarea cols="40" rows="5" name="subregion"></textarea>
		</td>
	</tr>
	<tr><td><h3>Region Preference Fee: &nbsp; &nbsp; <input type="text" value="#get_region_info.regional_guarantee#" name="regional_guarantee" size=8></input></h3> </td></tr>

</table>
	</tr>
   </td>
 </table>
<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><font size=-1><br><input name="submit" type="image" src="pics/update.gif" border=0></td></tr>
</table>

<cfinclude template="../table_footer.cfm">
</form>
</cfoutput>