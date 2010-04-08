<cfquery name="add_region" datasource="caseusa">
insert into smg_Regions (regionname, company)
			values ('#form.region#', #client.companyid#)
</cfquery>

<cflocation url="../index.cfm?curdoc=tools/regions">