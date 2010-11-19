<cfquery name="available_posistions" datasource="mysql">
select *
from extra_web_jobs
</cfquery>

<cfdump var="#available_posistions#">