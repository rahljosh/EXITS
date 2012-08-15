<!-----Company Information----->
<Cfquery name="companyshort" datasource="MySQL">
select *
from smg_companies
where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(client.companyid)#">
</Cfquery>