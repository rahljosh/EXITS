<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>
<cfif form.use_address is 'personal'>
	<cfset client.payment.firstname = '#form.personal_name_f#'>
	<cfset client.payment.lastname = '#form.personal_name_l#'>
	<cfset client.payment.address = '#form.personal_address#'>
	<cfif isDefined('form.personal_address2')>
		<cfset client.payment.address2 = '#form.personal_address2#'>
	<cfelse>
			<cfset client.payment.address2 = ''>
	</cfif>
	<cfset client.payment.city = '#form.personal_city#'>
	<cfset client.payment.country = '#form.personal_country#'>
	<cfset client.payment.zip = '#form.personal_zip#'>
<cfelseif form.use_Address is 'business'>
	<cfset client.payment.firstname = '#form.personal_name_f#'>
	<cfset client.payment.lastname = '#form.personal_name_l#'>
	<cfset client.payment.address = '#form.billing_address#'>
		<cfif isDefined('form.billing_address2')>
			<cfset client.payment.address2 = '#form.billing_address2#'>
		<cfelse>
			<cfset client.payment.address2 = ''>
		</cfif>
	<cfset client.payment.city = '#form.billing_city#'>
	<cfset client.payment.country = '#form.billing_country#'>
	<cfset client.payment.zip = '#form.billing_zip#'>
<cfelseif form.use_Address is 'other'>
	<cfset client.payment.firstname = '#form.firstname#'>
	<cfset client.payment.lastname = '#form.lastname#'>
	<cfset client.payment.address = '#form.address#'>
		<cfif isDefined('form.address2')>
			<cfset client.payment.address2 = '#form.address2#'>
		</cfif>
	<cfset client.payment.city = '#form.city#'>
	<cfset client.payment.country = '#form.counry#'>
	<cfset client.payment.zip = '#form.zip#'>
</cfif>

<cfoutput>
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
								<img src="intrep/payments/images/payment_info.gif" align="center">
								<br>
								<br>
							</td>
						</tr>
						<tr>
							<td style="line-height:20px;" valign="top" width=40% align="right">
							
							<table class="box">
								<tr>
									<td bgcolor="##f4992D">Payment Details</td>
								</tr>
								<tr>
									<td>
									<u>Payment Amount:</u><br> #LSCurrencyFormat(client.payment.amount, 'local')#
									</td>
								</tr>
								<tr>
									<td><u>Address:</u><br>
									#client.payment.firstname# #client.payment.lastname#<br>
									#client.payment.address#<br>
									#client.payment.city# #client.payment.country# #client.payment.zip#
									</td>
								</tr>
							</table>
							</td>
							<td width=15 rowspan=2 align="center"><img src="intrep/payments/images/orange.gif" width=1 height=80%>
							</td>
							<td >
							<cfform method="post" action="?curdoc=intrep/payments/payment_step_5">
							<table>
								<tr>
									<td>Credit Card Type:</td><td> <cfselect name="credit_Card_type">
							<option value="Visa">Visa</option>
							<option value="MasterCard">MasterCard</option>
							<option value="Amex">American Express</option>
							<option value="Discover">Discover</option>
							</cfselect></td>
								</tr>
								<tr>
									<td>Card Number:</td><Td> <input name="number" type="text" tabindex="1" size=20> (don't include spaces)</Td>
								</tr>
								<Tr>
									<td><a href="intrep/payments/images/creditcardsecurity.jpg" target="_blank">3 or 4 digit security:</a></td><Td> <input type="text" name="ccv" tabindex="2" size=4 ></Td>
								</Tr>
								<Tr>
									<td>Expires:</td><Td> <input name=month type="text" size=2 maxlength="2" tabindex="3"> / <input maxlength="4" type="text" size=4 name="year" tabindex="4"> mm/yyyy</Td>
								</Tr>
								<!----<Tr>
									<td colspan=2><input type="checkbox" name="savecard">Save this card on file for future transactions.</td>
								</Tr>---->
							</table>
							<br>
							
							
							</td>
							
							
						</tr>
						<tr>
							<td colspan=5 align="center"><input type="image" src="pics/next.gif" alt="next"></td>
						</tr>
					</table>
					</cfform>
					<!----footer of table---->
								<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>

</cfoutput>
</body>
</html>
