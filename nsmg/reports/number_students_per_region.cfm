<cfquery name="number_students_region" datasource="MySQL">
select regionid, regionname
from smg_regions
where company = #client.companyid#
</cfquery>

<cfoutput query="number_Students_region">
<cfquery name="students" datasource="mysql">
select studentid
from smg_students
where regionassigned = #number_students_region.regionid#
</cfquery>
#regionname# - #students.recordcount#<br>
</cfoutput>

