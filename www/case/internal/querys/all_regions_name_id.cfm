
<cfquery name="all_regions_name_id" datasource="caseusa">
Select regionid, regionname
From smg_regions
order by regionname

</cfquery>