<!-----Company Information----->
<Cfquery name="companyshort" datasource="MySQL">
	select *
	from smg_companies
	where companyid = '#client.companyid#'
</Cfquery>