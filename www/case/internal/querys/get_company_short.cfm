<!-----Company Information----->
<Cfquery name="companyshort" datasource="caseusa">
	select *
	from smg_companies
	where companyid = '#client.companyid#'
</Cfquery>