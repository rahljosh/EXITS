<cfquery name="charges_paid" datasource="MySQL">
		select  smg_charges.chargeid,  smg_payment_charges.amountapplied, smg_payment_charges.paymentid
		from smg_charges right join smg_payment_charges on smg_charges.chargeid = smg_payment_charges.chargeid
		where smg_charges.invoiceid = 1232 
		</cfquery>
		<!----
		<cfset paid_amount =0>
		<cfloop query="charges_paid">
		<cfset paid_amount = #paid_amount# + #charges_paid.amountapplied#> 
		</cfloop>
		---->
		
		<Cfoutput query="charges_paid">
		#chargeid# <Br>
		</Cfoutput>