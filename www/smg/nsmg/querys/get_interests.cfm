<cfquery name="get_interests" datasource="MySQL">
select *
from smg_interests
order by interest
</cfquery>