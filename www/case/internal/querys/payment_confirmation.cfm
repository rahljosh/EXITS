<cfquery name="get_invoice_details" datasource="caseusa">
select sum(charge) as total_charge,
from smg_invoice
where number = #url.inv#
</cfquery>