<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cftransaction action="begin" isolation="serializable">
<cfquery name="get_last_invoice" datasource="caseusa">
select max(invoiceid) as last_invoice from smg_charges
</cfquery>

<cfset invoice_number = #get_last_invoice.last_invoice# + 1>

<cfquery name="create_invoice" datasource="caseusa">
update smg_charges
	set invoiceid = #invoice_number#,
		invoicedate = #now()#
	where invoiceid = 0 and 
	<cfif form.inv_type is 'deposit'>
	type = '#form.inv_type#' and
	<cfelseif form.inv_type is 'final'>
	(type = 'program fee' or type = 'guarantee' or type = 'insurance' or type = 'sevis' or type = 'direct placement') and
	<cfelseif form.inv_type is 'misc'>
	(type <> 'program fee' and  type <> 'guarantee' and type <> 'insurance' and  type <> 'deposit' and type <> 'sevis') and
	</cfif>
	  
	agentid = #url.agentid#
	and companyid = #client.companyid#
</cfquery>
</cftransaction>

<cfoutput>
<cflocation url="../index.cfm?curdoc=invoice/user_account_details&userid=#url.agentid#" addtoken="yes">
</cfoutput>it 