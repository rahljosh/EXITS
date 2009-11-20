


<!---  DELETE paymentID from egom_payments and egom_payment_charges fields --->
 		<cfquery name="delete_invoice" datasource="MySql">
			DELETE 
			FROM egom_payments
			WHERE paymentid = #paymentid# 
		</cfquery>

<cfquery name="delete_invoice" datasource="MySql">
			DELETE 
			FROM egom_payment_charges
			WHERE paymentid = #paymentid# 
		</cfquery>
