<cfquery name="get_interests" datasource="caseusa">
select *
from smg_interests
order by interest
</cfquery>