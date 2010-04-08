	<cfif isDefined ('client.payment')>
		<cfset client.payment = structdelete(client.payment,1)>
	</cfif> 
	<cfset client.payment = structNew()>
	<Cfif form.pay_amount is "full">
		<cfset client.payment.amount = #form.full_payment#>
	<cfelse>
		<cfset client.payment.amount = #form.amount#>
	</Cfif>
	
	<cfif form.pay_amount is 'full'>
	<cflocation url="index.cfm?curdoc=intrep/payments/payment_step_3">
	<cfelse>
	Apply partial payment
	</cfif>