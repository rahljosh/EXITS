<cfquery name="account_balance" datasource="caseusa">
select account_credit from smg_users
where userid = #url.intrep#
</cfquery>

<cfif account_balance.account_credit lt #form.credit_amount#>
You can't credit back more then the account balance.
</cfif>

<cftransaction action="begin" isolation="SERIALIZABLE">
	<cfquery name="get_invoice_number" datasource="caseusa">
	select MAX(number) as new_number
	from smg_invoices
	</cfquery>

<cfset invoice_number = #get_invoice_number.new_number# +1>
<cfset creditamount = 0 - #form.credit_Amount#>
	<cfset client.invoice_number=#invoice_number#>
	<cfset client.intrep = #url.intrep#>
<cfset new_balance = #account_balance.account_credit# - #form.credit_amount#>
<cfquery name="create_refund_invoice" datasource="caseusa">
insert into smg_invoices (number, other_desc, other_charge, intrepid)
			values(#invoice_number#, 'Refund for student cancellation',#creditamount#, #url.intrep#)
</cfquery>
<cfquery name="update_account" datasource="caseusa">
update smg_users 
set account_credit = #new_balance#
where userid = #url.intrep#
</cfquery>
</cftransaction>
<cflocation url="../index.cfm?curdoc=invoice/print_view">