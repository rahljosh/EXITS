<cfquery name="add_region" datasource="mysql">
insert into smg_Regions (regionname, companyid)
			values ('#form.region#', #client.companyid#)
</cfquery>

<cflocation url="../index.cfm?curdoc=tools/regions">