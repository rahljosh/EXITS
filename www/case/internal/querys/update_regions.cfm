<!----Updates all aspects of the regions---->
<cfdump var="#form#">

<cfquery name="update_companies" datasource="caseusa">
update smg_regions
		set regionfacilitator = #form.facilitator#,
			regional_guarantee = #form.regional_guarantee#,
			active = #form.status#
		where regionid = #form.regionid#
</cfquery>

<cfquery name="get_sub_Regions" datasource="caseusa">
	select regionid
	from smg_regions
	where subofregion = #form.regionid#
</cfquery>

<cfloop query="get_sub_Regions">
	<cfquery name="update_sub_Regional_guar" datasource="caseusa">
	update smg_regions
		set regional_guarantee = #form.regional_guarantee#
	where regionid = #regionid#
	</cfquery>
</cfloop>
<!----Update Facilitators for each company selected---->

	<cfloop list="#form.subregion#" index=#i#>
		<cfquery name="insert_sub_Region" datasource="caseusa">
		insert into smg_regions (regionname, subofregion)
					values ('#i#',#form.regionid#)
		</cfquery>
	</cfloop>

<cflocation url="../index.cfm?curdoc=tools/edit_region&id=#form.regionid#" addtoken="no">