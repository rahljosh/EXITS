<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cfquery name="payments" datasource="caseusa">
select distinct number, amount_paid_total_invoice, datepaid, companyid, intrepid
from smg_invoices
where amount_paid_total_invoice <> 0 
order by datepaid
</cfquery>

<cfloop query="payments">
<cfset amount_left = 0>
	<Cfquery name="update_payments" datasource="caseusa">
	insert into smg_payment_Received (date, paymentref, paymenttype, totalreceived, agentid, companyid)
						values (#datepaid#, #payments.currentrow#, 'migrated', #amount_paid_total_invoice#, #intrepid#, #companyid#)
	</Cfquery>

	<!----Get Charges associated with an invoice---->
	<cfquery name="charge_id_amount" datasource="caseusa">
	select chargeid, amount_due, invoiceid 
	from smg_charges
	where invoiceid = #number#
	</cfquery>
	<!---- figure payment and assign to ind. charges---->
	<cfset amount_left = #payments.amount_paid_total_invoice#>
		<cfloop query="charge_id_amount">
			<cfif amount_left lt 0>
				<Cfset amount_left = 0>
			<cfelse>
			<cfif amount_due lte amount_left>
				<Cfquery name="add_charge" datasource="caseusa">
				insert into smg_payment_Charges (chargeid, amountapplied, paymentid)
							values(#chargeid#, #amount_due#,#payments.currentrow#)
				</Cfquery>
				<cfset amount_left = #amount_left# - #amount_due#>
			<cfelseif amount_due gt amount_left>
				<Cfquery name="add_charge" datasource="caseusa">
				insert into smg_payment_Charges (chargeid, amountapplied, paymentid)
							values(#chargeid#, #amount_left#, #payments.currentrow#)
				</Cfquery>
				<cfset amount_left = #amount_left# - #amount_due#>
				</cfif>
			</cfif>
		</cfloop>

</cfloop>
