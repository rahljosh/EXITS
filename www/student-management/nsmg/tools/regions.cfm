<cfquery name="region_info" datasource="MySQL">
	SELECT r.regionid, r.active, r.regionname, r.regionfacilitator, r.company, r.regional_guarantee,
		   u.firstname, u.lastname
	FROM smg_regions r
	LEFT JOIN smg_users u ON r.regionfacilitator = u.userid
	WHERE r.subofregion = 0
		  AND r.company = #client.companyid#
	ORDER BY r.regionname
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><!--- <img src="pics/helpdesk.gif"> ---></td>
		<td background="pics/header_background.gif"><h2>Region Maintenance </h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
</table>

<table border=0 cellpadding=4 cellspacing=2 width=100% class="section">
<tr><td>
	<font size=-1>Total Regions: <Cfoutput>#region_info.recordcount#</Cfoutput></font>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <font color="3333FF"> * Regional Preference</font><br>
</td></tr>
</table>

<Cfoutput>
	
	<cfloop query="region_info">
	<table border=0 cellpadding=4 cellspacing=2 width=100% class="section">
	<tr><td>
		#regionname# - #firstname# #lastname# [ <a href="?curdoc=tools/edit_region&id=#regionid#">edit</a> ] <br> 
		Status: <cfif region_info.active is 1><font color="3333FF">Active</font><cfelse><font color="red">Inactive</font></cfif><br>
		Regional Preference: $#regional_guarantee#<br>
		<cfquery name="subregions" datasource="MySQL">
			select regionname
			from smg_regions 
			where subofregion = #regionid#
		</cfquery>		
		<cfloop query="subregions">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <font color="3333FF"> #regionname#<br></font>
		</cfloop><br>
	</td></tr>
	</table>
	</cfloop>

</cfoutput>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><a href="?curdoc=tools/add_Region">Add a new Master Region</a></td></tr>
</table>

<cfinclude template="../table_footer.cfm">