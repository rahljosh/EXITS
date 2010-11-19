<cfquery name="company_short" datasource="MySQL">
select companyshort
from smg_companies
where companyid = #client.companyid#
</cfquery>