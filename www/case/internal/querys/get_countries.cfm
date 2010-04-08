<cfquery name="get_countries" datasource="caseusa">
select countryname, countryid
from smg_countrylist
order by Countryname
</cfquery>
