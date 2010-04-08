<cfquery name="get_Region_info" datasource="caseusa">
select * from smg_Regions where regionid = #url.id#
</cfquery>