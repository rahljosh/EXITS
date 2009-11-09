<cfquery name="get_Region_info" datasource="MySQL">
select * from smg_Regions where regionid = #url.id#
</cfquery>