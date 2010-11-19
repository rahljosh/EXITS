
<cfquery name="all_regions_name_id" datasource="MySQL">
Select regionid, regionname
From smg_regions
order by regionname

</cfquery>