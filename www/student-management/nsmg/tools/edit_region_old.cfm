<cfquery name="get_Region_info" datasource="MySQL">
select * from smg_regions where regionid = #url.id#
</cfquery>