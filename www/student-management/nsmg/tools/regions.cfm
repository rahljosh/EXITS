<cfparam name="URL.isActive" default="1">

<cfquery name="qGetRegionInfo" datasource="MySQL">
	SELECT 
    	r.regionid, 
        r.active, 
        r.regionname, 
        r.regionfacilitator, 
        r.company, 
        r.regional_guarantee,
		u.firstname, 
        u.lastname
	FROM 
    	smg_regions r
	LEFT JOIN 
    	smg_users u ON r.regionfacilitator = u.userid
	WHERE 
    	r.subofregion = 0
	AND 
    	r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
	<cfif URL.isActive NEQ 'All'>
    	AND
        	r.active = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(URL.isActive)#">
    </cfif>    
    ORDER BY 
    	r.regionname
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><!--- <img src="pics/helpdesk.gif"> ---></td>
		<td background="pics/header_background.gif"><h2>Region Maintenance </h2></td>
		<td background="pics/header_background.gif" align="right" style="font-size:-1;">
            [ &nbsp;
                <cfif URL.isActive EQ 1><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif> 
                <a href="?curdoc=tools/regions&isActive=1">Active</a></span> 
                
                &middot; 
                
                <cfif URL.isActive EQ 0><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif> 
                <a href="?curdoc=tools/regions&isActive=0">Inactive</a> </span> 
                
                &middot;
                
                <cfif URL.isActive EQ 'ALL'><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif>  
                <a href="?curdoc=tools/regions&isActive=All">All</a> </span>                     
            &nbsp; ] 
		</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
</table>

<table border=0 cellpadding=4 cellspacing=2 width=100% class="section">
<tr><td>
	<font size=-1>Total Regions: <Cfoutput>#qGetRegionInfo.recordcount#</Cfoutput></font>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <font color="3333FF"> * Regional Preference</font><br>
</td></tr>
</table>

<Cfoutput>
	
	<cfloop query="qGetRegionInfo">
	<table border=0 cellpadding=4 cellspacing=2 width=100% class="section">
	<tr><td>
		#regionname# - #firstname# #lastname# [ <a href="?curdoc=tools/edit_region&id=#regionid#">edit</a> ] <br> 
		Status: <cfif qGetRegionInfo.active is 1><font color="3333FF">Active</font><cfelse><font color="red">Inactive</font></cfif><br>
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