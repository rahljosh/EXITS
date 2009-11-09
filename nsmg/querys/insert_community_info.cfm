<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfquery name="insert_community_info" datasource="MySQL">
update smg_hosts
	set population="#form.population#",
		nearbigCity="#form.near_City#",
		near_City_Dist="#form.near_City_Dist#",
		near_pop="#form.near_pop#",
		neighborhood="#form.neighborhood#",
		community="#form.community#",
		terrain1="#form.terrain1#",
		terrain2="#form.terrain2#",
		
		wintertemp="#form.wintertemp#",
		summertemp="#form.summertemp#",
		special_cloths="#form.special_cloths#",
		point_interest="#form.point_interest#",
		local_air_code="#form.local_Air_code#",
		major_air_code="#form.major_air_code#"
  where hostid=#client.hostid#
		
</cfquery>
<cfif isDefined('form.terrain3')>
<cfquery name="terrain3" datasource="MySQL">
update smg_hosts
	set 
	terrain3 = "#form.terrain3#",
	terrain3_desc = "#form.other_desc#"
where hostid=#client.hostid#
</cfquery>
</cfif>

</cftransaction>
<cflocation url="../index.cfm?curdoc=forms/family_app_11">
