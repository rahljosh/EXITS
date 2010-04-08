<cfinclude template="paypal-util.cfm">

<html>
<body>
<h1>Direct Payment Receipt</h1>




<cfinvoke component="paypal" method="DoDirectPayment" returnvariable="doDirectPaymentResponse">
	<cfinvokeargument name="buyerLastName" value=#client.payment.lastname#>
	<cfinvokeargument name="buyerFirstName" value=#client.payment.firstname#>
	<cfinvokeargument name="buyerAddress1" value=#client.payment.address#>
	<cfinvokeargument name="buyerAddress2" value=#client.payment.address2#>
	<cfinvokeargument name="buyerCity" value=#client.payment.city#>
	<cfinvokeargument name="buyercountry" value='BR'>
	<cfinvokeargument name="buyerZipCode" value=#client.payment.zip#>
	<cfinvokeargument name="buyerstate" value='ZZ'>
	<cfinvokeargument name="creditCardType" value=#client.payment.cctype#>
	<cfinvokeargument name="creditCardNumber" value=#client.payment.cc#>
	<cfinvokeargument name="CVV2" value=#client.payment.ccv#>
	<cfinvokeargument name="expMonth" value=#client.payment.expmonth#>
	<cfinvokeargument name="expYear" value=#client.payment.expyear#>
	<cfinvokeargument name="paymentAmount" value=#client.payment.amount#>
	<cfinvokeargument name="ip" value=#cgi.REMOTE_ADDR#>

</cfinvoke>



<!--- Check the Ack --->
<cfscript>
	If (Not IsTrxSuccessful(doDirectPaymentResponse)) {
		PrintErrorMessages(doDirectPaymentResponse);
	}
</cfscript>



<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"></td>
							<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Make a Payment </td><td background="pics/header_background.gif" align="right"><img src="intrep/payments/images/logo_ccVisa.gif"><img src="intrep/payments/images/logo_ccMC.gif"><img src="intrep/payments/images/logo_ccAmex.gif"><img src="intrep/payments/images/logo_ccDiscover.gif"><img src="intrep/payments/images/logo_ccEcheck.gif"><img src="intrep/payments/images/PayPal_mark_37x23.gif"></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					<table width=100% cellpadding=2 cellspacing=0 border=0 class="section">
						<tr>
							<td colspan="5" align="center">
								<img src="intrep/payments/images/receipt.gif" align="center">
								<br>
								<br>
							</td>
						</tr>

<!--- Print the transaction results --->
<b>Thank you for your purchase!</b><br><br>
Transaction Details:<br>
<table border="1">
	<cfoutput>
		<tr>
			<td>Transaction ID: </td> 
			<td>#doDirectPaymentResponse.getTransactionID()#</td>
		</tr>
		<tr>
			<td>AVS Code: </td>
			<td>#doDirectPaymentResponse.getAVSCode()#</td>
		</tr>
		<tr>
			<td>CVV2 Code: </td>
			<td>#doDirectPaymentResponse.getCVV2Code()#</td>
		</tr>
		<tr>
			<td>Amount: </td>
			<td>#doDirectPaymentResponse.getAmount().getCurrencyID()# #doDirectPaymentResponse.getAmount().get_value()#</td>
		</tr>
	</cfoutput>
</table>
<cfdump var="#client.payment#">
<a href="index.cfm">Home</a>

</body>
</html>
