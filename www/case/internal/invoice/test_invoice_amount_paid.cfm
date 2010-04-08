
<cfoutput>

<Cfset invoiceid = 1290>
<cfset total_invoice_amount_received = 0>



		<cfquery name="invoice_totals" datasource="caseusa">
			select sum(amount_due) as invoice_due
			from smg_charges
			where invoiceid = #invoiceid#
		</cfquery>
		
		<cfquery name="invoice_charge_id" datasource="caseusa">
		select smg_charges.chargeid 
		from smg_charges 
		where smg_charges.invoiceid = #invoiceid#
		</cfquery>
		
		<Cfloop query="invoice_charge_id">
			<cfquery name=get_applied_amount datasource="caseusa">
			select amountapplied
			from smg_payment_charges
			where chargeid = #invoice_charge_id.chargeid#
			</cfquery>
				<cfloop query=get_applied_amount>
					<cfset total_invoice_amount_received = #total_invoice_amount_received# + #get_applied_amount.amountapplied#>
					#amountapplied#
				</cfloop>
		
		
		
		
		
		</Cfloop>
		total:
		#total_invoice_amount_received#
		<br>
		#invoice_totals.invoice_due#
		<!----
		
		<cfset paid_amount =0>
		<cfloop query=invoice_charge_id>
		<cfquery name="charges_paid" datasource="caseusa">
				select smg_payment_charges.chargeid, smg_payment_charges.amountapplied, smg_payment_charges.paymentid
				from smg_payment_charges 
				where smg_payment_charges.chargeid = #invoice_charge_id.chargeid#
				</cfquery>
				#invoice_charge_id.chargeid# #charges_paid.amountapplied# #charges_paid.paymentid#<br>
				<cfif charges_paid.recordcount is 0>
				<cfset famountapplied = 0>
				<Cfelse>
				<cfset famountapplied = #charges_paid.amountapplied#>
				</cfif>		
				<cfset paid_amount = #paid_amount# + #famountapplied#> 
		</cfloop>
				
		<cfif charges_paid.recordcount is 0>
		<Cfset payref.paymentref = ''>
		<cfelse>
		<cfquery name="payref" datasource="caseusa">
		select paymentref from smg_payment_received
		where paymentid = #charges_paid.paymentid#
		</cfquery>
		</cfif>
		
		---->
		</cfoutput>