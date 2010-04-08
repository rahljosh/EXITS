<cfquery name="company_short" datasource="caseusa">
select companyshort
from smg_companies
where companyid = #client.companyid#
</cfquery>