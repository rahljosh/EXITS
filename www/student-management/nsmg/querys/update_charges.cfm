<Cflock scope="application" timeout="30">
<cfquery name="update_chareges" datasource="MySQL">
update smg_invoices
	set program_Fee = #form.program_fee#
	<cfif #form.other_Charge# is ''>
		
		<Cfelse>,
		other_charge = #form.other_charge#,
		other_desc = "#form.other_desc#",		
		</cfif>
		
		insurance_charge = "#form.insurance_charge#"
		
		where (studentid = #form.student# and number=#client.invoice_number#)
</cfquery>
</cflock>

<cflocation url="../index.cfm?curdoc=invoice/step3">


