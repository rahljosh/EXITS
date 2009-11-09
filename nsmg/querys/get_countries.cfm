<cfquery name="get_countries" datasource="MySQL">
select countryname, countryid
from smg_countrylist
order by Countryname
</cfquery>
