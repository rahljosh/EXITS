

<cfset payment_Amount = #url.amount#>
<cfquery name="total_charge" datasource="caseusa">
select sum(charge) as total_charge
from smg_invoices
where number = #url.number#
</cfquery>

<cfquery name="previous_payment" datasource="caseusa">
select sum(ammount_paid) as previous_payment
from smg_invoices 
where number = #url.number#
</cfquery>



<cfquery name="get_invoice" datasource="caseusa">
select id, number, charge
from smg_invoices
where number=#url.number# and ammount_paid = 0.00 and status <> 'cancel'
</cfquery>

<cfset remainingbalance = #payment_amount#>
<cfoutput>
#remainingbalance#<br>
<cfif #payment_amount# lt #total_charge.total_charge#>
<cfset partial_payment = 1>
<Cfelse>
<cfset partial_payment = 0>
</cfif>
<cfset credit_used=#url.origamount# - #url.amount#>

<Cfloop query = "get_invoice" >



<Cfquery name="update_charges" datasource="caseusa">
update smg_invoices

	<cfif #remainingbalance# lt 0>
	set ammount_paid = 0,
	<cfelseif #remainingbalance# lt #charge# and #remainingbalance# gt 0>    
	set ammount_paid = #remainingbalance#,
	<Cfelseif #charge# lte #remainingbalance#>
	set ammount_paid = #charge#,
	</cfif> 
useridpaid =#client.userid#,
status = 'paid',
datepaid =#now()#,
partial_payment = #partial_payment#,
amount_paid_total_invoice  = #url.origamount#,
credit_used = #credit_used#
where id = #id#
	</Cfquery>

<cfset #remainingbalance# = #remainingbalance# - #charge#>

<cfoutput>
#remainingbalance#
</cfoutput>
</Cfloop>
<cfoutput>
#remainingbalance#
</cfoutput>
<cfquery name="get_balance" datasource="caseusa">
select account_credit
from smg_users
where userid = #url.intrep#
</cfquery>
<Cfset credit = #get_balance.account_credit# + #remainingbalance#>
<Cfquery name="update_account_credit" datasource="caseusa">
update smg_users
set account_credit = #credit#
where userid = #url.intrep#
</Cfquery>

</cfoutput>

<cflocation url="../index.cfm?curdoc=invoice/payment_confirmation&inv=#url.number#&intrep=#intrep#&amount=#url.amount#&origamount=#url.amount#">
