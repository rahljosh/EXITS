<cfquery name="get_interests" datasource="mysql">
select *
from smg_interests
order by interest
</cfquery>