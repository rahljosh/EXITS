<cfset client.payment.cctype = '#form.credit_Card_type#'>
<cfset client.payment.cc = #form.number#>
<cfset client.payment.ccv = '#form.ccv#'>
<cfset client.payment.expmonth = #form.month#>
<cfset client.payment.expyear = #form.year#>


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
								<img src="intrep/payments/images/review.gif" align="center">
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
									<u>Payment Amount: [EDIT]</u><br> #LSCurrencyFormat(client.payment.amount, 'local')#
									</td>
								</tr>
								<tr>
									<td><u>Address: [EDIT]</u><br>
									#client.payment.firstname# #client.payment.lastname#<br>
									#client.payment.address#<br>
									#client.payment.city# #client.payment.country# #client.payment.zip#
									</td>
								</tr>
								<tr>
									<td><u>Credit Card: [EDIT]</u><br>
									Type: #client.payment.cctype# <br>
									Number: ****#Right(client.payment.cc,4)#<br>
									Expires: #client.payment.expmonth#/ #client.payment.expyear#
									</td>
								</tr>
							</table>
							</td>
							<td width=15 rowspan=2 align="center"><img src="intrep/payments/images/orange.gif" width=1 height=80%>
							</td>
							<td >
							<cfform method="post" action="intrep/payments/payment_final.cfm">
							<table>
								<tr>
									<td>
									Please review payment details to left.  To change any information, click on EDIT.  If the information is correct, 
									click Process Payment below.  Please click only once to avoid multiple charges.
									<div align="center"><br>
<br>

									<input type="submit" value="Pay Now">
									</div>
									</td>
								</tr>
							</table>
							<br>
							
							
							</td>
							
							
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
